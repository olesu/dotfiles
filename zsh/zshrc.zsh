# Source modular Zsh configuration files
# Get the directory of this file (zshrc.zsh)
CURRENT_FILE_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check if the current script's directory matches ZSH_CONFIG_DIR
if  [[ "$CURRENT_FILE_DIR" == "$ZSH_CONFIG_DIR" ]]; then
  # Source all files in the config folder, excluding this file.
  for config_file in "${ZSH_CONFIG_DIR}"/*.zsh; do
    if [[ $config_file != *"/zshrc.zsh" ]]; then
      # shellcheck source=src/$config_file
      source "$config_file"
    fi
  done
else
  echo "zshrc.zsh is NOT in the same directory as ZSH_CONFIG_DIR!"
  echo "zshrc.zsh is in: $CURRENT_FILE_DIR"
  echo "ZSH_CONFIG_DIR is: $ZSH_CONFIG_DIR"
fi

