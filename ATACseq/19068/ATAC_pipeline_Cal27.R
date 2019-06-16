options(java.parameters = "-Xmx8192m")
suppressMessages(library(esATAC))

source_way <- "/data/MiSeqOutput/0-RUO_Service/0-RAWDATA/1-Fastq/Analysis/19068-01-analysis"

library(esATAC)

Cal127_WT_01 <- atacPipe(
        # MODIFY: Change these paths to your own case files!
        # e.g. fastqInput1 = "your/own/data/path.fastq"
        fastqInput1 = file.path(source_way, "19068XD-01-01_S32_L005_R1_001.fastq.gz"),
        fastqInput2 = file.path(source_way, "19068XD-01-01_S32_L005_R2_001.fastq.gz"),
        # MODIFY: Set the genome for your data
        refdir <- "/data/TG/RUO_Yifei/esATAC_pipeline/refdir",
        tmpdir = "/data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/19068/g1_Cal27_WT", 
        threads = 15,
        genome = "hg19",
)

Cal27_WT_03 <- atacPipe(
        # MODIFY: Change these paths to your own case files!
        # e.g. fastqInput1 = "your/own/data/path.fastq"
        fastqInput1 = file.path(source_way, "19068XD-01-03_S34_L005_R1_001.fastq.gz"),
        fastqInput2 = file.path(source_way, "19068XD-01-03_S34_L005_R2_001.fastq.gz"),
        # MODIFY: Set the genome for your data
        refdir <- "/data/TG/RUO_Yifei/esATAC_pipeline/refdir",
        tmpdir = "/data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/19068/g3_Cal27_WT", 
        threads = 15,
        genome = "hg19",
)

Cal27_CisR_02 <- atacPipe(
        # MODIFY: Change these paths to your own case files!
        # e.g. fastqInput1 = "your/own/data/path.fastq"
        fastqInput1 = file.path(source_way, "19068XD-01-02_S33_L005_R1_001.fastq.gz"),
        fastqInput2 = file.path(source_way, "19068XD-01-02_S33_L005_R2_001.fastq.gz"),
        # MODIFY: Set the genome for your data
        refdir <- "/data/TG/RUO_Yifei/esATAC_pipeline/refdir",
        tmpdir = "/data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/19068/g2_Cal27_CisR", 
        threads = 15,
        genome = "hg19",
)

Cal27_CisR_04 <- atacPipe(
        # MODIFY: Change these paths to your own case files!
        # e.g. fastqInput1 = "your/own/data/path.fastq"
        fastqInput1 = file.path(source_way, "19068XD-01-04_S0_L001_R1_001.fastq.gz"),
        fastqInput2 = file.path(source_way, "19068XD-01-04_S0_L001_R2_001.fastq.gz"),
        # MODIFY: Set the genome for your data
        refdir <- "/data/TG/RUO_Yifei/esATAC_pipeline/refdir",
        tmpdir = "/data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/19068/g4_Cal27_CisR", 
        threads = 15,
        genome = "hg19",
)



###############################################################################################

## Group info:

# Cal27-WT group:

# 1. 19068XD-01-01
# 2. 19068XD-01-03

# Cal27-CisR group:

# 1. 19068XD-01-02
# 2. 19068XD-01-04

###############################################################################################
