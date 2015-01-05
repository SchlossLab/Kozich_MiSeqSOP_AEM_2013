################################################################################
#
# paper_figure3.R
#
# Description...
#
#
# Dependencies...
#
#
# Produces...
#
#
################################################################################


make.figure2 <- function(run){

	figure <- paste0("results/figures/", run, ".figure2.pdf")
	stub <- paste0("data/process/", run)
	
	png(file=figure)





	dev.off()
}