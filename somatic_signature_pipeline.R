# author: Yifei Wan

# Visualize the signature plot of somatic mutation
# Based on VCF file

library(SomaticSignatures)
library(VariantAnnotation)
library("BSgenome.Hsapiens.UCSC.hg19")

setwd("/data/TG/RUO_Yifei/somatic_signature")

fa <- BSgenome.Hsapiens.UCSC.hg19

# Input somatic variant calls
vcfs <- list.files(path = "/data/MiSeqOutput/0-RUO_Service/0-RAWDATA/1-Fastq/Analysis/18139-07-analysis/analysis/analysis_new", recursive = F, pattern = "18139XD-07-0._annotation2_.*\\.vcf$", full.names = T)

vrs <- sapply(vcf, readVcfAsVRanges, "hg19")

## Remove indels from vcf
indel_filter <- function(vcf_vrange){
    idx_snv = ref(vcf_vrange) %in% DNA_BASES & alt(vcf_vrange) %in% DNA_BASES
    return vcf_vrange(idx_snv)
    }

vrs_snv <- sapply(vrs, indel_filter)

## Somatic motifs
vrs_motif <- sapply(vrs_snv, mutationContext, fa)

## Draw distribution

## Constructe motif matix

vrs_mm <- lapply(vrs_motif, motifMatrix, normalize = T)






