
## Collect arguments
args <- commandArgs(TRUE)
 
## Default setting when no arguments passed
if(length(args) < 1) {
  args <- c("--help")
}
 
## Help section
if("--help" %in% args) {
	cat("
	The R Script
 
	Arguments:
	--arg1=<Input>  -  string, Input peak bed file
	--arg2=<Output> -  string, Output annotation txt file
	--help          -  print this text
 
	Example:
	Example:
	.PeakAnnotate.R --arg1= input.bed --arg2= output.bed \n
	")
 
	q(save="no")
}



## Parse arguments (we expect the form --arg=value)
parseArgs <- function(x) strsplit(sub("^--", "", x), "=")
argsDF <- as.data.frame(do.call("rbind", parseArgs(args)))
#print(argsDF)
argsL <- as.list(as.character(argsDF$V2))
names(argsL) <- argsDF$V1
#print(argsL)


## Arg1 default
if(!(is.null(argsL$arg1))) {
	input <- argsL$arg1
	print(input)
}
 
## Arg2 default
if(!(is.null(argsL$arg2))) {
	output <- argsL$arg2
	print(output)
}
 

suppressMessages(library(esATAC))
library(TxDb.Mmusculus.UCSC.mm10.knownGene)
AnnoInfo <- peakanno(peakInput = input, TxDb = TxDb.Mmusculus.UCSC.mm10.knownGene, annoDb = "org.Mm.eg.db", annoOutput = output)
