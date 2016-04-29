#!/usr/bin/env bash

if ! [ -d ~/.original_dotfiles ]; then
	echo "Dotfiles are not installed."
	exit 1
fi

# Unlink Gitted dotfiles
# ONLY unlink if they're symlinks in the first place
[ -h ~/.bash_profile ] && unlink ~/.bash_profile
[ -h ~/.bash_aliases ] && unlink ~/.bash_aliases
[ -h ~/.ssh/config ] && unlink ~/.ssh/config
[ -h ~/.gitconfig ] && unlink ~/.gitconfig
[ -h ~/.vimrc ] && unlink ~/.vimrc

# Copy over the backed up dotfiles
# Keep track of any failures to move
FAILED_TO_MOVE=false
mv ~/.original_dotfiles/.bash_profile ~/.bash_profile
[ $? -ne 0 ] && FAILED_TO_MOVE=true

mv ~/.original_dotfiles/.bash_aliases ~/.bash_aliases
[ $? -ne 0 ] && FAILED_TO_MOVE=true

mv ~/.original_dotfiles/.ssh/config ~/.ssh/config
[ $? -ne 0 ] && FAILED_TO_MOVE=true

mv ~/.original_dotfiles/.gitconfig ~/.gitconfig
[ $? -ne 0 ] && FAILED_TO_MOVE=true

mv ~/.original_dotfiles/.vimrc ~/.vimrc
[ $? -ne 0 ] && FAILED_TO_MOVE=true

if [ $FAILED_TO_MOVE ]; then
	echo "There was an error moving your original dotfiles back into place."
	echo "Examine the output above and correct any mistakes, then delete .original_dotfiles when you are done."
else
	rm -r ~/.original_dotfiles
	echo "Your original dotfiles have been replaced."
fi

echo "Git Dotfiles have been uninstalled."
