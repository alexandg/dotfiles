# Set up the prompt
autoload -Uz promptinit
setopt histignorealldups sharehistory promptsubst
promptinit
#prompt adam1

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
path+=("$HOME/bin/rust/bin")
path+=("$HOME/bin/cargo/bin")
path+=("$HOME/.cargo/bin")

export PATH
export ZLE_REMOVE_SUFFIX_CHARS=""
export RUST_SRC_PATH="$HOME/src/rust/src/"
export GTK_OVERLAY_SCROLLING=0
export PYTHONPATH=${PYTHONPATH}:$HOME/src/androguard/

git_prompt() {
    r_prompt=''
    if (git status 2> /dev/null 1> /dev/null); then
        local dirty=''
        local branch=$(git branch 2> /dev/null | sed -n '/^\*/s/^\* //p')
        if [[ $(git status --porcelain) != '' ]]; then
            dirty='*'
        fi
        r_prompt="[$dirty][$branch]"
    fi
    echo $r_prompt
}

vim_ins_mode="[I]"
vim_cmd_mode="[N]"
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

PROMPT='${vim_mode} %n@%m %~ %# '
RPROMPT='$(git_prompt)'

if [ $TERM = "xterm" ] ; then
    if [ -n $COLORTERM ] ; then
        if [ $COLORTERM = "xfce-terminal" ] ; then
            TERM=xterm-256color
        fi
    elif [ -n "$VTE_VERSION" ] ; then
        TERM=xterm-256color
    fi
fi

source $HOME/.zsh_aliases
