hst=$(hostname -s)
if [[ "$hst" == "ganymede" ]]; then
   source "$HOME/Dropbox/OSX/exports/ganymede.exports"
elif [[ "hst" == "hyperion" ]];then
   source "$HOME/Dropbox/OSX/exports/hyperion.exports"
fi
