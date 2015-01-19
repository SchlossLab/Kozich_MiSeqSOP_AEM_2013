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

FASTA=$1    #data/process/no_metag/no_metag.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta
COUNT=$2    #data/process/no_metag/no_metag.trim.contigs.good.unique.good.filter.unique.precluster.uchime.pick.pick.count_table

PICK_FASTA=$(echo $FASTA | sed -E 's/fasta/pick.fasta/')
PICK_COUNT=$(echo $COUNT | sed -E 's/count_table/pick.count_table/')

MOCK_FASTA=$(echo $FASTA | sed -E 's/fasta/mock.fasta/')
MOCK_COUNT=$(echo $COUNT | sed -E 's/count_table/mock.count_table/')

PROCESS_PATH=$(echo $FASTA | sed -E 's/\/[^/]*$//')

echo Mock mock > mock.design
echo Mock2 mock >> mock.design

mothur "#set.dir(output=$PROCESS_PATH);
    get.groups(count=$COUNT, fasta=$FASTA, groups=Mock-Mock2);
    system(mv $PICK_FASTA $MOCK_FASTA);
    system(mv $PICK_COUNT $MOCK_COUNT);
    seq.error(fasta=$MOCK_FASTA, count=$MOCK_COUNT, reference=data/references/HMP_MOCK.fasta, aligned=F, processors=8);
    dist.seqs(fasta=$MOCK_FASTA, cutoff=0.10);
    cluster(count=$MOCK_COUNT);
    make.shared(label=0.03);
    merge.groups(design=mock.design);
    summary.single(calc=sobs, subsample=5000)"


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
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.mock.dist
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.mock.an.unique_list.shared
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.mock.an.unique_list.Mock.rabund
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.mock.an.unique_list.Mock2.rabund
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.mock.an.unique_list.merge.shared
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.mock.an.unique_list.merge.groups.summary
rm mock.design


# Keeping...
# $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.mock.error.summary
