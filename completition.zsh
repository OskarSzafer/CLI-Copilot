#!/bin/zsh
# Get the directory of the script
SCRIPT_DIR=${0:a:h}

OPTIONS_FILE="${SCRIPT_DIR}/.options"
CONTEXT_FILE="${SCRIPT_DIR}/.context"

_update_context() {
    # local his=$(history | tail -n 10)
    local his=$(fc -l)

    print -r "$BUFFER" > $CONTEXT_FILE
    pwd >> $CONTEXT_FILE
    print -r "$his" >> $CONTEXT_FILE
    ls >> $CONTEXT_FILE
}

_update_context_buffer() {
    sed -i "1s/.*/$(printf "%s" "${BUFFER:-}" | sed 's/[\/&]/\\&/g')/" "$CONTEXT_FILE"
}

_update_postdisplay() {
    suggestion=$(grep -i "^$BUFFER" "$OPTIONS_FILE" | head -n 1)
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
_autosuggestion_widget_newline() {
    _update_context
    _update_postdisplay
}

_autosuggestion_widget_buffer_change() {
    _update_context_buffer
    _update_postdisplay
}

# TODO: remove this
insert_autosuggestion() {
    if [[ -n "$suggestion" ]]; then
        # Insert the remaining part of the suggestion into the line
        LBUFFER+="${suggestion#$BUFFER}"
    fi
    
    zle redisplay
}

# Set up hooks to update suggestions as you type
autoload -U add-zle-hook-widget
add-zle-hook-widget line-init _autosuggestion_widget_newline
add-zle-hook-widget zle-line-pre-redraw _autosuggestion_widget_buffer_change

# TODO: remove this
# Bind the widget to a key (tab)
zle -N insert_autosuggestion_widget insert_autosuggestion
bindkey '^I' insert_autosuggestion_widget