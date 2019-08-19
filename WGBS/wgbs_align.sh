# author: Yifei Wan
# Algin WGBS samples to reference

set -e

input=$1 ## input fastq file: fq files must in the work directory
ref=$2 ## folder of reference genome
output=$3 ## output folder for BAM files

for f in ${input}/*R1_001.fastq.gz
do
    name=$(basename $f)
    prefix=${name%%_R*}
    mate1=${prefix}_R1_001.fastq.gz
    mate2=${prefix}_R2_001.fastq.gz
    echo ==========================================
    echo Align $prefix to reference
    echo ------------------------------------------
    echo Input:
    echo $mate1
    echo $mate2 
    echo ------------------------------------------
    echo
    echo 
    cd $output
    perl /home/yifei.wan/Tools/Bismark-0.22.1/bismark --parallel 40  --genome $ref -1 $mate1 -2 $mate2 ## alignment
    echo ------------------------------------------
    echo Remove duplicates from BAM files
    echo Filter ${prefix}_R1_001_bismark_bt2_pe.bam
    perl /home/yifei.wan/Tools/Bismark-0.22.1/deduplicate_bismark --bam ${prefix}_R1_001_bismark_bt2_pe.bam ## Remove duplicates
    echo ------------------------------------------
    echo Extract methylation of specified region
    perl /home/yifei.wan/Tools/Bismark-0.22.1/bismark_methylation_extractor --parallel 40 --gzip --bedGraph ${prefix}_R1_001_bismark_bt2_pe.deduplicated.bam ##Extract context-dependent (CpG/CHG/CHH) methylation 
    echo ------------------------------------------
    echo Generate HTML report
    perl /home/yifei.wan/Tools/Bismark-0.22.1/bismark2report ##Bismark paired-end report  
    echo ------------------------------------------
    echo Generate summary report
    perl /home/yifei.wan/Tools/Bismark-0.22.1/bismark2summary ##Bismark Summary Report  
    echo ------------------------------------------
    echo Sort BAM file
    echo Scrt ${prefix}_R1_001_bismark_bt2_pe.deduplicated.bam
    samtools sort -@ 80 ${prefix}_R1_001_bismark_bt2_pe.deduplicated.bam -o ${prefix}_R1_001_bismark_bt2_pe.deduplicated.sorted.bam
    echo ------------------------------------------
    echo Index BAM file
    echo Index ${prefix}_R1_001_bismark_bt2_pe.deduplicated.sorted.bam
    samtools index ${prefix}_R1_001_bismark_bt2_pe.deduplicated.sorted.bam
done
