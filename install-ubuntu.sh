#!/bin/bash

printf "Enter the sudo password: "
read -s PASSWORD

#Install packages
echo $PASSWORD | sudo apt update && sudo apt install -y zsh python3-pip unzip tmux powerline fonts-powerline keychain

# Install Homebrew's dependencies
echo $PASSWORD | sudo apt-get install -y build-essential

# Brew install condition
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" 1> brew_installation.log && echo "brew installation ok"
    
    # Run these two commands in your terminal to add Homebrew to your PATH
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$USER/.zprofile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    printf "brew is already installed, skipping: \n"
fi


# We recommend that you install GCC (GNU compiler collection)
brew install --quiet gcc

# Install general tools 
brew install --quiet fzf neovim jq ripgrep ncdu

# Install aws tools
brew install --quiet fzf awscli saml2aws

# Install kube tools
brew install --quiet kubect kubectx kube-ps1 eksctl k9s

#Install automation tools
brew install --quiet ansible terraform


# Function to install Oh-My-Zsh plugins
install_zsh_plugin() {
    local plugin_name=$1
    local repo_url=$2
    local install_path="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/$plugin_name"

    if [ -d "$install_path" ]; then
        echo "Plugin $plugin_name already exists, skipping installation."
    else
        git clone --depth=1 "$repo_url" "$install_path"
    fi
}

# Install Oh-my-zsh if not already installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh-my-zsh already exists, skipping installation."
else
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Powerlevel10k theme
install_zsh_plugin "themes/powerlevel10k" "https://github.com/romkatv/powerlevel10k.git"

# Install zsh-autosuggestions plugin
install_zsh_plugin "plugins/zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"

# Install zsh-syntax-highlighting plugin
install_zsh_plugin "plugins/zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"


# Prompt the user to configure Git
echo "Do you wish to configure Git?"
select yn in "Yes" "No"; do
    case $yn in
        Yes )
            # If Yes, prompt for Git full name and email
            printf "Git Full Name: \n";
            read -r fullname;
            printf "Git E-mail: \n";
            read -r email;

            # Write Git config to ~/.gitconfig file
            cat <<EOF > "$HOME/.gitconfig"
[user]
    email = $email
    name = $fullname
EOF
            echo "Git configured successfully."
            break;;

        No )
            # If No, exit the script
            echo "Exiting without configuring Git."
            break;;
    esac
done


# Prompt the user to create an SSH key
echo "Do you wish to create an SSH key?"
select yn in "Yes" "No"; do
    case $yn in
        Yes )
            # Ensure the ~/.ssh directory exists
            mkdir -p "$HOME/.ssh"

            # Prompt user for the filename
            read -p "Enter the filename to save the key (default: /home/ubuntu/.ssh/id_rsa): " filename
            filename=${filename:-id_rsa}

            # Generate SSH key with specified filename
            ssh-keygen -t rsa -b 4096 -C "$email" -f "$HOME/.ssh/$filename"

            # Start SSH agent
            eval "$(ssh-agent -s)"

            # Add SSH key to SSH agent
            ssh-add "$HOME/.ssh/$filename"

            echo "SSH key created successfully."
            break;;
        No )
            echo "Exiting without creating an SSH key."
            break;;
    esac
done


# Copy cfg files to home directory
cp .vimrc $HOME/.vimrc
cp .tmux.conf $HOME/.tmux.conf
cp .zsh_aliases $HOME/.zsh_aliases
cp .zshrc.oh-my-zsh $HOME/.zshrc
cp .p10k.zsh $HOME/.p10k.zsh
cp .gitconfig $HOME/.gitconfig
cp .gitconfig-personal $HOME/.gitconfig-personal
cp .gitconfig-work $HOME/.gitconfig-work


# Make zsh the default shell
echo $PASSWORD | sudo -S chsh -s $(which zsh)
