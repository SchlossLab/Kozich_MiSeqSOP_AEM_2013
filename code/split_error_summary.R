################################################################################
#
# split_error_summary.R
#
#
# Here we take in a *.summary file and use the information in the
# data/references/start_stop.positions file to split the *.summary file into the
# three regions and a scrap group. Will produce an accnos file for each region
# and a table that can be used to aggregate the data in the *error.summary
# files.
#
# Dependencies...
# * data/process/*/*.summary - could be a single contigs or two unaligned reads
# * data/references/start_stop.positions
#
# Produces:
# * data/process/*/*.region
# * data/process/*/*.v34.accnos
# * data/process/*/*.v4.accnos
# * data/process/*/*.v45.accnos
#
################################################################################

positions <- read.table(file="data/references/start_stop.positions", header=F, row.names=1)
colnames(positions) <- c("start", "end")

contig_split <- function(contig_file){
	align_data <- read.table(file=contig_file, header=T, row.names=1)
	
	v34 <- align_data$start <= positions["V34", "start"] & align_data$end >= positions["V34", "end"]
	v4 <- align_data$start <= positions["V4", "start"] & align_data$end >= positions["V4", "end"]
	v45 <- align_data$start <= positions["V45", "start"] & align_data$end >= positions["V45", "end"]
	scrap <- !(v34 | v4 | v45)
	
	region <- rep(NA, length(scrap))
	region[v4] <- "v4"	# order is very importnat here. if v4 goes 2nd, then it wipes out all of the v34
	region[v34] <- "v34"
	region[v45] <- "v45"
	
	stub_file <- gsub(".summary", "", contig_file)
	
	write.table(file=paste0(stub_file, ".v34.accnos"), rownames(align_data)[v34], quote=F, col.names=F, row.names=F)
	write.table(file=paste0(stub_file, ".v4.accnos"), rownames(align_data)[v4], quote=F, col.names=F, row.names=F)
	write.table(file=paste0(stub_file, ".v45.accnos"), rownames(align_data)[v45], quote=F, col.names=F, row.names=F)
	write.table(file=paste0(stub_file, ".region"), cbind(rownames(align_data), region), quote=F, col.names=F, row.names=F)
}


reads_split <- function(read1_file, read2_file){
	read1_data <- read.table(file=read1_file, header=T, row.names=1)
	read2_data <- read.table(file=read2_file, header=T, row.names=1)
	
	v34 <- read1_data$start <= positions["V34", "start"] & read2_data$end >= positions["V34", "end"]
	v4 <- read1_data$start <= positions["V4", "start"] & read2_data$end >= positions["V4", "end"]
	v45 <- read1_data$start <= positions["V45", "start"] & read2_data$end >= positions["V45", "end"]
	scrap <- !(v34 | v4 | v45)
	
	region <- rep(NA, length(scrap))
	region[v4] <- "v4"
	region[v34] <- "v34"
	region[v45] <- "v45"
	
	stub_file <- gsub(".summary", "", read1_file)
	
	write.table(file=paste0(stub_file, ".v34.accnos"), rownames(read1_data)[v34], quote=F, col.names=F, row.names=F)
	write.table(file=paste0(stub_file, ".v4.accnos"), rownames(read1_data)[v4], quote=F, col.names=F, row.names=F)
	write.table(file=paste0(stub_file, ".v45.accnos"), rownames(read1_data)[v45], quote=F, col.names=F, row.names=F)
	write.table(file=paste0(stub_file, ".region"), cbind(rownames(read1_data), region), quote=F, col.names=F, row.names=F)
}
