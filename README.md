Development Environment Setup Script

This Bash script automates the setup of a development environment on a Linux system. 

Features:
- Installs essential packages
- Sets up Homebrew
- Configures Zsh and Oh-My-Zsh
- Installs various tools like Neovim, AWS CLI, and Kubernetes utilities 
- Configures Git, generates an SSH key
- Copies configuration files to the user's home directory.

The script is configuring [Oh-My-Zsh](https://github.com/romkatv/powerlevel10k)  for Ubuntu WSL and [Starship](https://github.com/starship/starship)  for MacOS.


Usage:
1. Clone the repo, and make the scripts executable
 ```bash
git clone git@github.com:f-ionescu/cli-setup.git
cd cli-setup
chmod +x install*.sh
```

2. Run the script corresponding to your OS
```bash
./install-ubuntu.sh
./install-macos.sh
```

3. Follow the prompts to enter the sudo password, configure Git, and generate an SSH key.

License:
This project is licensed under the MIT License.
