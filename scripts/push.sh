#! /bin/bash

RELEASE_PATH=./public
UPDATE_TAR_NAME=update.tar.gz

cleanup () {
	echo "Cleaning up..."
	rm -f $UPDATE_TAR_NAME
	echo "done."
}

push () {
	if [[ -f $UPDATE_TAR_NAME ]]; then
		cleanup
	fi

	echo "Compressing..."
	tar -czf $UPDATE_TAR_NAME -C $RELEASE_PATH .
	if [[ $? -ne 0 ]]; then
		echo "ERROR: Failed to compress update."
		exit 1
	fi
	echo "done."

	echo "Uploading..."
	scp $UPDATE_TAR_NAME root@172.238.112.152:/var/marvins-frequency
	if [[ $? -ne 0 ]]; then
		echo "ERROR: Failed to upload update.tar.gz. Is ssh port 22 open?"
		cleanup
		exit 1
	fi
	echo "done."

	cleanup

	echo "Update successful!"
	sleep 3
}

deploy () {
	echo "Building..."
	zola build
	echo "done."

	push
}

help () {
	echo "Usage: $0 [COMMAND]"
	echo
	echo "Commands:"
	echo "help		Get help"
	echo "push		Package /public directory and push to the server. A open ssh port is required"
	echo "deploy		Build, package and push to the server. A open ssh port is required"
}

case $1 in
	help | "")
		help
		;;
	push)
		push
		;;
	deploy)
		deploy
		;;
	*)
		help
		;;
esac
	

