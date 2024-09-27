#!/bin/zsh
# Get the directory of the script
SCRIPT_DIR=${0:a:h}

pid=$$
OPTIONS_FILE=$(find "${SCRIPT_DIR}/.tmp/" -name ".options_${pid}_??????" | head -n 1)

# Custom autosuggestion function
_zsh_autosuggest_strategy_my_custom_suggestion() {
    local buffer=$1
    local suggestion

    # Find the first matching suggestion
    suggestion=$(grep -E "^${buffer}.*" "$OPTIONS_FILE" | head -n1)

    # Return the untyped part of the suggestion
    if [[ -n "$suggestion" && "$suggestion" != "$buffer" ]]; then
        echo "${suggestion#$buffer}"
    fi
}

ZSH_AUTOSUGGEST_STRATEGY=(my_custom_suggestion history)
