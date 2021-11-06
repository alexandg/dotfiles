set __fish_git_prompt_show_informative_status

function fish_prompt
    if not set -q VIRTUAL_ENV_DISABLE_PROMPT
        set -g VIRTUAL_ENV_DISABLE_PROMPT true
    end
    if test $VIRTUAL_ENV
        printf "(%s) " (set_color blue)(basename $VIRTUAL_ENV)(set_color normal)
    end

    set_color normal
    switch $fish_bind_mode
        case default
            set_color --bold green
            printf '[N] '
        case insert
            set_color --bold blue
            printf '[I] '
        case replace_one
            set_color --bold yellow
            printf '[R] '
        case replace
            set_color --bold yellow
            printf '[R] '
        case visual
            set_color --bold cyan
            printf '[V] '
        case '*'
            set_color --bold red
            printf '[?] '
    end

    set_color --bold green
    printf '%s' $USER
    set_color normal
    printf ' at '

    set_color --bold yellow
    printf '%s' (prompt_hostname)
    set_color normal
    printf ' in '

    set_color --bold cyan
    printf '%s' (prompt_pwd)
    set_color normal

    set -l is_git_repo (git rev-parse --is-inside-work-tree ^/dev/null)
    if test -n "$is_git_repo"
        printf ' on'
        set_color --bold magenta
        printf '%s' (fish_git_prompt)
    end
    set_color normal

    # Line 2
    set_color normal
    printf '\n'
    printf '> '
    # printf '↪ '
end
