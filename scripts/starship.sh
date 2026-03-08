#!/usr/bin/env bash
# Configure Starship prompt

header "Configuring Starship"

if [[ ! -f "$HOME/.config/starship.toml" ]]; then
    info "Writing Starship config"
    cat > "$HOME/.config/starship.toml" << 'STARSHIP_CFG'
format = """
$directory\
$git_branch\
$git_status\
$rust\
$python\
$nodejs\
$cmd_duration\
$line_break\
$character"""

[character]
success_symbol = "[>](bold green)"
error_symbol = "[>](bold red)"

[directory]
truncation_length = 3
truncation_symbol = ".../"

[git_branch]
symbol = " "
format = "[$symbol$branch]($style) "

[git_status]
format = '([$all_status$ahead_behind]($style) )'

[rust]
symbol = " "
format = "[$symbol($version)]($style) "

[python]
symbol = " "
format = "[$symbol($version)]($style) "

[nodejs]
symbol = " "
format = "[$symbol($version)]($style) "

[cmd_duration]
min_time = 2_000
format = "[$duration]($style) "
STARSHIP_CFG
else
    warn "Starship config already exists, skipping"
fi
