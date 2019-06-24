## Extract sam files from esATAC result and transformation
set -e

runfolder=$1

if [[ ! -d $1/bams ]]
then
    echo Make bams folder.
    mkdir $1/bams
fi

## Sort sam file and transform to bam file
for f in $1/g*/*.sam
do
    echo $f
    filename="${f%%.*}"
    samtools view -bS $f | samtools sort -@ 70 - ${filename}.sorted
    echo ${filename}.sorted.bam done!
    mv -v ${filename}.sorted.bam $1/bams
done
