set -e

mkdir /data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/Group2/rep_concord_merge/Sam_files
cp /data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/Group2/replicate{1,2,3,4,5,6}/*.Bowtie2Mapping.sam /data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/Group2/rep_concord_merge/Sam_files

mkdir /data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/Group3/rep_concord_merge/Sam_files
cp /data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/Group3/replicate{1,2,3,4,5,6}/*.Bowtie2Mapping.sam /data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/Group3/rep_concord_merge/Sam_files

mkdir /data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/Group4/rep_concord_merge/Sam_files
cp /data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/Group4/replicate{1,2,3,4,5,6}/*.Bowtie2Mapping.sam /data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/Group4/rep_concord_merge/Sam_files

for f in /data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/Group2/rep_concord_merge/Sam_files/*.sam; do filename="${f%%.*}"; samtools view -bS $f | samtools sort -@ 4 - ${filename}.sorted.bam; done

for f in /data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/Group3/rep_concord_merge/Sam_files/*.sam; do filename="${f%%.*}"; samtools view -bS $f | samtools sort -@ 4 - ${filename}.sorted.bam; done

for f in /data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/Group4/rep_concord_merge/Sam_files/*.sam; do filename="${f%%.*}"; samtools view -bS $f | samtools sort -@ 4 - ${filename}.sorted.bam; done
