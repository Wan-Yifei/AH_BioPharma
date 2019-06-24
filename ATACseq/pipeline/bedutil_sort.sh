input=$1 ## input folder
output=$2 ## output folder

for f in $1/*BedUtils.bed
do
    echo Input: $f
    path=$(basename $f)
    filename=${path%%.BedUtils.bed}
    sortBed -i $f > $output$filename.sorted.bed
    echo Output: $output$filename.sorted.bed
done
