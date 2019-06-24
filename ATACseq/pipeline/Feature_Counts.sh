set -e

bams=$1 ## folder of sorted bam files
saf_and_output=$2 ## output folder includes saf file

for f in $bams/*.bam
do
    filename=$(basename $f)
    outname=${filename%%.sorted*}
    echo ==============================================
    echo input: $filename
    echo output: $saf_and_output/${outname}.count.txt
    echo
    /home/yifei.wan/Tools/subread-1.6.3-source/bin/featureCounts -F SAF -T 64 -P -p -d 0 -D 100 -a $saf_and_output/*.saf -o $saf_and_output/${filename}.count.txt $f
done
