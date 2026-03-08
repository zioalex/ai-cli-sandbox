# Experiment: Refactor

Practice refactoring messy code into clean, idiomatic Python.

## Task

The file `messy.py` contains working but poorly written Python code. Refactor it so that it:

1. Uses proper function and variable names (PEP 8).
2. Eliminates code duplication.
3. Adds type hints.
4. Passes `flake8` with no warnings.

Do **not** change the observable behavior — all existing outputs must remain the same.

## Files

- `messy.py` — the code to refactor (do not delete, rename to `messy_original.py` as a backup before editing)
- `clean.py` — write your refactored version here

## Success Criteria

- `python clean.py` produces the same output as `python messy.py`.
- `flake8 clean.py` reports no issues.
- The refactored code is noticeably cleaner and easier to read.
