options(java.parameters = "-Xmx8192m")
suppressMessages(library(esATAC))

source_way <- "/data/MiSeqOutput/0-RUO_Service/0-RAWDATA/1-Fastq/18177-01-enough/Finished/"
s_time_total <- proc.time()

###############################################################################################
# 1. Group 1: H20 Sal
s_time <- proc.time()

#options(atacConf=setConfigure("threads",14))
# call pipeline
# all human motif in JASPAR will be processed
conclusion <- 
	atacRepsPipe(
# MODIFY: Change these paths to your own case files!
# e.g. fastqInput1 = "your/own/data/path.fastq"
# MODIFY: Change these paths to your own control files!

## Group: H2O Sal; Group: sample A

		fastqInput1 = list(file.path(source_way, "18177XD-01-01_S122_L007_R1_001.fastq.gz"), 
						   file.path(source_way, "18177XD-01-02_S123_L007_R1_001.fastq.gz"), 
						   file.path(source_way, "18177XD-01-03_S124_L007_R1_001.fastq.gz"), 
						   file.path(source_way, "18177XD-01-04_S125_L007_R1_001.fastq.gz"), 
						   file.path(source_way, "18177XD-01-05_S0_L001_R1_001.fastq.gz")),
		fastqInput2 = list(file.path(source_way, "18177XD-01-01_S122_L007_R2_001.fastq.gz"),
						   file.path(source_way, "18177XD-01-02_S123_L007_R2_001.fastq.gz"),
						   file.path(source_way, "18177XD-01-03_S124_L007_R2_001.fastq.gz"),
						   file.path(source_way, "18177XD-01-04_S125_L007_R2_001.fastq.gz"),
						   file.path(source_way, "18177XD-01-05_S0_L001_R2_001.fastq.gz")),

		refdir <- "/data/TG/RUO_Yifei/esATAC_pipeline/refdir",
		tmpdir = "/data/TG/RUO_Yifei/esATAC_pipeline/intermediate_results", 
		threads = 15,
# MODIFY: Set the genome for your data
		genome = "mm10")

proc.time() - s_time

###############################################################################################
