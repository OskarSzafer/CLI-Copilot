#!/bin/zsh
# Get the directory of the script
SCRIPT_DIR=${0:a:h}

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

# Set up hooks to update suggestions as you type
autoload -U add-zle-hook-widget
add-zle-hook-widget line-init _update_context
add-zle-hook-widget zle-line-pre-redraw _update_context_buffer
