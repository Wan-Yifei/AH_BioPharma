# author: yifei.wan
# Apply mixcr to analyze TCR/IG data based on WES (PE).

set -e

input=$1 ## the complete path of the folder of input fastq file
output=$2 ## result
ref=$3 ## reference genome type

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
    # alignment
    mixcr align -s $ref -OvParameters.geneFeatureToAlign=VGeneWithP -OallowPartialAlignments=true $fq $fq2 ${prefix}_alignments.vdjca | tee align_log.txt
    # contig assembly twice
    mixcr assemblePartial ${prefix}_alignments.vdjca ${prefix}_alignments_rescued_1.vdjca | tee contig_assemble_log1.txt
    mixcr assemblePartial ${prefix}_alignments_rescued_1.vdjca ${prefix}_alignments_rescued_2.vdjca | tee contig_assemble_log2.txt
    # extension
    mixcr extend ${prefix}_alignments_rescued_2.vdjca ${prefix}_alignments_rescued_2_extended.vdjca | tee extend_log.txt
    # assemble clonotypes
    mixcr assemble ${prefix}_alignments_rescued_2_extended.vdjca clones.clns | tee assemble_log.txt
    # export:
    ## export total result
    mixcr exportClones clones.clns clones.txt
    ## export specific immunological chains
    mixcr exportClones -c TRA clones.clns clones.TRA.txt
    mixcr exportClones -c TRB clones.clns clones.TRB.txt
    mixcr exportClones -c TRD clones.clns clones.TRD.txt
    mixcr exportClones -c TRG clones.clns clones.TRG.txt
    mixcr exportClones -c IGH clones.clns clones.IGH.txt
    mixcr exportClones -c IGK clones.clns clones.IGK.txt
    mixcr exportClones -c IGL clones.clns clones.IGL.txt

done

