# author: yifei.wan
# Apply mixcr to analyze TCR/IG data based on random fragmented data (like RNA-Seq, Exome-Seq, etc).

set -e

input=$1 ## the complete path of the folder of input fastq file
output=$2 ## result

check_folder(){
    if [[ -d ${output}/${prefix} ]]
    then
        echo ====================================
        echo ------------------------------------
        echo Output folder: $prefix present!
        echo ------------------------------------
    else
        echo ------------------------------------
        echo Make folder: $prefix
        mkdir ${output}/${prefix}
        echo ------------------------------------
    fi
}


for fq in ${input}/*R1*.fastq.gz
do
    file=$(basename $fq)
    name=${file%%_R1_001.fastq.gz}
    prefix=${name%%_L001}
    fq2=${input}/${name}_R2_001.fastq.gz
    check_folder
done 

for fq in ${input}/*R1*.fastq.gz
do
    file=$(basename $fq)
    name=${file%%_R1_001.fastq.gz}
    prefix=${name%%_L001}
    fq2=${input}/${name}_R2_001.fastq.gz
    echo ====================================
    echo ====================================
    echo Input FASTQ files:
    echo $fq
    echo $fq2
    cd ${output}/${prefix}
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    /home/yifei.wan/.linuxbrew/bin/mixcr analyze shotgun \
            --species hsa \
            --starting-material dna \
            $fq $fq2 $prefix
done

