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
function atom {
	$HOME//Applications/Atom.app/Contents/MacOS/Atom "$1" &> /dev/null &
}
