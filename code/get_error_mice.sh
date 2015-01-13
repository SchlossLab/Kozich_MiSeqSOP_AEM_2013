#!/bin/bash

################################################################################
#
# get_error_mice.sh
#
#
# Here we run the data/raw/*metag/*.[fasta,count] files through mothur to
# calculate the sequencing error rate that was observed when we resequenced the
# mouse data.
#
# Dependencies...
# * $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta
# * $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.uchime.pick.pick.count_table
#
# Produces...
# * $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.mock.error.summary
#
################################################################################

FASTA=data/process/no_metag/no_metag.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta
COUNT=data/process/no_metag/no_metag.trim.contigs.good.unique.good.filter.unique.precluster.uchime.pick.pick.count_table

PICK_FASTA=data/process/no_metag/no_metag.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.fasta
PICK_COUNT=data/process/no_metag/no_metag.trim.contigs.good.unique.good.filter.unique.precluster.uchime.pick.pick.pick.count_table

MOCK_FASTA=data/process/no_metag/no_metag.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.mock.fasta
MOCK_COUNT=data/process/no_metag/no_metag.trim.contigs.good.unique.good.filter.unique.precluster.uchime.pick.pick.mock.count_table

PROCESS_PATH=$(echo $FASTA | sed -E 's/\/[^/]*$//')

mothur "#set.dir(output=$PROCESS_PATH);
    get.groups(count=$COUNT, fasta=$FASTA, groups=Mock-Mock2);
    system(mv $PICK_FASTA $MOCK_FASTA);
    system(mv $PICK_COUNT $MOCK_COUNT);
    seq.error(fasta=$MOCK_FASTA, count=$MOCK_COUNT, reference=data/references/HMP_MOCK.fasta, aligned=F, processors=8)"


# Garbage collection
rm $MOCK_FASTA
rm $MOCK_COUNT
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.mock.error.seq
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.mock.error.chimera
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.mock.error.seq.forward
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.mock.error.seq.reverse
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.mock.error.count
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.mock.error.matrix
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.mock.error.ref


# Keeping...
# $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.mock.error.summary
