#! /bin/bash

REPO_PATH=./repo/marvins-frequency
SRC_SCRIPTS_PATH=$REPO_PATH/scripts
SRC_CONFIGS_PATH=$SRC_SCRIPTS_PATH/configs
SRC_SERVICES_PATH=$SRC_SCRIPTS_PATH/services

TGT_SERVICES_PATH=/etc/systemd/system

git_pull () {
	echo "Updating repo..."
	(cd $REPO_PATH && git pull)
	echo "done."
}

update_scripts () {
	echo "Updating scripts..."
	
	# upload-watchdog.sh
	cp $SRC_SCRIPTS_PATH/upload-watchdog.sh .

	echo "done."
}

update_configs() {
	echo "Updating configs..."

	# SWS
	cp $SRC_CONFIGS_PATH/sws.toml .

	# SWS Secure
	cp $SRC_CONFIGS_PATH/sws-secure.toml .

	echo "done."
}

update_services () {
	SERVICE_BASE_NAME="marvins-frequency-"
	UPDATER_SERVICE="${SERVICE_BASE_NAME}updater.service"
	SWS_SERVICE="${SERVICE_BASE_NAME}sws.service"
	SWS_SECURE_SERVICE="${SERVICE_BASE_NAME}sws-secure.service"

	restart_service () {
		systemctl restart $1
	}

	echo "Updating services..."

	# Updater
	cp "$SRC_SERVICES_PATH/$SERVICE_BASE_NAME-updater.service" $TGT_SERVICES_PATH

	# SWS
	cp "$SRC_SERVICES_PATH/$SERVICE_BASE_NAME-sws.service" $TGT_SERVICES_PATH
	
	# SWS Service
	cp "$SRC_SERVICES_PATH/$SERVICE_BASE_NAME-sws-secure.service" $TGT_SERVICES_PATH

	systemctl daemon-reload
	resart_service $UPDATER_SERVICE
	restart_service $SWS_SERVICE
	restart_service $SWS_SECURE_SERVICE

	echo "done."
}

help () {
	echo "Usage: $0 [COMMAND]"
	echo "Execute in main directory."
	echo
	echo "Commands:"
	echo "help, h		Show help"
	echo "git		Update repository"
	echo "scripts		Update all scripts; $0 is not updated"
	echo "configs		Update all configs"
	echo "services		Update all services"
	echo "self		Update $0"
	echo "all 		Update all"
}

case $1 in
	git | scripts | configs | services | all)
		echo "Updating..."
		# Git is in every command.
		git_pull

		case $1 in
			scripts)
				update_scripts
				;;
			configs)
				update_configs
				;;
			services)
				update_services
				;;
			self)
				cp $SRC_SCRIPTS_PATH/server-scripts-updater.sh .
			all)
				update_scripts
				update_configs
				update_services
				;;
		esac

		echo "Update completed!"
		;;
	*)
		help
		;;
esac

