################################################################################
#
# paper_figure3.R
#
# Description: Generates separate plots for each region within the 16S rRNA gene
# that indicate the sequencing error rate and the percentage of sequences kept
# for different delta Q threshold between the paired reads. This is Figure 3
# from the Kozich paper
#
# Dependencies: the data/process/$RUN/deltaq.error.summary file
#
#
# Produces: a png file called results/figures/$RUN.figure3.png
#
################################################################################



make.figure2 <- function(run){

	data.filename <- paste0("data/process/", run, "/deltaq.error.summary")
	data <- read.table(file=data.filename, header=T)		
	
	figure <- paste0("results/figures/", run, ".figure3.png")
	png(file=figure, width=480, height=960)


	delta <- seq(0, 10, 1)
	par(mfrow=c(3,1))
	
	v34 <- data[data$region == "v34",]
	v34[,"nseqs"] <- v34$nseqs / v34[v34$deltaQ==0,"nseqs"]
	
	par(mar=c(0, 5, 5, 5)) 
	plot(x=delta, 100*v34$error.rate, ylim=c(0,1.5), xaxt="n", xlab="", ylab="", type="l", lwd=3, cex.axis=2)
	par(new=TRUE)
	plot(x=delta, 100*v34$nseqs, ylim=c(0,100), xlab="", ylab="", yaxt="n", xaxt="n", type="l", lty=2, lwd=3)
	axis(4, cex.axis=2)
	legend(x=5, y=70, legend=c("Error rate", "Sequences kept"), lty=c(1,2), cex=1.5, lwd=2)
	text(x=9.7, y=98, label="V34", cex=2.5, font=2)

	
	v4 <- data[data$region == "v4",]
	v4[,"nseqs"] <- v4$nseqs / v4[v4$deltaQ==0,"nseqs"]

	par(mar=c(2.5, 5, 2.5, 5)) 
	plot(x=delta, 100*v4$error.rate, ylim=c(0,0.8), xaxt="n", xlab="", ylab="Error rate (%)", type="l", cex.lab=2, font.lab=2, lwd=3, cex.axis=2)
	par(new=TRUE)
	plot(x=delta, 100*v4$nseqs, ylim=c(0,100), xlab="", ylab="", yaxt="n", xaxt="n", type="l", lty=2, lwd=3)
	axis(4, cex.axis=2)
	text(par("usr")[2]+1, (par("usr")[3]+par("usr")[4])/2+2, srt=-90, adj = 0, labels = "Sequences kept (%)", xpd = TRUE, pos=1, cex=2, font=2)
	text(x=9.7, y=98, label="V4", cex=2.5, font=2)



	v45 <- data[data$region == "v45",]
	v45[,"nseqs"] <- v45$nseqs / v45[v45$deltaQ==0,"nseqs"]
	
	par(mar=c(5, 5, 0, 5)) 
	plot(x=delta, 100*v45$error.rate, ylim=c(0,4), xlab="Difference between quality scores (\u0394Q)", ylab="", type="l", cex.lab=2, font.lab=2, lwd=3, cex.axis=2)
	par(new=TRUE)
	plot(x=delta, 100*v45$nseqs,, ylim=c(0,100), xlab="", ylab="", yaxt="n", xaxt="n", type="l", lty=2, lwd=3)
	axis(4, cex.axis=2)
	text(x=9.7, y=98, label="V45", cex=2.5, font=2)


	par(mfrow=c(1,1))
	dev.off()

}
