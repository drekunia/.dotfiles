# My dotfiles

This directory contains the dotfiles for my system

## Installation

### Shell Tools

- Install [Jetbrains Mono Nerd Font](https://www.jetbrains.com/lp/mono/)

- Install [WezTerm](https://wezfurlong.org/wezterm/install/linux.html#using-the-apt-repo) (or Setup Windows Terminal for WSL)
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

- Setup Git credentials (SSH key in my case)
  Create or import SSH keypair and make sur it's not too open
  ```bash
  chmod 700 ~/.ssh; \
  chmod 644 ~/.ssh/id_ed25519.pub; \
  chmod 600 ~/.ssh/id_ed25519; \
  ssh-add
  ```

- Clone this repository to home
  ```
  git clone git@github.com:drekunia/.dotfiles.git ~/.dotfiles
  ```

- Stow the configs
  ```
  cd ~/.dotfiles && stow .
  ```

- Change default shell to ZSH
  ```bash
  chsh -s $(which zsh)
  ```

- Restart Terminal

- Clone ZSH plugins
  ```
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

#### Neovim and LazyVim
I use LazyVim and some plugin have dependencies. I put `lazygit` on `mise` config and other packages are installed with `apt`.

- Install [mise-en-place](https://mise.jdx.dev/installing-mise.html#apt)

- Restart Terminal and run `mise install`
  (check the [plugin details](https://mise.jdx.dev/plugins.html) for requirements if the install fails)

- Install `luarocks` and `xsel`
  ```bash
  sudo apt install luarocks xsel
  ```

- Install Neovim (v0.10.0 or later)
  ```
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
- `git-lfs`
- `keychain`

