#!/usr/bin/env Rscript
options(java.parameters = "-Xmx8192m")
suppressMessages(library("optparse"))

optionList <- list(make_option(c("-i", "--input"), type="character", default=NULL, 
    help="folder of input Fastq files."),
    make_option(c("-m", "--meta"), type="character", default=NULL, help="metadata file [the format of the file is shown in \"meta_demo.txt\"]"),
    make_option(c("-o", "--output"), type="character", default=NULL, help="output folder"),
    make_option(c("-r", "--ref"), type="character", default=NULL, help="the type of reference genome [e.g. hg19 or mm10]"),
    make_option(c("-t", "--threads"), type="integer", default=NULL, help="the number of threads"))

opt_parser <- OptionParser(option_list=optionList)
opt <- parse_args(opt_parser)

if (is.null(opt$input)||is.null(opt$output)||is.null(opt$meta)||is.null(opt$ref)){
  print_help(opt_parser)
  }

input = opt$input ## input folder
thread = opt$threads
ref_type = opt$ref
ref_genome <- "/data/TG/RUO_Yifei/esATAC_pipeline/refdir"
setwd(input)

# Prepare the FASTQ for each sample

meta_table <- read.csv(opt$meta, sep="\t", header=T, stringsAsFactors=F)
samples <- meta_table$Sample

get_fastq <- function(sample){
    fastqs = list.files(pattern=sample, recursive=F)
    return(fastqs)
    }

samples_fastq <- data.frame(sapply(samples, get_fastq))

print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
print(">>>>>>>>>>>  Create folders for each group  >>>>>>>>>>>")
print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
cat("\n")

# Prepare folder for group and samples

groups = unique(meta_table$condition)
output = opt$output
make_folder <- function(name, path){
   folder = paste(path, name, sep="/")
   dir.create(folder, showWarnings = F)
   return(folder)
   }

sapply(groups, make_folder, output) ## create folder for each group

# Run esATAC pipeline for each sample independently 
cat("\n")
suppressMessages(library(esATAC))
for (i in 1:length(samples)){ ## column of FASTQ dataframe has sample order with samples
    group = meta_table$condition[i]
    group_folder = paste(output, group, sep="/")
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
    print(">>>>>>>>>>>        Process each sample        >>>>>>>>>")
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
    sample_folder = make_folder(samples[i], group_folder) ## create the sub-folder for each sample
    #inter_folder = make_folder("internediate_result", sample_folder)
    setwd(sample_folder)
    atacPipe(
        fastqInput1 = file.path(input, samples_fastq[1, which(colnames(samples_fastq) == make.names(samples[i]))]), 
        fastqInput2 = file.path(input, samples_fastq[2, which(colnames(samples_fastq) == make.names(samples[i]))]), 
        refdir = ref_genome, 
        #tmpdir = sample_folder,
        threads = thread,
        genome = ref_type 
        )
    }

    
    
