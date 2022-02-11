#!/bin/sh

# This is a script that creates a script that recreates an existing folder

script_folder() {
  FOLDER=${1:?}
  FILES=$(find $FOLDER -type f)

  echo '#!/bin/bash -x' > $FOLDER.sh
  echo '' >> $FOLDER.sh
  echo 'mkdir' $FOLDER >> $FOLDER.sh

  for f in $FILES;
  do
    script_file $f $FOLDER.sh
  done
}

script_file() {
  SRC=${1:?}
  DEST=${2:?}

  echo 'touch' $SRC >> $DEST
  echo 'chmod' $(stat -c "%a %n" $SRC) >> $DEST
  cat $SRC | sed "s/'/'\"'\"'/g" | sed 's|\\|\\\\|g' \
    | xargs -d '\n' -n1 -i echo "echo -e '{}' >> "$SRC >> $DEST

  chmod +x $DEST
}

if [ -d $1 ]; then script_folder $1; fi
