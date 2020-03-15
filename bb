#!/bin/bash
set +o xtrace +o verbose

# bb - Wrapperscript around borgbackup
# Required: borg coreutils(date tee cat)
# Environment variables (optional): BORG_REPO BORG_PASSPHRASE

borgrepo='ssh://hosthatch.passchier.net/data/borg'
basedir='/data'
datadirs='Dovecot Peter Kelly MyDocuments'  # dirs in $basedir
log="$HOME/borg.log"
passwordfile="$HOME/borg.pw"
mnt="$HOME/Public"
mustmount=0

Help(){
	cat <<-EOH
		 $self - Wrapperscript around borgbackup
		 USAGE: $self [ init|check|help|unlock|prune | list [<prefix>] |
		       info|delete <name> | backup [<dir>] | rename <name> <newname> |
		       mount [<name>] | unmount ]
			 init:  init repo (set BORG_REPO variable in $self or on commandline)
			 check:  check repo
			 help:  output this help text (also without any argument)
			 unlock:  unlock the repo when left locked
			 prune:  prune the backups
			 list [<prefix>]:  list backups in repo [starting with <prefix>]
			 info <name>:  list details of [backup <name> in] repo
			 delete <name>:  delete [backup <name> from] repo
			 backup [Dovecot|Peter|Kelly|MyDocuments]:  backup $basedir[/<dir>]
			 rename <name> <newname>:  rename backup <name> to <newname>
			 mount [<name>]:  mount [backup <name> from] repo on $(basename "$mnt")
			 unmount:  unmount from $(basename "$mnt")
		 BORG_REPO=$BORG_REPO
	EOH
}

Error(){ # $1:message  O:error
	echo -e "\nERROR: $1"
	error=1
}

Umount(){ # IO:mounted  I:mnt
	((mounted)) && mounted=0 && fusermount -u "$mnt"
}

Backup(){ # $1:directory in $basedir
	# New incremental backup
	out+="$(echo 'y' |borg create -v --show-rc --stats -C lz4 "::$1-$(date +%Y%m%d)" "$basedir/$1" 2>&1)\n"
}

self=$(basename "$0")
: ${BORG_REPO:=$borgrepo}
BORG_PASSPHRASE=$(<"$passwordfile")
error=0
grep -q "^borgfs $mnt fuse " /proc/mounts && wasmounted=1 || wasmounted=0
mounted=$wasmounted

case $1 in
	init) Umount
		if [[ $2 ]] && [[ ! $2 = $BORG_REPO ]]
		then
			borg init -e repokey -v --show-rc "$2"
			echo "Modify BORG_REPO if you want to use this script for this repo!"
			echo "Or, prefix each run with BORG_REPO=$2 $0 ..."
		else
			borg init -e repokey -v --show-rc "$BORG_REPO"
		fi ;;
	unlock) Umount
		borg break-lock -v --show-rc :: ;;
	check) Umount
		borg check -v --show-rc ;;
	prune) Umount
		for n in $datadirs
		do
			borg prune -d 6 -w 4 -m 11 -v --show-rc -P "$n" :: |
					sed '/^borg.output.progress/d'
		done ;;
	help|'') Help ;;
	list) [[ $2 ]] && borg list --short --debug --show-rc -P "$2" ||
			borg list -v --show-rc --short :: ;;
	info) [[ $2 ]] && borg info -v --show-rc "::$2" ||
			Error "'info' needs the name of a backup as 2nd argument!" ;;
	delete) if [[ $2 ]]
		then
			Umount
			borg delete -v --show-rc "::$2"
		else
			Error "'delete' needs the name of a backup as 2nd argument!"
		fi ;;
	backup) Umount
		if [[ $3 ]]
		then
			out+="$(borg create -v --show-rc --stats -C lz4 "::$2" "$3" 2>&1)\n"
		elif [[ $2 ]]
		then
			grep " $2 " <<<" $datadirs " && Backup "$2" ||
				Error "wrong 2nd argument after 'backup': $2"
		else
			for n in $datadirs
			do
				Backup "$n"
			done
		fi ;;
	rename) if [[ $3 ]]
		then
			borg info "::$2" &>/dev/null && Umount &&
				borg rename -v --show-rc "::$2" "$3" ||
				Error "no existing backup name: $2"
		else
			Error "'rename' needs 2 arguments"
		fi ;;
	extract) if [[ $3 ]]
		then
			borg info "::$2" &>/dev/null || Error "no existing backup name: $2"
			borg extract -v --show-rc "::$2" "$3" || Error "no existing file: $3"
		else
			Error "'extract' needs 2 arguments"
		fi ;;
	mount) if ((mounted))
		then
			Error "borg archive already mounted on $mnt"
		else
			mounted=1
			[[ $2 ]] && borg mount -v "::$2" "$mnt" || borg mount -v :: "$mnt"
		fi ;;
	unmount|umount) Umount ;;
	*) Error "wrong 1st argument to $self: $1" ;;
esac

((error)) && echo -e "For more help, type:\n $0"
((mustmount)) || ((wasmounted)) && ! ((mounted)) && borg mount :: "$mnt"

if [[ $out ]]
then {
	echo "================================================================================"
	echo "$(date +%Y-%m-%d_%H:%M:%S) LOG: $self $@"
	echo -en "$out"; } |tee -a "$log"
fi

exit 0
