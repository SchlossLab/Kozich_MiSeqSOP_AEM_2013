################################################################################
#
# paper_figure2.R
#
#
# Here we run the output of running seq.error through a script to generate a
# figure similar to what we presented as Figure 2 in Kozich et al. AEM 2013. A
# subtle difference between what we do here and we did in the original paper was
# to average the seq.forward/seq.reverse files and add the counts of the
# quality files. Ideally we could have done a weighted average of the
# seq.forward/seq.reverse files, but whatever. It shouldn't have resulted in a
# huge difference. The figure in the paper was based on the Mock1 files.
#
# Dependencies...
# * data/process/$RUN/Mock1_S1_L001_R1_001.filter.error.seq.forward
# * data/process/$RUN/Mock2_S2_L001_R1_001.filter.error.seq.forward
# * data/process/$RUN/Mock3_S3_L001_R1_001.filter.error.seq.forward
# * data/process/$RUN/Mock1_S1_L001_R2_001.rc.filter.error.seq.reverse
# * data/process/$RUN/Mock2_S2_L001_R2_001.rc.filter.error.seq.reverse
# * data/process/$RUN/Mock3_S3_L001_R2_001.rc.filter.error.seq.reverse
# * data/process/$RUN/Mock1_S1_L001_R1_001.filter.error.quality
# * data/process/$RUN/Mock2_S2_L001_R1_001.filter.error.quality
# * data/process/$RUN/Mock3_S3_L001_R1_001.filter.error.quality
# * data/process/$RUN/Mock1_S1_L001_R2_001.rc.filter.error.quality
# * data/process/$RUN/Mock2_S2_L001_R2_001.rc.filter.error.quality
# * data/process/$RUN/Mock3_S3_L001_R2_001.rc.filter.error.quality
#
#
# Produces...
# * results/figures/$RUN.figure2.png
#
################################################################################


make.figure2 <- function(run){

	figure <- paste0("results/figures/", run, ".figure2.png")
	stub <- paste0("data/process/", run)
	
	png(file=figure)

	par(mfcol=c(2,2))

	#A
	par(mar=c(1, 5, 5, 1))
	a<-read.table(file=paste0(stub, "/Mock1_S1_L001_R1_001.filter.error.seq.forward"), header=T)
	b<-read.table(file=paste0(stub, "/Mock2_S2_L001_R1_001.filter.error.seq.forward"), header=T)
	c<-read.table(file=paste0(stub, "/Mock3_S3_L001_R1_001.filter.error.seq.forward"), header=T)
	nr <- min(c(nrow(a), nrow(b), nrow(c)))
	composite <- (a[1:nr,] + b[1:nr,] + c[1:nr,])/3
	
	plot(100*(1-composite$match[1:nr]), xlim=c(0,nr), ylim=c(0,10), type="l", xlab="", ylab="Substitution rate (%)", xaxt="n", cex.lab=1.2)
#	points(100*composite$substitution[1:nr], type="l", col="black")
	text(x=0, y=9.9, label="A", cex=1.5, font=2)


	#B
	par(mar=c(6, 5, 0, 1))
	a<-read.table(file=paste0(stub, "/Mock1_S1_L001_R2_001.rc.filter.error.seq.reverse"), header=T)
	b<-read.table(file=paste0(stub, "/Mock2_S2_L001_R2_001.rc.filter.error.seq.reverse"), header=T)
	c<-read.table(file=paste0(stub, "/Mock3_S3_L001_R2_001.rc.filter.error.seq.reverse"), header=T)
	nr <- min(c(nrow(a), nrow(b), nrow(c)))
	composite <- (a[1:nr,] + b[1:nr,] + c[1:nr,])/3
	
	plot(100*(1-composite$match[1:nr]), xlim=c(0,nr), ylim=c(0,10), type="l", xlab="Bases sequenced", ylab="", cex.lab=1.2)
#	points(100*composite$substitution, type="l", col="black")
	text(x=0, y=9.9, label="B", cex=1.5, font=2)


	#C
	par(mar=c(1, 5, 5, 1))
	a<-read.table(file=paste0(stub, "/Mock1_S1_L001_R1_001.filter.error.quality"), header=T, row.names=1)
	b<-read.table(file=paste0(stub, "/Mock2_S2_L001_R1_001.filter.error.quality"), header=T, row.names=1)
	c<-read.table(file=paste0(stub, "/Mock3_S3_L001_R1_001.filter.error.quality"), header=T, row.names=1)
	composite <- a + b + c
	
	q <- as.numeric(rownames(composite))

	m<-sample(rep(q, composite$matches), 10000)
	boxplot(m, at=1, xlim=c(0.5,4.5), ylim=c(0,40), ylab="Quality score", cex.lab=1.2)
	boxplot(rep(q, composite$substitutions), at=2,add=T, outline=F, yaxt="n")
	boxplot(rep(q, composite$insertions), at=3, add=T, outline=F, yaxt="n")
	boxplot(rep(q, composite$ambiguous), at=4, add=T, outline=F, yaxt="n")
	text(0.5, 39.9, label="C", cex=1.5, font=2)


	#D
	par(mar=c(6, 5, 0, 1))
	a<-read.table(file=paste0(stub, "/Mock1_S1_L001_R2_001.rc.filter.error.quality"), header=T)
	b<-read.table(file=paste0(stub, "/Mock2_S2_L001_R2_001.rc.filter.error.quality"), header=T)
	c<-read.table(file=paste0(stub, "/Mock3_S3_L001_R2_001.rc.filter.error.quality"), header=T)
	composite <- a + b + c
	
	q <- as.numeric(rownames(composite))

	m<-sample(rep(q, composite$matches), 10000)
	boxplot(m, at=1, xlim=c(0.5,4.5), ylim=c(0,40), ylab="")
	boxplot(rep(q, composite$substitutions), at=2,add=T, outline=F, yaxt="n")
	boxplot(rep(q, composite$insertions), at=3, add=T, outline=F, yaxt="n")
	boxplot(rep(q, composite$ambiguous), at=4, add=T, outline=F, yaxt="n")
	axis(1, at=c(1,2,3,4), labels=c("Matches", "Substitutions", "Insertions", "Ambiguous"), las=2)
	text(0.5, 39.9, label="D", cex=1.5, font=2)
	par(mfrow=c(1,1))

	dev.off()

}
