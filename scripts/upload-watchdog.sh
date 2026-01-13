#! /bin/bash

ROOT="${1%/}"
FILE=update.tar.gz
FILE_PATH=$ROOT/$FILE
BLOG_PATH=$ROOT/marvins-frequency
LOG_FILE=$ROOT/update.log
ERR_LOG_FILE=$ROOT/update-error.log

err_log () {
	echo "ERROR: " $1
	touch $ERR_LOG_FILE
	echo $1 > $ERR_LOG_FILE
	log "ERROR: See $LOG_FILE for more infos."
}

log () {
	echo "INFO: " $1
	touch $LOG_FILE
	echo $1 > $LOG_FILE
}

update () {
	echo "Update detected..."
	log "Updating..."

	echo "Removing old site data..."
	rm -rf $BLOG_PATH/*
	if [[ $? -ne 0 ]]; then
		err_log "Failed to delete old data."
		exit 1
	fi
	echo "done."

	echo "Extracting update..."
	tar -xzf $1 -C $BLOG_PATH
	if [[ $? -ne 0 ]]; then
		err_log "Failed to extract new data."
		exit 1
	fi
	echo "done."

	echo "Cleaning up..."
	rm -f $1
	if [[ $? -ne 0 ]]; then
		err_log "Failed to delete archive."
		exit 1
	fi
	echo "done."

	echo "Update successful!"
	log "Updated successfully!"
}

echo "Watching $ROOT"

while true; do
	if [[ -f "$FILE_PATH" ]]; then
		sleep 3
		update $FILE_PATH
	fi

	sleep 120
done
