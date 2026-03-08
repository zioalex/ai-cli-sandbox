# ai-cli-sandbox

A general-purpose sandbox for experimenting with AI CLI coding agents. Use this repository to safely test, evaluate, and compare different AI agents in a controlled environment.

## Supported Agents

- **[Opencode](https://opencode.ai/)** — terminal-first AI coding agent supporting 75+ LLM providers

> More agents will be added over time. Contributions welcome!

## Getting Started

### Opencode

1. **Install Opencode**

   ```bash
   # Using the install script
   curl -fsSL https://opencode.ai/install | bash

   # Or with npm
   npm install -g opencode-ai

   # Or with Homebrew (macOS/Linux)
   brew install opencode
   ```

2. **Configure your API key** (choose a provider)

   ```bash
   export ANTHROPIC_API_KEY=sk-ant-...
   # or
   export OPENAI_API_KEY=sk-...
   ```

3. **Run Opencode in this sandbox**

   ```bash
   cd /path/to/ai-cli-sandbox
   opencode
   ```

   Opencode will read `.opencode.json` and `AGENTS.md` automatically to understand the project context.

4. **Try the example tasks** found in the `experiments/` directory.

## Repository Structure

```
ai-cli-sandbox/
├── .opencode.json        # Opencode project configuration
├── AGENTS.md             # Agent instructions and context
├── README.md             # This file
└── experiments/          # Example tasks and sandbox exercises
    ├── hello-world/      # Simple "hello world" starting point
    └── refactor/         # Refactoring exercise
```

## Running with Docker (sandbox isolation)

```bash
docker run -it --rm \
  -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/opencode-ai/opencode
```

## Contributing

Feel free to add new experiments, agent configurations, or support for additional AI CLI tools by opening a pull request.

## License

[MIT](LICENSE)