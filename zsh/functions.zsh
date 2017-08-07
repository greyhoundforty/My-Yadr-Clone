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
function st { stat -c '%n %a' "$@"; }

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

