#!/usr/bin/env bash
# Get current dir so you can run from anywhere
export DOTFILES_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Get latest version of your dotfiles repo
[ -d "$DOTFILES_DIR/.git" ] && git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master

# Backup the original dotfiles in case something goes wrong
mkdir ~/.original_dotfiles
[ -f ~/.bash_profile ] && mv ~/.bash_profile ~/.original_dotfiles
[ -f ~/.bash_aliases ] && mv ~/.bash_aliases ~/.original_dotfiles
if [ -f ~/.ssh/config ]; then
	mkdir ~/.original_dotfiles/.ssh
	mv ~/.ssh/config ~/.original_dotfiles
fi
[ -f ~/.gitconfig ] && mv ~/.gitconfig ~/.original_dotfiles
[ -f ~/.vimrc ] && mv ~/.vimrc ~/.original_dotfiles

# Set up symlinks
ln -sv "$DOTFILES_DIR/.bash_profile" ~
ln -sv "$DOTFILES_DIR/.bash_aliases" ~
ln -sv "$DOTFILES_DIR/.ssh/config" ~
ln -sv "$DOTFILES_DIR/.gitconfig" ~
ln -sv "$DOTFILES_DIR/.vimrc" ~

# Install Vundle plugins
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# function in bash_aliases
# sets up aliases for moving to working directories, restarting
# services, and tailing log files
setup_aliases

# Script done, give further information
echo "Dotfiles installed."
echo "Old dotfiles available at ~/.original_dotfiles"
echo "Don't forget to set up your keys!"
