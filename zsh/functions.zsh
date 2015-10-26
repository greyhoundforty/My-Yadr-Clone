# Usage: extract file.tar.gz
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

function hgo {
	cd /Users/ryan/Repos/hugobuild && hugo -D -t nofancy --baseUrl="http://tinybot.io" --destination="/Users/ryan/Repos/greyhoundforty.github.io"
  cd /Users/ryan/Repos/greyhoundforty.github.io
  git add . 
  git commit -am "Hugo autodeply run"
  git push 
}

# Usage: scrap 'thing to search for'
function scrap {
	find ~/Dropbox/Working_dir/Scrap/ -type f -iname "*.md" -print0|xargs -0 egrep "$1"
}

function atom {
	/Applications/Atom.app/Contents/MacOS/Atom "$1" &> /Dev/null &
}

# Grab file and send to my hastebin server
function haste {
    a=$(cat); curl -X POST -s -d "$a" http://haste.tinybot.io/documents | awk -F '"' '{print "http://haste.tinybot.io/"$4}'; }'"'
  }

# Changes to a directory and lists its contents.
# Usage: cdls /var/foo/bar
function cdls {
    builtin cd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

function notice { echo -e "\e[0;34m:: \e[1;37m${*}\e[0m"; }

# Removes a conflicting ssh-key from the known hosts file
# Usage: iprem 192.168.0.1
function iprem {
ssh-keygen -f "$HOME/.ssh/known_hosts" -R $1
}

# Upload file to transfer.sh amd get back the download URL
# Usage: transfer /etc/rc.local
function transfer { if [ $# -eq 0 ]; then echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }; alias transfer=transfer


# Run a mosh connection to a server
# Usage: msh PORT X.X.X.X
function msh { mosh --ssh='ssh -p "$1"' "$2"; }

function pwgen { openssl rand -base64 16;echo; }

# Search the .zhistory file
# Usage: hist thing
function hist { egrep "$@" $HOME/*.zhistory; }

# Get human readable number for file permissions
# Usage: st FILENAME
function st { stat -c '%n %a' "$@"; }

# Netcat with the -v flag on a port scan
# Usage: ncz IP PORT
function ncz { netcat -z -v "$1" "$2"; }

function search_notes { find $HOME/Dropbox/Ryans\ Docs/Work/CST_CSA\ Notes/ -iname "*.md" -print0| xargs -0 egrep "$@" }

function dockip() {
  docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
}
# 
