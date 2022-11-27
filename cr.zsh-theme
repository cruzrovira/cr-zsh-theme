function real_time() {
    local color="%{$fg_no_bold[cyan]%}";
    local color_reset="%{$reset_color%}";
     echo "${color}🦊$(host_name)${color_reset}";
}

function host_name() {
    local color="%{$fg_no_bold[cyan]%}";          # color in PROMPT need format in %{XXX%} which 
    local ip
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        ip="$(hostname)";
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        ip="$(hostname)";
    else
    fi
    local color_reset="%{$reset_color%}";
    echo "${color}%n@${ip}${color_reset}";
}

function directory() {
    local color="%{$fg_no_bold[white]%}";
    local directory=" %c";
    local color_reset="%{$reset_color%}";
    echo "📁${color}${directory}${color_reset}";
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_no_bold[red]%}[%{$fg_no_bold[yellow]%}";
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} ";
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_no_bold[red]%}] 🔥";
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_no_bold[red]%}] 💚";

function update_git_status() {
    GIT_STATUS=$(git_prompt_info);
}

function git_status() {
    echo "${GIT_STATUS}"
}

function update_command_status() {
    local arrow="";
    local color_reset="%{$reset_color%}";
    local reset_font="%{$fg_no_bold[white]%}";
    if $1;
    then
        arrow="%{$fg_bold[yellow]%}❱";
    else
        arrow="%{$fg_bold[red]%}❱";
    fi
    COMMAND_STATUS="${arrow}${reset_font}${color_reset}";
}

update_command_status true;

function command_status() {
    echo "${COMMAND_STATUS}"
}

output_command_execute_after() {
    if [ "$COMMAND_TIME_BEIGIN" = "-20200325" ] || [ "$COMMAND_TIME_BEIGIN" = "" ];
    then
        return 1;
    fi

    local cmd="${$(fc -l | tail -1)#*  }";
    local color_cmd="";
    if $1;
    then
        color_cmd="$fg_no_bold[green]";
    else
        color_cmd="$fg_bold[red]";
    fi
    local color_reset="$reset_color";
    cmd="${color_cmd}${cmd}${color_reset}"
}


precmd() {
    local last_cmd_return_code=$?;
    local last_cmd_result=true;
    if [ "$last_cmd_return_code" = "0" ];
    then
        last_cmd_result=true;
    else
        last_cmd_result=false;
    fi

    update_git_status;

    update_command_status $last_cmd_result;

    output_command_execute_after $last_cmd_result;
}

setopt PROMPT_SUBST;

PROMPT='$(real_time) $(directory) $(git_status)$(command_status) ';
