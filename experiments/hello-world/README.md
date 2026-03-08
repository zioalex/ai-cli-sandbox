# Experiment: Hello World

A simple starting point to verify the agent is working correctly in this sandbox.

## Task

Create a script called `hello.py` that:

1. Prints `Hello, World!` to stdout.
2. Accepts an optional command-line argument `--name <name>` and prints `Hello, <name>!` instead.

## Expected Behavior

```
$ python hello.py
Hello, World!

$ python hello.py --name Alice
Hello, Alice!
```

## Success Criteria

- The script runs without errors.
- Default output is `Hello, World!`.
- With `--name`, the output greets the provided name.
