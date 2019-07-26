# author: Yifei.wan

# Extract CNV from TSV file

input=$1 ## input folder
output=$2 ## output folder

echo ===============================
echo Format: chr   start        stop    segment_mean 
for p in $input/*.tsv
do
    file=$(basename $p)
    name=${file%%.tsv}
    echo -------------------------------
    echo Extract content from $name!
    awk -F"\t" 'BEGIN{OFS="\t"} /chrom/{next}{print $1, $2, $3, 2*(2**$4)}' $p | sed 's/%//g' | sed 's/chr//g' > ${output}/${name}_cnv.txt 
done

