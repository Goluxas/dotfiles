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

if [ -f ~/.workspace_aliases ]; then
	echo -n "Would you like to delete .workspace_aliases as well? (Y/N): "
	read ANSWER
	if [ $ANSWER == "Y" ]; then
		rm ~/.workspace_aliases
	else
		echo -e "\n.workspace_aliases preserved, but remember to alter your .bash_profile to include them!"
	fi
fi

# Copy over the backed up dotfiles
# Keep track of any failures to move
FAILED_TO_MOVE=false
files=( ".bashrc" ".bash_profile" ".bash_aliases" ".ssh/config" ".gitconfig" ".vimrc" )
for dotfile in "${files[@]}"
do
	if [ -f ~/.original_dotfiles/$dotfile ]; then
		mv ~/.original_dotfiles/$dotfile ~/$dotfile
		[ $? -ne 0 ] && FAILED_TO_MOVE=true
	fi
done

if [ $FAILED_TO_MOVE = true ]; then
	echo "There was an error moving your original dotfiles back into place."
	echo "Examine the output above and correct any mistakes, then delete .original_dotfiles when you are done."
else
	rm -r ~/.original_dotfiles
	echo "Your original dotfiles have been replaced."
fi

echo "Git Dotfiles have been uninstalled."
