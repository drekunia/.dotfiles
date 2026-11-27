# My dotfiles

My personal Linux/WSL configuration files, managed with [GNU Stow](https://www.gnu.org/software/stow/). Mainly intended for Ubuntu and Debian-based distributions.

For my Windows configuration, see [dotfiles-windows](https://github.com/drekunia/dotfiles-windows).

## Installation

### Shell tools

- Install [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads).
- Install [WezTerm](https://wezfurlong.org/wezterm/install/linux.html) or use [my Windows Terminal settings](https://github.com/drekunia/dotfiles-windows/blob/main/home/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json) for WSL.
- Install dependencies:

  ```bash
  sudo apt install stow zsh git git-delta bat fd-find eza zoxide ripgrep fzf tmux keychain
  ```

- Symlink `fdfind` to `fd`:

  ```bash
  mkdir -p ~/.local/bin
  ln -s "$(command -v fdfind)" ~/.local/bin/fd
  ```

- Set up SSH for Git authentication and signing. Create or import an Ed25519 keypair:

  ```bash
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/id_ed25519
  chmod 644 ~/.ssh/id_ed25519.pub
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519
  ```

- Clone and stow the dotfiles:

  ```bash
  git clone git@github.com:drekunia/dotfiles.git ~/.dotfiles
  mkdir -p ~/{.config/gh,.vim,.zsh,.ssh,.gnupg}
  cd ~/.dotfiles
  stow .
  ```

  Back up existing configuration files and resolve any conflicts before running `stow .`.

- Set Zsh as the default shell, then restart the terminal:

  ```bash
  chsh -s "$(command -v zsh)"
  ```

- Generate the locale if needed:

  ```bash
  sudo locale-gen en_US.UTF-8
  ```

- Install Zsh plugins:

  ```bash
  mkdir -p "${ZSH_PLUGINS:-$HOME/.zsh/plugins}"
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_PLUGINS:-$HOME/.zsh/plugins}/zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "${ZSH_PLUGINS:-$HOME/.zsh/plugins}/zsh-syntax-highlighting"
  git clone https://github.com/MichaelAquilina/zsh-you-should-use "${ZSH_PLUGINS:-$HOME/.zsh/plugins}/you-should-use"
  git clone https://github.com/zsh-users/zsh-history-substring-search "${ZSH_PLUGINS:-$HOME/.zsh/plugins}/zsh-history-substring-search"
  ```

- Install [Starship](https://starship.rs/#quick-install).

### Development environment

#### Git

Git configuration and global ignore rules are located in `~/.config/git/`. Adjust the identity and signing key in `config` if needed.

SSH signing is enabled for commits and tags. Alternatively, disable signing in `~/.config/git/config`.

Install [GitHub CLI](https://github.com/cli/cli/blob/trunk/docs/install_linux.md) and [Git LFS](https://git-lfs.com/).

```bash
gh auth login
```

#### mise, Neovim, and LazyVim

- Install development dependencies:

  ```bash
  sudo apt install build-essential luarocks xsel lazygit
  ```

- Install [Ruby build dependencies](https://github.com/rbenv/ruby-build/wiki#ubuntudebianmint) if needed.
- Install [mise](https://mise.jdx.dev/installing-mise.html), restart the terminal, and run `mise install`.
- Install [Neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md#ubuntu) (see [LazyVim requirements](https://www.lazyvim.org/installation)).

#### Other tools

- [wslu](https://wslutiliti.es/wslu/install.html#ubuntu) (WSL only)
- [Yazi](https://yazi-rs.github.io/docs/installation#apt)
- [Docker Engine](https://docs.docker.com/engine/install/ubuntu/)
- [Ollama](https://ollama.com/download/linux)
- [jq](https://jqlang.github.io/jq/)
- [Fastfetch](https://github.com/fastfetch-cli/fastfetch)
- [Google Chrome](https://www.google.com/linuxrepositories/)

## Other useful tools

- [WireGuard](https://protonvpn.com/support/wireguard-linux#cli)
- [cheat.sh](https://cheat.sh)
- [qrenco.de](https://qrenco.de)

