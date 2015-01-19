################################################################################
#
# build_table2.R
#
#
# Here we build a table that summarizes the error rates and number of OTUs that
# were seen for each region and sequencing run. This is presented as Table 2 in
# the paper
#
# Dependencies...
# * data/process/{run}/deltaq.error.summary - summary of errors/nseqs for each
#   run, region, and deltaq value
# * data/process/noseq_error/HMP_MOCK.{region}.summary - number of OTUs that
#   would be seen if there was no sequencing or PCR error
# * data/process/{run}/{mock}_L001_R1_001.6.contigs.{region}.filter.unique.precluster.error.summary -
#   The error rate after running precluster on the Mock data with a deltaq=6
# * data/process/{run}/{library}*.filter.unique.precluster.pick.an.ave-std.summary -
#   Number of OTUs observed when datasets are rarefied to 5000 reads for each
#   of the 12 libraries in each region and for each sequencing run
# * data/process/{run}/{mock}_L001_R1_001.6.contigs.{region}.*filter.unique.precluster.perfect.an.ave-std.summary -
#   Number of OTUs that would be observed if we did a perfect job of removing
#   the chimeras.
#
# Produces results/tables/table_2.tsv
#
################################################################################


# Given a region, extract the number of OTUs we'd expect if there were no
# sequencing errors and no chimeras.

get_ideal <- function(region){
    file_name <- paste0("data/process/noseq_error/HMP_MOCK.", region, ".summary")
    file <- read.table(file=file_name, header=T)
    file$sobs
}



# Given the run number, region, and the deltaQ value, output the corresponding
# sequencing error rate

get_delta_q_error <- function(run, region, dq){
    file_name <- paste0("data/process/", run, "/deltaq.error.summary")
    file <- read.table(file=file_name, header=T)
    file[file$deltaQ == dq & file$region == region, "error.rate"]
}



# Given the run number and the region output the corresponding sequencing error
# rate for a deltaQ of 6 after running the data through pre.cluster

get_pc_errors <- function(run, region){
    path <- paste0("data/process/", run, "/")
    mocks <- c("Mock1_S1", "Mock2_S2", "Mock3_S3")

    error_summary_fname <- paste0("data/process/", run, "/", mocks,
                                "_L001_R1_001.6.contigs.", region,
                                ".filter.unique.precluster.error.summary")
    error_summary <- read.table(file=error_summary_fname[1], header=T, row.names=1)
    error_summary <- rbind(error_summary, read.table(file=error_summary_fname[2], header=T, row.names=1))
    error_summary <- rbind(error_summary, read.table(file=error_summary_fname[3], header=T, row.names=1))

    good <- error_summary$numparents == 1 & error_summary$ambig == 0

    error_summary.good <- error_summary[good,]

    nseqs <- sum(error_summary.good$weight)
    error <- sum(error_summary.good$weight * error_summary.good$error) / nseqs
    error
}



# Given the run number, the region, and two deltaQ values, calculate the
# percentage of reads in the second deltaQ value relative to the first

get_per_reads_remaining <- function(run, region, dq_a=0, dq_b=6){

    file_name <- paste0("data/process/", run, "/deltaq.error.summary")
    file <- read.table(file=file_name, header=T)

    basic <- file[file$region == region & file$deltaQ == dq_a, "nseqs"]
    clean <- file[file$region == region & file$deltaQ == dq_b, "nseqs"]

    100 * clean / basic
}



# Given an ave-std.summary file, extract the number of observed OTUs

get_sobs <- function(summary_file){

    if(file.info(summary_file)$size != 0){

        data <- read.table(file=summary_file, header=T)
        sobs <- data[data$method == "ave", "sobs"]
    } else {
        sobs <- NA
    }

    return(sobs)
}



# Given the run number and the region, output the number of OTUs that would be
# observed if we did a perfect job of removing the chimeras.

get_nochim_otus <- function(run, region){

    path <- paste0("data/process/", run, "/")
    mocks <- c("Mock1_S1", "Mock2_S2", "Mock3_S3")

    ave_std_summary <- paste0("data/process/", run, "/", mocks,
                                "_L001_R1_001.6.contigs.", region,
                                ".filter.unique.precluster.perfect.an.ave-std.summary")

    sobs <- unlist(lapply(ave_std_summary, get_sobs))
    ave_sobs <- mean(sobs, na.rm=T)

    ifelse(is.nan(ave_sobs), NA, ave_sobs)
}





get_typical_otus <- function(run, region){

    path <- paste0("data/process/", run, "/")
    libraries <- c("Mock1_S1", "Mock2_S2", "Mock3_S3",
                    "Soil1_S4", "Soil2_S5", "Soil3_S6",
                    "Human1_S7", "Human2_S8", "Human3_S9",
                    "Mouse1_S10", "Mouse2_S11", "Mouse3_S12")
    type <- gsub("\\d.*", "", libraries)

    ave_std_summary <- paste0("data/process/", run, "/", libraries,
                                "_L001_R1_001.6.contigs.", region,
                                ".filter.unique.precluster.pick.an.ave-std.summary")

    sobs <- unlist(lapply(ave_std_summary, get_sobs))
    ave_sobs <- aggregate(sobs, by=list(type), mean, na.rm=T)

    return_sobs <- ave_sobs$x
    names(return_sobs) <- ave_sobs$Group.1
    return_sobs[is.nan(return_sobs)] <- NA
    return_sobs
}





#Region and run
folders <- list.dirs("data/process", recursive=FALSE)
error_run <- grepl("data/process/1", folders)
error_folders <- folders[error_run]
runs <- gsub("data/process/", "", error_folders)
regions <- c("v34", "v4", "v45")

runs_regions <- expand.grid(runs=runs, regions=regions, stringsAsFactors=F)


#Get Sobs for each region w/o errors or chimeras
perfect_sobs <- sapply(regions, get_ideal)
names(perfect_sobs) <- regions


#Basic error rate
delta_0_errors <- mapply(get_delta_q_error, runs_regions$runs, runs_regions$regions, dq=0)
delta_0_table <- cbind(runs_regions, delta_0=delta_0_errors)


#deltaQ=6 error rate
delta_6_errors <- mapply(get_delta_q_error, runs_regions$runs, runs_regions$regions, dq=6)
delta_6_table <- cbind(runs_regions, delta_6=delta_6_errors)


#Precluster error rate
pc_errors <- mapply(get_pc_errors, run=runs_regions$runs, region=runs_regions$regions)
pc_table <- cbind(runs_regions, pc_errors)


#% reads remaining from basic (deltaQ=0)
per_reads_remaining <- mapply(get_per_reads_remaining, run=runs_regions$runs, region=runs_regions$regions)
per_reads_table <- cbind(runs_regions, per_reads_remaining)


#Mock^b - Sobs with perfect chimera removal
nochim_sobs <- mapply(get_nochim_otus, run=runs_regions$runs, region=runs_regions$regions)
nochim_sobs_table <- cbind(runs_regions, nochim_sobs)


#Number of OTUs in the Mock, Soil, Mouse and Human samples
typical_sobs <- mapply(get_typical_otus, run=runs_regions$runs, region=runs_regions$regions)
typical_sobs_table <- cbind(runs_regions, t(typical_sobs)[,c(2,4,3,1)])



#Merge table together
table_3 <- cbind(region = runs_regions$regions,
    perfect = perfect_sobs[runs_regions$regions],
    run = runs_regions$runs,
    delta0_error = format(round(100*delta_0_table$delta_0, 2), 2),
    delta6_error = format(round(100*delta_6_table$delta_6, 2), 2),
    pc_error = format(round(100*pc_table$pc_errors, 2), 2),
    perecent_remaining = format(round(per_reads_table$per_reads_remaining, 1), 1),
    no_chimeras = format(round(nochim_sobs_table$nochim_sobs, 1), 1),
    typical_mock = format(round(typical_sobs_table$Mock, 1), 1),
    typical_soil = format(round(typical_sobs_table$Soil, 1), 1),
    typical_mouse = format(round(typical_sobs_table$Mouse, 1), 1),
    typical_human = format(round(typical_sobs_table$Human, 1), 1)
)

write.table(file="results/tables/table_2.tsv", table_3, row.names=F, quote=F, sep="\t")
