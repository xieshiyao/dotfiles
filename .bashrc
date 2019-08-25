# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
# PS1='\[\033[3;34m\]\u@\H \W 情けは人のためならず\$\[\033[0m\] '
# default PS1: [\u@\h \W]\$
# which looks like: [sudongpo@localhost ~]$ 
# PS1='\[\033[3;34m\]\u@\h \W \$\[\033[0m\] '
# PS1='\[\033[0;36m\]\u@\h \W \$\[\033[0m\] '
PS1="\[\033[0;36m\]\u \W\[\033[32m\]\$(parse_git_branch) \[\033[0;36m\]\$\[\033[0m\] "
export PS1

#alias 'g++=g++ -std=c++11'	# C++ default option of g++ 4.8.5 20150623 is gnu++98 or gnu++03, the GNU dialect of -std=c++98
#alias 'gcc=gcc -std=c99'
alias 'cc=cc -std=c99'

#alias 'ECHO=echo' # makes it easier to show environment variables.

EDITOR=nvim
export EDITOR
#alias cd..='cd ..'
alias cd-='cd -'
alias py2='python2'
alias py3='python3'
alias py='python3'
alias xargs='xargs '
alias mysudo='sudo -E env "PATH=$PATH"'
alias tree='tree -C'
alias nv='nvim'
alias ipy='ipython3'
alias Ipy='ipython3'
alias please='sudo dnf'
alias view='nvim -R'
alias gs='git status'
alias open='gnome-open'

alias nv='~/Downloads/nvim.appimage'

#set -o vi # hang onto your hat

function addpath()
{
	# if ! grep "$1" >/dev/null <<< $PATH;then
	if ! [[ "$PATH" =~ "$1" ]];then
		export PATH="$PATH":"$1"
	fi
}
addpath /usr/local/python3/bin 
addpath /usr/local/go/bin 
addpath /home/sudongpo/bin

addpath "$HOME/.local/bin"
addpath "$HOME/bin"

eatwhat(){
	echo "Tacos,Burgers,Pizza,Sushi,Salad,Pasta" | tr ',' '\n' |sort -R |head -1
} 

export winhost=125.216.244.141

function _gotoProgramFileDir()
{
	# go to the directory containing the program
	if [[ $# != 1 ]];then
		echo "Usage: $FUNCNAME programname"
		return 1
	fi

	if prog=$(which $1);then
		cd $(dirname $prog)
	else
		return 1
	fi
}

function _gotoNormalFileDir()
{
	# go to the directory containing a nornal file
	if [[ $# != 1 ]];then
		echo "Usage: $FUNCNAME pathname"
		return 1
	fi

	cd $(dirname $1)
}

function gtdir()
{
	if [[ $# != 1 ]];then
		echo "Usage: $FUNCNAME programname/pathname"
		return 1
	fi
	if [[ $1 =~ .*/.* ]];then
		_gotoNormalFileDir $1
	else
		_gotoProgramFileDir $1
	fi
}

function viewprog()
{
	# view a program in vim
	if [[ $# != 1 ]];then
		echo "Usage: $FUNCNAME programname"
		return 1
	fi
	$EDITOR -R $(which $1)
}

alias rainbowstream='rainbowstream -24' 
		# -24, --color-24bit    Display images using 24bit color codes.
# you may need the line below to run rainbowstream
# export REQUESTS_CA_BUNDLE=/etc/pki/tls/certs/ca-bundle.crt 

export HISTSIZE=10000

function showpath()
{
	tr : \\n <<< $PATH
}

export -f showpath
#md=/home/sudongpo/.vim/bundle/vim-instant-markdown/after/ftplugin/markdown
export plugin=/home/sudongpo/.vim/plugged
export swp=~/.local/share/nvim/swap

cd..()
{
	case $# in
		0)
			n=1
			;;
		1)
			n=$1
			;;
		*)
			exit 1
			;;
	esac

	for ((i=n;i>0;i=i-1)); do
		cd ..
	done
}

export MANPAGER='nvim +Man!'

if ! $MACOS; then
	alias ls='ls -G'
	alias ll='ls -l -G'
	alias l.='ls -d .*'
	alias firefox='open -a /Applications/Firefox.app'
	export LC_ALL=en_US.UTF-8
fi
