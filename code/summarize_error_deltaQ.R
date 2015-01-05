################################################################################
#
# paper_figure3.R
#
# Description...
#
#
# Dependencies...
# * run_id
#
# Produces...
# * data/process/run_id/deltaq.error.summary
#
################################################################################





get.summary <- function(run){

	run <- "121203"
	directory <- paste0("data/process/", run, "/")
	
	deltaq <- 0:10
	
	a.region <- paste0(directory, "Mock1_S1_L001_R1_001.", deltaq, ".contigs.region")
	b.region <- paste0(directory, "Mock2_S2_L001_R1_001.", deltaq, ".contigs.region")
	c.region <- paste0(directory, "Mock3_S3_L001_R1_001.", deltaq, ".contigs.region")
	
	a.summary <- paste0(directory, "Mock1_S1_L001_R1_001.", deltaq, ".contigs.filter.error.summary")
	b.summary <- paste0(directory, "Mock2_S2_L001_R1_001.", deltaq, ".contigs.filter.error.summary")
	c.summary <- paste0(directory, "Mock3_S3_L001_R1_001.", deltaq, ".contigs.filter.error.summary")
	
	for(dq in deltaq){
		region <- rbind(read.table(file=a.region[dq+1]), read.table(file=b.region[dq+1]), read.table(file=c.region[dq+1])) 
		summary <- rbind(read.table(file=a.summary[dq+1], header=T), read.table(file=b.summary[dq+1], header=T), read.table(file=c.summary[dq+1], header=T)) 
		
		good <- summary$numparents==1 & summary$ambig==0
		summary.nochim_noN <- summary[good,]
		region.nochim_noN <- region[good,]
		
		error.nseqs <- aggregate(summary.nochim_noN$error, by=list(region.nochim_noN$V2), function(x){c(mean(x), length(x))})
	}


	output <- paste0(directory, "/deltaq.error.summary")
	write.table(file=outut, s.table, quote=F)
}

v4 length <= 260
v45 length <= 400
v34 length <= 450


