#!/bin/bash

################################################################################
#
# get_shared_mice.sh
#
#
# Here we run the data/raw/*metag/*.files through mothur like we would in a
# normal study and outputs a shared file
#
# Dependencies...
# * data/raw/*metag/*.files
#
# Produces...
# * *.an.shared
#
################################################################################

FILES_FILE=$1
RAW_PATH=$(echo $FILES_FILE | sed -E 's/(.*)\/[^\/]*/\1/')
PROCESS_PATH=$(echo $RAW_PATH | sed -E 's/raw/process/')
mkdir -p $PROCESS_PATH

mothur "#pcr.seqs(fasta=data/references/silva.bacteria.align, start=11894, end=25319, keepdots=F, processors=12)"
mv data/references/silva.bacteria.pcr.align $PROCESS_PATH/silva.v4.align


mothur "#set.dir(output=$PROCESS_PATH);
	make.contigs(inputdir=$RAW_PATH, file=$FILES_FILE, processors=12);
	screen.seqs(fasta=current, group=current, maxambig=0, maxlength=275);
	unique.seqs();
	count.seqs(name=current, group=current);
	align.seqs(fasta=current, reference=silva.v4.align);
	screen.seqs(fasta=current, count=current, start=1968, end=11550, maxhomop=8);
	filter.seqs(fasta=current, vertical=T, trump=.);
	unique.seqs(fasta=current, count=current);
	pre.cluster(fasta=current, count=current, diffs=2);
	chimera.uchime(fasta=current, count=current, dereplicate=t);
	remove.seqs(fasta=current, accnos=current);
	classify.seqs(fasta=current, count=current, reference=data/references/trainset9_032012.pds.fasta, taxonomy=data/references/trainset9_032012.pds.tax, cutoff=80);
	remove.lineage(fasta=current, count=current, taxonomy=current, taxon=Chloroplast-Mitochondria-unknown-Archaea-Eukaryota);
	remove.groups(count=current, fasta=current, taxonomy=current, groups=Mock-Mock2);
	cluster.split(fasta=current, count=current, taxonomy=current, splitmethod=classify, taxlevel=4, cutoff=0.15);
	make.shared(list=current, count=current, label=0.03);
	classify.otu(list=current, count=current, taxonomy=current, label=0.03);"
