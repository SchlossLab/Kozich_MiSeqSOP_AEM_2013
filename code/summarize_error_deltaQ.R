################################################################################
#
# paper_figure3.R
#
# Aggregates the error data for each delta Q size and region and reports the 
# average error rate and number of good reads in that region and delta Q size.
# Of course, this will exclude the sequences flagged as being chimeras and those
# that escape the contiging process with an ambiguous base call.
#
# Dependencies...
# * run_id
# * Mock#_S#_L001_R1_001.$DELTAQ.contigs.region
# * Mock#_S#_L001_R1_001.$DELTAQ.contigs.filter.error.summary
#
# Produces...
# * data/process/run_id/deltaq.error.summary
#
################################################################################

get.summary <- function(run){

	run <- "130403"
	directory <- paste0("data/process/", run, "/")
	
	deltaq <- 0:10
	
	a.region <- paste0(directory, "Mock1_S1_L001_R1_001.", deltaq, ".contigs.region")
	b.region <- paste0(directory, "Mock2_S2_L001_R1_001.", deltaq, ".contigs.region")
	c.region <- paste0(directory, "Mock3_S3_L001_R1_001.", deltaq, ".contigs.region")
	
	a.summary <- paste0(directory, "Mock1_S1_L001_R1_001.", deltaq, ".contigs.filter.error.summary")
	b.summary <- paste0(directory, "Mock2_S2_L001_R1_001.", deltaq, ".contigs.filter.error.summary")
	c.summary <- paste0(directory, "Mock3_S3_L001_R1_001.", deltaq, ".contigs.filter.error.summary")
	
	error.summary <- data.frame()
	deltaq <- 0:3
	for(dq in deltaq){
		region <- rbind(read.table(file=a.region[dq+1]), read.table(file=b.region[dq+1]), read.table(file=c.region[dq+1])) 
		summary <- rbind(read.table(file=a.summary[dq+1], header=T), read.table(file=b.summary[dq+1], header=T), read.table(file=c.summary[dq+1], header=T)) 
		
		good <- summary$numparents==1 & summary$ambig==0
		summary.nochim_noN <- summary[good,]
		region.nochim_noN <- region[good,]
		
		error <- aggregate(summary.nochim_noN$error, by=list(region.nochim_noN$V2), mean)
		nseqs <- aggregate(summary.nochim_noN$error, by=list(region.nochim_noN$V2), length)
		error.summary <- rbind(error.summary, cbind(rep(dq, 3), error$Group.1, error$x, nseqs$x))
	}
	regions <- c("v34", "v4", "v45")
	colnames(error.summary) <- c("deltaQ", "region", "error.rate", "nseqs")
	error.summary$region <- regions[error.summary$region]
	output <- paste0(directory, "/deltaq.error.summary")
	write.table(file=output, error.summary, quote=F, row.names=F)
}
