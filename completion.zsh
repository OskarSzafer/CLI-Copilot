#!/bin/zsh

OPTIONS_FILE=$(find "${SCRIPT_DIR}/.tmp/" -name ".options_${pid}_??????" | head -n 1)

# Define a custom strategy for zsh-autosuggest
_zsh_autosuggest_strategy_my_custom_suggestion() {
    typeset -g suggestion=$(cat "$OPTIONS_FILE" | head -n 1)
}


# Add as the first strategy to zsh-autosuggest plugin
export ZSH_AUTOSUGGEST_STRATEGY=(my_custom_suggestion $ZSH_AUTOSUGGEST_STRATEGY)
