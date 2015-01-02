# ToDo:
# * add some header material - note that the figure in the paper only used rep 1 - here we average the three runs
# * get rid of dependency on 250 cycles
# * figure out the problem with the reverse quality scores - remaking those files


make.figure2 <- function(run){

	figure <- paste0("results/figures/", run, ".figure2.pdf")
	stub <- paste0("data/process/", run)
	
	pdf(file=figure, width=11, height=6.5)

	par(mfcol=c(2,2))

	#A
	par(mar=c(1, 5, 5, 1))
	a<-read.table(file=paste0(stub, "/Mock1_S1_L001_R1_001.filter.error.seq.forward"), header=T)
	b<-read.table(file=paste0(stub, "/Mock2_S2_L001_R1_001.filter.error.seq.forward"), header=T)
	c<-read.table(file=paste0(stub, "/Mock3_S3_L001_R1_001.filter.error.seq.forward"), header=T)
	composite <- (a[1:250,] + b[1:250,] + c[1:250,])/3
	
	plot(100*(1-composite$match), xlim=c(0,250), ylim=c(0,10), type="l", xlab="", ylab="Substitution rate (%)", xaxt="n", cex.lab=1.2)
	points(100*composite$substitution, type="l", col="black")
	text(x=0, y=9.9, label="A", cex=1.5, font=2)


	#B
	par(mar=c(5, 5, 1, 1))
	a<-read.table(file=paste0(stub, "/Mock1_S1_L001_R2_001.rc.filter.error.seq.reverse"), header=T)
	b<-read.table(file=paste0(stub, "/Mock2_S2_L001_R2_001.rc.filter.error.seq.reverse"), header=T)
	c<-read.table(file=paste0(stub, "/Mock3_S3_L001_R2_001.rc.filter.error.seq.reverse"), header=T)
	composite <- (a[1:250,] + b[1:250,] + c[1:250,])/3
	
	plot(100*(1-composite$match), xlim=c(0,250), ylim=c(0,10), type="l", xlab="Bases sequenced", ylab="", cex.lab=1.2)
	points(100*composite$substitution, type="l", col="black")
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
	text(0.5, 39, label="C", cex=1.5, font=2)


	#D
	par(mar=c(5, 5, 1, 1))
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
	axis(1, at=c(1,2,3,4), labels=c("Matches", "Substitutions", "Insertions", "Ambiguous"))
	text(0.5, 39, label="D", cex=1.5, font=2)
	par(mfrow=c(1,1))

	dev.off()

}