#author: Yifei.wan

# WGBS comparison

# Parse arguments
suppressMessages(library("optparse"))

optionList <- list(make_option(c("-i", "--input"), type="character", default=NULL, help="Folder of BAM"),
    make_option(c("-m", "--meta"), type="character", default=NULL, help="Meta text file"), 
    make_option(c("-r", "--reference"), type="character", default=NULL, help="Reference genome [\"mm10\" or \"hg18\"]"),
    make_option(c("-n", "--negative"), type="character", default=NULL, help="Name of the control group [e.g. \"WT\"]"),
    make_option(c("-c", "--context"),type="character",default=NULL,help="Type of the context [\"CpG\" or \"CHG\" or  \"CHH\"]"),
    make_option(c("-o", "--output"), type="character", default=NULL, help="Output folder"))
    
opt_parser <- OptionParser(option_list=optionList)
opt <- parse_args(opt_parser)

if (is.null(opt$input) || is.null(opt$output) || is.null(opt$meta)){
    print_help(opt_parser)
    }

input <- opt$input ## input folder of BAM
output <- opt$output ## output folder

# Read the meta table
meta_table <- read.csv(opt$meta, sep="\t", header=T, stringsAsFactors=F)
samples <- meta_table$Sample
conditions <- meta_table$Group

# prepare BAM for each sample
setwd(input)
get_bam <- function(sample){
    bam = list.files(pattern=paste(sample, ".*deduplicated.sorted.bam$", sep=""), recursive=F)
    return(bam)
    }

samples_bams <- sapply(samples, get_bam)
attributes(samples_bams) <- NULL

#print(samples_bams)
dir.create(output)
#setwd(output)

# Parse the experiment design

control <- opt$negative
others <- unique(conditions)[which(unique(conditions) != control)]
design <- as.numeric(factor(conditions, levels = c(control, others))) - 1
print(design)

# Compare WGBS
print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
print(">>>>>>>>>>>>>>>  Start to run MethylKit  <<<<<<<<<<<<<<<<")
print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")

#print(length(as.list(samples_bams)))
#print(length(as.list(samples)))
#print(length(as.list(design)))

#quit()
suppressMessages(library(methylKit))
cat("\n")
print("---------------------------------------------------------")
print("1. Extract the CpG, CHG, CHH")

my.methRaw_context = processBismarkAln(location = as.list(samples_bams),
                         sample.id=as.list(samples), 
                         assembly=opt$reference,
                         treatment=design,
                         read.context=opt$context,
                         save.folder= output)

save.image("methRaw_context.RData")

print("---------------------------------------------------------")
print("2. Filter samples based on the read coverage and normalize")
# filter samples based on the read coverage and normalize 
filtered.myobj = filterByCoverage(my.methRaw_context,lo.count=10,lo.perc=NULL,
                                      hi.count=NULL,hi.perc=99.9)
filtered.myobj = normalizeCoverage(filtered.myobj,method="median")

print("---------------------------------------------------------")
print("3. Merge samples")
# merge samples
meth = unite(filtered.myobj, destrand=TRUE) ## set at TRUE only for CpG
#meth = unite(filtered.myobj, destrand=False) 

print("---------------------------------------------------------")
print("4. Correlation")
# Correlation
pdf("Sample_correlation.pdf")
getCorrelation(meth,plot=TRUE)
dev.off()

print("---------------------------------------------------------")
print("5. Clustering")
# Clustering
pdf("Sample_clustering.pdf")
clusterSamples(meth, dist="correlation", method="ward.D", plot=TRUE)
dev.off()

print("---------------------------------------------------------")
print("6. PCA")
# PCA
pdf("Sample_PCA_screeplot.pdf")
PCASamples(meth, screeplot=TRUE)
dev.off()
pdf("Sample_PCA.pdf")
PCASamples(meth)
dev.off()

print("---------------------------------------------------------")
print("7. Differential methylation")
# Differential methylation
myDiff = calculateDiffMeth(meth, mc.cores=80) ## assign 80 cores
saveRDS(myDiff, file = "myDiff_cpg.rds")
#myDiff25p=getMethylDiff(myDiff,difference=25,qvalue=0.01)

print("---------------------------------------------------------")
print("8. Annotation")
# Annotation
supressMessage(library(genomation))
source = paste("refseq.", opt$reference, ".bed.txt", sep="")
gene.obj=readTranscriptFeatures(system.file("extdata", "refseq.mm10.bed.txt", package = "methylKit")) ## annotation source for mouse

diffann = annotateWithGeneParts(as(myDiff,"GRanges"),gene.obj)

print("---------------------------------------------------------")
print("9. Generate final result")
# Organize result
md_output = myDiff@.Data[[1]]
for(i in 2:7){
    md_output = cbind(md_output, myDiff@.Data[[i]])
}
colnames(md_output) = myDiff@names
md_output = cbind(md_output, diffann@dist.to.TSS[ ,c(-1, -4)])
md_output = cbind(md_output, diffann@members)

write.csv(md_output, "differential_methylation.csv")

pdf("different_methylation_annotation.pdf"
plotTargetAnnotation(diffann,precedence=TRUE,
    main="differential methylation annotation")
dev.off()

saveRDS(diffann, file = "diffann.rds")

print("---------------------------------------------------------")
print("All done!!")
print("=========================================================")

