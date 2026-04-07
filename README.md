# Homebrew Tap

Custom Homebrew formulae for [mangas](https://github.com/mangas) projects.

## Setup

```sh
brew tap mangas/tap
```

## Formulas

### mcpfile

Declarative MCP server manager for Docker-based MCP servers.

```sh
brew install mangas/tap/mcpfile
```

### graphctl-rs

Tools for managing Graph network subgraph deployments. Each binary is a separate formula — install only what you need.

```sh
# CLI client
brew install mangas/tap/gctl

# Server daemon (NATS listener)
brew install mangas/tap/gctl-server

# MCP server for AI assistants
brew install mangas/tap/gctl-mcp
```

## Supported platforms

| Platform       | mcpfile | gctl | gctl-server | gctl-mcp |
|----------------|---------|------|-------------|----------|
| macOS ARM      | yes     | yes  | yes         | yes      |
| Linux x86_64   | yes     | yes  | yes         | yes      |

macOS Intel and Linux ARM are not currently built.

## Upgrading

```sh
brew update
brew upgrade mangas/tap/<formula>
```

Formula updates are checked automatically every 6 hours via GitHub Actions. To trigger a check manually:

```sh
just update-formulas
```

Or directly:

```sh
gh workflow run update-formulas.yml --repo mangas/homebrew-tap
```
