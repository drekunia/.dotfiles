# My dotfiles

This repository contains the dotfiles for my system.
I aim to make this setup to be easy to replicate mainly on Ubuntu and Debian based OS, so here I use `apt` for the installation.
For Mac environment, I think it's still easy to replicate using Homebrew.

## Installation

### Shell Tools

- Install [Jetbrains Mono Nerd Font](https://www.jetbrains.com/lp/mono/)

- Install [WezTerm](https://wezfurlong.org/wezterm/install/linux.html#using-the-apt-repo) (or Setup Windows Terminal for WSL)\
  For Windows Terminal, apply this [settings.json](https://gist.github.com/drekunia/8eb6db8024bdc668d7ccece28a820109) in Settings

- Install required packages
  ```bash
  sudo apt install stow git zsh bat fd-find eza zoxide ripgrep tmux
  ```
  (`eza` can be replaced with `tree` for `fzf` preview)

- Symlink `fdfind` to local PATH 
  ```bash
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

- Stow the configs
  ```bash
  cd ~/.dotfiles && stow .
  ```

- Change default shell to ZSH
  ```bash
  chsh -s $(which zsh)
  ```

- Restart Terminal

- Clone ZSH plugins
  ```bash
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_PLUGINS:-~/.zsh/plugins}/zsh-autosuggestions; \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_PLUGINS:-~/.zsh/plugins}/zsh-syntax-highlighting; \
  git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_PLUGINS:-~/.zsh/plugins}/you-should-use; \
  git clone https://github.com/zsh-users/zsh-history-substring-search.git ${ZSH_PLUGINS:-~/.zsh/plugins}/zsh-history-substring-search
  ```

- Install Starship
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

I use LazyVim and some plugin have dependencies\
I put `lazygit` on `mise` config and other packages are installed with `apt`

- Install [mise-en-place](https://mise.jdx.dev/installing-mise.html#apt)

- `mise` requires `unzip` for extracting plugins on install
  ```bash
  sudo apt install unzip
  ```

- Restart Terminal and run `mise install`\
  (check the [plugin details](https://mise.jdx.dev/plugins.html) for requirements if the install fails)\
  To install `ruby` plugin, install these [dependencies](https://github.com/rbenv/ruby-build/wiki#ubuntudebianmint) along with `rustc`
  ```bash
  sudo apt-get install autoconf patch build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
  ```

- Install `luarocks` and `xsel`
  ```bash
  sudo apt install luarocks xsel
  ```

- Install Neovim (v0.10.0 or later)
  ```bash
  sudo apt-get install software-properties-common && \
  sudo add-apt-repository ppa:neovim-ppa/stable && \
  sudo apt-get update && \
  sudo apt-get install neovim
  ```

#### Other tools
- [Docker Engine](https://docs.docker.com/engine/install/ubuntu/)
- [VS Code](https://code.visualstudio.com/docs/setup/linux)
- [Cursor](https://www.cursor.com/)
- [Github CLI](https://github.com/cli/cli/blob/trunk/docs/install_linux.md)
- [Warp Terminal](https://docs.warp.dev/getting-started/getting-started-with-warp)
- [Ollama](https://github.com/ollama/ollama?tab=readme-ov-file#linux)
- `jekyll`: run `gem install bundler jekyll` after installing `ruby`
- `git-lfs`
- `keychain`

## Problems

I made a separate Starship config and add some conditionals in `.zshrc` for WSL not to include glyphs.
For some reason, most glyphs doesn't work in Windows Terminal. 
Let me know in the issues if you have solution or any idea on this.
