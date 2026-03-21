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
$golang\
$docker_context\
$kubernetes\
$line_break\
$character"""

right_format = """$cmd_duration"""

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"

[directory]
truncation_length = 3
fish_style_pwd_dir_length = 1
truncation_symbol = "…/"
style = "bold lavender"

[git_branch]
symbol = " "
format = "[$symbol$branch]($style) "
style = "bold mauve"

[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'
style = "bold red"
staged = "+${count}"
modified = "!${count}"
untracked = "?${count}"
deleted = "✘${count}"
stashed = "≡"
ahead = "⇡${count}"
behind = "⇣${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"

[rust]
symbol = " "
format = "[$symbol($version)]($style) "
style = "bold #CE412B"

[python]
symbol = " "
format = "[$symbol($version)( $virtualenv)]($style) "
style = "bold yellow"

[nodejs]
symbol = " "
format = "[$symbol($version)]($style) "
style = "bold green"

[golang]
symbol = " "
format = "[$symbol($version)]($style) "
style = "bold cyan"

[docker_context]
symbol = " "
format = "[$symbol$context]($style) "
style = "bold blue"
only_with_files = true

[kubernetes]
symbol = "☸ "
format = '[$symbol$context( ($namespace))]($style) '
style = "bold purple"
disabled = false

[cmd_duration]
min_time = 2_000
format = "[$duration]($style)"
style = "bold yellow"
STARSHIP_CFG
else
    warn "Starship config already exists, skipping"
fi
