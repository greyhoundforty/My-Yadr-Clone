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
	find "$HOME/Work/Notes/Tech_Support/" -type f -iname "*.md" -print0|xargs -0 egrep "$@" |cut -d ':' -f 2
}

## Launch Atom with the given file opened and fork to background
## Usage: atom file.txt
function atom {
	$HOME//Applications/Atom.app/Contents/MacOS/Atom "$1" &> /Dev/null &
}

## Grab file and send to my hastebin server
## Usage: haste file.txt
function haste {
  a=$(cat)
  curl -X POST -s -d "$a" http://haste.techbabble.xyz:8080/documents | awk -F '"' '{print "http://haste.techbabble.xyz:8080/"$4}'
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
function hist { egrep "$@" $HOME/.zhistory | cut -d ';' -f 2 }

function oldhist { egrep "$@" $HOME/Dropbox/OSX/tycho_pre_reload.zhistory |  cut -d ';' -f 2 }

## Get human readable number for file permissions
## Usage: st FILENAME
function st { stat -c '%n %a' "$@"; }

## Netcat with the -v flag on a port scan
## Usage: ncz IP PORT
function ncz { netcat -z -v "$1" "$2"; }

## Get the IP of docker machine by name
## Usage: dockip CONTAINER_ID
function dockip { docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@" }

## Show all files in finder
## Usage: showfiles
function showfiles {
  defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app }

  ## Hide all hidden files in finder
  ## Usage: hidefiles
function hidefiles {
  defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app }

## Start the default local vbox docker-machine
## Usage: start_docker
function start_docker {
  docker-machine start default && eval "$(docker-machine env default)"
}

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
function svd {
  slcli vs detail "$@" --passwords
}

## Get Server details and passwords
## Usage: ssd 1234567
function ssd {
  slcli server detail "$@" --passwords
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


## Call the slcli using my personal account
## Usage: slp vs list (and all other functions)
function slp {
  slcli --config ~/.personal "$@"
}

## Alias to use cliist to interact with todoiist
## Usage: todo "--options task"
function todo {
 cd ~/Dropbox && na -r && cd -
}

## Add a quick note to follow up on tomorrow - synced to todoist
## Usage: followup "task"
function followup {
  todo -a -d tomorrow "$@" --project Follow-Up
}

## List all the functions in this file
## Usage: functions
function functions {
  grep "{$" "$HOME/.yadr/zsh/functions.zsh" |grep function | awk '{print $2 }'
}

## Quickly search chrome bookmarks from the command line
## Usage: bkmrk 'search string'
function bkmrk {
  grep "$@" $HOME/Library/Application\ Support/Google/Chrome/Default/Bookmarks
}

## Testing some todo command line function
## Usage: doit 1 'thing'
function doit {
if [[ "$1" == "today" ]];then
  dt=$(date +"%Y-%m-%d")
  echo "- $2 @start($dt)" >> $HOME/Dropbox/todolist.taskpaper
elif [[ "$1" == "tomorrow" ]];then
  dt=$(date -v+1d +"%Y-%m-%d")
  echo "- $2 @start($dt)" >> $HOME/Dropbox/todolist.taskpaper
fi
}

## Grab my default install setup for new Ubuntu boxes
## Usage: newsetup
function newsetup {
  curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "http://git.tinylab.info/api/v3/projects/5/snippets/3/raw"
}

## Grab the example for adding a private network IP to an Ubuntu server
## Usage: ubuntuprivate
function ubuntuprivate {
  curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "http://git.tinylab.info/api/v3/projects/5/snippets/4/raw";
}

## Open a search term for the SLDN in Chrome
## Usage: SoftLayer_Virtual_Guest
function sldn {
  open http://sldn.softlayer.com/reference/services/"$@"
}

## Get the current SoftLayer internal password and copy it to the clipboard
## Usage: getpass
function getpass {
  echo $SLPASS| tr -d '\n' | pbcopy
}

## Encode a search term for use with the 'search' command line
## Usage: none really
function encode { echo -n $@ | perl -pe's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg'; }

## Quickly open a google search from the command line
## search 'string to search'
function search {
  encode "$@" | pbcopy && open "https://www.google.com/webhp?hl=en#q=`pbpaste`"; }

## Checkout a new branch based on todays date for working with release notes
## Usage: start_release_notes
function start_release_notes {
 dt=$(date +"%Y%m%d")
 cd $HOME/Repos/work/githubio_source
 git checkout -b "$dt".rt_branch

}

## Get the 1pass password
## Usage: 1pass
function 1pass {
  echo "$ONEPASS"| tr -d '\n' | pbcopy
}

function showtokens {
echo "-R —Record: something created—writing, pictures, etc"
echo "-I —Information: something collect—articles, bookmarks, etc"
echo "-C —Communication: something exchanged—email, IM, etc"
echo ".1 —Important documents: backups, finance, taxes, etc"
echo ".2 —Writing: blog, manuscripts, books, cover letters, reviews, etc"
echo ".3 —Design and visuals: art, scientific figures, seminar slides, etc"
echo ".4 —Life: recipes, productivity, vacations, etc"
echo ".5 —Commerce: transactions, returns, etc"
}

## Use the maid command to sort downloads folder
## Usage: sort-downloads
function sort-downloads {
maid clean -fr $HOME/.maid/sort-downloads.rb
}

function clean-up {
maid clean -fr $HOME/.maid/clean-up.rb
}

function dry-run {
  maid clean -nr $HOME/.maid/clean-up.rb
  maid clean -nr $HOME/.maid/sort-downloads.rb
}


##Search archived nvalt notes
## Usage: vault SEARCHTERM
function vault {
  find "$HOME/Dropbox/Nvalt/Archive/" -type f -print0 | xargs -0 egrep -i "$@" | cut -d ':' -f 2
}

shorten () {
	local helpstring="Truncate each line of the input to X characters\n\t-l              Shorten from left side\n\t-s STRING         replace truncated characters with STRING\n\n\t$ ls | shorten -s ... 15"
	local ellip="" left=false
	OPTIND=1
	while getopts "hls:" opt; do
		case $opt in
			l) left=true ;;
			s) ellip=$OPTARG ;;
			h) echo -e $helpstring; return;;
			*) return 1;;
		esac
	done
	shift $((OPTIND-1))

	if $left; then
		cat | sed -E "s/.*(.{${1-70}})$/${ellip}\1/"
	else
		cat | sed -E "s/(.{${1-70}}).*$/\1${ellip}/"
	fi
}
