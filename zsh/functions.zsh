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

## fn cdls:  Changes to a directory and lists its contents. Usage: cdls /var/foo/bar
function cdls {
    builtin cd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

## fn iprem: Removes a conflicting ssh-key from the known hosts file. Usage: iprem 192.168.0.1
function iprem {
ssh-keygen -f "$HOME/.ssh/known_hosts" -R $1
}

## fn pwgen: Generate random 16 character password
function pwgen {
  LC_ALL=C tr -dc "[:alpha:][:alnum:][:special:]" < /dev/urandom | head -c 20 | pbcopy
}

## fn st: Get human readable number for file permissions. Usage: st FILENAME
function st { 
  if [[ "$OSTYPE" == "darwin"* ]];then
    stat -f %Mp%Lp "$@";
  else
    stat -c '%n %a' "$@";
  fi
}

## fn showfiles: Show all files in finder
function showfiles {
  defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app }

## fn hidefiles: Hide all hidden files in finder
function hidefiles {
  defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app }

## fn fp: Use fping to ping a CIDR notated range of IP's. Usage: fp 10.30.45.29/28
function fp {
  fping -g -r 1 "$@"
}

## fn encode: Encode a search term for use with the 'search' command line
function encode { echo -n $@ | perl -pe's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg'; }

## fn search: Quickly open a google search from the command line. Usage search 'string to search'
function search {
  encode "$@" | pbcopy && open "https://www.google.com/webhp?hl=en#q=`pbpaste`"; }

function decode() {
   python -m base64 -d
}

function 1pass() {
	echo "$ONEPASS" | tr -d '\n' | pbcopy
}

function srch() {
	noglob find "$HOME/Dropbox/OSX/" -iname "*.zhistory" -print0 | xargs -0 egrep "$@" | cut -d ';' -f 2
}

## fn sldn: Open a search term for the SLDN in Chrome. Usage: SoftLayer_Virtual_Guest
function sldn() {
  open http://sldn.softlayer.com/reference/services/"$@"
}

## fn svd: Get VSI details and passwords. Usage: svd 1234567
function svd() {
  slcli vs detail "$@" --passwords
}

## fn ssd: Get Server details and passwords. Usage: ssd 1234567
function ssd() {
  slcli server detail "$@" --passwords
}

## fn getsrvtx: Get the current transaction for an SL Hardware Server. Usage: getsrvtx 123456
function getsrvtx() {
  slcli --format=raw call-api Hardware_Server getActiveTransaction --id="$@";
}

## fn getvstx: Get the current transaction for an SL VSI. Usage: getvstx 123456
function getvstx() {
  slcli --format=raw call-api Virtual_Guest getActiveTransaction --id="$@";
}

## fn slp: Call the slcli using my personal account
function slp() {
  slcli --config ~/.personal "$@"
}

## fn bkmrk: Quickly search chrome bookmarks from the command line. Usage: bkmrk 'search string'
function bkmrk() {
  grep "$@" $HOME/Library/Application\ Support/Google/Chrome/Default/Bookmarks
}

## fn hist: Search the .zhistory file. Usage: hist thing
function hist() {
	egrep "$@" ${HOME}/Dropbox/.zhistory | cut -d ';' -f 2
}

## fn oldhist: Search my pre-reload .zhistory file
function oldhist() {
	egrep "$@" $HOME/Dropbox/OSX/oldhist.zhistory
}

function td() {
        if [[ -n "$1" ]]; then
                proj="$1"
                todofile="$proj.taskpaper"
        else
                proj=${PWD##*/}
                todofile="$proj.taskpaper"
                todofile=${todofile#.}
        fi
        if [[ ! -e "$todofile" ]]; then
                touch "$todofile"
                echo -e "Inbox:\n$proj:\n\tTodos:\n\tIdeas:\nArchive:\nSearch Definitions:\n\tTop Priority @search(@priority = 5 and not @done)\n\tHigh Priority @search(@priority > 3 and not @done)\n\tMaybe @search(@maybe)\n\tNext @search(@na and not @done and not project = \"Archive\")\n" >> $todofile
        fi
        open -a /Applications/Setapp/TaskPaper.app "$todofile"
}

function trav() {
        if [[ -n "$1" ]]; then
                proj="$1"
                todofile="$proj.taskpaper"
        else
                proj=${PWD##*/}
                todofile="$proj.taskpaper"
                todofile=${todofile#.}
        fi
        if [[ ! -e "$todofile" ]]; then
                touch "$todofile"
                echo -e "Inbox:\n$proj:\n\tReceipts:\n\tFollow Up Actions:\nArchive:\nSearch Definitions:\n\tTop Priority @search(@priority = 5 and not @done)\n\tHigh Priority @search(@priority > 3 and not @done)\n\tMaybe @search(@maybe)\n\tNext @search(@na and not @done and not project = \"Archive\")\n" >> $todofile
        fi
        open -a /Applications/Setapp/TaskPaper.app "$todofile"
}
