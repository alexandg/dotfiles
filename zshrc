# Set up the prompt
autoload -Uz promptinit
setopt histignorealldups sharehistory promptsubst
promptinit

autoload -U colors
colors

# Use vi keybindings
bindkey -v
# Vim-like backspace key
bindkey "^?" backward-delete-char
# Enter vi mode with 'jj'
bindkey -M viins 'jj' vi-cmd-mode
bindkey '^R' history-incremental-search-backward

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LD_LIBRARY_PATH="$HOME/bin/rust/lib"

path+=("$HOME/bin")
path+=("$HOME/.cargo/bin")
path+=("$HOME/.local/bin")

export PATH
export ZLE_REMOVE_SUFFIX_CHARS=""
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export GTK_OVERLAY_SCROLLING=0
export PYTHONPATH=${PYTHONPATH}:$HOME/src/androguard/

git_prompt() {
    r_prompt=''
    if (git status 2> /dev/null 1> /dev/null); then
        local branch=$(git branch 2> /dev/null | sed -n '/^\*/s/^\* //p')
        local short_hash=$(git rev-parse --short HEAD 2>/dev/null)
        local na="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
        local nb="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
        ahead=''
        if [ "$na" -gt 0 ]; then
            ahead=" +$na"
        elif [ "$nb" -gt 0 ]; then
            ahead=" -$nb"
        fi
        r_prompt="[%B%F{white}$branch$ahead%f%b:%F{green}$short_hash%f] [%F{red}$(git_status)%f]"
    fi
    echo $r_prompt
}

# From: https://codereview.stackexchange.com/questions/117639/bash-function-to-parse-git-status
git_status() {
    git status 2>/dev/null | (
        unset dirty deleted untracked newfile ahead renamed
        while read line ; do
            case "$line" in
              *modified:*)                      dirty='!' ; ;;
              *deleted:*)                       deleted='x' ; ;;
              *'Untracked files:')              untracked='?' ; ;;
              *'new file:'*)                    newfile='+' ; ;;
              *renamed:*)                       renamed='>' ; ;;
            esac
        done
        bits="$dirty$deleted$untracked$newfile$ahead$renamed"
        [ -n "$bits" ] && echo "$bits"
    )
}

vim_ins_mode="I"
vim_cmd_mode="N"
vim_mode=$vim_ins_mode

function zle-keymap-select {
    vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
    zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-init {
    vim_mode=$vim_ins_mode
}
zle -N zle-line-init

PROMPT='[%F{blue}%n@%m%f %F{cyan}%~%f] $(git_prompt)
[%F{yellow}${vim_mode}%f] %# '

source $HOME/.zsh_aliases
