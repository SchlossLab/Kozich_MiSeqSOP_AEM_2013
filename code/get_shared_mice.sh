#!/bin/bash

################################################################################
#
# get_shared_mice.sh
#
#
# Here we run the data/raw/*metag/*.[fasta,count,taxonomy] files through mothur
# like we would in a normal study to the point of generating the final shared
# file and the cons.taxonomy file that indicates the 'name' for each OTU. The
# input files have been run through get_good_seqs_mice.sh
#
# Dependencies...
# * data/process/*/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta
# * data/process/*/*.trim.contigs.good.unique.good.filter.unique.precluster.uchime.pick.pick.count_table
# * data/process/*/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.pick.taxonomy
#
# Produces...
# * data/process/*/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.an.unique_list.shared
# * data/process/*/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.an.unique_list.0.03.cons.taxonomy
#
################################################################################

FASTA=$1
COUNT=$2
TAXONOMY=$3

PROCESS_PATH=$(echo $FASTA | sed -E 's/[^/]*$//')

mothur "#set.dir(output=$PROCESS_PATH);
    remove.groups(count=$COUNT, fasta=$FASTA, taxonomy=$TAXONOMY, groups=Mock-Mock2);
    cluster.split(fasta=current, count=current, taxonomy=current, splitmethod=classify, taxlevel=4, cutoff=0.15, processors=8);
    make.shared(list=current, count=current, label=0.03);
    classify.otu(list=current, count=current, taxonomy=current, label=0.03);"



# Garbage collection
rm $PROCESS_PATH/*/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.fasta
rm $PROCESS_PATH/*/*.trim.contigs.good.unique.good.filter.unique.precluster.uchime.pick.pick.pick.count_table
rm $PROCESS_PATH/*/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.pick.pick.taxonomy
rm $PROCESS_PATH/*/*.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.an.unique_list.list
rm $PROCESS_PATH/*/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.an.unique_list.*.rabund
rm $PROCESS_PATH/*/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.an.unique_list.0.03.cons.tax.summary

#keeping...
# $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.an.unique_list.0.03.cons.taxonomy
# $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.an.unique_list.shared
