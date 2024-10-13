# zsh-copilot

_Copilot-like autosuggestions generation for zsh._

in project root directory mk python venv\
```python -m venv venv```\
install requirements in venv:\
```./venv/bin/pip install -r requirements.txt```\

in your ~/.zshrc add\
```source/path/to/repository/copilot.zsh```\
and add env variable, for example by adding to ~/.zshrc:\
```export GOOGLE_API_KEY=<your_token>```\
You can generate token on:\
https://aistudio.google.com/app/apikey?hl=pl