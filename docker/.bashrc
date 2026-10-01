# Appended to /home/dev/.bashrc in the dev container (see Dockerfile).
# Not meant to be run directly.

# ---- python-playground shell setup -------------------------------------

# History: large, deduplicated, and saved after every command.
# Stored in a volume, so it survives `make stop` / `make dev`.
export HISTFILE="$HOME/.history/bash_history"
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# Tab completion (make targets, git)
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi

# Colors
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Navigation
alias ll='ls -lah'
alias ..='cd ..'
alias ws='cd /workspace'
alias ex='cd /workspace/examples'

# uv shortcuts
alias uvi='uv init'
alias uva='uv add'
alias uvr='uv run'
alias uvs='uv sync'

# Prompt (keep this last)
eval "$(starship init bash)"
