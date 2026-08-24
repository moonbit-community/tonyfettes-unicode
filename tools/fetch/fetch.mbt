///|
/// Pre-populate the Unicode data cache used by `tools/gen`.
///
/// `tools/gen` reads its inputs from `tools/.cache/`, downloading them with
/// `@http.get` when missing. Some unicode.org responses make `@http.get`
/// fail with `ReaderClosed`, so this tool retries and falls back to a
/// streaming client that writes the raw response body to disk.
let sources : Array[(String, String)] = [
  (
    "UnicodeData.txt", "https://www.unicode.org/Public/16.0.0/ucd/UnicodeData.txt",
  ),
  (
    "CompositionExclusions.txt", "https://www.unicode.org/Public/16.0.0/ucd/CompositionExclusions.txt",
  ),
  (
    "SpecialCasing.txt", "https://www.unicode.org/Public/16.0.0/ucd/SpecialCasing.txt",
  ),
  (
    "DerivedCoreProperties.txt", "https://www.unicode.org/Public/16.0.0/ucd/DerivedCoreProperties.txt",
  ),
  (
    "IdnaMappingTable.txt", "https://www.unicode.org/Public/idna/16.0.0/IdnaMappingTable.txt",
  ),
  (
    "DerivedJoiningType.txt", "https://www.unicode.org/Public/16.0.0/ucd/extracted/DerivedJoiningType.txt",
  ),
  (
    "DerivedBidiClass.txt", "https://www.unicode.org/Public/16.0.0/ucd/extracted/DerivedBidiClass.txt",
  ),
  (
    "BidiMirroring.txt", "https://www.unicode.org/Public/16.0.0/ucd/BidiMirroring.txt",
  ),
  (
    "BidiBrackets.txt", "https://www.unicode.org/Public/16.0.0/ucd/BidiBrackets.txt",
  ),
  ("BidiTest.txt", "https://www.unicode.org/Public/16.0.0/ucd/BidiTest.txt"),
  (
    "BidiCharacterTest.txt", "https://www.unicode.org/Public/16.0.0/ucd/BidiCharacterTest.txt",
  ),
  (
    "NormalizationTest.txt", "https://www.unicode.org/Public/16.0.0/ucd/NormalizationTest.txt",
  ),
]

///|
async fn save_string(name : String, content : String) -> Unit {
  @fs.write_file(
    "tools/.cache/\{name}",
    content,
    create_mode=CreateOrTruncate,
    permission=0o644,
  )
  println("OK \{name} (\{content.length()} bytes)")
}

///|
fn path_of(url : String) -> String {
  match url.split_once("://") {
    Some((_, rest)) =>
      match rest.split_once("/") {
        Some((_, path)) => "/\{path}"
        None => "/"
      }
    None => "/"
  }
}

///|
fn host_of(url : String) -> String {
  match url.split_once("://") {
    Some((scheme, rest)) =>
      match rest.split_once("/") {
        Some((host, _)) => "\{scheme}://\{host}"
        None => "\{scheme}://\{rest}"
      }
    None => url
  }
}

///|
async fn fetch_stream(name : String, url : String) -> Unit {
  let host = host_of(url)
  let path = path_of(url)
  let headers = Map::from_array([
    ("User-Agent", "moonbit-unicode-gen/1.0"),
    ("Connection", "close"),
    ("Accept-Encoding", "identity"),
  ])
  let client = @http.Client::Client(host, headers~)
  let response = client.get(path)
  println("\{name} stream code=\{response.code}")
  guard response.code >= 200 && response.code < 300 else {
    client.close()
    fail("bad status \{response.code} for \{name}")
  }
  let file = @fs.open(
    "tools/.cache/\{name}",
    mode=@fs.Mode::WriteOnly,
    create_mode=CreateOrTruncate,
    permission=0o644,
  )
  let buf = FixedArray::make(65536, b'0')
  let mut total = 0
  for ;; {
    let n = client.read(buf, offset=0, max_len=65536) catch {
      e => {
        println("\{name} read raised \{e.to_string()}")
        client.close()
        file.close()
        fail("read failed for \{name}")
      }
    }
    if n == 0 {
      break
    }
    file.write(Bytes::from_iter(buf.iter().take(n)))
    total += n
  }
  client.close()
  file.close()
  guard total > 0 else { fail("empty body for \{name}") }
  println("OK \{name} (\{total} bytes)")
}

///|
async fn fetch(name : String, url : String) -> Unit {
  for attempt in 1..<=3 {
    let headers = Map::from_array([("User-Agent", "moonbit-unicode-gen/1.0")])
    let pair = @http.get(url, headers~) catch {
      e => {
        println("\{name} attempt \{attempt}: get raised \{e.to_string()}")
        continue
      }
    }
    let (response, body) = pair
    println("\{name} attempt \{attempt}: code=\{response.code}")
    if response.code >= 200 && response.code < 300 {
      try {
        let content = body.text()
        if content.length() > 0 {
          save_string(name, content)
          return
        }
        println("\{name} empty body")
      } catch {
        e => println("\{name} body read error: \{e.to_string()}")
      }
    }
  }
  // Fall back to a manual streaming read over a dedicated client.
  println("\{name}: falling back to streaming read")
  fetch_stream(name, url)
}

///|
async fn main {
  for pair in sources {
    let (name, url) = pair
    if @fs.exists("tools/.cache/\{name}") {
      let text = @fs.read_file("tools/.cache/\{name}").text()
      if text.contains("\n") {
        println("cached \{name}")
        continue
      }
      println("refetching corrupt \{name}")
    }
    fetch(name, url) catch {
      _ => fail("failed to fetch \{name}")
    }
  }
}
