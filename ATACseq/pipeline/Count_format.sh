set -e

input=$1
output=$2

for f in $input/*.txt
do
    path=$(basename $f)
    filename="${path%%.*}"
    echo Input: $f
    echo Output: ${filename}_DA.txt
    awk -F '\t' -v OFS='\t' 'NR > 2 {print $1, $7}' $f > $output/${filename}_DA.txt
done

#sed -i '1s/.*/GeneID\tCounts/' $output/*_DA.txt
