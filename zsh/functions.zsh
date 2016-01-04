## Extract common compressed file types
## Usage: extract file.tar.gz
function extract {
   if [ -f $1 ] ; then
     case $1 in
       *.tar.bz2)   tar xjf $1     ;;
       *.tar.gz)    tar xzf $1     ;;
       *.bz2)       bunzip2 $1     ;;
       *.rar)       unrar e $1     ;;
       *.gz)        gunzip $1      ;;
       *.tar)       tar xf $1      ;;
       *.tbz2)      tar xjf $1     ;;
       *.tgz)       tar xzf $1     ;;
       *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

## Build tinybot.io, commit to Github which triggers a CodeShip build and deploy to webserver
## Usage: remote_hugo
function hugo_ship {
cd /Users/ryan/Repos/personal/greyhoundforty.github.io
hugo -D -t angels-ladder
git add .
git commit -am "Blog updated with hgo function on `date`"
git push
}

## Build a local version of tinybot.io and run it in a Docker container
## Usage: local_hugo
function hugo_local {
  cd /Users/ryan/Repos/personal/greyhoundforty.github.io
  hugo server -D -t angels-ladder -w & disown
}

## Search scrap.md file
## Usage: scrap 'thing to search for'
function scrap {
	find "$HOME/Dropbox/Work/CST_CSA_Notes/" -type f -iname "*.md" -print0|xargs -0 egrep "$@" |cut -d ':' -f 2
}

## Launch Atom with the given file opened and fork to background
## Usage: atom file.txt
function atom {
	/Applications/Atom.app/Contents/MacOS/Atom "$1" &> /Dev/null &
}

## Grab file and send to my hastebin server
## Usage: haste file.txt
function haste {
    a=$(cat); curl -X POST -s -d "$a" http://haste.tinybot.io/documents | awk -F '"' '{print "http://haste.tinybot.io/"$4}'; }'"'
  }

# Changes to a directory and lists its contents.
# Usage: cdls /var/foo/bar
function cdls {
    builtin cd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

## Used for terminal output. Will print blue :: before whatever phrase you choose
## Usage: notice 'this is a thing'
function notice { echo -e "\e[0;34m:: \e[1;37m${*}\e[0m"; }

## Removes a conflicting ssh-key from the known hosts file
## Usage: iprem 192.168.0.1
function iprem {
ssh-keygen -f "$HOME/.ssh/known_hosts" -R $1
}

## Upload file to transfer.sh amd get back the download URL
## Usage: transfer /etc/rc.local
function transfer { if [ $# -eq 0 ]; then echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }; alias transfer=transfer


## Run a mosh connection to a server
## Usage: msh PORT X.X.X.X
function msh { mosh --ssh='ssh -p "$1"' "$2"; }

## Generate random 16 character password
## pwgen
function pwgen { openssl rand -base64 16;echo; }

## Search the .zhistory file
## Usage: hist thing
function hist { egrep "$@" $HOME/.zhistory; }

## Get human readable number for file permissions
## Usage: st FILENAME
function st { stat -c '%n %a' "$@"; }

## Netcat with the -v flag on a port scan
## Usage: ncz IP PORT
function ncz { netcat -z -v "$1" "$2"; }

## Get the IP of docker machine by name
## Usage:
function dockip { docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@" }

## Show all files in finder
## Usage:
function showfiles { defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app }

function hidefiles { defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app }

function start_docker { docker-machine start default && eval "$(docker-machine env default)" }

##
##
function tat {
  path_name="$(basename "$PWD" | tr . -)"
  session_name=${1-$path_name}

  not_in_tmux() {
    [ -z "$TMUX" ]
  }

  session_exists() {
    tmux list-sessions | sed -E 's/:.*$//' | grep -q "^$session_name$"
  }

  create_detached_session() {
    (TMUX='' tmux new-session -Ad -s "$session_name")
  }

  create_if_needed_and_attach() {
    if not_in_tmux; then
      tmux new-session -As "$session_name"
    else
      if ! session_exists; then
        create_detached_session
      fi
      tmux switch-client -t "$session_name"
    fi
  }

  create_if_needed_and_attach
}

## Get VSI details and passwords
## Usage: svd 1234567
function svd { slcli vs detail "$@" --passwords }

## Get Server details and passwords
## Usage: ssd 1234567
function ssd { slcli server detail "$@" --passwords }

# Deploy tinybot.me hugo site to webserver
## Usage: tinyme_deploy
function tinyme_deploy {
  cd $HOME/Repos/personal/tinybot.me;
  hugo -t heather-hugo;
  rsync -azv ./public/ root@107.170.132.229:/var/www/html
}

## Get the current transaction for an SL Hardware Server
## Usage: getsrvtx 123456
function getsrvtx {
  slcli --format=raw call-api Hardware_Server getActiveTransaction --id="$@";
}

## Get the current transaction for an SL VSI
## Usage: getvstx 123456
function getvstx {
  slcli --format=raw call-api Virtual_Guest getActiveTransaction --id="$@";
}

## Get function definitions
## Usage: define getvstx
function define {
  grep -B2 "$@" "$HOME"/.yadr/zsh/functions.zsh | grep -v "function $@"
}

## Use fping to ping a CIDR notated range of IP's
## Usage: fp 10.30.45.29/28
function fp { 
  fping -g -r 1 "$@" 
}


## Get a nicely formatted view of things marked as 'later' in doing app
## Usage: dvl
function dvl {
	doing view later |colout "^([ \d:apm]+) ?([>:]) (.*)" green,black,white
}

## Start openxenmanager and fork it to the background
## Usage: xen
function xen {
  nohup ~/Repos/misc/openxenmanager/openxenmanager & 
}

## Call the slcli using my personal account
## Usage: slp vs list (and all other functions)
function slp { 
  slcli --config ~/.personal "$@" 
}

## Alias to use cliist to interact with todoiist
## Usage: todo "--options task"
function todo() { 
  ~/Repos/misc/cliist/cliist.py "$@" 
}

## Add a quick note to follow up on tomorrow - synced to todoist
## Usage: followup "task"
function followup { 
  todo -a -d tomorrow "$@" --project Follow-Up
}

function untracked_files_check {
  expr `git status --porcelain 2>/dev/null| grep "^??" | wc -l`
}

function notify_untracked {
  if [[ `untracked_files_check` == "1" ]]; then
    API="xw8oSkPqF2tz2lgNhmD75t1j5gPwBHKV"
    MSG=`pwd`
    curl -u $API: https://api.pushbullet.com/v2/pushes -d type=note -d title="Git Dirs that need commits" -d body="$MSG"
  fi
}
