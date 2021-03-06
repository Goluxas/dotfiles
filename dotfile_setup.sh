#!/usr/bin/env bash
# Get current dir so you can run from anywhere
export DOTFILES_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Get latest version of your dotfiles repo
[ -d "$DOTFILES_DIR/.git" ] && git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master

# Backup the original dotfiles in case something goes wrong
mkdir ~/.original_dotfiles
[ -f ~/.bashrc ] && mv ~/.bashrc ~/.original_dotfiles
[ -f ~/.bash_profile ] && mv ~/.bash_profile ~/.original_dotfiles
[ -f ~/.bash_aliases ] && mv ~/.bash_aliases ~/.original_dotfiles
[ -f ~/.inputrc ] && mv ~/.inputrc ~/.original_dotfiles
#if [ -f ~/.ssh/config ]; then
	#mkdir ~/.original_dotfiles/.ssh
	#mv ~/.ssh/config ~/.original_dotfiles
#fi
[ -f ~/.gitconfig ] && mv ~/.gitconfig ~/.original_dotfiles
[ -f ~/.vimrc ] && mv ~/.vimrc ~/.original_dotfiles
[ -f ~/.tmux.conf ] && mv ~/.tmux.conf ~/.original_dotfiles
echo -e "\nYour dotfiles have been backed up to .original_dotfiles.\n"

# Set up symlinks
ln -sv "$DOTFILES_DIR/.bashrc" ~
ln -sv "$DOTFILES_DIR/.bash_profile" ~
ln -sv "$DOTFILES_DIR/.bash_aliases" ~
ln -sv "$DOTFILES_DIR/.inputrc" ~
#ln -sv "$DOTFILES_DIR/.ssh/config" ~/.ssh
ln -sv "$DOTFILES_DIR/.gitconfig" ~
ln -sv "$DOTFILES_DIR/.vimrc" ~
ln -sv "$DOTFILES_DIR/.tmux.conf" ~

# Install vim and curl if they're missing
sudo apt -y install vim curl

# Install VimPlug plugins; VimPlug itself installs automatically on first run of Vim
echo -e "\nYou may get a Vim error about Solarized. Just hit enter and let it run.\n"
vim +PlugInstall +qall

# function in bash_aliases
# sets up aliases for moving to working directories, restarting
# services, and tailing log files
source .bash_aliases
#setup_aliases # disabled due to divergent use case

# Script done, give further information
echo "Dotfiles installed."
echo "Old dotfiles available at ~/.original_dotfiles"
echo "Don't forget to set up your keys and copy over your ssh config!"
