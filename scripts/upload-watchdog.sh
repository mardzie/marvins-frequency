#! /bin/bash

ROOT=$1
FILE=update.tar.gz
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
		continue
	fi
	echo "done."

	echo "Extracting update..."
	tar -xzf $1 -C $BLOG_PATH
	if [[ $? -ne 0 ]]; then
		err_log "Failed to extract new data."
		continue
	fi
	echo "done."

	echo "Cleaning up..."
	rm -f $1
	if [[ $? -ne 0 ]]; then
		err_log "Failed to delete archive."
		continue
	fi
	echo "done."

	echo "Update successful!"
	log "Updated successfully!"
}

inotifywait -m -e create $ROOT | while read path action file; do
	if [[ "$file" == "$FILE" ]]; then
		update "${path%/}/$file"
	fi
done

