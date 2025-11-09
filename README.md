# My dotfiles

This repository contains the dotfiles for my system.
I aim to make this setup to be easy to replicate mainly on Ubuntu and Debian based OS, so here I use `apt` for the installation.
For Mac environment, use [Homebrew](https://brew.sh/) instead.

## Installation

### Shell Tools

- Install [Jetbrains Mono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases)

- Install [WezTerm](https://wezfurlong.org/wezterm/install/linux.html#using-the-apt-repo) (or Setup Windows Terminal for WSL)

  For Windows Terminal, apply this [settings.json](https://gist.github.com/drekunia/8eb6db8024bdc668d7ccece28a820109) in Settings

- Install required packages

  ```bash
  sudo apt install stow git zsh bat fd-find eza zoxide ripgrep tmux fzf keychain
  ```

  (`eza` can be replaced with `tree` for `fzf` preview)

- Symlink `fdfind` to local PATH (see [more details](https://github.com/sharkdp/fd?tab=readme-ov-file#on-ubuntu))

  ```bash
  mkdir ~/.local/bin -p; \
  ln -s $(which fdfind) ~/.local/bin/fd
  ```

- Setup Git credentials (SSH key in my case)\
  Create or import SSH keypair and make sure it's not too open

  ```bash
  chmod 700 ~/.ssh; \
  chmod 644 ~/.ssh/id_ed25519.pub; \
  chmod 600 ~/.ssh/id_ed25519; \
  ssh-add
  ```

- Clone this repository to home

  ```bash
  git clone git@github.com:drekunia/.dotfiles.git ~/.dotfiles
  ```

- Create directories to avoid symlink to parent directories

  ```bash
  mkdir ~/{.config/zed,.config/gh,.vim,.zsh,.ssh,.gnupg} -p
  ```

- Stow the configs

  ```bash
  cd ~/.dotfiles && stow .
  ```

  (sometimes needs to resolve conflicts in case of duplicates)

- Change default shell to ZSH

  ```bash
  chsh -s $(which zsh)
  ```

- **Restart Terminal**

- Generate locale (if not available)

  ```bash
  sudo locale-gen en_US.UTF-8
  ```

- Clone ZSH plugins

  ```bash
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_PLUGINS:-~/.zsh/plugins}/zsh-autosuggestions; \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_PLUGINS:-~/.zsh/plugins}/zsh-syntax-highlighting; \
  git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_PLUGINS:-~/.zsh/plugins}/you-should-use; \
  git clone https://github.com/zsh-users/zsh-history-substring-search.git ${ZSH_PLUGINS:-~/.zsh/plugins}/zsh-history-substring-search
  ```

- Install [Starship](https://starship.rs/#quick-install)

### Development Environment

#### GPG keypair for signing Git commit

Or just disable signing in `.config/git/config`

#### mise, Neovim, and LazyVim

I use [LazyVim](https://www.lazyvim.org/) and some plugins have dependencies\
I put `lazygit` on `mise` config and other packages are installed with `apt`

- Install [mise-en-place](https://mise.jdx.dev/installing-mise.html)

- **Restart Terminal** and run `mise install`\
  (check the [plugin details](https://mise.jdx.dev/plugins.html) for requirements if the install fails)\
  To install `ruby`, `erlang`, and `elixir` plugin, install these [dependencies](https://github.com/rbenv/ruby-build/wiki#ubuntudebianmint) along with `rustc` ([rustup](https://rustup.rs/))

- Install `luarocks` and `xsel` (LazyVim dependencies)

  ```bash
  sudo apt install luarocks xsel
  ```

- Install `python3-venv` (Ruff dependencies)

  ```bash
  sudo apt install python3-venv
  ```

- Install [Neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md#ubuntu) (v0.10.0 or later)

Check `.other-installs/` for tools that are not automatically installed

#### Other common dev tools

CLI

- [wslu](https://wslutiliti.es/wslu/install.html#ubuntu): A collection of utilities for WSL (including `xdg-open`)
- [Docker Engine](https://docs.docker.com/engine/install/ubuntu/)

GUI

- [Google Chrome](https://www.google.com/linuxrepositories/)

  ```
  wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo tee /etc/apt/trusted.gpg.d/google.asc >/dev/null && \
  echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google.list && \
  sudo apt update && sudo apt install google-chrome-stable
  ```

## Other useful packages to install

- [Github CLI](https://github.com/cli/cli/blob/trunk/docs/install_linux.md)
- [Git LFS](https://git-lfs.com/): Git extension for versioning large files
- `wireguard`: CLI VPN client (read [setup guide](https://protonvpn.com/support/wireguard-linux#cli))
- `jq`: JSON formatter CLI (read [tutroial](https://jqlang.github.io/jq/tutorial/))
- [Ollama](https://ollama.com/download/linux)
