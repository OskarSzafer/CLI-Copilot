_mycmd_dynamic_autocomplete() {
    local cur opts script_dir
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    # Get the directory of the script
    script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    # Check if options.txt exists in the script directory
    if [[ -f "$script_dir/options.txt" ]]; then
        # Clean up Windows-style line endings in 'options.txt'
        sed -i 's/\r$//' "$script_dir/options.txt"

        # Read options from 'options.txt'
        opts=$(cat "$script_dir/options.txt")

        # Generate autocomplete suggestions
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    else
        echo "Error: options.txt not found in $script_dir"
    fi
}

# Register the autocomplete function for the 'lm' command
complete -F _mycmd_dynamic_autocomplete lm

# run the command
lm() {
    $@
}