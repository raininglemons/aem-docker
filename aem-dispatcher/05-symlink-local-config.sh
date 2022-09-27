#!/bin/sh

folder="/tmp/dispatcher"
config_dir="/etc/httpd"

# AEM_HOST=localhost --env AEM_PORT=12345
if [ "$AEM_HOST" == "localhost" ] && [ "$AEM_PORT" == "12345" ]; then
  # Do no mapping when we're running the config validator
  # since the validator compares configs
  echo "Running in validator mode, silently doing nothing."
else
  # Remove default symlink for /etc/httpd/conf.d/enabled_vhosts/default.vhost
  rm /etc/httpd/conf.d/enabled_vhosts/default.vhost

  # Create symlinks for each individual conf file so they behave with the default configs on the image
  for relativeSubfolder in "conf.d" "conf.dispatcher.d"
  do
      echo "processing configuration subfolder: ${folder}/$relativeSubfolder"
      subfolder="${folder}/${relativeSubfolder}"
      [ -d "${subfolder}" ] || error "${relativeSubfolder} configuration subfolder not found in: ${folder}"
      for file in $(find "${subfolder}" -type f -or -type l | grep -Ev '/.git')
      do
          resolved="$(cd -P "$(dirname "$file")" && pwd -P)"
          fullpath=${resolved}/$(basename "${file}")
          targetpath=${config_dir}/${relativeSubfolder}/${fullpath#*/${relativeSubfolder}/}
          relativepath=${relativeSubfolder}/${fullpath#*/${relativeSubfolder}/}

          # this just checks for a string currently, but would be better if it checked an exact line existed.
          # for now there's no issue, but there could be later perhaps
          if ! grep -q ${relativepath} /etc/httpd/immutable.files.txt; then
            if [[ -f $targetpath ]];then
              rm ${targetpath}
            fi

            echo " - Mapping ${fullpath} --> ${targetpath}"
            ln -s "${fullpath}" "${targetpath}"
          else
            echo " - Ignoring immutable file ${fullpath} [${relativepath}]"
          fi
      done
  done

  echo "${volumes}"
fi