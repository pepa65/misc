#!/usr/bin/env python3
# Find repeating decimals in integer division

import sys

def repdec(numerator, denominator):
	head = str(numerator // denominator)
	seen = {}
	decimals = ""
	p1,p2,p3 = 0,0,0
	if head != "0":
		p1 = len(head)
	print(f"{numerator} / {denominator} = {head}", end="")
	remainder = numerator % denominator
	position = 0
	while remainder != 0:
		if remainder in seen:
			p2 = seen[remainder]
			#p3 = len(decimals) - p2
			p3 = position - p2
			print(f".{decimals[:p2]}[{decimals[p2:]}]  ({p1},{p2},{p3})")
			return p1,p2,p3

		seen[remainder] = position
		decimals += str(remainder * 10 // denominator)
		remainder = remainder * 10 % denominator
		position += 1

	if decimals != "":
		p2 = len(decimals)
		print(f".{decimals}", end="")
	print(f"  ({p1},{p2},0)")
	return p1,p2,0

if len(sys.argv) > 2:
	repdec(int(sys.argv[1]),int(sys.argv[2]))
	sys.exit(0)

repdec(3,1)
repdec(0,4)
repdec(1,3)
repdec(1,4)
repdec(1,6)
repdec(22,7)
repdec(13,28)
repdec(7001,14)
#repdec(23929,5783)
#repdec(71788,5783)
#repdec(100003,100019)
#repdec(999983,100003)
#repdec(100003,999983)
