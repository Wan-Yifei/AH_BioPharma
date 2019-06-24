
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
	<Input>  -  string, Input peak bed file
	<Output> -  string, Output annotation txt file
	--help          -  print this text
 
	Example:
	Example:
	.PeakAnnotate.R input.bed output.bed \n
	")
 
	q(save="no")
}



## Parse arguments (we expect the form --arg=value)
parseArgs <- function(x) strsplit(x, " ")
print(args)
argsL <- args
print(argsL)


## Arg1 default
if(!(is.null(argsL[1]))) {
	input <- argsL[1]
	print(input)
}
 
## Arg2 default
if(!(is.null(argsL[2]))) {
	output <- argsL[2]
	print(output)
}
 

suppressMessages(library(esATAC))
library(TxDb.Mmusculus.UCSC.mm10.knownGene)
AnnoInfo <- peakanno(peakInput = input, TxDb = TxDb.Mmusculus.UCSC.mm10.knownGene, annoDb = "org.Mm.eg.db", annoOutput = output)
