options(java.parameters = "-Xmx8192m")

suppressMessages(library(esATAC))

source_way <- "/data/MiSeqOutput/0-RUO_Service/0-RAWDATA/1-Fastq/18177-01-enough/Finished/"

###############################################################################################


# 5. Analyze sample without replicates

## 5.1 H2O Sal B1	18177XD-01-06

conclusion <- 
	atacPipe(
# MODIFY: Change these paths to your own case files!
# e.g. fastqInput1 = "your/own/data/path.fastq"
		fastqInput1 = file.path(source_way, "18177XD-01-06_S0_L001_R1_001.fastq.gz"),
		fastqInput2 = file.path(source_way, "18177XD-01-06_S0_L001_R2_001.fastq.gz"),

		refdir <- "/data/TG/RUO_Yifei/esATAC_pipeline/refdir",
		tmpdir = "/data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/g1_B", 
		threads = 15,
# MODIFY: Set the genome for your data
		genome = "mm10")

###############################################################################################

## 5.2 Abx Sal B1	18177XD-01-12

conclusion <- 
	atacPipe(
# MODIFY: Change these paths to your own case files!
# e.g. fastqInput1 = "your/own/data/path.fastq"
		fastqInput1 = file.path(source_way, "18177XD-01-12_S0_L001_R1_001.fastq.gz") ,
		fastqInput2 = file.path(source_way, "18177XD-01-12_S0_L001_R2_001.fastq.gz"),

		refdir <- "/data/TG/RUO_Yifei/esATAC_pipeline/refdir",
		tmpdir = "/data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/g2_B", 
		threads = 15,
# MODIFY: Set the genome for your data
		genome = "mm10")

###############################################################################################

## 5.3 H2O Mor B1	18177XD-01-18 

conclusion <- 
	atacPipe(
# MODIFY: Change these paths to your own case files!
# e.g. fastqInput1 = "your/own/data/path.fastq"
		fastqInput1 = file.path(source_way, "18177XD-01-18_S0_L001_R1_001.fastq.gz"),
		fastqInput2 = file.path(source_way, "18177XD-01-18_S0_L001_R2_001.fastq.gz"),

		refdir <- "/data/TG/RUO_Yifei/esATAC_pipeline/refdir",
		tmpdir = "/data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/g3_B", 
		threads = 15,
# MODIFY: Set the genome for your data
		genome = "mm10")

###############################################################################################

## 5.4 Abx Mor B1	18177XD-01-24

conclusion <- 
	atacPipe(
# MODIFY: Change these paths to your own case files!
# e.g. fastqInput1 = "your/own/data/path.fastq"
		fastqInput1 = file.path(source_way, "18177XD-01-24_S0_L001_R1_001.fastq.gz" ),
		fastqInput2 = file.path(source_way, "18177XD-01-24_S0_L001_R2_001.fastq.gz"),

		refdir <- "/data/TG/RUO_Yifei/esATAC_pipeline/refdir",
		tmpdir = "/data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results/g4_B", 
		threads = 15,
# MODIFY: Set the genome for your data
		genome = "mm10")


