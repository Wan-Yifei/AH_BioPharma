## Sort and convert to bams 
input=$1
output=$2

for f in $input/g5*/*.sam 
do 
    path=$(basename $f)
    filename=${path%%.*}
    echo Input: $f
    echo Output: $output/${filename}.sorted
    samtools view -bS $f | samtools sort -@ 60 - $output/${filename}.sorted
done

