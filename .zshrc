# ---------------------------------------------------------------------------------
# Header Setup
# ---------------------------------------------------------------------------------

# GPG_TTY required for no GUI environtment like WSL
export GPG_TTY=$(tty)

# If you come from bash you might have to change your $PATH.
typeset -U path PATH

export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# ---------------------------------------------------------------------------------
# ZSH
# ---------------------------------------------------------------------------------

# - ZSH history
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
# HISTDUP=erase

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
setopt INTERACTIVE_COMMENTS

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

# General aliases
alias which-command=whence

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

if command -v nvim >/dev/null 2>&1; then
  export EDITOR='nvim'
  alias vi=nvim
  alias vim=nvim
else
  export EDITOR='vim'
fi

# - Version manager
# mise
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# - Other tools
# Laravel Sail
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'

# - VS Code Extensions
# Console Ninja
if [[ -d "$HOME/.console-ninja/.bin" ]]; then
    export PATH="$HOME/.console-ninja/.bin:$PATH"
fi

# ---------------------------------------------------------------------------------
# Shell Tools
# ---------------------------------------------------------------------------------

# - keychain
if command -v keychain >/dev/null 2>&1; then
  eval `keychain --eval --quiet`
fi

# - delta
if command -v delta >/dev/null 2>&1; then
    alias rdiff='command diff -u --color=auto'
    alias diff='delta'
else
    alias diff='command diff -u --color=auto'
fi

# - bat
if command -v batcat >/dev/null 2>&1; then
    alias rcat='command cat'
    alias cat='batcat'

    export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
    export MANROFFOPT="-c"
elif command -v bat >/dev/null 2>&1; then
    alias rcat='command cat'
    alias cat='bat'

    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export MANROFFOPT="-c"
fi

# - eza
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --color=always --group-directories-first --icons'
  alias ll='ls -la --octal-permissions'
  alias l='ls -bGF --header --git'
  alias llm='ls -lbGd --header --git --sort=modified'
  alias la='ls --long --all --group'
  alias lx='ls -lbhHigUmuSa@ --time-style=long-iso --git --color-scale'
  alias lS='ls -1'
  alias lt='ls --tree --level=3'
  alias ltag='ls --tree --all --git-ignore'
  alias l.="eza -a | grep -E '^\.'"
else
  alias ls='ls --color=tty'
  alias ll='ls -lh'
  alias l='ls -lah'
  alias la='ls -lAh'
  alias lsa='ls -lah'
fi

# - ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.config/rg/ripgrep.conf"

# - fzf
if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_OPTS='--height=60% --reverse --color=bg+:#1a1b26,gutter:#32344a,pointer:#f7768e,info:#9ece6a,hl:#7aa2f7,hl+:#7dcfff'

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
  source <(fzf --zsh)

# - Kill process with fzf
    fzf-kill() {
        if (( $# > 0 )); then
            echo "Usage: fzf-kill"
            return 1
        fi

        local selection pid

        selection=$(ps -eo pid,ppid,user,%cpu,%mem,etime,stat,comm=NAME --sort=-%cpu |
            fzf \
                --header-lines=1 \
                --prompt="Kill process > " \
                --border \
                --preview-window="wrap" \
                --preview '
                    ps -p {1} -o pid,ppid,user,%cpu,%mem,etime,stat,comm=NAME
                
                    printf "\nStarted:\n"
                    ps -p {1} -o lstart=
                
                    printf "\nCommand:\n"
                    ps -ww -p {1} -o args=
                
                    printf "\nExecutable:\n"
                    readlink -f /proc/{1}/exe 2>/dev/null
                
                    printf "\nWorking directory:\n"
                    readlink -f /proc/{1}/cwd 2>/dev/null
                ') || return 0

        [[ -n "$selection" ]] || return 0

        pid=$(awk '{print $1}' <<< "$selection")

        if kill -TERM "$pid"; then
            echo "Sent SIGTERM to process $pid."
        else
            echo "Failed to terminate process $pid."
            return 1
        fi
    }

fi

# - tmux
if command -v tmux >/dev/null 2>&1; then
  # Use 256 color for tmux
  alias tmux="TERM=screen-256color-bce tmux"

  # Attemtp to take over existing sessions before creating a new tmux session.
  TMUX_DEFAULT_SESSION="tmux"
  alias t="tmux -u a -d -t ${TMUX_DEFAULT_SESSION} 2> /dev/null || tmux -u new -s ${TMUX_DEFAULT_SESSION}"
fi

# - zoxide
if command -v zoxide >/dev/null 2>&1; then
  export _ZO_RESOLVE_SYMLINKS=1
  eval "$(zoxide init zsh --cmd cd)"
fi

# - harlequin
if command -v harlequin >/dev/null 2>&1; then
  alias harlequin="harlequin --theme tokyo-night"
  alias local-harlequin="harlequin -a postgres -h localhost -p 5432 -U postgres --password postgres"
fi

# - starship
# - starship
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# - Codex on WSL
if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
  codexw() {
    local dir winpath

    dir="$(realpath "${1:-.}")" || return 1

    [[ -d "$dir" ]] || {
      print -r -u2 -- "codexw: Directory does not exist: $dir"
      return 1
    }

    winpath="$(wslpath -w "$dir")" || return 1

    printf '%s' "$winpath" | clip.exe

    powershell.exe -NoProfile -NonInteractive \
      -Command "Start-Process 'codex://threads/new'"

    print -r -- "Copied project path: $winpath"
    print -r -- "In Codex: Ctrl+O → Ctrl+L → Ctrl+V → Enter"
  }
fi

# - Google Antigravity on WSL
if command -v antigravity >/dev/null 2>&1 && ! command -v agy >/dev/null 2>&1; then
  # alias agy=antigravity
  agy() {
    antigravity --remote wsl+Ubuntu "$(realpath "$1")"
  }
fi

if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
  agyw() {
    local dir winpath

    dir="$(realpath "${1:-.}")" || return 1

    [[ -d "$dir" ]] || {
        print -r -u2 -- "antigravityw: Directory does not exist: $dir"
        return 1
    }

    # Convert WSL path to Windows UNC path
    winpath="$(wslpath -w "$dir")" || return 1

    # Launch the Windows Antigravity desktop app
    powershell.exe -NoProfile -NonInteractive -Command '
      $app = Join-Path $env:LOCALAPPDATA "Programs\Antigravity\Antigravity.exe"

      if (-not (Test-Path -LiteralPath $app)) {
        Write-Error "Antigravity desktop app is not installed"
        exit 1
      }

      Start-Process -FilePath $app
    ' || return 1

    # Copy Windows path to clipboard
    printf '%s' "$winpath" | clip.exe

    print -r -- "Opened Antigravity"
    print -r -- "Copied project path: $winpath"
  }
fi

# ---------------------------------------------------------------------------------
# Helper Functions
# ---------------------------------------------------------------------------------

# - General
# Function to update and clean the system, including external tools
auto-update() {
    # Do not accept any arguments
    if (( $# > 0 )); then
        echo "Usage: auto-update"
        return 1
    fi

    local failed=0

    echo "--- 1/4: Updating APT packages ---"

    if sudo apt update; then
        if sudo apt full-upgrade -y; then
            echo "Removing unused APT packages..."
            sudo apt autoremove -y || failed=1
        else
            echo "APT full-upgrade failed."
            failed=1
        fi
    else
        echo "APT update failed. Skipping upgrades."
        failed=1
    fi

    echo "--- 2/4: Cleaning APT cache ---"
    sudo apt clean || failed=1

    echo "--- 3/4: Updating development tools ---"

    # Update mise-managed tools
    if command -v mise &>/dev/null; then
        echo "Updating mise-managed tools..."
        mise upgrade --global || failed=1

        # Synchronize Python installations with uv
        if command -v uv &>/dev/null; then
            echo "Synchronizing Python with uv..."
            mise sync python --uv || failed=1
        fi
    fi

    # Check for rustup and cargo packages then update
    # if command -v rustup &>/dev/null; then
    #     echo "Updating rustup..."
    #     rustup update
    # fi
    #
    # if command -v cargo-install-update &>/dev/null; then
    #     echo "Updating cargo packages..."
    #     cargo install-update -a
    # fi
    #
    # Check for uv and tools then update
    # if command -v uv &>/dev/null; then
    #     echo "Updating uv..."
    #     uv self update
    #     uv tool upgrade --all
    # fi

    echo "--- 4/4: Updating Zsh plugins ---"

    if (( $+functions[update-zsh-plugins] )); then
        update-zsh-plugins || failed=1
    fi

    if (( failed )); then
        echo "--- Update completed with errors. ---"
        return 1
    fi

    echo "--- System update and cleanup complete! ---"
}

# - ZSH
# Function to update all manually cloned Zsh plugins
update-zsh-plugins() {
    # Do not accept any arguments
    if (( $# > 0 )); then
        echo "Usage: update-zsh-plugins"
        return 1
    fi

    local plugins_dir="${ZSH_PLUGINS:-$HOME/.zsh/plugins}"
    local plugin_path
    local -i updated=0 failed=0

    # Validate dependencies and directory
    if [[ ! -d "$plugins_dir" ]]; then
        echo "Error: Plugin directory not found: $plugins_dir"
        return 1
    fi

    if ! command -v git &>/dev/null; then
        echo "Error: Git is not installed."
        return 1
    fi

    echo "Updating Zsh plugins from $plugins_dir"

    # Iterate through Git repositories
    for plugin_path in "$plugins_dir"/*(N/); do
        [[ -e "$plugin_path/.git" ]] || continue

        echo "Updating ${plugin_path:t}..."

        if git -C "$plugin_path" pull --ff-only; then
            (( ++updated ))
        else
            echo "Failed to update ${plugin_path:t}"
            (( ++failed ))
        fi
    done

    echo "Zsh plugins: $updated successful, $failed failed."

    (( failed == 0 ))
}

# - Docker
if command -v docker &>/dev/null; then

    local-postgres-up() {
        if (( $# > 0 )); then
            echo "Usage: local-postgres-up"
            return 1
        fi

        local name="local_postgres"

        # Reuse an existing container
        if docker container inspect "$name" &>/dev/null; then
            if [[ "$(docker inspect -f '{{.State.Running}}' "$name")" == "true" ]]; then
                echo "PostgreSQL is already running."
                return 0
            fi

            echo "Starting existing PostgreSQL container..."
            docker start "$name" >/dev/null || return 1
        else
            echo "Creating PostgreSQL container..."

            docker run -d \
                --pull always \
                --name "$name" \
                -e POSTGRES_PASSWORD=postgres \
                -p 127.0.0.1:5432:5432 \
                -v local_pgdata:/var/lib/postgresql \
                postgres:alpine >/dev/null || return 1
        fi

        echo "PostgreSQL started on localhost:5432."
    }

    local-postgres-down() {
        if (( $# > 0 )); then
            echo "Usage: local-postgres-down"
            return 1
        fi

        local name="local_postgres"

        if ! docker container inspect "$name" &>/dev/null; then
            echo "PostgreSQL container does not exist."
            return 0
        fi

        docker rm -f "$name" >/dev/null || return 1

        echo "PostgreSQL container removed. Data preserved."
    }

fi

# ---------------------------------------------------------------------------------

