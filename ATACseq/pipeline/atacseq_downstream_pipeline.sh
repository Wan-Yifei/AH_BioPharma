# Process ATAC-seq data based on esATAC result
# author: Yifei Wan

set -e

input=$1 ## the esATAC run folder
meta=$2

if [[ ! -d $input/bam_files ]]
then
    echo Make a directory for SAM/BAM files!
    mkdir $input/bam_files 
else
    echo The bam_files folder exists.
fi

if [[ ! -d $input/util_beds ]]
then
    echo Make a directory for util_bed files!
    mkdir $input/util_beds
else
    echo The util_bel folder exists.
fi

if [[ ! -d $input/peakcalling ]]
then
    echo Make directory for peakcalling!
    mkdir $input/peakcalling
else
    echo The peakcalling folder exists.
fi

if [[ ! -d $input/count ]]
then
    echo Make directory for count!
    mkdir $input/count
else
    echo The count folder exists.
fi

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo ">>>>>>>>>>>>> Downstream analysis <<<<<<<<<<<<<"
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo
echo ">>>>>=========================================="
echo Covert SAM to BAM 
for group in $(awk -F"\t" 'NR>1{print $3}' $meta | uniq)
do
    echo -----------------------------------------------
    echo Sample group: $group
    for sample in $(ls $input/$group)
    do
        echo Sample ID: $sample
        echo -----------------------------------------------
        run_folder=($input/$group/$sample/esATAC_pipeline/intermediate_results) ## the intermediate folder
        cp $run_folder/*.BedUtils.bed $input/util_beds
        file=$(basename $(ls $run_folder/*.sam))
        filename=${file%%.*}
        echo samtools sort start
        echo ${input}/bam_files/${filename}.sorted.bam
        exit
        samtools view -bSh $run_folder/*.sam | samtools sort -@ 60 -o ${input}/bam_files/${filename}.sorted.bam ## covert sam to bam
        echo samtools sort done
        echo -----------------------------------------------
    done
done

echo ">>>>>=========================================="
echo Merge bed files

cat $input/util_beds/*.BedUtils.bed > $input/util_beds/union.bed
sortBed -i $input/util_beds/union.bed > $input/util_beds/union_sorted.bed

echo ">>>>>=========================================="
echo Call peaks based on union BED file

/home/yifei.wan/Tools/fseq/bin/fseq -f 0 -o $input/peakcalling -of bed ${input}/util_beds/union_sorted.bed 
cat $input/peakcalling/chr*.bed > $input/peakcalling/union_peaks.bed
sortBed -i $input/peakcalling/union_peaks.bed > $input/peakcalling/union_peaks_sorted.bed 

echo ">>>>>=========================================="
echo Covert BED to SAF

awk -v OFS="\t" 'BEGIN {print "Gene", "Chr", "Start", "End", "Strand"} {print "Peak_"NR, $1, $2+1, $3, "."}' $input/peakcalling/union_peaks_sorted.bed > $input/peakcalling/union.saf

echo ">>>>>=========================================="
echo Count reads on peaks

bash /home/AH_Biopharma/ATACseq/pipeline/Feature_Count.sh $input/$bam_files $input/$peakcalling
bash /home/AH_Biopharma/ATACseq/pipeline/Count_format.sh $input/$peakcalling $input/count 

echo ">>>>>=========================================="
echo DA analysis

##Rscript /home/yifei.wan/AH_BioPharma/ATACseq/pipeline/DE-analysis.R -i $input/count -d $input/DA_output 
