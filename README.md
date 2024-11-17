# My dotfiles

This repository contains the dotfiles for my system.
I aim to make this setup to be easy to replicate mainly on Ubuntu and Debian based OS, so here I use `apt` for the installation.
For Mac environment, I think it's still easy to replicate using Homebrew.

## Installation

### Shell Tools

- Install [Jetbrains Mono Nerd Font](https://www.jetbrains.com/lp/mono/)

- Install [WezTerm](https://wezfurlong.org/wezterm/install/linux.html#using-the-apt-repo) (or Setup Windows Terminal for WSL)

  ```bash
  curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg && \
  echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list && \
  sudo apt update && sudo apt install wezterm
  ```

  For Windows Terminal, apply this [settings.json](https://gist.github.com/drekunia/8eb6db8024bdc668d7ccece28a820109) in Settings

- Install required packages

  ```bash
  sudo apt install stow git zsh bat fd-find eza zoxide ripgrep tmux
  ```

  (`eza` can be replaced with `tree` for `fzf` preview)

- Symlink `fdfind` to local PATH (see [more details](https://github.com/sharkdp/fd?tab=readme-ov-file#on-ubuntu))

  ```bash
  mkdir ~/.local/bin; \
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
  mkdir ~/{.config,.vim,.zsh}
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

- Clone ZSH plugins

  ```bash
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_PLUGINS:-~/.zsh/plugins}/zsh-autosuggestions; \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_PLUGINS:-~/.zsh/plugins}/zsh-syntax-highlighting; \
  git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_PLUGINS:-~/.zsh/plugins}/you-should-use; \
  git clone https://github.com/zsh-users/zsh-history-substring-search.git ${ZSH_PLUGINS:-~/.zsh/plugins}/zsh-history-substring-search
  ```

- Install [Starship](https://starship.rs/#quick-install)

  ```bash
  curl -sS https://starship.rs/install.sh | sh
  ```

### Development Environment

#### GPG keypair for signing Git commit

tba

#### [Rust with rustup](https://www.rust-lang.org/tools/install)

`rustc` is a requirement for `ruby` in `mise` plugins, so it's better to install Rust version manager first

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

#### mise, Neovim, and LazyVim

I use LazyVim and some plugins have dependencies\
I put `lazygit` on `mise` config and other packages are installed with `apt`

- Install [mise-en-place](https://mise.jdx.dev/installing-mise.html#apt)

  ```
  sudo install -dm 755 /etc/apt/keyrings && \
  wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1> /dev/null && \
  echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=amd64] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list && \
  sudo apt update && sudo apt install -y mise
  ```

- `mise` requires `unzip` for extracting plugins on install

  ```bash
  sudo apt install unzip
  ```

- **Restart Terminal** and run `mise install`\
  (check the [plugin details](https://mise.jdx.dev/plugins.html) for requirements if the install fails)\
  To install `ruby` plugin, install these [dependencies](https://github.com/rbenv/ruby-build/wiki#ubuntudebianmint) along with `rustc`

  ```bash
  sudo apt-get install autoconf patch build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
  ```

- Install `luarocks` and `xsel` (LazyVim dependencies)

  ```bash
  sudo apt install luarocks xsel
  ```

- Install [Neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md#ubuntu) (v0.10.0 or later)

  ```bash
  sudo add-apt-repository ppa:neovim-ppa/unstable && \
  sudo apt-get update && \
  sudo apt-get install neovim
  ```

#### Other tools

- [wslu](https://wslutiliti.es/wslu/install.html#ubuntu): A collection of utilities for WSL (including `xdg-open`)

  ```bash
  sudo add-apt-repository ppa:wslutilities/wslu
  sudo apt update
  sudo apt install wslu
  ```

- [Docker Engine](https://docs.docker.com/engine/install/ubuntu/)
- [VS Code](https://code.visualstudio.com/docs/setup/linux)
- [Cursor](https://www.cursor.com/)
- [Github CLI](https://github.com/cli/cli/blob/trunk/docs/install_linux.md)

  ```bash
  sudo apt install gh
  ```

- [Warp Terminal](https://docs.warp.dev/getting-started/getting-started-with-warp)
- [Ollama](https://github.com/ollama/ollama?tab=readme-ov-file#linux)

  ```bash
  curl -fsSL https://ollama.com/install.sh | sh
  ```

- `jekyll`: run `gem install bundler jekyll` after installing `ruby`
- `git-lfs`
- `keychain`

## Problems

I made a separate Starship config and add some conditionals in `.zshrc` for WSL not to include glyphs.
For some reason, most glyphs doesn't work in Windows Terminal.
Let me know in the issues if you have solution or any idea on this.
