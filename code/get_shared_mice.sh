#!/bin/bash

################################################################################
#
# get_shared_mice.sh
#
#
# Here we run the data/raw/*metag/*.[fasta,count,taxonomy] files through mothur
# like we would in a normal study to the point of generating the final shared
# file and the cons.taxonomy file that indicates the 'names' for each OTU
#
# Dependencies...
# *
#
# Produces...
# *
#
################################################################################

FASTA=data/process/no_metag/no_metag.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta
COUNT=data/process/no_metag/no_metag.trim.contigs.good.unique.good.filter.unique.precluster.uchime.pick.pick.count_table
TAXONOMY=data/process/no_metag/no_metag.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.pick.taxonomy

PROCESS_PATH=$(echo $FASTA | sed -E 's/[^/]*$//')

mothur "#set.dir(output=$PROCESS_PATH);
    remove.groups(count=$COUNT, fasta=$FASTA, taxonomy=$TAXONOMY, groups=Mock-Mock2);
    cluster.split(fasta=current, count=current, taxonomy=current, splitmethod=classify, taxlevel=4, cutoff=0.15);
    make.shared(list=current, count=current, label=0.03);
    classify.otu(list=current, count=current, taxonomy=current, label=0.03);"



# Garbage collection


#keeping...
