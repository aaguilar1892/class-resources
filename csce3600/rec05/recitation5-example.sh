#! /bin/bash

test()
{
	arr=("$@")

	echo "TEST:"
	sum=0

	arr[1]=100
	for x in "${arr[@]}"
	do
		echo "x = $x"
		let sum=$sum+$x
	done

	let result=$sum/4
	return $result
}

grades=(90 76 80 98)

test "${grades[@]}"

average=$?

echo "MAIN:"
for (( i=0 ; $i<${#grades[*]}; i=$i+1 ))
do
	echo "grades[$i] = ${grades[$i]}"
done

echo "TEST AVG  = $average"
