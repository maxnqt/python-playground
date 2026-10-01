# Python dev environment for python-playground.
# The official image already ships python, pip, git, make, and a C toolchain.
FROM python:3-bookworm

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

# Shell niceties: tab completion, a less pager, and the Starship prompt
RUN apt-get update \
 && apt-get install -y --no-install-recommends bash-completion less \
 && rm -rf /var/lib/apt/lists/* \
 && curl -fsSL https://starship.rs/install.sh | sh -s -- -y \
 && git config --system --add safe.directory /workspace

# uv – fast Python package installer
RUN curl -LsSf https://astral.sh/uv/install.sh | env INSTALLER_NO_MODIFY_PATH=1 sh \
 && mv /root/.local/bin/uv /usr/local/bin/ \
 && mv /root/.local/bin/uvx /usr/local/bin/

# Non-root user matching your host UID/GID, so files created in the
# bind-mounted repo are owned by you (matters most on Linux).
# -o allows reusing IDs that already exist in the image (e.g. macOS GID 20).
RUN groupadd -o --gid "$USER_GID" "$USERNAME" \
 && useradd -o --uid "$USER_UID" --gid "$USER_GID" -m -s /bin/bash "$USERNAME" \
 && mkdir -p "/home/$USERNAME/.config" "/home/$USERNAME/.history" "/home/$USERNAME/.cache/uv" \
 && chown -R "$USER_UID:$USER_GID" "/home/$USERNAME"

# Prompt config and shell setup
COPY --chown=$USER_UID:$USER_GID docker/starship.toml /home/$USERNAME/.config/starship.toml
COPY docker/.bashrc /tmp/bashrc.append
RUN cat /tmp/bashrc.append >> "/home/$USERNAME/.bashrc" && rm /tmp/bashrc.append

USER $USERNAME
WORKDIR /workspace
