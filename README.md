# zsh-copilot

_Copilot-like autosuggestions generation for zsh._

Extends the functionality of [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) plugin, providing an additional LLM-based autosuggest strategy and autosuggestion refreshment.


## Installation

1. Clone project repository to location of choice:

    ```sh
    git clone https://github.com/OskarSzafer/CLI-Copilot.git
    ```

2. Inside project repository create python venv and install requirements:

    ```sh
    python -m venv venv && ./venv/bin/pip install -r requirements.txt
    ```

3. Source main script, and export API-key by adding to ```~/.zshrc``` following lines:

    ```sh
    export GOOGLE_API_KEY=<your_token>
    source ~/path/to/repository/copilot.zsh
    ```

    _You can get your API-key on:_\
    _https://aistudio.google.com/app/apikey_

4. Start new terminal sesion.


## Requirements

- Zsh v4.3.11 or later
- Zsh-autosuggestions v0.7.0
- Python v3.9 or later


## Roadmap


- Improvment of special character handling
- Resolving a conflict with the history widget
- Integration of open-source, local LLM