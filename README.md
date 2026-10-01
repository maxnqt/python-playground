# python-playground

> A sandbox for experimenting with Python, from core language features and standard-library gems to Django and async, with write-ups for each.

This repo is my working notebook for learning Python. It has two parts: `notes` where I write down concepts, gotchas, and "aha" moments as I go, and a set of `examples`, each a small, self-contained uv project that explores one idea.

Everything runs inside a Docker dev container, so the only thing you need installed locally is Docker. No Python toolchain on the host required.

## Project layout

```
python-playground/
├── docker/             # Shell setup copied into the image
│   ├── .bashrc         # History, completion, aliases
│   └── starship.toml   # Prompt (bind-mounted, edits apply on new shell)
├── examples/           # Self-contained uv projects, one folder per example
│   └── <example>/
│       ├── pyproject.toml
│       └── ...
├── notes/              # Learning log: concepts, commands, lessons learned
├── compose.yaml        # Dev container, code mount, uv cache volume
├── Dockerfile          # Python dev image (uv, non-root user)
├── LICENSE
└── Makefile            # Host commands: dev, stop, clean
```

## Getting started

**Prerequisites:** [Docker Desktop](https://docs.docker.com/get-docker/), Colima, or Docker Engine with the Compose plugin, plus `make`.

On macOS with Colima, install the `docker-buildx` plugin too and add
Homebrew's plugin folder to `~/.docker/config.json`
(`"cliPluginsExtraDirs": ["/opt/homebrew/lib/docker/cli-plugins"]`),
otherwise builds fall back to the legacy builder. The Makefile's
`COMPOSE` variable can be `docker compose` or `docker-compose`.

From the repo root on your machine:

```bash
make dev     # build the image, start the container, open a shell in it
make stop    # stop the container (image and caches are kept)
make clean   # remove the container, network, image, cache and history volumes
```

`make dev` is safe to run again: if the container is already up, it just opens another shell. The repo is mounted at `/workspace`, so edits you make in your editor on the host show up in the container immediately.

### Inside the container

The shell has a one-line [Starship](https://starship.rs) prompt
(`dev@python-playground:/workspace (branch *%) $`), tab completion for
`make` and `git`, and bash history that survives restarts.

| Alias | Runs |
|---|---|
| `ws` / `ex` | `cd /workspace` / `cd /workspace/examples` |
| `uvi` / `uva` | `uv init` / `uv add` |
| `uvr` / `uvs` | `uv run` / `uv sync` |

Prompt changes in `docker/starship.toml` apply when you open a new shell.
Changes to `docker/.bashrc` need `make dev` to rebuild.

Git markers in the prompt: `*` unstaged, `+` staged, `%` untracked,
`$` stash, `-` deleted, `=` conflicts, `>`/`<`/`<>` ahead/behind/diverged.

### Working on an example

Inside the container, create or `cd` into an example:

```bash
cd examples
uv init 01-hello-world && cd 01-hello-world
uv run python hello.py
```

### Adding an example

1. Inside the container: `cd examples && uv init 02-my-example`
2. Add a README using the template below and a row to the example index.

**Example README template:**

1. **What it does:** one or two sentences
2. **Why it's useful:** the concept or problem it illustrates
3. **How to run it:** exact commands
4. **What I learned:** gotchas and notes

### Troubleshooting

If `uv sync` or file creation fails, check that `dev` can write to
`/workspace`: `touch /workspace/test && rm /workspace/test` inside the
container should succeed. If it doesn't, the bind mount's permissions
don't match your host user.

## Topics

> Kind reminder: never try to "finish" (learning) a language. Reach productive fluency by becoming able to read an unfamiliar codebase, make a safe change, debug failures, test behavior, profile bottlenecks, and explain trade-offs.

A running list of topics covered in [`notes/`](notes/).

### Core mechanics

- [ ] Types and data model
- [ ] Control flow
- [ ] Functions and decorators
- [ ] Collections
- [ ] Modules and packages
- [ ] Errors and exceptions
- [ ] I/O
- [ ] Debugging
- [ ] Build tooling (uv, pyproject.toml)
- [ ] Tests (pytest)

### Idioms

- [ ] Pythonic code and PEP 8
- [ ] Generators and iterators
- [ ] Context managers
- [ ] Comprehensions
- [ ] Type hints
- [ ] Naming conventions

### Production mechanics

- [ ] Logging
- [ ] Configuration
- [ ] Dependency management
- [ ] Concurrency (threading, multiprocessing, asyncio)
- [ ] Serialization (JSON, dataclasses, Pydantic)
- [ ] Database access
- [ ] HTTP and networking
- [ ] Observability
- [ ] Profiling
- [ ] Security boundaries

### Frameworks

- [ ] Django
- [ ] FastAPI
- [ ] Flask

### Project(s)

> Narrow service/tool with a user/use case and constraints. Deliberate rewrites: make it work; then add tests and error handling; then refactor for clarity; then measure performance before optimizing.

- [ ] ...

## License

Code (Python sources, Makefiles, Dockerfile, Compose files, etc.) is licensed under the [MIT License](LICENSE).
Written notes and documentation are licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
