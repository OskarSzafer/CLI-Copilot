#!/bin/zsh

OPTIONS_FILE=$(find "${SCRIPT_DIR}/.tmp/" -name ".options_${pid}_??????" | head -n 1)

# Update the postdisplay with the suggestion
_update_postdisplay() {
    suggestion=$(grep -i "^$BUFFER" "$OPTIONS_FILE" | head -n 1)
    POSTDISPLAY="${suggestion#$BUFFER}"
    zle redisplay
}
zle -N _update_postdisplay_widget _update_postdisplay


# Call the _update_postdisplay_widget function every 1 second
TRAPALRM() {
    zle _update_postdisplay_widget
}
# Set the timer interval to 1 second
TMOUT=1


insert_autosuggestion() {
    if [[ -n "$suggestion" ]]; then
        # Insert the remaining part of the suggestion into the line
        LBUFFER+="${suggestion#$BUFFER}"
    fi

    zle redisplay
}


# Set up hooks to update suggestions as you type
autoload -U add-zle-hook-widget
add-zle-hook-widget zle-line-pre-redraw _update_postdisplay

# Bind the widget to a key (tab)
zle -N insert_autosuggestion_widget insert_autosuggestion
bindkey '^I' insert_autosuggestion_widget