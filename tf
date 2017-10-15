#!/bin/bash
set +xv
# tf - Transfer files via transfer.sh
# Features:
# - For upload (files and directories) and download (https:// links)
# - En/decryption option (gpg)
# - Gives a single link for multiple files or directories (tar/zip)
# - Display QR code option for links (qrencode)
# Required: curl
# Optional: gpg tar qrencode

Help(){
	cat <<-EOH
	 $SELF - Transfer files via transfer.sh
	 Usage: $SELF [-q|--qr] [-z|--zip] [-c|--crypt] [-h|--help | <link> | <path>...]
	   -q|--qr:     Also give QR code for resulting link
	   -z|--zip:    Use zip instead of tar for the uploaded archive
	   -c|--crypt:  Use gpg for en/decryption of file/archive to be up/downloaded
	   -h|--help:   Display this help text
	 <link> is a transfer.sh link starting with https://
	 <path> is the path to a file or directory; there can be multiple
	EOH
	exit 0
}

Main(){
	local qr=0 zip=0 crypt=0 links files nfiles=0
	while (($#))
	do
		case $1 in
		-q|--qr) qr=1 ;;
		-z|--zip) zip=1 ;;
		-c|--crypt) crypt=1 ;;
		-h|--help) Help ;;
		*) if [[ ${1:0:8} = "https://" ]]
			then
				links+=$1$'\n'
			else
				! files+=$(find -H "$1")$'\n' && echo "ERROR: $1 not found" && Help
				((nfiles++))
				[[ -d $$1 ]] && ((nfiles++))
			fi
		esac
		shift
	done
	[[ $links || $files ]] || Help

	# Process links
	local dl=$(mktemp -t $SELF-XXXX.dl) dc=$(mktemp -t $SELF-XXXX.dc)
	while read -r
	do
		[[ $REPLY ]] || continue
echo "-> $REPLY"; continue
		curl -s "$REPLY" >"$dl"
		((crypt)) && gpg --passphrase-fd 0 -o "$dc" "$dl" || mv "$dl" "$dc"
		local sig=$(hexdump -n 2 -e '/1 "%02x"' "$dc")
		if [[ $sig = "504b" ]]
		then
echo unzip
#			unzip "$dc"
		elif [[ $sig = "if8b" ]]
		then
echo tar
#			tar xf "$dc"
		else
echo "Not sure: $sig $dc"
		fi
	done <<<"$links"

	# Process files
	while read -r
	do
		[[ $REPLY ]] || continue
echo "-> $REPLY"; continue
		local f=$(basename "$REPLY" |sed -e 's/[^a-zA-Z0-9._-]/-/g')
		((!crypt)) && q=$(curl -X PUT -T \"-\" \"https://transfer.sh/$f\") ||
			q=$(gpg -ac -o- |curl -X PUT -T \"-\" \"https://transfer.sh/$f\")
		echo -e "$REPLY:\n\t$q\n"
		((qr)) && qrencode --t ANSIUTF8 -l H -o- "$q"
		((crypt)) && gpg --passphrase-fd 0 -o "$dc" "$dl" || mv "$dl" "$dc"
	done <<<"$files"

	rm -- "$dl" "$dc"
}

SELF=${0##*/}
Main "$@"
exit 0
