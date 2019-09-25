#!/usr/bin/env Rscript
suppressMessages(library("optparse"))

optionList = list(make_option(c("-i", "--input"), type="character", default=NULL, help="count input: file or working folder.\n(1)input file needs the first header line(delimited by \",\");\nor (2) the file in the working folder does not need first head line and count number is in the second column]"),make_option(c("-p", "--prefix"), type="character", default="output", help="output prefix [default= %default]"),make_option(c("-m","--meta"),type="character",default=NULL,help="metadata file [the format of the file is shown in \"metadata.txt\"]"),make_option(c("-d","--dir"),type="character",default=NULL,help="output folder"),make_option(c("-r","--ref"),type="character",default=NULL,help="reference condition [e.g. \"control\",which must be shwon in your condition level in the metadata file]"));

opt_parser = OptionParser(option_list=optionList);
opt = parse_args(opt_parser);

if (is.null(opt$input)||is.null(opt$dir)||is.null(opt$meta)||is.null(opt$ref)){
  print_help(opt_parser)
  stop("Parameter errors!", call.=FALSE)
}
#.libPaths("/home/quan.zhang/R/x86_64-pc-linux-gnu-library/3.3/")
options(java.parameters = "-Xmx8000m")
#.libPaths() #show the lib path for debug purpose 


suppressMessages(library("reshape2"))
suppressMessages(library("gplots"))
suppressMessages(library("RColorBrewer"))
suppressMessages(library("ggplot2"))
suppressMessages(library("DESeq2") )
suppressMessages(library(reshape2))
suppressMessages(library(ggplot2))
suppressMessages(library("pheatmap"))
#suppressMessages(library('xlsx'))
suppressMessages(library('png'))
suppressMessages(library("genefilter"))


readCount<- function(line)
{
  temp = read.csv(line[2],row.names =1,sep="\t")
        return(temp[,1])
}

InputFileCount=opt$input
InputFileMeta=opt$meta
outputPrefix=paste0(opt$dir,"/",opt$prefix)
Metadata=read.csv(file=InputFileMeta,sep="\t",header=T,check.names=FALSE,row.names=1)

if (file_test("-f",InputFileCount)){
   inputCount=read.csv(file=InputFileCount,header=T,check.names=FALSE)
   inputCount = read.csv(file=InputFileCount,header=T,check.names=FALSE,row.names=colnames(inputCount)[1])
   inputCount<-inputCount[, rownames(Metadata)]

   ddspre <- DESeqDataSetFromMatrix(countData = inputCount,colData=Metadata,design=~condition)
}else{
	sampleTable <- data.frame(sampleName=Metadata[,1],fileName=Metadata[,1],condition=Metadata[,2])
	
	ddspre <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable,directory=InputFileCount,design=~condition)
	meta=read.table(file=InputFileMeta,header = T,sep="\t",check.names=FALSE)
	print (meta)
	#newFiles<-outer(Metadata[,1],InputFileCount,FUN=function(r,c) paste(trimws(c),r,sep="/"))
	originalDir<-getwd()
	setwd(InputFileCount)
	inputCount = apply(meta,1,readCount)
	inputCount = as.data.frame(inputCount)
	colnames(inputCount) = meta[,1]
	setwd(originalDir)
}


ddspre$condition <-relevel(ddspre$condition,ref=opt$ref)
dds<-DESeq(ddspre)
#dds<-DESeq(ddspre,test = "LRT", reduced = ~ 1)
resultsDDS<-results(dds)
#resultsDDS<-results(dds,contrast=c("condition","group1","group2"))
orderResultsDDS<-resultsDDS[order(resultsDDS$padj),]
write.xlsx(orderResultsDDS, file=paste0(outputPrefix,"-AnalysisResult.xlsx"), sheetName="DE_All")
#write.table(orderResultsDDS, file=paste0(outputPrefix,"-AnalysisResult.csv"),sep=",",quote = FALSE)
write.table(data.frame("ensembleID"=rownames(orderResultsDDS),orderResultsDDS),
file=paste0(outputPrefix,"-AnalysisResult.csv"),sep=",",quote = FALSE,row.names=FALSE)


#Select significant ones: p-value<0.05
#noNAres = results[complete.cases(orderResultsDDS$pval),]
#orderResultsDDS[is.na(orderResultsDDS)] = FALSE
#typeof (orderResultsDDS)
#Sig = orderResultsDDS[orderResultsDDS$pval<0.05,]
Sig<-subset(resultsDDS, resultsDDS$pvalue < 0.05)
if (nrow(Sig)>0){
OrderSig = Sig[order(Sig$padj),]
write.xlsx(OrderSig,file=paste0(outputPrefix,"-AnalysisResult.xlsx"),sheetName="DE_Significant", append =TRUE)
write.table(data.frame("ensembleID"=rownames(OrderSig),OrderSig),
file=paste0(outputPrefix,"-AnalysisResult-sig.csv"),sep=",",quote = FALSE,row.names=FALSE)

write(rownames(OrderSig),file=paste0(outputPrefix,"-sigEnsemble.txt"))
}





rld=rlogTransformation(ddspre)
vsd <- varianceStabilizingTransformation(ddspre)
#rldcor=cor(assay(rld),method="pearson")
#write.table(paste("rld",rldcor[2][1],sep="\t"),file=paste0(outputPrefix,"-cor.txt"))
#vsdcor=cor(assay(vsd),method="pearson")
#write.table(paste("vsd",vsdcor[2][1],sep="\t"),file=paste0(outputPrefix,"-cor.txt"),append=TRUE)
## plot count of each sample ###
   pseudoCount = log2(inputCount + 1)
   pseudoCount = as.data.frame(pseudoCount)
   #sampleCor=cor(pseudoCount,method="pearson")
   #write.table(paste0("log2(count+1)",sampleCor[2][1]),file=paste0(outputPrefix,"-cor.txt"),append=TRUE)
    
   df = melt(pseudoCount) # reshape the matrix
   png(file=paste0(outputPrefix,"-BetweenSampleDis.png"),type="cairo")
   ggplot(df,aes(x=variable,y=value))+ geom_boxplot(fill="pink") +  ylab(expression(log[2](count+ 1)))+theme(axis.text.x = element_text(angle = 90, hjust = 1))
   dev.off()

##plot heat map
topVarGenes <- head(order(rowVars(assay(vsd)), decreasing = TRUE), 500)
matAll<- assay(vsd)[ topVarGenes,]
png(file=paste0(outputPrefix,"-heatmap.png"),type="cairo")
distsRL <- dist(t(matAll)) # Calculate distances using transformed (and normalized) counts

mat <- as.matrix(distsRL) # convert to matrix
#mat
rownames(mat) <- colnames(mat) <- with(colData(ddspre), paste(condition,Metadata[,1],sep=":")) # set rownames in the matrix
colnames(mat) = NULL # remove column names
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255) # set colors
pheatmap(mat,
         clustering_distance_rows=distsRL,
         clustering_distance_cols=distsRL,
         col=colors)

dev.off()


##heatmap: sample vs genes
#varList<-rowVars(assay(vsd))
#matAndVar<-cbind(matAll,varList[AllVarGenes])
#colnames(matAndVar)[length(colnames(matAndVar))]<-"variance"
#write.table(data.frame("ensembleID"=rownames(matAndVar),matAndVar),file=paste0(outputPrefix,"-allgenes-order-variance.csv"),sep=",",quote = FALSE,row.names=FALSE)
#write.table(matAndVar,file=paste0(outputPrefix,"-allgenes-order-variance.csv")),sep=",")
#write.xlsx(matAll,file=paste0(outputPrefix,"-allgenes-order-variance.xlsx"))
#mat  <- assay(vsd)[ topVarGenes,]
#anno <- as.data.frame(colData(vsd)[,"condition"])
#colnames(anno)<-"group"
#rownames(anno)<-colnames(mat)
#col_vector<-list(sample=c("group1"="#e6194b", "group2"='#3cb44b', "group3"='#ffe119'))
#png(file=paste0(outputPrefix,"-heatmap-vsd-top4000.png"),type="cairo")
#pheatmap(mat, annotation_col = anno,show_colnames = T,show_rownames=F,annotation_colors=col_vector,col=colorpanel(20,'blue','red'))
#pheatmap(mat, annotation_col = anno,clustering_method="average",clustering_distance_rows="correlation", clustering_distance_cols="euclidean", show_colnames = T,show_rownames=F,annotation_colors=col_vector,col=colorpanel(20,'blue','red'))
#dev.off()


#p-value plot
png(file=paste0(outputPrefix,"-pval.png"),type="cairo")
pvalueDf<-data.frame(pvalue=resultsDDS$pvalue)
ggplot(pvalueDf, aes(x=pvalue)) + geom_histogram(color="black", fill="blue",binwidth=.05)+xlab("p-values")
dev.off()

#MA-plot
png(file=paste0(outputPrefix,"-DE_MAplot.png"),type="cairo")
plotMA(resultsDDS, ylim=c(-7,7))
dev.off()

#PCA
png(file=paste0(outputPrefix,"-DE_PCA.png"),type="cairo")
plotPCA(rld, intgroup=c("condition"))
dev.off()

#volcano plot
png(file=paste0(outputPrefix,"-DE_VolcanoPlot.png"), type='cairo')
pval.cutoff<-.01 # threshold on the adjust p-value
log2FolderChange.cutoff<-2 #threshold on the log2 folder change

sigDDS<-subset(resultsDDS, resultsDDS$pvalue<pval.cutoff & abs(resultsDDS$log2FoldChange)>log2FolderChange.cutoff)
with(resultsDDS, plot(resultsDDS$log2FoldChange, -log10(resultsDDS$pvalue), pch=20, main="DE_VolcanoPlot",col="black"))
with(sigDDS, points(sigDDS$log2FoldChange, -log10(sigDDS$pvalue), pch=20, col="red"))
dev.off()


#Reference Link
#ftp://ftp.jax.org/dgatti/ShortCourse2015/tutorials/Differential-Expression.html
#http://folk.uio.no/jonbra/MBV-INF4410_2017/exercises/2017-12-07_R_DESeq2_exercises_without_results.html
#http://bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.html
#https://bioinformatics.uconn.edu/resources-and-events/tutorials-2/rna-seq-tutorial-with-reference-genome/#
#https://informatics.fas.harvard.edu/differential-expression-with-deseq2.html
