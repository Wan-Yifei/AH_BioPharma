#!/usr/bin/env Rscript
suppressMessages(library("optparse"))

optionList <- list(make_option(c("-i", "--input"), type="character", default=NULL, 
    help="folder of input Fastq files."),
    make_option(c("-m","--meta"),type="character",default=NULL,help="metadata file [the format of the file is shown in \"met_demo.txt\"]"),
    make_option(c("-o","--output"),type="character",default=NULL,help="output folder"),
    make_option(c("-r","--ref"),type="character",default=NULL,help="type of reference genome [e.g. hg19 or mm10]"))

opt_parser <- OptionParser(option_list=optionList)
opt <- parse_args(opt_parser)

if (is.null(opt$input)||is.null(opt$dir)||is.null(opt$meta)||is.null(opt$ref)){
  print_help(opt_parser)
  }

# Prepare the FASTQ for each sample

meta_table <- read.csv(opt$meta, sep="/t", header=T, stringAsFactor=F)
samples <- meta_table$Sample

get_fastq <- function(sample){
    fastqs = list.files(pattern=sample, recursive=F)
    return(fastqs)
    }

samples_fastq <- data.frame(sapply(samples, get_fastq))

# Prepare folder for group and samples

groups = unique(meta_table$condition)
output = opt$output
make_folder <- function(name, path){
   folder = paste(path, name, sep="/")
   dir.create(folder)
   }

sapply(group, make_folder, output) ## create folder for each group
