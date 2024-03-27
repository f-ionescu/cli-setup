#!/bin/bash

printf "Enter the sudo password: "
read -s PASSWORD

#Install packages
echo $PASSWORD | sudo apt update && sudo apt install zsh python3-pip unzip tmux powerline fonts-powerline keychain

# Install Homebrew's dependencies
echo $PASSWORD | sudo apt-get install build-essential

# Brew install condition
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" 1> brew_installation.log && echo "brew installation ok"
    
    # Run these two commands in your terminal to add Homebrew to your PATH
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$USER/.zprofile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    printf "brew is already installed, skipping: \n"x
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


# Install zsh addons
if [ -d $HOME/.oh-my-zsh ]; then
  echo "Oh-my-zsh already exists, skipping installation"
else
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ -d $HOME/.oh-my-zsh/custom/themes/powerlevel10k ]; then
  echo "Theme Powerlevel10k already exists, skipping installation."
else
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

if [ -d $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
  echo "Plugin zsh-autosuggestions already exists, skipping installation."
else
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [ -d $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
  echo "Plugin zsh-syntax-highlightinh already exists, skipping installation."
else
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Git config
echo "Do you wish to config git?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) printf "Git Full Name: \n";
              read fullname;
              printf "Git E-mail: \n";
              read email;
              touch $HOME/.gitconfig;
              echo "[user]" >> $HOME/.gitconfig;
              echo "email = $email" >> $HOME/.gitconfig;
              echo "name = $fullname" >> $HOME/.gitconfig;
              break;;
        No ) break;;
    esac
done

# Generate ssh key
echo "Do you wish to create a ssh key?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) 
        if [ ! -d $HOME/.ssh ]; then
          mkdir $HOME/.ssh
        fi
        printf "Enter file in which to save the key (/home/ubuntu/.ssh/id_rsa): ";
        read filename
        ssh-keygen -t rsa -b 4096 -C "$email" -f $HOME/.ssh/$filename;
        eval $(ssh-agent -s);
        ssh-add $HOME/.ssh/$filename;
        break;;
        No ) break;;
    esac
done

# Copy cfg files to home directory
cp .vimrc $HOME/.vimrc
cp .tmux.conf $HOME/.tmux.conf
cp .zsh_aliases $HOME/.zsh_aliases
cp .zshrc.oh-my-zsh $HOME/.zshrc


# Make zsh the default shell
echo $PASSWORD | sudo -S chsh -s $(which zsh)