#!/bin/bash

################################################################################
#
# noseq_error_analysis.sh
#
#
# Here we look for the number of OTUs we'd expect from each of the three regions
# if there were no sequencing errors and no chimeras
#
# Dependencies...
# * data/references/HMP_MOCK.align
# * data/references/start_stop.positions
#
# Produces...
# * data/process/noseq_error/HMP_MOCK.v34.summary
# * data/process/noseq_error/HMP_MOCK.v45.summary
# * data/process/noseq_error/HMP_MOCK.v4.summary
#
################################################################################

run_mothur (){
	START=$1
	END=$2
	REGION=$3
	
	mkdir -p data/process/noseq_error
	
	mothur "#set.dir(output=data/process/noseq_error);
			pcr.seqs(fasta=data/references/HMP_MOCK.align, start=$START, end=$END);
			filter.seqs(fasta=current, trump=., vertical=.);
			unique.seqs(fasta=current);
			dist.seqs(fasta=current, cutoff=0.20);
			cluster(column=current, name=current);
			summary.single(list=current, label=0.03, calc=sobs)"

	mv data/process/noseq_error/HMP_MOCK.pcr.filter.unique.an.summary data/process/noseq_error/HMP_MOCK.$REGION.summary	
}



V4_START=$(grep "V4 " data/references/start_stop.positions | cut -f 2 -d " ")
V4_END=$(grep "V4 " data/references/start_stop.positions | cut -f 3 -d " ")
run_mothur $V4_START $V4_END v4

V34_START=$(grep "V34" data/references/start_stop.positions | cut -f 2 -d " ")
V34_END=$(grep "V34" data/references/start_stop.positions | cut -f 3 -d " ")
run_mothur $V34_START $V34_END v34

V45_START=$(grep "V45" data/references/start_stop.positions | cut -f 2 -d " ")
V45_END=$(grep "V45" data/references/start_stop.positions | cut -f 3 -d " ")
run_mothur $V45_START $V45_END v45


# garbage collection
rm data/process/noseq_error/HMP_MOCK.pcr.filter.unique.an.list
rm data/process/noseq_error/HMP_MOCK.pcr.filter.unique.an.rabund
rm data/process/noseq_error/HMP_MOCK.pcr.filter.unique.an.sabund
rm data/process/noseq_error/HMP_MOCK.pcr.filter.unique.dist
rm data/process/noseq_error/HMP_MOCK.pcr.filter.names
rm data/process/noseq_error/HMP_MOCK.pcr.filter.unique.fasta
rm data/process/noseq_error/HMP_MOCK.pcr.filter.fasta
rm data/process/noseq_error/HMP_MOCK.filter
rm data/process/noseq_error/HMP_MOCK.pcr.align
rm data/process/noseq_error/mothur.*.logfile


# keep
# data/process/noseq_error/HMP_MOCK.v34.summary
# data/process/noseq_error/HMP_MOCK.v45.summary
# data/process/noseq_error/HMP_MOCK.v4.summary
