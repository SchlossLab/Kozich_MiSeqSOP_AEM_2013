#!/bin/bash

################################################################################
#
# single_read_analysis.sh
#
#
# Here we get the error rates for the individual sequence reads
#
# Dependencies...
# * The assembled *.contigs.fasta file
#
# Produces
# * The error data for each individual read from the *.error.summary file
# * The starting and ending coordinates for every aligned read
#
################################################################################

CONTIGS=$1

#need to get the paths
PROCESS_PATH=$(echo $CONTIGS | sed -e 's/\/Mock.*fasta//')
FILE_STUB=$(echo $CONTIGS | sed -e 's/.*\/\(Mock.*\).fasta/\1/')
PROCESS_STUB=$PROCESS_PATH/$FILE_STUB

mothur "#set.dir(output=$PROCESS_PATH/);
    align.seqs(fasta=$CONTIGS, reference=data/references/HMP_MOCK.align, processors=12);
    summary.seqs();
    filter.seqs(fasta=current-data/references/HMP_MOCK.align, vertical=T);
    seq.error(fasta=current, reference=$PROCESS_PATH/HMP_MOCK.filter.fasta);"

rm $PROCESS_STUB.align
rm $PROCESS_STUB.align.report
rm $PROCESS_STUB.filter.fasta
