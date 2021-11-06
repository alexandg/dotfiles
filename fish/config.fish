# Remove greeting
set fish_greeting

# Variables
set PATH $HOME/bin $HOME/.cargo/bin $HOME/.local/bin $PATH
set LC_ALL "en_US.UTF-8"
set LANG "en_US.UTF-8"
set LANGUAGE "en_US.UTF-8"
set RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/src

# Abbreviations
if status --is-interactive
    abbr --add --global spelltex 'aspell --lang=en --mode=tex check'
    abbr --add --global jupoetry 'poetry run jupyter'
    abbr --add --global poetrylab 'poetry run jupyter-lab'
    abbr --add --global cfmt 'astyle -A2 -s4 -S -U -Y -H -j -c -p --align-pointer=name'
    abbr --add --global exl 'exa -l'

    # cargo
    abbr --add --global cargob 'cargo build'
    abbr --add --global cargobr 'cargo build --release'
    abbr --add --global cargoc 'cargo check'
    abbr --add --global cargoup 'cargo install-update'
    abbr --add --global cargoupl 'cargo install-update -al'

    # Git abbrevs
    abbr --add --global ga 'git add'
    abbr --add --global gpl 'git pull'
    abbr --add --global gps 'git push'
    abbr --add --global gf 'git fetch'
    abbr --add --global gco 'git checkout'
    abbr --add --global gcb 'git checkout -b'
    abbr --add --global gb 'git branch'
    abbr --add --global gm 'git merge'
    abbr --add --global gs 'git status'
    abbr --add --global gd 'git diff'

    abbr --add --global gplom 'git pull origin master'
    abbr --add --global gpsom 'git push origin master'
    abbr --add --global gfom 'git fetch orign master'

    abbr --add --global gupsub 'git submodule foreach git pull origin master'
end
