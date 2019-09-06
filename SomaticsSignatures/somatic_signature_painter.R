# author: Yifei Wan

# Visualize the signature plot of somatic mutation
# Based on VCF file

suppressMessages(library(SomaticSignatures))
suppressMessages(library(VariantAnnotation))
suppressMessages(library("BSgenome.Hsapiens.UCSC.hg19"))

#setwd("/data/TG/RUO_Yifei/somatic_signature")
args <- commandArgs(trailingOnly = TRUE)
fa <- BSgenome.Hsapiens.UCSC.hg19

# Input somatic variant calls
#vcfs <- list.files(path = "/data/MiSeqOutput/0-RUO_Service/0-RAWDATA/1-Fastq/Analysis/18139-07-analysis/analysis/analysis_new", recursive = F, pattern = "18139XD-07-0._annotation2_.*\\.vcf$", full.names = T)
vcf <- args[1]
output_folder <- paste(args[2], "images", sep = "/")
output_folder
setwd(output_folder)
suppressWarnings(vrs <- readVcfAsVRanges(vcf, "hg19"))
#vrs <- sapply(vcf, readVcfAsVRanges, "hg19")

## Remove indels from vcf
indel_filter <- function(vrs){
    idx_snv = ref(vrs) %in% DNA_BASES & alt(vrs) %in% DNA_BASES
    return(vrs[idx_snv])
    }

#vrs_snv <- sapply(vrs, indel_filter)
vrs_snv <- indel_filter(vrs)

## Somatic motifs
#vrs_motif <- sapply(vrs_snv, mutationContext, fa)
vrs_motif <- mutationContext(vrs_snv, fa)

## Draw distribution
vcf <- basename(vcf)
output <- gsub(".vcf", ".pdf", vcf)
pdf(output)
plotMutationSpectrum(vrs_motif, "sampleNames")
dev.off()

## Constructe motif matix

#vrs_mm <- lapply(vrs_motif, motifMatrix, normalize = T)






