function fish_prompt
    # Helper
    function _nim_prompt_wrapper
        set -l color $argv[1]
        set -l field_name $argv[2]
        set -l field_value $argv[3]

        set_color normal
        set_color $color
        echo -n '-'
        set_color -o green
        test -n "$field_name"
        and echo -n $field_name:
        set_color $color
        echo -n $field_value
    end

    # Prompt path segment
    set pwd_result = (prompt_pwd)
    set_color --bold -b cyan black
    if [ "$pwd_result" = "= ~" ]
        echo -n ' /home/alry/ '
    else
        echo -n ' '(prompt_pwd)' '
    end
    set_color -b black cyan
    echo -n ''

    # Return code color
    set -l retc cyan
    test $status = 0; and set retc green

    # Date/time
    set_color --bold -b black white
    echo -n ' '(date +%H)':'(date +%M)' '
    set_color -b normal black
    echo -n ' '
    set_color normal

    # Virtual Environment
    set -q VIRTUAL_ENV_DISABLE_PROMPT; or set -g VIRTUAL_ENV_DISABLE_PROMPT true
    set -q VIRTUAL_ENV
    and _nim_prompt_wrapper $retc V (path basename "$VIRTUAL_ENV")

    # Git info
    set -q __fish_git_prompt_showupstream
    or set -g __fish_git_prompt_showupstream auto

    set -l prompt_git (fish_git_prompt '%s')
    test -n "$prompt_git"
    and _nim_prompt_wrapper $retc G $prompt_git

    echo # Newline

    # Background jobs
    for job in (jobs)
        set_color $retc
        echo -n '│ '
        set_color brown
        echo $job
    end

    # Final ❯
    set_color blue
    echo -n '❯ '
    set_color normal
end

