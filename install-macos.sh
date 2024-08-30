#!/bin/bash

# Install general tools
brew install --quiet fzf neovim jq ripgrep ncdu tmux starship

# Install aws tools
brew install --quiet awscli saml2aws

# Install kube tools
brew install --quiet kubect kubectx kube-ps1 eksctl k9s

#Install automation tools
brew install --quiet ansible terraform

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


# Config vim powerline
cp cfg/.vimrc $HOME/.vimrc
cp cfg/.tmux.conf $HOME/.tmux.conf
cp cfg/.zshrc.starship $HOME/.zshrc
cp .gitconfig $HOME/.gitconfig
cp .gitconfig-personal $HOME/.gitconfig-personal
cp .gitconfig-work $HOME/.gitconfig-work
