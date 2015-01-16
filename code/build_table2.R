

get_dq_errors <- function(run, delta_q){

    path <- paste0("data/process/", run, "/")
    mocks <- c("Mock1_S1", "Mock2_S2", "Mock3_S3")

    error_summary_fname <- paste0("data/process/", run, "/", mocks, "_L001_R1_001.", delta_q, ".contigs.filter.error.summary")
    error_summary <- read.table(file=error_summary_fname[1], header=T, row.names=1)
    error_summary <- rbind(error_summary, read.table(file=error_summary_fname[2], header=T, row.names=1))
    error_summary <- rbind(error_summary, read.table(file=error_summary_fname[3], header=T, row.names=1))

    region_fname <- paste0("data/process/", run, "/", mocks, "_L001_R1_001.", delta_q, ".contigs.region")
    region <- read.table(file=region_fname[1], header=F, row.names=1)
    region <- rbind(region, read.table(file=region_fname[2], header=F, row.names=1))
    region <- rbind(region, read.table(file=region_fname[3], header=F, row.names=1))

    good <- error_summary$numparents == 1 & error_summary$ambig == 0

    error_summary.good <- error_summary[good,]
    region.good <- region[good,]

    aggregate(error_summary.good$error, by=list(region.good), function(x){c(mean(x), length(x))})
}



merge_delta_q_data <- function(runs, delta_q_data){

    n_tables <- length(delta_q_data)
    merge_table <- data.frame()
    for(i in 1:n_tables){
        n_regions <- nrow(delta_q_data[[i]])
        mini_table <- data.frame(run=rep(runs[i], n_regions),
                                 region=delta_q_data[[i]][["Group.1"]],
                                 error=delta_q_data[[i]][,"x"][,1],
                                 n_seqs=delta_q_data[[i]][,"x"][,2])

        merge_table <- rbind(merge_table, mini_table)
    }

    merge_table[order(merge_table$region, merge_table$run),]
}


get_pc_errors <- function(run, region){

    path <- paste0("data/process/", run, "/")
    mocks <- c("Mock1_S1", "Mock2_S2", "Mock3_S3")

    error_summary_fname <- paste0("data/process/", run, "/", mocks, "_L001_R1_001.6.contigs.", region, ".filter.unique.precluster.error.summary")
    error_summary <- read.table(file=error_summary_fname[1], header=T, row.names=1)
    error_summary <- rbind(error_summary, read.table(file=error_summary_fname[2], header=T, row.names=1))
    error_summary <- rbind(error_summary, read.table(file=error_summary_fname[3], header=T, row.names=1))

    good <- error_summary$numparents == 1 & error_summary$ambig == 0

    error_summary.good <- error_summary[good,]

    nseqs <- sum(error_summary.good$weight)
    error <- sum(error_summary.good$weight * error_summary.good$error) / nseqs
    c(error=error, n_seqs=nseqs)
}


get_nochim_otus <- function(run, region){

    path <- paste0("data/process/", run, "/")
    mocks <- c("Mock1_S1", "Mock2_S2", "Mock3_S3")

    ave_std_summary <- paste0("data/process/", run, "/", mocks, "_L001_R1_001.6.contigs.", region, ".filter.unique.precluster.perfect.an.ave-std.summary")

    data_there <- file.info(ave_std_summary)$size != 0
    n_files <- sum(data_there)

    if(n_files != 0){
        sobs <- vector()

        sobs_summary <- lapply(ave_std_summary[data_there], read.table, header=T)

        for(i in 1:n_files){
            sobs[i] <- sobs_summary[[i]][1,"sobs"]
        }
    } else {
        sobs <- NA
    }

    mean(sobs)
}



get_typical_otus <- function(run, region){

    path <- paste0("data/process/", run, "/")
    libraries <- c("Mock1_S1", "Mock2_S2", "Mock3_S3",
                    "Soil1_S4", "Soil2_S5", "Soil3_S6",
                    "Human1_S7", "Human2_S8", "Human3_S9",
                    "Mouse1_S10", "Mouse2_S11", "Mouse3_S12")
    type <- gsub("\\d.*", "", libraries)

    ave_std_summary <- paste0("data/process/", run, "/", libraries, "_L001_R1_001.6.contigs.", region, ".filter.unique.precluster.pick.an.ave-std.summary")

    data_there <- file.info(ave_std_summary)$size != 0
    n_files <- sum(data_there)

###problems here when some of the files are empty and others are not
###may need to break this up so that we pass it a set of libraries

    if(n_files != 0){
        sobs <- vector()

        sobs_summary <- lapply(ave_std_summary[data_there], read.table, header=T)

        for(i in 1:n_files){
            sobs[i] <- sobs_summary[[i]][1,"sobs"]
        }
    } else {
        sobs <- NA
    }
###problems here when some of the files are empty and others are not

    ave_sobs <- aggregate(sobs, by=list(type), mean)
    return_sobs <- ave_sobs$x
    names(return_sobs) <- ave_sobs$Group.1
    return_sobs
}



#Region and run
#folders <- list.dirs("data/process", recursive=FALSE)
#error_run <- grepl("data/process/1", folders)
#error_folders <- folders[error_run]
#runs <- gsub("data/process/", "", error_folders)
runs <- c("121203", "121205", "121207")
regions <- c("v34", "v4", "v45")
runs_regions <- expand.grid(runs=runs, regions=regions)


#Basic error rate
delta_0 <- lapply(runs, get_dq_errors, delta_q=0)
delta_0_table <- merge_delta_q_data(runs, delta_0)


#deltaQ=6 error rate
delta_6 <- lapply(runs, get_dq_errors, delta_q=6)
delta_6_table <- merge_delta_q_data(runs, delta_6)


#Precluster error rate
pc_report <- mapply(get_pc_errors, run=runs_regions$runs, region=runs_regions$regions)
pc_table <- cbind(runs_regions, t(pc_report))


#% reads remaining from basic (deltaQ=0)
per_reads_remaining <- 100 * delta_6_table$n_seqs / delta_0_table$n_seqs
per_reads_table <- cbind(runs_regions, t(per_reads_remaining))


#Mock^b - Sobs with perfect chimera removal
perfect_sobs <- mapply(get_nochim_otus, run=runs_regions$runs, region=runs_regions$regions)
perfect_sobs_table <- cbind(runs_regions, perfect_sobs)


typical_sobs <- mapply(get_typical_otus, run=runs_regions$runs, region=runs_regions$regions)
typical_sobs_table <- cbind(runs_regions, perfect_sobs)
