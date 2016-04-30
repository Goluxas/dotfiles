## Safety aliases
# confirmation prompt for rm
alias rm="rm -i"

## Utility aliases
# colorize ls every time
alias ls="ls --color=auto"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

## Functions
# Setup for the Dotfiles deploy
function setup_aliases() {
	# Add services with logs/daemons to this array
	services=( "uwsgi" "nginx" )

	echo "We will now set up your workspace aliases."
	echo "First, the locations of working directories."

	MORE_WORKSPACES="Y"
	until [ $MORE_WORKSPACES == "N" ]; do
		echo -n "Absolute Path: "
		read WORKING_DIR

		echo -n "Alias Name: "
		read ALIAS_NAME
		
		echo -n "Virtual Env Activation Command (blank to skip): "
		read VIRTUAL_ENV
		
		# -d = is a directory
		# -n = is a nonzero-length string
		# -z = is a zero-length string
		# -a = and
		if [ -d $WORKING_DIR -a -n $ALIAS_NAME ]; then
			if [ -z $VIRTUAL_ENV ]; then
				echo -e "alias $ALIAS_NAME=\"cd $WORKING_DIR\"" >> ~/.workspace_aliases
			else
				echo -e "alias $ALIAS_NAME=\"cd $WORKING_DIR; $VIRTUAL_ENV\"" >> ~/.workspace_aliases
			fi
		else
			# Error messages
			if [ -z $ALIAS_NAME ]; then
				echo "No alias name set."
			else
				if [ ! -d $WORKING_DIR ]; then
					echo "$WORKING_DIR is not a valid directory."
				fi
			fi
			# prompt for completion, because maybe they accidentally re-entered this loop
		fi
		echo -n "Do you have another workspace? (Y/N): "
		read MORE_WORKSPACES
	done
	echo -e "Working Directory alias setup done.\n"
	
	echo "Now, log checkers."
	for service in "${services[@]}"
	do
		TRY_AGAIN=Y
		while [ $TRY_AGAIN = "Y" ]; do
			echo -n "$service Log Location (Enter N to skip. Blank for Default at /var/log/$service.log): "
			read LOG_LOCATION
			# This line format means "if [conditional] then do command after &&
			# You can also use || to do command if conditional is false
			[ -z $LOG_LOCATION ] && LOG_LOCATION="/var/log/$service.log"
			if [ -f $LOG_LOCATION ]; then
				echo -e "alias log-$service=\"tail -f $LOG_LOCATION\"" >> ~/.workspace_aliases
				TRY_AGAIN="N"
			else
				if [ $LOG_LOCATION == "N" ]; then
					TRY_AGAIN="N"
				else
					echo -n "Log not found at $LOG_LOCATION. Try again? (Y/N): "
					read TRY_AGAIN
				fi
			fi
		done
	done
	echo -e "Log Checker alias setup done.\n"

	echo "Finally, Service Restart aliases."
	
	for service in "${services[@]}"
	do
		TRY_AGAIN="Y"
		while [ $TRY_AGAIN == "Y" ]; do
			echo -n "$service Daemon Location (N to skip, blank for default at /etc/init.d/$service): "
			read DAEMON_LOCATION
			[ -z $DAEMON_LOCATION ] && DAEMON_LOCATION="/etc/init.d/$service"
			if [ -f $DAEMON_LOCATION ]; then
				echo -e "alias re-$service=\"sudo $DAEMON_LOCATION restart\"" >> ~/.workspace_aliases
				TRY_AGAIN="N"
			else
				if [ $DAEMON_LOCATION == "N" ]; then
					TRY_AGAIN="N"
				else
					echo -n "Daemon not found at $DAEMON_LOCATION. Try Again? (Y/N): "
					read TRY_AGAIN
				fi
			fi
		done
	done

	echo -e "Service Restart alias setup done.\n"

	echo "Alias Setup Complete."
}
