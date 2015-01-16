################################################################################
#
# plot_nmds.R
#
# Here we take in the *.nmds.axes file from the mouse stability analysis and
# plot it in R as we did in Figure 4 of Kozich et al.
#
#
# Dependencies...
# * data/process/*/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.an.unique_list.thetayc.0.03.lt.ave.nmds.axes
#
# Produces...
# * results/figures/*.figure4.png
#
################################################################################

plot_nmds <- function (axes_file){
    axes <- read.table(file=axes_file, header=T, row.names=1)
    day <- as.numeric(gsub(".*D(\\d*)$", "\\1", rownames(axes)))

    early <- day <= 10
    late <- day >= 140 & day <= 150

    plot.axes <- axes[early | late, ]
    plot.day <- day[early | late]
    plot.early <- early[early | late]
    plot.late <- late[early | late]

    pch <- vector()
    pch[plot.early] <- 21
    pch[plot.late] <- 19

    output_file_stub <- strsplit(axes_file, split="\\/")[[1]][3]
    output_file <- paste0("results/figures/", output_file_stub, ".figure4.png")

    png(file=output_file)
    plot(plot.axes$axis2~plot.axes$axis1, pch=pch, xlab="PCoA Axis 1", ylab="PCoA Axis 2")
    legend(x=max(plot.axes$axis1)-0.125, y=min(plot.axes$axis2)+0.125, legend=c("Early", "Late"), pch=c(21,19))
    dev.off()
}
