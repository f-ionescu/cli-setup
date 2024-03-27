#!/bin/bash

#Install packages
#sudo apt update && sudo apt install zsh python3-pip unzip tmux powerline fonts-powerline

# Install dependencies
#sudo apt-get install build-essential

# Brew install condition
#which -s brew
#if [[ $? != 0 ]] ; then
#    # Install Homebrew
#    echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" 1> brew_installation.log && echo "brew installation ok"
#    
#    # Run these two commands in your terminal to add Homebrew to your PATH
#    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$USER/.zprofile
#    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#else
#    printf "brew is already installed, skipping: \n"x
#fi
#
# Install general tools
brew install --quiet fzf neovim jq ripgrep ncdu starship

# Install aws tools
brew install --quiet fzf awscli saml2aws

# Install kube tools
brew install --quiet kubect kubectx kube-ps1 eksctl k9s

#Install automation tools
brew install --quiet ansible terraform



# Install zsh addons
if [ -d ~/.oh-my-zsh ]; then
  echo "Oh-my-zsh exists."
else
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ -d ~/.oh-my-zsh/custom/themes ]; then
  echo "Theme Powerlevel10k exists."
else
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

if [ -d ~/.oh-my-zsh/custom/plugins ]; then
  echo "Plugin zsh-autosuggestions exists."
else
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [ -d ~/.oh-my-zsh/custom/plugins ]; then
  echo "Plugin zsh-syntax-highlightinh exists."
else
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

clear

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
        eval \$(ssh-agent -s);
        ssh-add $HOME/.ssh/$filename;
        break;;
        No ) break;;
    esac
done


# Config vim powerline
cp cfg/.vimrc $HOME/.vimrc
cp cfg/.tmux.conf $HOME/.tmux.conf
cp cfg/.zshrc.starship $HOME/.zshrc
