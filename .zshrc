export GPG_TTY=$(tty)

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# ZSH
HISTSIZE=100000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt nobeep

export ZSH_CUSTOM=$HOME/.zsh
export ZSH_PLUGINS=$ZSH_CUSTOM/plugins

# ZSH plugins
source $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH_PLUGINS/you-should-use/you-should-use.plugin.zsh

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Additional configs
# export MANPATH="/usr/local/man:$MANPATH"
# export LANG=en_US.UTF-8
# export ARCHFLAGS="-arch $(uname -m)"

# General aliases
alias md='mkdir -p'
alias rd=rmdir
alias which-command=whence

# Functions
# Returns whether the given command is executable or aliased
# _has() {
#   return $(whence $1 >/dev/null)
# }

# Laravel Sail
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'

# Console Ninja VS Code Extension
PATH=~/.console-ninja/.bin:$PATH

# bat
if command -v batcat >/dev/null 2>&1; then
  # Save the original system `cat` under `rcat`
  alias rcat="$(which cat)"

  # For Ubuntu and Debian-based `bat` packages
  # the `bat` program is named `batcat` on these systems
  alias cat="$(which batcat)"
  export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
  export MANROFFOPT="-c"
elif command -v bat >/dev/null 2>&1; then
  # Save the original system `cat` under `rcat`
  alias rcat="$(which cat)"

  # For all other systems
  alias cat="$(which bat)"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c"
fi

# eza
if [ $(command -v eza) ]; then
  alias ls='eza --color=always --group-directories-first --icons'
  alias ll='eza -la --icons --octal-permissions --group-directories-first'
  alias l='eza -bGF --header --git --color=always --group-directories-first --icons'
  alias llm='eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons' 
  alias la='eza --long --all --group --group-directories-first'
  alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons'
  alias lS='eza -1 --color=always --group-directories-first --icons'
  alias lt='eza --tree --level=2 --color=always --group-directories-first --icons'
  alias l.="eza -a | grep -E '^\.'"
else
  alias ls='ls --color=tty'
  alias ll='ls -lh'
  alias l='ls -lah'
  alias la='ls -lAh'
  alias lsa'ls -lah'
fi

# ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.config/rg/ripgreprc"

# tmux
if [ $(command -v tmux) ]; then
  # Use 256 color for tmux
  alias tmux="TERM=screen-256color-bce tmux"

  # Attemtp to take over existing sessions before creating a new tmux session.
  TMUX_DEFAULT_SESSION="tmux"
  alias t="tmux -u a -d -t ${TMUX_DEFAULT_SESSION} 2> /dev/null || tmux -u new -s ${TMUX_DEFAULT_SESSION}"
fi

# keychain
# if [[ $(command -v keychain) && -e ~/.ssh/id_rsa ]]; then
#   eval `keychain --eval --quiet id_rsa`
# fi

if [[ $(command -v keychain) && -e ~/.ssh/id_ed25519 ]]; then
  eval `keychain --eval --quiet id_ed25519`
fi

# fzf
if [ $(command -v fzf) ]; then
  export FZF_DEFAULT_OPTS='--no-height --color=bg+:#1a1b26,gutter:#32344a,pointer:#f7768e,info:#9ece6a,hl:#7aa2f7,hl+:#7dcfff'

  if type fd > /dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --color=never --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d . --color=never --hidden --follow --exclude .git'
  fi

  if type batcat > /dev/null 2>&1; then
    export FZF_CTRL_T_OPTS="--preview 'batcat --color=always {}'"
  else
    export FZF_CTRL_T_OPTS="--preview 'cat -n {}'"
  fi

  if type eza > /dev/null 2>&1; then
    export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --group-directories-first --icons {}'"
  elif type tree > /dev/null 2>&1; then
    export FZF_ALT_C_OPTS="--preview 'tree -C {}'"
  fi

  # Set up fzf keybindings and fuzzy completion
  # source <(fzf --zsh)
  . /usr/share/doc/fzf/examples/key-bindings.zsh
  . /usr/share/doc/fzf/examples/completion.zsh

  # Kill process
  fzf-kill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf --header-lines=1 --preview 'echo {}' --header 'Select a process to kill' | awk '{print $2}')
    if [ -n "$pid" ]; then
      kill -9 "$pid"
    fi
  }

  # SSH selection
  # fzf-ssh() {
  #   local host
  #   host=$(cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sort | uniq | fzf) && zle accept-line
  #   BUFFER="ssh $host"
  #   zle end-of-line
  # }
fi

# zoxide
if [ $(command -v zoxide) ]; then
  export _ZO_RESOLVE_SYMLINKS=1
  eval "$(zoxide init zsh --cmd cd)"
fi

# mise
if [ $(command -v mise) ]; then
  eval "$(mise activate zsh)"
fi

# starship
if [ $(command -v starship) ]; then
  eval "$(starship init zsh)"
fi
