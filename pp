#!/usr/bin/env bash # Purely for the editor
# pp - Settings to be included in .bashrc

# Recommended packages:
# CLI:
#  aria2 ne dfc dcfldd iftop pv w3m htop colordiff dwdiff mmv fzf timg secure-delete
#  tty-clock rdiff caca-utils git tmux aptitude gpgsm rsync ghostscript csvtool
#  jq zbar-tools diskscan smartmontools rename curl ffmpeg gdisk parted lynx xterm
#  psmisc lsof telnet exfatprogs unrar swath cryptsetup gettext pkg-config lvm2
#  python3-pyasn1 minidlna dovecot-imapd sqlite3 restic rclone uni2ascii nmon
#  php-fpm php-xml php-gd shellcheck zint libnss-resolve[github.com/censurfridns/client-configs]
# tiv: https://github.com/stefanhaustein/TerminalImageViewer (4e4.in/tiv) [override LDFLAGS  += -pthread -static]
# difft: From https://github.com/Wilfred/difftastic/releases
# bat: sudo wget -qO /usr/local/bin/c wget 4e4.in/c; chmod +x /usr/local/bin/c
# exa: sudo wget -qO /usr/local/bin/l 4e4.in/l; chmod +x /usr/local/bin/l

# X:
#  qpdfview clipit vlc smplayer xiphos yad gimp unoconv geany calibre numlockx weasyprint
#  galculator virtualbox keepassxc gnumeric #libgtk3-nocsd0
#  photofilmstrip vcdimager skype zoom feh flameshot flpsed
#  google-earth-pro-stable
# numlockx:
#  (if /etc/lightdm/lightdm.conf empty, start with: '[SeatDefaults]')
#  echo 'greeter-setup-script=/usr/bin/numlockx on' |sudo tee -a /etc/lightdm/lightdm.conf
# vscodium: https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo
# signaldesktop: https://signal.org/download
# tpm-fido: https://github.com/psanford/tpm-fido (Github:Security Key) (+ misc/tpmfido in Startup Application)

#alias getyoutube-dl='sudo curl -qL https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl; sudo chmod +x /usr/local/bin/youtube-dl'
alias getytdl='sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/ytdl && sudo chmod a+rx /usr/local/bin/ytdl'

# Best adjust them in the terminal used
#eval $(dircolors |sed 's/:di=01;34:/:di=01;33:/; s/:ow=34;42:/:ow=34;40:/')
stty -ixon  # Disallow Ctrl-S
shopt -s interactive_comments
shopt -s dotglob extglob
shopt -s histappend
set +H  # no more history expansion, use ! safely in strings

((UID)) && S=@ || S=#
((UID==1000)) && S='$'
((UID==1001)) && S=%
export R=$'\e[31m' G=$'\e[32m' Br=$'\e[33m' B=$'\e[34m' P=$'\e[35m' C=$'\e[36m' Lg=$'\e[37m' N=$'\e[0m' S
export Dg=$'\e[1;30m' LR=$'\e[1;31m' LG=$'\e[1;32m' Y=$'\e[1;33m' LB=$'\e[1;34m' LP=$'\e[1;35m' LC=$'\e[1;36m' W=$'\e[1;37m'
#export PROMPT_COMMAND='hasjobs=$(jobs -p)'
export PROMPT_COMMAND='hasjobs=$(s=$(jobs -s |wc -l) r=$(jobs -r |wc -l); ((s+r)) && printf "$LG$r$N-$LR$s$N ")'
export PS1='\[$LC\]$hasjobs\[\e[1;$(($? ? 36 : 32))m\]\w\[$Y\]$(ls .git &>/dev/null && printf " " && git rev-parse --abbrev-ref HEAD 2>/dev/null)\[$LP\]$S \[$N\]'
#export PS1='\[\e[1;36m\]${hasjobs:+\j }\[\e[1;32m\]\w \[\e[1;33m\]$(ls .git &>/dev/null && git rev-parse --abbrev-ref HEAD 2>/dev/null)\[\e[1;36m\]\$ \[\e[0m\]'
export HISTSIZE=5000  # Default: 2000
export HISTFILESIZE=-1
#export WINEPREFIX=~/.wine
export EDITOR=nano
#export LESSOPEN="| command c --paging always --plain %s"
export QUOTING_STYLE=literal
export DISPLAY=:0.0
#export CHROME_DEVEL_SANDBOX=/usr/local/sbin/chrome-devel-sandbox
#export PAGER='less -Gg -~RXQFP"%pB\% %f - press Q to exit"'
#export PAGER='command c --paging always --plain'
export LESS_TERMCAP_mb=$'\E[01;31m' LESS_TERMCAP_md=$'\E[01;31m' LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m' LESS_TERMCAP_so=$'\E[01;44;33m' LESS_TERMCAP_ue=$'\E[0m' LESS_TERMCAP_us=$'\E[01;32m'
export TERM=xterm-256color
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export SCT=6500
export GOROOT=/usr/local/go GOBIN=~/go/bin
export PYTHONPATH=$(e=(/usr/lib/python*/dist-packages); e=${e[@]}; echo "${e// /:}")
#export MODULAR_HOME="/home/pp/.modular"
export GIT_EXTERNAL_DIFF=difft
#export RUSTC_WRAPPER=sccache

addpath(){ for p; do [[ -e $p && ":$PATH:" != *:"$p":* ]] && PATH+=":$p"; done;}
ods2csv(){ soffice --invisible --nofirststartwizard --norestore --headless "$1" macro:///ExportAllToCsv.Module.ExportAllToCsvAndExit ;}
ds(){ [[ $1 ]] && sudo smartctl -t long "$1" && sudo diskscan -f -o ${1%%*/}$RANDOM.diskscan "$1" ||
	echo "ds needs a valid blockdevice that refers to a harddrive!";}
fv(){ [[ -z $1 ]] && echo "Need video substring to search" && return; ssh server "find /data/video |grep --color=auto $1";}
st(){ [[ $1 ]] && (($1>=1000 && $1<=10000)) && SCT=$1 || SCT=$(yad --title "Display tint" --scale --value=${SCT:=6500} --min-value=1000 --max-value=10000); [[ $SCT ]] && /usr/local/bin/sct $SCT; # sct needs to be compiled from sct.c
}
rqr(){ zbarimg --raw -q $1;}
bt(){ [[ $1 == *\&* ]] && aria2c "$1" || echo "Use single quotes!";}
#c(){ [[ -d $1 ]] && ls -AFl $@ |less -RMgx2 || less -RMgx2 "$@";}
#c(){ [[ -d $1 ]] && command l -aBgHl --time-style=long-iso $@ |less -RMgx2 || command c --paging always --tabs 2 --plain "$@";}
c(){ type -P c >/dev/null && command c --paging always --tabs 2 --plain "$@" || less -RMgx2 "$@";}
cx(){ [[ -d $1 ]] && command l -aBgHl --time-style=long-iso "$1" |less -RMgx2 +G || less -RMgx2 +G "$1";}
ff(){ [[ $2 ]] && d="$2" || d='.'; find "$d" |grep -s --color=auto --devices=skip -I "$1";}
pdfc(){ (($#<2 || $#>3)) && echo "PDF Resize needs: <input.pdf> <output.pdf> [1] (third argument optional, gives better quality)" && return 1; [[ $3 = 1 ]] && q=ebook || q=screen; gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/"$q" -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$2" "$1";}
pdfcl(){ (($#!=2)) && echo "PDF Clean needs 2 arguments: <input.pdf> and <output.pdf>" && return 1; t=$(mktemp); pdf2ps "$1" "$t"; ps2pdf "$t" "$2"; rm -- "$t";}
qv(){ qpdfview --unique "$@" &}
d2u(){ # Remove all CR/^M/\r at the end of lines (before newline/NL/^J/\n)
	for f; do sed -i 's/\r$//' "$f"; done;}
u2d(){ sed -i 's@$@\r@' $1;}
md(){ mkdir -p "$1" && cd "$1"; }
al(){ local f="$(declare -f "$1")" a="$(alias "$1" 2>/dev/null)" b="$(whereis "$1")"
	[[ $f ]] && echo "$f"
	[[ $a ]] && echo "$a"
	[[ ${b##*:} ]] && echo "$b";}
sk(){ ((sk)) && sk=0 && xmodmap -e "pointer = 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16" && echo "mousekeys normal" && return
	export sk=1; xmodmap -e "pointer = 2 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16"; echo "mousekeys 1 and 2 swapped";}
asf(){ apt-cache search $1 |egrep --color=auto $1;}
s5(){ # $1:country(us|nl|th|ca|cr|sg) # entries s5nl/s5th/s5us/s5ca/s5cr/s5sg must be defined in .ssh/config
	! [[ $1 = nl || $1 = th || $1 = us || $1 = de || $1 = cr || $1 = ca || $1 = sg ]] &&
		echo "Usage: s5 nl | th | us | ca | cr | sg" && return 1
	ssh -N s5$1 & ssh=$!
    sleep 1
    pgrep -c falkon > /dev/null || falkon & falkon=$!
    wait $falkon
    kill $ssh
}
dif(){ [[ $3 ]] && arg=$1 && shift; local c=$(colordiff $arg -u "$1" "$2"); [[ "$c" ]] && less -r <<<"$c" || echo "Same: $1 $2";}
dy(){ colordiff -y "$1" "$2" |less -r;}
gr(){
 [[ $2 ]] && d=$2 || d=$PWD
 egrep -r -s --color=auto --devices=skip -I "$1" "$d"
}
as(){ r=$(apt-cache search "$1" |egrep --color=always "$1") && less -Rm <<<"$r";}
ass(){ apt-cache show "$@" |less -r;}
asp(){ apt-cache showpkg "$@" |less -r;}
u(){
	[[ -d "$1" ]] && d="$1" || d="."
	du -h --max-depth=1 "$d" |sort -h
}
joinpdf(){ gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$*;}
rotvidr(){ mencoder -ovc lavc -vf rotate=1 -oac copy ${1} -o ${1}.avi;}
rotvidl(){ mencoder -ovc lavc -vf rotate=2 -oac copy ${1} -o ${1}.avi;}
reduce4e(){ local a=$1 b; [[ $2 ]] && b=$2 || b=$1.mp4; ffmpeg -hide_banner -i "$a" -vf "scale=iw/4:ih/4" -vcodec libx265 -crf 28 "$b"; command l -al "$a" "$b";}
reduce4(){ local a=$1 b; [[ $2 ]] && b=$2 || b=$1.mp4; ffmpeg -hide_banner -i "$a" -vf "scale=iw/4:ih/4" -vcodec libx265 -crf 24 "$b"; command l -al "$a" "$b";}
reduce3(){ local a=$1 b; [[ $2 ]] && b=$2 || b=$1.mp4; ffmpeg -hide_banner -i "$a" -vf "scale=iw/3:ih/3" -vcodec libx265 -crf 24 "$b"; command l -al "$a" "$b";}
reduce2(){ local a=$1 b; [[ $2 ]] && b=$2 || b=$1.mp4; ffmpeg -hide_banner -i "$a" -vf "scale=iw/2:ih/2" -vcodec libx265 -crf 24 "$b"; command l -al "$a" "$b";}
reduce(){ local a=$1 b; [[ $2 ]] && b=$2 || b=$1.mp4; ffmpeg -hide_banner -i "$a" -vcodec libx265 -crf 24 "$b"; command l -al "$a" "$b";}
adb(){ # adb - analyse max-decibel; USAGE: adb <inputmp3> # if neg, increase possible
	ffmpeg -hide_banner -i "$1" -af "volumedetect" -vn -sn -dn -f null /dev/null 2>&1 |grep -o 'max_volume.*';}
bv(){ ffmpeg -hide_banner -i "$1" -af "volume=$2dB" "$1.mp3";}
clipvid(){
	# $1:src $2:start(time) $3:fadein(s) $4:fadeout(s) $5:end(time) [$6:dst]
	local tmp out=$1.mp4 i b e bd ed
	local usage="Usage: clipvid <videofile> <start(0 | hmmss[.mmm])>"
	usage+=" <fadein(s[.mmm])> <fadeout(s[.mmm])> <end(hmmss[.mmm])> <outfile>"
	[[ -z $1 || $1 = -h || $1 = --help ]] &&
		echo $usage && return 0
	[[ ! -f $1 ]] &&
		echo -e "$usage\nSource video not a file: '$1'" && return 1
	b=$2 e=$5 bd=$(cut -s -d. -f2 <<<"$b") ed=$(cut -s -d. -f2 <<<"$e")
	[[ $b = 0 ]] && b=00000
	[[ ! $b = [0-9][0-5][0-9][0-5][0-9]* ]] &&
		echo -e "$usage\nStarttime '$2' not in time format hmmss[.mmm]" && return 2
	[[ -z $3 || ${3//[0-9.]} ]] &&
		echo -e "$usage\nFade-in seconds '$3' not numerical" && return 3
	[[ -z $4 || ${4//[0-9.]} ]] &&
		echo -e "$usage\nFade-out seconds '$4' not numerical" && return 4
	[[ ! $e = [0-9][0-5][0-9][0-5][0-9]* ]] &&
		echo -e "$usage\nEndtime '$e' not in time format hmmss[.mmm]" && return 5
	[[ $6 ]] && out=$6
	b=${b:0:1}:${b:1:2}:${b:3:2}${b:5} e=${e:0:1}:${e:1:2}:${e:3:2}${e:5}
	i=$(bc -l <<<"$(date -d $e +%s).$ed-$(date -d $b +%s).$bd-$4")
	tmp=$(mktemp --suffix=.mp4)
	ffmpeg -hide_banner -i "$1" -ss "$b" -to "$e" -async 1 $tmp
	echo "ffmpeg -hide_banner -i '$1' -ss '$b' -to '$e' -async 1 $tmp"
	[[ ! $3 = 0 || ! $4 = 0 ]] &&
		ffmpeg -hide_banner -i $tmp -vf "fade=t=in:st=0:d=$3,fade=t=out:st=$i:d=$4" \
			-af "afade=t=in:st=0:d=$3,afade=t=out:st=$i:d=$4" "$out" &&
		rm $tmp ||
		mv "$tmp" "$out"
}
speedvid(){
	(($#!=2)) && echo "Usage: speedvid <video> <speed>" && return 1
	[[ ! -f $1 ]] && echo "Not a video file: $1" && return 2
	[[ ${2//[0-9.]} ]] && echo "Speed not a rational number: $2" && return 3
	local a=$2
	[[ ${a:0:1} = . ]] && a=0$a
	local v=$(bc -l <<<"1/$a")
	[[ ${v:0:1} = . ]] && v=0$v
	ffmpeg -hide_banner -i "$1" -filter_complex "[0:v]setpts=$v*PTS[v];[0:a]atempo=$a[a]" -map "[v]" -map "[a]" "$1.mp4"
}
tn(){ : &>/dev/null <"/dev/tcp/$1/$2" && echo open || echo closed;}
cd(){ # Print working directory after `cd`
	[[ $@ == '-' ]] && builtin cd "$@" >/dev/null || builtin cd "$@"; echo -e "   \e[1;30m"`pwd`"\e[0m";}
addpk(){ # add PUBKEY
 gpg --keyserver subkeys.pgp.net --recv-keys $1;  gpg --armor --export $1 | sudo apt-key add -;}
ah(){ # hold package (no upgrades)
	while [[ "$1" ]]; do sudo apt-mark hold "$1"; shift; done;}
arh(){ # unhold package
	while (($#)); do sudo apt-mark unhold "$1"; shift; done;}
thcc(){ # Thai character count
	echo -n "$@" |sed "s@[\xe0\xb8\xb1|\xe0\xb8\xb4|\xe0\xb8\xb5|\xe0\xb8\xb6|\xe0\xb8\xb7|\xe0\xb8\xb8|\xe0\xb8\xb9|\xe0\xb8\xba|\xe0\xb9\x87\xe0\xb9\x88|\xe0\xb9\x89|\xe0\xb9\x8a|\xe0\xb9\x8b|\xe0\xb9\x8c|\xe0\xb9\x8d|\xe0\xb9\x8e]@@g" |wc -m;}
spinner(){ (set +m && coproc $@; local pid=$! spinstr='/-\|'; while [ "$(ps a |awk '{print $1}' |grep $pid)" ]; do local temp=${spinstr#?}; printf " [%c]  " "${spinstr}"; local spinstr=${temp}${spinstr%"$temp"}; sleep 1; printf "\b\b\b\b\b\b"; done; printf "    \b\b\b\b");}
exin(){ [[ -f "$1" ]] && f="$1" || f=/initrd.img; f=$(readlink -e "$f"); d="${f##*/}_$(date -r "$f"  '+%F_%T')"; mkdir $d; cd $d; n=$(cpio -iF "$f" 2>&1 |grep ' blocks$'); dd if="$f" of=i.gz bs=512 skip=${n%% *}; gunzip i.gz; cpio -iF i; rm i;}
aenc(){ for f in "$@"; do if [[ -n ${f%%*.enchive} ]]; then [[ -d "$f" ]] && tar cJf "$f.txz" "$f" && enchive a "$f.txz" && rm "$f.txz" || enchive a "$f"; else enchive e "$f"; [[ -z ${f%%*.txz.enchive} ]] && tar xf "${f%%.enchive}" && rm "${f%%.enchive}"; fi; done;}
difch(){ (($#!=3)) && o=/dev/stdout || o="$3"
	[[ ! -f $1 || ! -f $2 ]] && echo "ERROR: $1 and $2 must be files" && return 1
	echo -e "<html lang=\"th\">\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\n<title>$o</title>\n<style>\n.f1{background-color:red}\n.f2{background-color:darkgreen}\n</style>" >"$o"
	git diff -U100000 --word-diff=color --word-diff-regex=. "$1" "$2" |tail -n +6 |ansi2htm --body-only 2>/dev/null |sed 's@^@<br>@' >>"$o";}
difw(){ (($#!=3)) && echo -e "USAGE: difch <file1> <file2> <outfile>\nERROR: 3 arguments required" && return 1
	[[ ! -f $1 || ! -f $2 ]] && echo "ERROR: $1 and $2 must be files" && return 2
	echo -e "<html lang=\"th\">\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\n<title>$3</title>\n<style>\n.f1{color:red}\n.f2{color:darkgreen}\n</style>" >"$3"
	git diff -U100000 --word-diff=color --word-diff "$1" "$2" |tail -n +6 |ansi2htm --body-only 2>/dev/null |sed 's@^@<br>@' >>"$3";}
wgt(){ wget -qO- "$1"; echo;}
togglepad(){ local id=$(xinput list |grep 'PS/2 Logitech Wheel Mouse' |grep -o '=[0-9]*'); id=${id#=}; local s=$(xinput list-props $id |head -n 2 |tail -c 2); xinput set-prop $id "Device Enabled" $((!s)); echo -n "Touchpad "; ((s)) && echo "off" || echo "on";}
prompt(){ [[ $1 ]] && { local a=($1); while true; do echo -en "$2"; read -r; [[ " ${a[@]} " = *" ${REPLY// /} "* ]] && return 0; echo -en "$3"; done;} || echo "USAGE: prompt \"<space-delimited input>\" [\"<prompt message>\" [\"<error message>\"]]";}
trim(){ while (($#)); do read -rd '' $1 <<<"${!1}"; shift; done; } # Trim whitespace off all given variables
fixusb3(){ # i=0000:00:10.0
	local i d=/sys/bus/pci/drivers/xhci_hcd
	# cd "$d"
	for i in $(ls "$d" |grep :)
	do
		echo -n "$i" |sudo tee "$d/unbind" >/dev/null
		# ln -s "../../../../devices/pci0000:00/$i" .
		echo -n "$i" |sudo tee "$d/bind" >/dev/null
	done
}
getmasterkey(){ # when root and device decrypted
	xxd -r -p <$(sudo dmsetup table --showkeys |grep '^lvmcrypt: 0' |cut -d' ' -f6) masterkey;}
smv(){ # Shred-move (with srm from secure-delete)
	[[ -z $2 ]] && echo "ABORT: shred-move requires at least 2 arguments" &&
		return 1
	local argv=("$@")
	local a dir=${argv[-1]}
	unset argv[-1]
	[[ -e $dir && ! -d $dir ]] &&
		echo "ABORT: last argument is not a directory: $dir" && return 2
	[[ ! -e $dir ]] && mkdir -p "$dir"
	[[ ! -d $dir ]] && echo "ABORT: directory $dir inaccessible" && return 3
	for a in "${argv[@]}"; do cp -a "$a" "$dir"; done;
	command srm -dlv "${argv[@]}";}
geo(){ # $1:(optional)ip-quadroctet
	[[ $1 && ! $1 =~ ^[1-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$ ]] &&
		echo "commandline argument not a numerical IP address in dot notation" &&
		return 1
	wget -qO- ipinfo.io/$1 |grep ':' |sed -e 's/"//g' -e 's/,$//';}
myip(){ #curl ipinfo.io
	curl -w'\n' api{4,6}.ipify.org;}
pb(){ [[ -z $1 ]] && echo "Missing filename to termbin.com:9999" && return
	while (($#)); do cat $1 |nc termbin.com 9999; shift; done;}
backlight(){ # $1:level (0/1/2, if empty: toggle)
	local b='/sys/class/leds/dell::kbd_backlight/brightness' l=$1
	! [[ -z $l || $l = 0 || $l = 1 || $l = 2 ]] &&
		echo -e "Invalid argument\nUsage: backlight [0|1|2]" && return 1
	[[ -z $l ]] && l=$((($(<"$b")+1)%3))
	echo $l |sudo tee "$b"
}
assh(){ #$1:host
	[[ -z $1 ]] && echo "ERROR: hostname as argument needed" && return 1
	autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -o "ControlMaster auto" -o "ControlPersist 2h" -o "ExitOnForwardFailure yes" -R 2222:localhost:5691 -l PeterPasschier1965 $1;}
kd(){ reset; local o; o=$(kdbxviewer -t "$@") && less -R <<<"$o" && reset;}
bzlist(){ [[ ! -f "$1" ]] && echo "not a file: '$1'" && return; local d=$(mktemp -d); s=$(stat -c %s "$1")00; cp "$1" "$d" || return 2; bunzip2 "$d"/* || return 3; i=$(stat -c "%n %s" "$d"/* |sed "s@$d/@@"); echo "$i $((s/${i##* }))%"; rm -r "$d";}
gcd(){ (($1%$2)) && gcd $2 $(($1%$2)) || echo $2;}
aspect(){ identify -format "%[fx:(w/h)]:%M\n" "$@" |sort -n;}
transfer(){ # Required: tty curl zip cd cat
  transferUsage(){
    echo "Usage:  transfer <name>" >&2
    echo "  Outputs a link where file/directory <name> can be downloaded." >&2
    echo "  (if <name> is a directory, the download will be <name>.zip)" >&2
    echo "  Data can also be piped into 'transfer', like:  ls |transfer listing" >&2
  }
  test x$1 = x && transferUsage && return 1
  ! tty -s && curl --progress-bar --upload-file "-" "https://transfer.sh/$1" && return
  test ! -e "$1" && echo "No such file or directory: $1" >&2 && transferUsage && return 2
  test ! -d "$1" && cat "$file" |curl --progress-bar --upload-file "-" "https://transfer.sh/${1##*/}" && return
  (cd "$1" && zip -r -q - .) |curl --progress-bar --upload-file "-" "https://transfer.sh/${1##*/}.zip"
}
2bin(){ bc <<<"obase=2;$1";}
#di(){ [[ ! $1 ]] && echo "Need docker container_id to inspect" && return ||
#	docker inspect --format "$(grep -v '^#' ~/git/misc/docker.tpl)" "$1";}
di(){ [[ ! -n $1 ]] && echo "Need docker container_id to inspect" && return || docker inspect -f 'docker run --name {{printf "%q" .Name}} {{- with .HostConfig}} {{- if .Privileged}} --privileged {{- end}} {{- if .AutoRemove}} --rm {{- end}} {{- if .Runtime}} --runtime {{printf "%q" .Runtime}} {{- end}} {{- range $b := .Binds}} --volume {{printf "%q" $b}} {{- end}} {{- range $v := .VolumesFrom}} --volumes-from {{printf "%q" $v}} {{- end}} {{- range $l := .Links}} --link {{printf "%q" $l}} {{- end}} {{- if .PublishAllPorts}} --publish-all {{- end}} {{- if .UTSMode}} --uts {{printf "%q" .UTSMode}} {{- end}} {{- with .LogConfig}} --log-driver {{printf "%q" .Type}} {{- range $o, $v := .Config}} --log-opt {{$o}}={{printf "%q" $v}} {{- end}} {{- end}} {{- with .RestartPolicy}} --restart "{{.Name -}} {{- if eq .Name "on-failure"}}:{{.MaximumRetryCount}} {{- end}}" {{- end}} {{- range $e := .ExtraHosts}} --add-host {{printf "%q" $e}} {{- end}} {{- range $v := .CapAdd}} --cap-add {{printf "%q" $v}} {{- end}} {{- range $v := .CapDrop}} --cap-drop {{printf "%q" $v}} {{- end}} {{- range $d := .Devices}} --device {{printf "%q" (index $d).PathOnHost}}:{{printf "%q" (index $d).PathInContainer}}:{{(index $d).CgroupPermissions}} {{- end}} {{- end}} {{- with .NetworkSettings -}} {{- range $p, $conf := .Ports}} {{- with $conf}} --publish " {{- if $h := (index $conf 0).HostIp}}{{$h}}: {{- end}} {{- (index $conf 0).HostPort}}:{{$p}}" {{- end}} {{- end}} {{- range $n, $conf := .Networks}} {{- with $conf}} --network {{printf "%q" $n}} {{- range $a := $conf.Aliases}} --network-alias {{printf "%q" $a}} {{- end}} {{- end}} {{- end}} {{- end}} {{- with .Config}} {{- if .Hostname}} --hostname {{printf "%q" .Hostname}} {{- end}} {{- if .Domainname}} --domainname {{printf "%q" .Domainname}} {{- end}} {{- range $p, $conf := .ExposedPorts}} --expose {{printf "%q" $p}} {{- end}} {{- range $e := .Env}} --env {{printf "%q" $e}} {{- end}} {{- range $l, $v := .Labels}} --label {{printf "%q" $l}}={{printf "%q" $v}} {{- end}} {{- if not (or .AttachStdin (or .AttachStdout .AttachStderr))}} --detach {{- end}} {{- if .AttachStdin}} --attach stdin {{- end}} {{- if .AttachStdout}} --attach stdout {{- end}} {{- if .AttachStderr}} --attach stderr {{- end}} {{- if .Tty}} --tty {{- end}} {{- if .OpenStdin}} --interactive {{- end}} {{- if .Entrypoint}} {{- if eq (len .Entrypoint) 1 }} --entrypoint " {{- range $i, $v := .Entrypoint}} {{- if $i}} {{end}} {{- $v}} {{- end}}" {{- end}} {{- end}} {{printf "%q" .Image}} {{range .Cmd}}{{printf "%q " .}}{{- end}} {{- end}}' "$1" |sed 's/ --/ \\\n  --/g' |less;}
vp(){ ffprobe -hide_banner "$1" 2>&1 |grep -e Duration: -e Video:;}
i(){ convert -colors 16 "$1" sixel:-;}
fpw(){ LD_LIBRARY_PATH=/usr/lib/firefox /data/git/misc/fpw -ftabular |grep $1 |c --paging always --tabs 1 --plain; reset;}
pg23(){ if [[ $1 ]]
	then
		xmodmap -e "keycode 68 = F2 F2 F2 NoSymbol F2 F2 XF86Switch_VT_2 F2 F2"
		xmodmap -e "keycode 69 = F3 F3 F3 NoSymbol F3 F3 XF86Switch_VT_3 F3 F3"
	else
		xmodmap -e "keycode 68 = Prior F2 F2 NoSymbol F2 F2 XF86Switch_VT_2 F2 F2"
		xmodmap -e "keycode 69 = Next F3 F3 NoSymbol F3 F3 XF86Switch_VT_3 F3 F3"
	fi
}
xt(){ [[ $1 ]] && ssh="-e ssh $1"
	xterm +ah -aw -rw -bc -cr cyan -j -fg white -bg black -maximized -fa Julia -fs 19 -si -rightbar -sl 51200 +vb -wf -ti vt340 -xrm '*metaSendsEscape:true' $ssh &}
gcd(){ (($#!=2)) && echo 'Need to numbers to get the Greatest Common Divider' && return
	(($1%$2)) && gcd $2 $(($1%$2)) || echo $2;}
ghl(){ # 1:user/project on github.com
	curl --silent --location --max-time 30 "https://api.github.com/repos/$1/releases/latest" |jq .tag_name;}
vchk(){ # 1:videofile
	[[ -z $1 ]] && echo "Need videofile to check" && return
	ffmpeg -hide_banner -v error -i $1 -f null -;}
vc(){ local out=$(ffprobe -hide_banner "$1" 2>&1)
 grep Invalid <<<"$out";}
tomp4(){ ffmpeg -hide_banner -i "$1" -c:a aac -c:v libx265 -x265-params crf=25 "$1.mp4";}
tomp4s(){ ffmpeg -hide_banner -i "$1" -c:a aac -c:v libx265 -x265-params crf=25 -c:s mov_text "$1.mp4";}
len(){ echo "$(($(wc -c <<<"$1")-1))";}
ord(){ LC_TYPE=C printf '%x' "'$1";}
erasedrive(){ # Completely hardformat
	local hd=$1
	[[ -z $hd ]] && echo "Give devicename of harddrive" && return 1
	[[ ! -a $hd ]] && echo "Device not found" && return 2
	local hdpi=$(sudo hdparm -I "$hd")
	local mins=$(grep '[0-9]*min for ' <<<$hdpi)
	mins=${mins%%min*}
	mins=${mins:1}
	echo "Secure Erase should take $mins minutes"
	((mins>120)) && local version=$(hdparm -V) && version=${version#hdparm v} && [[ $version < 9.31 ]] && echo "hdparm before v9.31 will time out on large disks after 2 hours!" && return 4
	local frozen=$(grep frozen <<<"$hdpi")
	[[ -z frozen ]] && echo "Not a harddrive: '$hd'" && return 5
	[[ ! $frozen = *not* ]] && echo "Device frozen" && sudo pm-suspend && hdpi=$(sudo hdparm -I "$hd") && frozen=$(grep frozen <<<"$hdpi") && [[ ! $frozen = *not* ]] && echo "Giving up, still frozen..." && return 6
	read -p "Press Ctrl-C to cancel, or Enter to continue erasing '$hd'"
	# Set security password: xxxx
	sudo hdparm --user-master u --security-set-pass xxxx "$hd"
	hdpi=$(sudo hdparm -I "$hd")
	local enabled=$(grep enabled <<<"$hdpi")
	[[ ! $enabled = enabled ]] && echo "Setting security password failed" && return 7
	local enh=$(grep 'supported: enhanced erase' <<<"$hdpi")
	[[ $enh ]] &&
		local cmd="time sudo hdparm --user-master u --security-erase-enhanced xxxx $hd" ||
		local cmd="time sudo hdparm --user-master u --security-erase xxxx $hd"
	# ATA Secure (Enhanced?) Erase
	echo "This might take a while..."
	$cmd
	# Check security password reset
	local reset=$(sudo hdparm -I "$hd" |grep enabled)
	[[ $reset = enabled ]] && echo "Reset of security password failed" && return 8
	echo "Drive '$hd' should be completely erased now"
}

alias ach='dpkg --get-selections | egrep hold$' # check holds
alias python2='PYTHONPATH=/usr/lib/python2.7/dist-packages; python2.7'
alias python3='PYTHONPATH=/usr/lib/python3/dist-packages; python3'
#alias lesspipe='file “$1” | grep -q text && export LESSOPEN="| command c --paging always --plain "$1"'
alias mpr='abduco -n mpr mate-panel --replace'
alias glr='gsettings list-recursively'
alias lockscreen='DISPLAY=:0.0 xdotool key Ctrl+alt+l'
alias panellock='gsettings set org.mate.panel locked-down true'
alias panelunlock='gsettings set org.mate.panel locked-down false'
alias pc='/usr/share/vim/vim74/macros/less.sh'
alias buildfontcache='fc-cache -f -v'
alias resetwl='sudo rmmod rtl8192ce rtl_pci rtl8192c_common rtlwifi mac80211 cfg80211; sleep 1; sudo modprobe rtl8192ce'
alias csv="csvtool -t ';' -u ';'"
alias fdisk4k='fdisk -H 224 -S 56'
alias filedefrag='shake --bigsize=0 --old=0 -C 0 '
alias tt='echo "$(TZ=Asia/Bangkok LC_TIME="th_TH.UTF-8" date +"%T วัน%A วันที่ %d %B พ.ศ.") $(($(date +%Y)+543))"'
alias vlcs='vlc -R -f --no-qt-fs-controller --mouse-hide-timeout 1 --aspect-ratio 16:9'
alias vlcp='vlc -R -f --video-on-top --no-video-title-show --no-qt-fs-controller --mouse-hide-timeout 1 --aspect-ratio 16:9'
alias lb='lsblk -o NAME,TYPE,FSTYPE,LABEL,SIZE,SCHED,FSUSE%,MOUNTPOINT -x START --tree' # lsblk recent enough for START
alias is='bc -l <<<'
alias m="mount |sed 's/ on / /g' |sed 's/ type / /g' |column -t"
alias be='(head -5; echo; tail -5) <'  ## requires a file to 'analyze'
alias ripvcd='vcdxrip -i /dev/sr0 -v -p -t 0'
alias dd='dcfldd statusinterval=2048'
alias it='sudo iftop -BP -i' # specify a network interface
alias b='pv -s' ## for use in a pipe: dd if=a|b 200M|dd of=b
alias cp='cp -i'
alias alsa='alsamixer; sudo alsactl store && echo "settings saved"'
alias say="DISPLAY=:0.0  notify-send"
alias qiso='qemu -no-kvm -cdrom'
alias makejpg='gs -sDEVICE=jpeg -dNOPAUSE -dBATCH -dSAFER -r600x600 -sOutputFile=p%03d.jpg'
alias makepdf='gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -r600x600 -sOutputFile=p%03d.jpg'
alias resizepdf='gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=resized.pdf'
alias shrinkpdf='gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=shrunk.pdf'
alias sdn='shutdown -t3 -H now'
alias killpp='killall -9 -u pp'
alias chpp='chown pp:pp -R'
alias telco='whois -h whois.telcodata.us'
alias sc='scp -P 5691 -p -r -o User=PeterPasschier1965'
alias scb='scp -P 21865 -p -r -o User=PeterPasschier1965'
#alias s='screen -D -R'
alias s='su pp -c "cd; tmux attach -t pp || tmux new -n pp"'
alias s='tmux a || tmux'
alias tmuxclean='for u in $(echo $(tmux ls |grep -v ^pp: |grep -v "(group 0) (attached)$" |sed "s/:.*//g")); do tmux kill-ses -t $u; done'
alias e='nano'
alias ee='dte'
alias eth='luit -encoding tis-620 ne'  ## Edit with tis-620/windows-874 encoding
alias E='ne'
alias w='w3m https://google.com'
alias f='find .|egrep --color=auto --devices=skip'
alias ft='find . -type f -print0|xargs -0 egrep'
alias h='hexdump -C'
alias l='command l -a'
#alias ll='ls -AFl --time-style=long-iso --color=auto'
alias ll='command l -aBgHl --time-style=long-iso'
alias llt='command l -aBgHls modified --time-style=long-iso'
alias lt='command l -aBgHls modified --time-style=long-iso'
alias lls='command l -aBgHls size --time-style=long-iso'
alias sr='sudo -i'
alias g='egrep -s --color=auto --devices=skip -I'
alias p='ps wwaux -H'
alias pg='ps faux|egrep --color=auto --devices=skip -I'
alias t='htop'
alias ap='apt-cache policy'
alias ad='apt-cache showpkg'
alias dra='sudo dpkg-reconfigure -a'
alias aar='sudo apt-get --purge autoremove'
alias adr='apt-cache rdepends'
alias afi='sudo apt-get -f install'
alias aup='sudo apt-get update'
alias adu='sudo apt-get dist-upgrade'
alias au='sudo apt-get update; sudo apt-get dist-upgrade'
alias ai='sudo apt-get install'
alias ain='sudo apt-get --no-install-recommends install'
alias ar='sudo apt-get remove'
alias air='sudo apt-get --reinstall install'
alias ais='aptitude -y -s install'
alias apr='sudo apt-get purge'
alias alg='dpkg -l|grep' ## list installed packages and filter
alias af='dpkg -S' ## file: which package?
alias alf='dpkg -L' ## package: which files?
alias ak='sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys'
alias apurge='dpkg -l|gr ^rc|cut -d" " -f3|xargs sudo dpkg -P'
alias d='dfc -d -T -b -t-tmpfs,devtmpfs -f; swapon --show=NAME,TYPE,SIZE,USED,PRIO,UUID'
alias da='df -ahT'
alias rs='rsync -vrptzlOuP --partial-dir=.rsync-partial --exclude="*/.~*" -e "ssh"'
alias rb='rsync -vrptzlPO --delete -e "ssh"'
alias cpf="rsync -ahW --inplace --no-compress --info=progress2"
alias cpr="rsync -ah --inplace --no-whole-file --no-compress --info=progress2"
alias qip='wget -q -O - "http://ip-api.com/csv/"'
alias ffx='/usr/lib/firefox/firefox'
alias lsdm='ls -AFl /dev/disk/by-id |gr dm-name |sed "s@.*dm-name-\([^ ]*\) -> \.\./\.\./\(.*\)@\2 \1@" |sort'
alias reset='\reset;  tmux clear-history'
alias memes='wget -O - -q reddit.com/r/memes.json | jq ".data.children[] |.data.url" | grep -v "/\"$" |xargs feh -xZ.'
alias tf=twofat
alias sun='sunclock -map -dottedlines -twilight -meridianmode 3 -tropics -decimal'
alias clk='tty-clock -sSbcC6'
alias ffpw='PYTHONPATH=/usr/lib/python3/dist-packages ffpw'
alias flush='sudo systemd-resolve --flush-caches'
alias lf="find . -type f -printf '%T+ %p\n' |sort -r |less -RMgx2"
alias clip="xclip -selection clipboard"
alias dt="dig +short @dns.toys"
alias vid='mpv --vo=tct' # Showing video on terminal
alias ffp='ffprobe -hide_banner'
alias ffm='ffmpeg -hide_banner'
alias recaudio='ffmpeg -hide_banner -f pulse -i $(pactl list sinks |grep $(pactl get-default-sink).monitor |cut -d: -f2)'
alias gor='goreleaser release --clean'
alias srm='command srm -dlv'
alias termcolors='c=(Default White Black DarkGray Red LightRed  Green LightGreen Brown Yellow Blue LightBlue Purple LightPurple Cyan LightCyan LightGray BoldWhite) i=0; echo "   fg:   bg:  40m   41m   42m   43m   44m   45m   46m   47m"; for f in "   0m" " 1;0m" "  30m" "1;30m" "  31m" "1;31m" "  32m" "1;32m" "  33m" "1;33m" "  34m" "1;34m" "  35m" "1;35m" "  36m" "1;36m" "  37m" "1;37m"; do g=${f// }; echo -en " $f \e[$g  #  "; for b in 40m 41m 42m 43m 44m 45m 46m 47m; do echo -en "$EINS \e[$g\e[$b  #  \e[0m"; done; echo "  ${c[i++]}"; done'

addpath ~/bin $GOBIN $GOROOT/bin ~/.luav/bin ~/.nimble/bin /usr/lib/dart/bin ~/.cargo/bin /opt/flutter/bin ~/.cabal/bin ~/.modular/pkg/packages.modular.com_mojo/bin ~/.cargo/bin /opt/cosmo/bin /opt/cosmos/bin
