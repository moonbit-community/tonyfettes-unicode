"""Regression checks for preserving independent benchmark result sets."""
import importlib.util
from pathlib import Path
import tempfile
from types import SimpleNamespace
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location('normperf_run', Path(__file__).with_name('run.py'))
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)


class ResultDirectoryTests(unittest.TestCase):
    def test_native_rerun_preserves_and_rejects_existing_backend_results(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory)
            previous = {
                'environment.json': '{"source_revision":"old-head"}\n',
                'icu-1.jsonl': 'old ICU samples\n',
                'native-1.jsonl': 'old Native samples\n',
                'wasm-1.jsonl': 'old Wasm samples\n',
                'wasm-gc-1.jsonl': 'old Wasm-GC samples\n',
            }
            for name, content in previous.items():
                (output / name).write_text(content)
            args = SimpleNamespace(output=output, prepare_only=False, targets=['native'],
                                   repeats=1, icu_prefix=Path('/unused'))
            with patch.object(runner, 'prepare') as prepare:
                with self.assertRaisesRegex(ValueError, 'choose a new --output directory'):
                    runner.run(args)
                prepare.assert_not_called()
            self.assertEqual({p.name: p.read_text() for p in output.iterdir()}, previous)

    def test_prepare_only_leaves_existing_results_untouched(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory)
            original = output / 'environment.json'
            original.write_text('existing results')
            args = SimpleNamespace(output=output, prepare_only=True, icu_prefix=Path('/unused'))
            with patch.object(runner, 'prepare', return_value=(output, {})) as prepare:
                runner.run(args)
                prepare.assert_called_once_with(args.icu_prefix)
            self.assertEqual(original.read_text(), 'existing results')


if __name__ == '__main__':
    unittest.main()
