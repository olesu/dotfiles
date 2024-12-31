# Source modular Zsh configuration files
ZSH_CONFIG_DIR="${HOME}/Developer/PycharmProjects/mgmt/zsh"

# Source all files in the config folder, excluding this file.
for config_file in "${ZSH_CONFIG_DIR}"/*.zsh; do
  if [[ $config_file != *"/zshrc.zsh" ]]; then
    # shellcheck source=src/$config_file
    source "$config_file"
  fi
done