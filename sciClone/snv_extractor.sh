# author: Dr. Cai.Chen
# author: Yifei.wan

# Extract SNV from VCF file

input=$1 ## input folder
output=$2 ## output folder

echo ===============================
echo Format: chr    pos     ref_reads       var_reads   allele_freq
for p in $input/*hc.vcf
do
    file=$(basename $p)
    name=${file%%.vcf}
    echo -------------------------------
    echo Extract content from $name!
    grep -v '#' $p | awk 'BEGIN {OFS="\t"} { print $1,$2,$10}' | awk -F"[\t:,]" 'BEGIN {OFS="\t"} {print $1, $2, $4, $5, $6}' > ${output}/${name}_snv.txt
done

