# ---------------------------------------------------------------------------------
# Header Setup
# ---------------------------------------------------------------------------------

# GPG_TTY required for no GUI environtment like WSL
export GPG_TTY=$(tty)

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# ---------------------------------------------------------------------------------
# ZSH
# ---------------------------------------------------------------------------------

# - ZSH history
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt BANG_HIST              # Treat the '!' character specially during expansion.
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event.
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file.
setopt HIST_VERIFY            # Do not execute immediately upon history expansion.
setopt NO_BEEP

alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

# - ZSH directory related config
export ZSH_CUSTOM=$HOME/.zsh

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHDMINUS

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias -- -='cd -'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias md='mkdir -p'
alias rd=rmdir

# - ZSH plugins
export ZSH_PLUGINS=$ZSH_CUSTOM/plugins

_source_plugin() {
  local plugin_path="$ZSH_PLUGINS/$1"

  if [[ -e "$plugin_path" ]]; then
    source "$plugin_path"
  fi
}

_source_plugin "zsh-autosuggestions/zsh-autosuggestions.zsh"
_source_plugin "zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
_source_plugin "you-should-use/you-should-use.plugin.zsh"

if [[ -e "$ZSH_PLUGINS/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
  source $ZSH_PLUGINS/zsh-history-substring-search/zsh-history-substring-search.zsh

  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down

  export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=magenta,bold'
  export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=''
  # export HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'
  # export HISTORY_SUBSTRING_SEARCH_FUZZY=''
  export HISTORY_SUBSTRING_SEARCH_PREFIXED=true
  # export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=true
  # export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_TIMEOUT=1
fi

# - ZSH additional configs
# export MANPATH="/usr/local/man:$MANPATH"
# export LANG=en_US.UTF-8
# export ARCHFLAGS="-arch $(uname -m)"

# General aliases
alias which-command=whence

# WSL environment check
if grep -iq "wsl" /proc/version; then
  export IN_WSL=true
else
  export IN_WSL=false
fi

# ---------------------------------------------------------------------------------
# Development Environment
# ---------------------------------------------------------------------------------

# - Text Editor
# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

if [ $(command -v nvim) ]; then
  alias vi=nvim
  alias vim=nvim
fi

# - Docker
if [ $(command -v docker) ]; then
  # default local postgresql environment
  alias run-local-postgres='docker run -d --name local_postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -v local_pgdata:/var/lib/postgresql/data postgres:alpine'
  alias stop-local-postgres='docker rm -f local_postgres'
fi

# - Version manager
# mise
if [ $(command -v mise) ]; then
  eval "$(mise activate zsh)"
fi

# - Other tools
# Laravel Sail
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'

# - VS Code Extensions
# Console Ninja
PATH=~/.console-ninja/.bin:$PATH

# ---------------------------------------------------------------------------------
# Shell Tools
# ---------------------------------------------------------------------------------

# - keychain
# if [[ $(command -v keychain) && -e ~/.ssh/id_rsa ]]; then
#   eval `keychain --eval --quiet id_rsa`
# fi

if [[ $(command -v keychain) && -e ~/.ssh/id_ed25519 ]]; then
  eval `keychain --eval --quiet id_ed25519`
fi

# - bat
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

# - eza
if [ $(command -v eza) ]; then
  if $IN_WSL; then
    alias ls='eza --color=always --group-directories-first'
  else
    alias ls='eza --color=always --group-directories-first --icons'
  fi

  alias ll='ls -la --octal-permissions'
  alias l='ls -bGF --header --git'
  alias llm='ls -lbGd --header --git --sort=modified' 
  alias la='ls --long --all --group'
  alias lx='ls -lbhHigUmuSa@ --time-style=long-iso --git --color-scale'
  alias lS='ls -1'
  alias lt='ls --tree --level=2'
  alias ltag='ls --tree --all --git-ignore'
  alias l.="eza -a | grep -E '^\.'"
else
  alias ls='ls --color=tty'
  alias ll='ls -lh'
  alias l='ls -lah'
  alias la='ls -lAh'
  alias lsa'ls -lah'
fi

# - ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.config/rg/ripgrep.conf"

# - fzf
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
    if $IN_WSL; then
      export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --group-directories-first {}'"
    else
      export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --group-directories-first --icons {}'"
    fi
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
fi

# - tmux
if [ $(command -v tmux) ]; then
  # Use 256 color for tmux
  alias tmux="TERM=screen-256color-bce tmux"

  # Attemtp to take over existing sessions before creating a new tmux session.
  TMUX_DEFAULT_SESSION="tmux"
  alias t="tmux -u a -d -t ${TMUX_DEFAULT_SESSION} 2> /dev/null || tmux -u new -s ${TMUX_DEFAULT_SESSION}"
fi

# - zoxide
if [ $(command -v zoxide) ]; then
  export _ZO_RESOLVE_SYMLINKS=1
  eval "$(zoxide init zsh --cmd cd)"
fi

# - starship
if [ $(command -v starship) ]; then
  if $IN_WSL; then
    export STARSHIP_CONFIG=~/.config/starship/starship_wsl.toml
  else
    export STARSHIP_CONFIG=~/.config/starship/starship.toml
  fi

  eval "$(starship init zsh)"
fi

# ---------------------------------------------------------------------------------
