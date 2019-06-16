options(java.parameters = "-Xmx8192m")
suppressMessages(library(esATAC))

source_way <- "/data/MiSeqOutput/0-RUO_Service/0-RAWDATA/1-Fastq/Analysis/19068-01-analysis"

library(esATAC)

SCC9_WT_05 <- atacPipe(
        # MODIFY: Change these paths to your own case files!
        # e.g. fastqInput1 = "your/own/data/path.fastq"
        fastqInput1 = file.path(source_way, "19068XD-01-05_S39_L005_R1_001.fastq.gz"),
        fastqInput2 = file.path(source_way, "19068XD-01-05_S39_L005_R2_001.fastq.gz"),
        # MODIFY: Set the genome for your data
        refdir <- "/data/TG/RUO_Yifei/esATAC_pipeline/refdir",
        tmpdir = "/data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/19068/g5_SCC9_WT", 
        threads = 15,
        genome = "hg19",
)

SCC9_WT_07 <- atacPipe(
        # MODIFY: Change these paths to your own case files!
        # e.g. fastqInput1 = "your/own/data/path.fastq"
        fastqInput1 = file.path(source_way, "19068XD-01-07_S37_L005_R1_001.fastq.gz"),
        fastqInput2 = file.path(source_way, "19068XD-01-07_S37_L005_R2_001.fastq.gz"),
        # MODIFY: Set the genome for your data
        refdir <- "/data/TG/RUO_Yifei/esATAC_pipeline/refdir",
        tmpdir = "/data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/19068/g7_SCC9_WT", 
        threads = 15,
        genome = "hg19",
)

SCC9_CisR_06 <- atacPipe(
        # MODIFY: Change these paths to your own case files!
        # e.g. fastqInput1 = "your/own/data/path.fastq"
        fastqInput1 = file.path(source_way, "19068XD-01-06_S36_L005_R1_001.fastq.gz"),
        fastqInput2 = file.path(source_way, "19068XD-01-06_S36_L005_R2_001.fastq.gz"),
        # MODIFY: Set the genome for your data
        refdir <- "/data/TG/RUO_Yifei/esATAC_pipeline/refdir",
        tmpdir = "/data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/19068/g6_SCC9_CisR", 
        threads = 15,
        genome = "hg19",
)

SCC9_CisR_08 <- atacPipe(
        # MODIFY: Change these paths to your own case files!
        # e.g. fastqInput1 = "your/own/data/path.fastq"
        fastqInput1 = file.path(source_way, "19068XD-01-08_S38_L005_R1_001.fastq.gz"),
        fastqInput2 = file.path(source_way, "19068XD-01-08_S38_L005_R2_001.fastq.gz"),
        # MODIFY: Set the genome for your data
        refdir <- "/data/TG/RUO_Yifei/esATAC_pipeline/refdir",
        tmpdir = "/data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/19068/g8_SCC9_CisR", 
        threads = 15,
        genome = "hg19",
)



###############################################################################################

## Group info:

# SCC9-WT group:

# 1. 19068XD-01-05
# 2. 19068XD-01-07

# SCC9-CisR group:

# 1. 19068XD-01-06
# 2. 19068XD-01-08

###############################################################################################
