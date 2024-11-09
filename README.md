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
### Shell Tools (highly recommended)
- bat
- eza
- fd (fd-find)
- fzf
- rg (ripgrep)
- zoxide

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
