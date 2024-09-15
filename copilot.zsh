#!/bin/zsh
# Get the directory of the script
SCRIPT_DIR=${0:a:h}

# Function to generate suggestions
_generate_suggestions() {
    local word="$1"
    local history=$(history | tail -n 10)
    local ls_output=$(ls)
    local ls2_output=$(ls ..)
    
    python3 $SCRIPT_DIR/generate_completition.py "$word" "$history" "$ls_output" "$ls2_output"
}

# Widget function for autosuggestions
_autosuggestion_widget() {
    suggestion=$(_generate_suggestions "$BUFFER")
    
    if [[ -n "$suggestion" ]]; then
        # Display only the remaining part of the suggestion
        POSTDISPLAY="${suggestion#$BUFFER}"
    else
        POSTDISPLAY=""
    fi
    
    zle redisplay
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
