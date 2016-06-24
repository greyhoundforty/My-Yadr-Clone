notice () {
	echo -e "\e[0;34m:: \e[1;37m${*}\e[0m"
}
## extract : Extract common compressed file types. notice "Usage: extract file.tar.gz"
extract () {
	if [ -f $1 ]
	then
		case $1 in
			(*.tar.bz2) tar xjf $1 ;;
			(*.tar.gz) tar xzf $1 ;;
			(*.bz2) bunzip2 $1 ;;
			(*.rar) unrar e $1 ;;
			(*.gz) gunzip $1 ;;
			(*.tar) tar xf $1 ;;
			(*.tbz2) tar xjf $1 ;;
			(*.tgz) tar xzf $1 ;;
			(*) echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}
