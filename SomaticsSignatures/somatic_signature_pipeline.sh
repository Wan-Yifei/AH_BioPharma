# author: Yifei.wan

# Find specified samples and split the vcf file

set -e
input_folder=$1
output_folder=$2

for f in $input_folder/18139XD-07-*_annotation2_mutect_snp_and_indel.Somatic.hc_eff_clinvar_dbnsfp.vcf
do
    echo ----------------------------------------------------
    echo $f
    python3 /home/yifei.wan/AH_BioPharma/SomaticsSignatures/vcf_spliter.py $f $output_folder
done

echo ====================================================
    
for f in $(ls $output_folder | egrep ^18139XD-07-0[1-9].vcf)
do
    echo Plot signature for $f
    echo ----------------------------------------------------
    if [[ ! -d ${output_folder}/images ]]
    then
        mkdir ${output_folder}/images
    fi
    Rscript /home/yifei.wan/AH_BioPharma/SomaticsSignatures/somatic_signature_painter.R ${output_folder}/$f ${output_folder}
done
