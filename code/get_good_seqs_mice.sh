#!/bin/bash

################################################################################
#
# get_good_seqs_mice.sh
#
#
# Here we run the data/raw/*metag/*.files through mothur like we would in a
# normal study to the point of generating the final reads that go into
# cluster.split
#
# Dependencies...
# * data/raw/*metag/*.files
#
# Produces...
# * *.precluster.pick.pick.fasta
# * *.precluster.uchime.pick.pick.count_table
# * *.precluster.pick.pds.wang.pick.taxonomy
#
################################################################################

FILES_FILE=$1
RAW_PATH=$(echo $FILES_FILE | sed -E 's/(.*)\/[^\/]*/\1/')
PROCESS_PATH=$(echo $RAW_PATH | sed -E 's/raw/process/')
mkdir -p $PROCESS_PATH

mothur "#pcr.seqs(outputdir=$PROCESS_PATH, fasta=data/references/silva.bacteria.align, start=11894, end=25319, keepdots=F, processors=12)"
mv $PROCESS_PATH/silva.bacteria.pcr.align $PROCESS_PATH/silva.v4.align


mothur "#set.dir(output=$PROCESS_PATH);
	make.contigs(inputdir=$RAW_PATH, file=$FILES_FILE, processors=12);
	screen.seqs(fasta=current, group=current, maxambig=0, maxlength=275, maxhomop=8);
	unique.seqs();
	count.seqs(name=current, group=current);
	align.seqs(fasta=current, reference=$PROCESS_PATH/silva.v4.align);
	screen.seqs(fasta=current, count=current, start=1968, end=11550);
	filter.seqs(fasta=current, vertical=T, trump=.);
	unique.seqs(fasta=current, count=current);
	pre.cluster(fasta=current, count=current, diffs=2);
	chimera.uchime(fasta=current, count=current, dereplicate=T);
	remove.seqs(fasta=current, accnos=current);
	classify.seqs(fasta=current, count=current, reference=data/references/trainset9_032012.pds.fasta, taxonomy=data/references/trainset9_032012.pds.tax, cutoff=80);
	remove.lineage(fasta=current, count=current, taxonomy=current, taxon=Chloroplast-Mitochondria-unknown-Archaea-Eukaryota);"



# Garbage collection
rm $PROCESS_PATH/silva.v4.8mer
rm $PROCESS_PATH/silva.v4.align
rm $PROCESS_PATH/silva.v4.summary
rm $PROCESS_PATH/*.contigs.good.groups
rm $PROCESS_PATH/*.contigs.groups
rm $PROCESS_PATH/*.contigs.report
rm $PROCESS_PATH/*.scrap.contigs.fasta
rm $PROCESS_PATH/*.trim.contigs.bad.accnos
rm $PROCESS_PATH/*.trim.contigs.fasta
rm $PROCESS_PATH/*.trim.contigs.good.count_table
rm $PROCESS_PATH/*.trim.contigs.good.fasta
rm $PROCESS_PATH/*.trim.contigs.good.good.count_table
rm $PROCESS_PATH/*.trim.contigs.good.names
rm $PROCESS_PATH/*.trim.contigs.good.unique.align
rm $PROCESS_PATH/*.trim.contigs.good.unique.align.report
rm $PROCESS_PATH/*.trim.contigs.good.unique.bad.accnos
rm $PROCESS_PATH/*.trim.contigs.good.unique.fasta
rm $PROCESS_PATH/*.trim.contigs.good.unique.flip.accnos
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.align
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.count_table
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.fasta
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.fasta
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.count_table
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.fasta
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.uchime.pick.count_table
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.uchime.chimeras
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.uchime.accnos
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.tax.summary
rm $PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.taxonomy


#keeping...
#	$PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.pick.taxonomy
#	$PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta
#	$PROCESS_PATH/*.trim.contigs.good.unique.good.filter.unique.precluster.uchime.pick.pick.count_table
