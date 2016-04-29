#!/usr/bin/env bash

if ! [ -d ~/.original_dotfiles ]; then
	echo "Dotfiles are not installed."
	exit 1
fi

# Unlink Gitted dotfiles
unlink ~/.bash_profile
unlink ~/.bash_aliases
unlink ~/.ssh/config
unlink ~/.gitconfig
unlink ~/.vimrc

# Copy over the backed up dotfiles
mv ~/.original_dotfiles/.bashprofile ~/.bash_profile
mv ~/.original_dotfiles/.bash_aliases ~/.bash_aliases
mv ~/.original_dotfiles/.ssh/config ~/.ssh/config
mv ~/.original_dotfiles/.gitconfig ~/.gitconfig
mv ~/.original_dotfiles/.vimrc ~/.vimrc

rm -r ~/.original_dotfiles

echo "Dotfiles have been uninstalled."
echo "Your original dotfiles have been replaced."
