function fish_mode_prompt
    set -l bg cyan
    set -l fg black
    switch $fish_bind_mode
        case insert
            set bg yellow
            set char ' I '
        case default
            set bg black
            set fg white
            set char ' N '
        case replace_one replace
            set char ' R '
        case visual
            set char ' V '
    end

    # Render mode segment
    set_color --bold -b $bg $fg
    echo -n $char

    set_color --bold -b purple $bg
    echo -n ''

    set_color normal
end
