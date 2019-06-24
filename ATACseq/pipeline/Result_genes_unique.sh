#!bin/bash
set -e
# sort and unique the genes from PeakAnno.txt of ATACseq
RESULT_FOLDER=$1 ## Run folder

for file in $RESULT_FOLDER/*RPeakAnno*.txt;
do
	echo Simplfying  $(basename $file)
	NAME=$(basename $file)
	INDEX="$( cut -d '_' -f -1 <<< "$NAME" )"
#	echo ${INDEX}"_02.csv"
	awk -F '\t' '{print $17, $18}' $file | sort -u | tr ' ' '\t'> $1/tmp/${INDEX}"_unique.txt"
	echo ${INDEX}"_unique.txt" done
done

