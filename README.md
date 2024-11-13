# My dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system

### Git

- Brew

```bash
brew install git
```

- APT

```bash
sudo apt install git
```

### Stow

- Homebrew

```bash
brew install stow
```

- APT

```bash
sudo apt install stow
```

## Installation

### Packages to install

Shell Tools

- `bat` (`batcat`)
- `fd` (`fd-find`)
- `fzf`
- `eza` (can be replaced with `tree` for `fzf` preview)
- `zoxide` (`z` `zi`)
- `rg` (`ripgrep`)
- `tmux`

Terminal

- `starship`
- `wezterm`
- `zsh`

Text Editor

- `neovim`
  (i use `lazyvim`, requires `lazygit`, `luarocks`, `xsel` and the shell tools above)
- `code` (VS Code)

Version Manager

- `git`
- `git-lfs`
- `mise`

Optional

- `docker`
- `keychain`

### The dotfiles

First, check out the .dotfiles repo in your $HOME directory using git

```bash
git clone git@github.com/drekunia/.dotfiles.git
cd .dotfiles
```

then use GNU stow to create symlinks

```bash
stow .
```
