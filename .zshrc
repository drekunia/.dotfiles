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
export LANG=en_US.UTF-8
# export ARCHFLAGS="-arch $(uname -m)"
export LESS="-FR"

# export NO_GLYPH=true

# General aliases
alias which-command=whence

export WINDOWS_PROJECTS="/mnt/d/Files/Projects"
alias godotdir=$WINDOWS_PROJECTS/Godot/
alias unitydir=$WINDOWS_PROJECTS/Unity/
alias unrealdir="$WINDOWS_PROJECTS/Unreal\ Projects/"
alias wincodedir=$WINDOWS_PROJECTS/Code

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

if [[ $(command -v nvim) ]]; then
  export EDITOR='nvim'
  alias vi=nvim
  alias vim=nvim
else
  export EDITOR='vim'
fi

# - Version manager
# mise
if [[ $(command -v mise) ]]; then
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
if [[ $(command -v keychain) ]]; then
  eval `keychain --eval --quiet`
fi

# - delta
if command -v delta >/dev/null 2>&1; then
  alias rdiff="$(which diff) -u --color=auto"
  alias diff="$(which delta)"
else
  alias diff="$(which diff) -u --color=auto"
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
if [[ $(command -v eza) ]]; then
  if $NO_GLYPH; then
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
if [[ $(command -v fzf) ]]; then
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
    if $NO_GLYPH; then
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
if [[ $(command -v tmux) ]]; then
  # Use 256 color for tmux
  alias tmux="TERM=screen-256color-bce tmux"

  # Attemtp to take over existing sessions before creating a new tmux session.
  TMUX_DEFAULT_SESSION="tmux"
  alias t="tmux -u a -d -t ${TMUX_DEFAULT_SESSION} 2> /dev/null || tmux -u new -s ${TMUX_DEFAULT_SESSION}"
fi

# - zoxide
if [[ $(command -v zoxide) ]]; then
  export _ZO_RESOLVE_SYMLINKS=1
  eval "$(zoxide init zsh --cmd cd)"
fi

# - harlequin
if [[ $(command -v harlequin) ]]; then
  alias harlequin="harlequin --theme tokyo-night"
  alias local-harlequin="harlequin -a postgres -h localhost -p 5432 -U postgres --password postgres"
fi

# - starship
if [[ $(command -v starship) ]]; then
  if $NO_GLYPH; then
    export STARSHIP_CONFIG=~/.config/starship/starship_no_glyph.toml
  else
    export STARSHIP_CONFIG=~/.config/starship/starship.toml
  fi

  eval "$(starship init zsh)"
fi

# ---------------------------------------------------------------------------------
# Helper Functions
# ---------------------------------------------------------------------------------

# - General
# Function to update and clean the system, including external tools
auto-update() {
    # Only run if no arguments are provided (e.g., just 'update')
    if [[ $# -eq 0 ]]; then

        echo "--- 1/4: Updating Apt package lists ---"
        sudo apt update

        # Check if the last command (apt update) was successful
        if [[ $? -eq 0 ]]; then
            echo "--- 2/4: Upgrading Apt packages ---"
            sudo apt upgrade -y
            sudo apt full-upgrade -y
        else
            echo "--- 'apt update' failed. Skipping Apt upgrades. ---"
        fi

        echo "--- 3/4: Cleaning Apt packages ---"
        sudo apt clean
        sudo apt autoclean
        sudo apt autoremove -y

        echo "--- 4/4: Updating external tools ---"

        # Check for mise plugins and update
        if command -v mise &>/dev/null; then
            echo "Updating mise..."
            mise upgrade
        fi

        # Check for rustup and cargo packages then update
        if command -v rustup &>/dev/null; then
            echo "Updating rustup..."
            rustup update
        fi

        if command -v cargo-install-update &>/dev/null; then
          echo "Updating cargo packages..."
          cargo install-update -a
        fi

        # Check for uv and tools then update
        if command -v uv &>/dev/null; then
            echo "Updating uv..."
            uv self update
            uv tool upgrade --all
        fi

        update-zsh-plugins

        echo "--- System update and cleanup complete! ---"

    else
        # This will fail with 'command not found'
        command auto-update "$@"
    fi
}

# - ZSH
# Function to update all manually cloned Zsh plugins
update-zsh-plugins() {
    # Only run if no arguments are provided
    if [[ $# -eq 0 ]]; then

        # Define the base directory (same as in your clone commands)
        local plugins_dir=${ZSH_PLUGINS:-~/.zsh/plugins}

        echo "Updating Zsh plugins from $plugins_dir"

        # Check if the plugins directory itself exists
        if [[ ! -d "$plugins_dir" ]]; then
            echo "Error: Plugin directory not found at $plugins_dir"
            return 1 # Exit the function with an error
        fi

        # Loop through every item inside the plugins directory
        # The (N) flag makes the loop do nothing if no matches are found
        # The / flag matches only directories
        for plugin_path in $plugins_dir/*(N/); do

            # Check if the directory is a git repository
            if [[ -d "$plugin_path/.git" ]]; then

                # Get just the folder name for logging
                local plugin_name=$(basename "$plugin_path")

                echo "Updating $plugin_name..."

                # Run the pull in a subshell to avoid changing your
                # current directory.
                ( cd "$plugin_path" && git pull )

            fi
        done

        echo "Zsh plugin update complete!"

    else
        # If arguments were given, fail with 'command not found'
        command update-zsh-plugins "$@"
    fi
}

# - Docker
# Check if docker is installed before defining docker functions
if command -v docker &>/dev/null; then

    # Function to run a default local postgresql container
    local-postgres-up() {
        # Only run if no arguments are provided
        if [[ $# -eq 0 ]]; then
            echo "--- Starting local postgres container... ---"
            docker run -d --name local_postgres \
                -e POSTGRES_PASSWORD=postgres \
                -p 5432:5432 \
                -v local_pgdata:/var/lib/postgresql/data \
                postgres:alpine

            if [[ $? -eq 0 ]]; then
                echo "--- Container 'local_postgres' started. ---"
            else
                echo "--- Failed to start container. It might already be running or an error occurred. ---"
            fi
        else
            # Fail if any arguments are given
            command local-postgres-up "$@"
        fi
    }

    # Function to stop and remove the local postgresql container
    local-postgres-down() {
        # Only run if no arguments are provided
        if [[ $# -eq 0 ]]; then
            echo "--- Stopping and removing 'local_postgres' container... ---"
            docker rm -f local_postgres
            if [[ $? -eq 0 ]]; then
                echo "--- Container 'local_postgres' removed. ---"
            else
                echo "--- Failed to remove container. It might not exist. ---"
            fi
        else
            # Fail if any arguments are given
            command local-postgres-down "$@"
        fi
    }

fi

# ---------------------------------------------------------------------------------
