function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive # Commands to run in interactive sessions can go here

    # No greeting
    set fish_greeting

    # Use starship
    starship init fish | source
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    zoxide init fish | source

    # Aliases
    alias pamcan pacman
    alias ls 'eza --icons'
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
    alias q 'qs -c ii'
    alias l 'll -A'
    alias weather="curl wttr.in" # 天气
    alias ipinfo="curl ipinfo.io" # 公网ip,地理位置
    alias c="clear"
    alias f="fastfetch"

    alias cd='z'
    alias cat="bat"
    alias find="fd"
    alias rg='rg --hidden --follow --glob "!.git/*"'
    alias du="dust"
    alias df="duf"
    alias diff='delta'
    alias man='tldr'

end
