#!/bin/zsh
# Get the directory of the script
SCRIPT_DIR=${0:a:h}

OPTIONS_FILE="${SCRIPT_DIR}/.options"
CONTEXT_FILE="${SCRIPT_DIR}/.context"

_update_context() {
    local word="$1"
    local history=$(history | tail -n 10)
    local ls_output=$(ls)
    local ls2_output=$(ls ..)

    # Save the variables to a file instead of calling the Python script
    {
        echo "Given the current terminal line and command history, suggest a completion for the current command."
        echo "Return completed terminal line, without any explanation or formatting."
        echo "Current terminal line:" 
        echo "'$word'"
        echo "Command history:"
        echo "'"
        echo "$history"
        echo "'"
    } > $CONTEXT_FILE
}

_update_postdisplay() {
    local word="$BUFFER"
    suggestion=$(grep -i "^$word" "$OPTIONS_FILE" | head -n 1)
    POSTDISPLAY="${suggestion#$BUFFER}"
    zle redisplay
}
zle -N _update_postdisplay_widget _update_postdisplay

# Function to run every second
TRAPALRM() {
    zle _update_postdisplay_widget
}
# Set the timer interval to 1 second
TMOUT=1


# Widget function for autosuggestions
_autosuggestion_widget() {
    _update_context "$BUFFER"
    _update_postdisplay
}

# Widget function for autosuggestions
insert_autosuggestion() {
    if [[ -n "$suggestion" ]]; then
        # Insert the remaining part of the suggestion into the line
        LBUFFER+="${suggestion#$BUFFER}"
    fi
    
    zle redisplay
}

# Set up hooks to update suggestions as you type
autoload -U add-zle-hook-widget
add-zle-hook-widget line-init _autosuggestion_widget
add-zle-hook-widget keymap-select _autosuggestion_widget
add-zle-hook-widget zle-line-pre-redraw _autosuggestion_widget

# Bind the widget to a key (e.g., right arrow)
zle -N insert_autosuggestion_widget insert_autosuggestion
bindkey '^I' insert_autosuggestion_widget