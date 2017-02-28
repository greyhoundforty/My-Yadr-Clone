## fn extract: Extract common compressed file types. notice Usage: extract file.tar.gz
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

## fn hugo_ship: Build local tinylab.info hugo site, commit to Github which triggers a CodeShip build and deploy to webserver.
function hugo_ship {
cd "$HOME/Repos/personal/greyhoundforty.github.io"
hugo -D -t angels-ladder
git add .
git commit -am "Blog updated with hgo function on `date`"
git push
}

## fn scrap: Search old tech support scrap files. USAGE: scrap 'thing to search for'
function scrap {
	find "$HOME/Work/Notes/Tech_Support/" -type f -iname "*.md" -print0|xargs -0 egrep "$@" |cut -d ':' -f 2
}

## fn atom: Launch Atom with the given file opened and fork to background. Usage: atom file.txt
function atm {
	$HOME//Applications/Atom.app/Contents/MacOS/Atom "$1" &> /dev/null &
}

## fn cdls:  Changes to a directory and lists its contents. Usage: cdls /var/foo/bar
function cdls {
    builtin cd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

## fn notice: Used for terminal output emphasis. Usage: notice 'this is a thing'
function notice { echo -e "\e[0;34m:: \e[1;37m${*}\e[0m"; }

## fn iprem: Removes a conflicting ssh-key from the known hosts file. Usage: iprem 192.168.0.1
function iprem {
ssh-keygen -f "$HOME/.ssh/known_hosts" -R $1
}

## fn transfer: Upload file to transfer.sh amd get back the download URL. Usage: transfer /etc/rc.local
function transfer { if [ $# -eq 0 ]; then echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }; alias transfer=transfer

## fn msh: Run a mosh connection to a server. Usage: msh PORT X.X.X.X
function msh { mosh --ssh='ssh -p "$1"' "$2"; }

## fn pwgen: Generate random 16 character password
function pwgen { 
  LC_ALL=C tr -dc "[:alpha:][:alnum:][:special:]" < /dev/urandom | head -c 20 | pbcopy
  }

## fn hist: Search the .zhistory file. Usage: hist thing
function hist { egrep "$@" ${HOME}/Dropbox/.zhistory | cut -d ';' -f 2 }

## fn oldhist: Search my pre-reload .zhistory file 
function oldhist { egrep "$@" $HOME/Dropbox/OSX/oldhist.zhistory }

## fn st: Get human readable number for file permissions. Usage: st FILENAME
function st { stat -c '%n %a' "$@"; }

## fn ncz: Netcat with the -v flag on a port scan. Usage: ncz IP PORT
function ncz { netcat -z -v "$1" "$2"; }

## fn dockerip: Get the IP of a docker container  by name or ID. Usage: dockip CONTAINER_ID
function dockip { docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@" }

## fn showfiles: Show all files in finder 
function showfiles {
  defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app }

## fn hidefiles: Hide all hidden files in finder
function hidefiles {
  defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app }

## fn tat: Create new tmux session from current owrking directory 
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

## fn svd: Get VSI details and passwords. Usage: svd 1234567
function svd {
  slcli vs detail "$@" --passwords
}

## fn ssd: Get Server details and passwords. Usage: ssd 1234567
function ssd {
  slcli server detail "$@" --passwords
}

## fn getsrvtx: Get the current transaction for an SL Hardware Server. Usage: getsrvtx 123456
function getsrvtx {
  slcli --format=raw call-api Hardware_Server getActiveTransaction --id="$@";
}

## fn getvstx: Get the current transaction for an SL VSI. Usage: getvstx 123456
function getvstx {
  slcli --format=raw call-api Virtual_Guest getActiveTransaction --id="$@";
}

## fn fp: Use fping to ping a CIDR notated range of IP's. Usage: fp 10.30.45.29/28
function fp {
  fping -g -r 1 "$@"
}

## fn slp: Call the slcli using my personal account
function slp {
  slcli --config ~/.personal "$@"
}

## fn bkmrk: Quickly search chrome bookmarks from the command line. Usage: bkmrk 'search string'
function bkmrk {
  grep "$@" $HOME/Library/Application\ Support/Google/Chrome/Default/Bookmarks
}

## fn newsetup: Grab my default install setup for new Ubuntu boxes
function newsetup {
  curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "http://git.tinylab.info/api/v3/projects/5/snippets/3/raw"
}

## fn ubuntuprivate: Grab the example for adding a private network IP to an Ubuntu server 
function ubuntuprivate {
  curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "http://git.tinylab.info/api/v3/projects/5/snippets/4/raw";
}

## fn sldn: Open a search term for the SLDN in Chrome. Usage: SoftLayer_Virtual_Guest
function sldn {
  open http://sldn.softlayer.com/reference/services/"$@"
}

## fn getpass: Get the current SoftLayer internal password and copy it to the clipboard
function getpass {
  echo $SLPASS| tr -d '\n' | pbcopy
}

## fn encode: Encode a search term for use with the 'search' command line
function encode { echo -n $@ | perl -pe's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg'; }

## fn search: Quickly open a google search from the command line. Usage search 'string to search'
function search {
  encode "$@" | pbcopy && open "https://www.google.com/webhp?hl=en#q=`pbpaste`"; }

## fn start_release_notes: Checkout a new branch based on todays date for working with release notes
function start_release_notes {
 dt=$(date +"%Y%m%d")
 cd $HOME/Repos/work/githubio_source
 git checkout -b "$dt".rt_branch

}

## fn 1pass: Get the 1pass password
function 1pass {
  echo "$ONEPASS"| tr -d '\n' | pbcopy
}

## fn sort-downloads: Use the maid command to sort downloads folder
function sort-downloads {
maid clean -fr $HOME/.maid/sort-downloads.rb
}

## fn clean-up: Run the clean up maid rules
function clean-up {
maid clean -fr $HOME/.maid/clean-up.rb
}

## fn dry-run: Do a dry run of maid rules
function dry-run {
  maid clean -nr $HOME/.maid/clean-up.rb
  maid clean -nr $HOME/.maid/sort-downloads.rb
}

## fn vault: Search archived nvalt notes. Usage: vault SEARCHTERM
function vault {
  find "$HOME/Dropbox/Nvalt/Archive/" -type f -print0 | xargs -0 egrep -i "$@" | cut -d ':' -f 2
}

## fn shorten: Truncate each line of the input to X characters. Usage: cat file | shorten
function shorten {
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

## fn qn: Create a new note in the Unsorted Evernote Notebook. Usage: qn TITLE NOTE_CONTENT
function qn {
  geeknote create --content "$2" --notebook Unsorted --title "$1"
}

function github-create () {
    currentDir=${PWD##*/}
    currentDir=${currentDir// /_}
    userName=greyhoundforty

    curl -s "https://api.github.com/user/repos?access_token=1b1ad46e3bae541b7d52d7403f305ced7e06360a" -d '{"name": "$currentDir"}' &&
    echo "# $currentDir" > README.md &&
    git init &&
    git add -A . &&
    git commit -m "first commit" &&
    git remote add origin https://github.com/$userName/$currentDir.git &&
    git push -u origin master
}

function here { open . }



  


## fn go_pi: Connect to Pi at the office through a remote jumphost
function go_pi {
  ssh ryan@169.46.3.91 -p 3376 -t 'ssh localhost -p 19999'
}

function getauth () {
	echo $AUTHY | tr -d '\n' | pbcopy
}

function decode() {
   python -m base64 -d
}

# List all my VSI's on the SE Demo account
function lsvsi() {
  slcli --format raw vs list -D ryantiffany.me
  slcli --format raw vs list -D tinylab.info
  slcli --format raw vs list -D tinylayer.net

}

# List all my Servers on the SE Demo account
function lssrv() {
  slcli --format raw server list -D ryantiffany.me
  slcli --format raw server list -D tinylab.info
  slcli --format raw server list -D tinylayer.net
}

function google() {
    search=""
    echo "Googling: $@"
      for term in $@; do
          search="$search%20$term"
      done
      open "http://www.google.com/search?q=$search"
}


function srch() { noglob find "$HOME/Dropbox/OSX/" -iname "*.zhistory" -print0 | xargs -0 egrep "$@" | cut -d ';' -f 2 }


