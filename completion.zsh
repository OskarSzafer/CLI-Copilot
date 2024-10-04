#!/bin/zsh
# Get the directory of the script
SCRIPT_DIR=${0:a:h}

pid=$$
OPTIONS_FILE=$(find "${SCRIPT_DIR}/.tmp/" -name ".options_${pid}_??????" | head -n 1)

_zsh_autosuggest_strategy_my_custom_suggestion() {
    #emulate -L zsh
    #setopt EXTENDED_GLOB

    # If a match is found, set it as the suggestion
    typeset -g suggestion=$(cat "$OPTIONS_FILE")
    
    #local prefix="${1//(#m)[\\*?[\]<>()|^~#]/\\$MATCH}"
    #local suggestion_match=$(grep -m 1 "^$prefix" "$OPTIONS_FILE")
    #typeset -g suggestion=$suggestion_match
}

# Function to run every second
TRAPALRM() {
    # zle autosuggest-fetch
    _zsh_autosuggest_invoke_original_widget "clear"
}
# Set the timer interval to 1 second
TMOUT=1

export ZSH_AUTOSUGGEST_STRATEGY=(my_custom_suggestion $ZSH_AUTOSUGGEST_STRATEGY)
