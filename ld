#!/usr/bin/env bash

# ld - Display x86_64 architecture level

_="$(grep ^flags /proc/cpuinfo |head -1)" flags=${_##*: }
levels=("lm cmov cx8 fpu fxsr mmx syscall sse2"
	"cx16 lahf popcnt sse4_1 sse4_2 ssse3"
	"avx avx2 bmi1 bmi2 f16c fma abm movbe xsave"
	"avx512f avx512bw avx512cd avx512dq avx512vl")
level=-1
while ((++level<4))
do for f in ${levels[level]}
	do [[ ! $flags = *$f* ]] && break 2
	done
done

((level)) &&
	echo "x86-64-v$level" &&
	exit $level

exit -1
