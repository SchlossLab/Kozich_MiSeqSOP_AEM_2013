################################################################################
#
# get_contigsfile.R
#
#
# Here we generate a file that can be used in make.contigs from the fastq files
# that are in a directory. We use the first underscore to indicate the group 
# name.
#
# Dependencies...
# * a folder with a bunch of fastq files
# * a directory path: eg. something/else/
#
# Produces something/else/else.files
#
################################################################################

get_contigsfile <- function(p){
	p <- gsub("\\/$", "", p)
	f <- list.files(p)

	r1 <- f[grep("_R1_", f)]
	r1.group <- sub("_S.*", "", r1)

	r2 <- f[grep("_R2_", f)]
	r2.group <- sub("_S.*", "", r2)

	stopifnot(r1.group == r2.group)
	
	files.file <- paste0(gsub(".*\\/(.*)", "\\1", p), ".files")
	p.files.file <- paste0(p, "/", files.file)
	
	write.table(file=p.files.file, cbind(r1.group, r1, r2), sep="\t", quote=F, row.names=F, col.names=F)
}
