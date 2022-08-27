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
alias pip='pip3'
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

alias lst='ls --color=auto -t'
alias ls.='ls --color=auto -d .*'
alias llt='ls --color=auto -lt'
alias llh='ls --color=auto -lh'
alias llth='ls --color=auto -lth'
# alias nv='~/Downloads/nvim.appimage'

alias shogi='mono /home/sudongpo/shogi/ShogiGUIv0.0.7.20/ShogiGUI.exe'

# competitive computing
_rtl()
{
	# Remove trailing newline of a file
	if [[ $# != 1 ]];then
		echo "Usage: $FUNCNAME filename"
		return 1
	fi
	if [ -f $1 ]; then
		perl -p -i -e 'chomp if eof' $1
		echo Trailing newline in $1 is removed.
	else
		return 1
	fi
}
alias ojt='make && oj t -c ./main'
alias pojt='oj t -c "python3 main.py"'
alias accs='acc submit'
alias ojts='ojt && accs main.cpp'
alias pojts='pojt && accs main.py'
alias vojt="oj t -c 'bash -c \"cat - > /tmp/vojt_hyq.out;TERM=dumb vim -N -u NONE -i NONE -s ./main.vim /tmp/vojt_hyq.out &> /dev/null;cat /tmp/vojt_hyq.out\"'"
alias vojts='_rtl main.vim && vojt &&  oj s $(acc task -u) main.vim -l vim'
alias vaccs='_rtl main.vim && oj s $(acc task -u) main.vim -l vim'
alias bfojt='oj t -c "bf main.bf"'
alias bfojts='_rtl main.bf && oj t -c "bf main.bf" && oj s $(acc task -u) main.bf -l brainfuck'
alias bfaccs='_rtl main.bf && oj s $(acc task -u) main.bf -l brainfuck'

for i in {a..v} ex; do
	alias $i="cd ../$i 2> /dev/null || cd $i"
done

for i in {1..3}; do
	alias "t$i=./main < ./test/sample-$i.in"
done

atcoderWait()
{
	case $# in
		1)
			startTime=21:00:00
			;;
		2)
			startTime=$2
			;;
		*)
			echo "Usage: $FUNCNAME contest-id [start-time]"
			return 1
			;;
	esac

	if [ $(basename $PWD) != atcoder ]; then
		for ((i=0;i<5;i++)); do
			echo "You may be in the wrong directory." >&2
		done
	fi

	diffenence=$(( $(date -d $startTime +%s) - $(date +%s) ))
	echo "Will start trying \`cd $1 && nvim a/main.cpp\` at $(date -d $startTime)($diffenence seconds later)."
	sleep $diffenence
	while true; do
		if [ -f $1/a/main.cpp ]; then
			cd $1
			nvim a/main.cpp
			break
		fi
		echo -n 🐍
		sleep 1
	done
}

atcoderDownload()
{
	case $# in
		1)
			startTime=21:00:00
			;;
		2)
			startTime=$2
			;;
		*)
			echo "Usage: $FUNCNAME contest-id [start-time]"
			return 1
			;;
	esac

	if [ $(basename $PWD) != atcoder ]; then
		for ((i=0;i<5;i++)); do
			echo "You may in the wrong directory." >&2
		done
	fi

	diffenence=$(( $(date -d $startTime +%s) - $(date +%s) ))
	echo "Will start trying download at $(date -d $startTime)($diffenence seconds after)."
	sleep $diffenence
	while true; do
		acc new $1
		if [ -f $1/a/main.cpp ]; then
			cd $1/a
			break
		fi
	done
}

#set -o vi # hang onto your hat

function addpath()
{
	if ! [[ "$PATH" =~ (^|:)"$1"(:|$) ]];then
		if [[ "$2" == before ]];then
			export PATH="$1":$PATH
		else
			export PATH="$PATH":"$1"
		fi
	fi
}
addpath /usr/local/python3/bin 
addpath /usr/local/go/bin 
# addpath /usr/local/cuda/bin

addpath "$HOME/.local/bin"
addpath "$HOME/bin"
addpath "$HOME/gooo/bin"
addpath "/usr/lib64/openmpi/bin/"

[ -f $HOME/mylocal.bashrc ] && . $HOME/mylocal.bashrc

# export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

eatwhat(){
	echo "Tacos,Burgers,Pizza,Sushi,Salad,Pasta" | tr ',' '\n' | sort -R | head -1
} 

mping ()
{ 
	ping $1 \
	| awk -F[=\ ] '/time=/
						{
							t=$(NF-1);
							f=3000-14*log(t^20);
							c="play -q -n synth 1 pl " f;
							print $0;
							system(c);
							print "hello"
						}
					! /time=/ { print "no" }'
}

mping2 ()
{ 
	ping $1 \
	| awk -F[=\ ] '/time=/
						{
							t=$(NF-1);
							f=3000-14*log(t^20);
							c="play -q -n synth 1 pl " f;
							system(c);
							print "hello"
						}
					! /time=/ { print "no" }'
}

mping3 ()
{ 
	ping $1 \
	| awk -F[=\ ] '/time=/
						{
							t=$(NF-1);
							f=3000-14*log(t^20);
							c="play -q -n synth 1 pl " f;
							system(c);
							print "hello"
						}'
}

mping4 ()
{ 
	ping $1 \
	| awk -F[=\ ] '/time=/
						{
							t=$(NF-1);
							f=3000-14*log(t^20);
							c="play -q -n synth 1 pl " f;
							system(c);
							print "hello"
						}'
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

export HISTSIZE=100000

function showpath()
{
	tr : \\n <<< $PATH
}

export -f showpath
#md=/home/sudongpo/.vim/bundle/vim-instant-markdown/after/ftplugin/markdown
export plugin=$HOME/.vim/plugged
export xunlei=$HOME/.deepinwine/Deepin-ThunderSpeed/drive_c/迅雷下载/
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

# for tensorflow

# fix error messages: Failed to get convolution algorithm. This is probably because cuDNN failed to initialize, so try looking to see if a warning log message was printed above.
export TF_FORCE_GPU_ALLOW_GROWTH=true

# 0 = all messages are logged (default behavior)
# 1 = INFO messages are not printed
# 2 = INFO and WARNING messages are not printed
# 3 = INFO, WARNING, and ERROR messages are not printed
export TF_CPP_MIN_LOG_LEVEL=2

export DOTNET_CLI_TELEMETRY_OPTOUT=true # opt out .NET from collecting usage data


export FZF_DEFAULT_OPTS="--height 60% --reverse --multi --inline-info \
	--preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat {} --color=always -pp) | head -300' \
	--preview-window=''right:hidden:wrap \
	--bind='f2:toggle-preview,\
ctrl-d:half-page-down,\
ctrl-y:execute(echo {+} | xsel --clipboard)'"
complete -o bashdefault -o default -F _fzf_path_completion nv

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

stty -ixon # disable ^S which freeze my terminal

function fq()
{
	if [[ $# == 0 ]]; then
		echo fqing...
		export http{,s}_proxy=127.0.0.1:12333
	else
		echo 做回合法公民
		export http{,s}_proxy=
	fi
}

export GOPATH=$HOME/gooo

function mkcd() {
	mkdir "$@"
	while [[ $# > 1 ]]; do
		shift
	done
	cd $1
}

function share(){
	echo -n "IP: "
	ifconfig | awk '/virbr/{getline;print $2}'
	if [[ $# == 0 ]];then
		py -m http.server
	else
		py -m http.server -d $1
	fi
}


# TODO write a program to unpack a directory
# eg:	$ ls
#		redundant/ something else
#		$ ls redundant/
#		dir1/ dir2/ file1
#		$ undir redundant/
#		$ ls
#		dir1/ dir2/ file1 something else

