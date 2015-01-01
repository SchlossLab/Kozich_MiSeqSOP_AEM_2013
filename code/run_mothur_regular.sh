#!/bin/bash

################################################################################
#
# run_mothur_regular.sh
#
#
# Here we run the *contigs.fasta files through mothur like we would in a normal
# study
#
# Dependencies...
# * A *.contigs.fasta file as input
# * The data/references/start_stop.positions file
#
# Produces...
# * OTU assignments for each of the three regions
# * *.v#.filter.unique.precluster.pick.an.ave-std.summary, which contains the
#   number of OTUs that were observed after rarefying to 5000 sequences
# * *.v#.filter.unique.precluster.pick.an.summary, which contains the number of
#	OTUs and sequences that were observed without rarefying
#
################################################################################

CONTIG_FASTA=$1
ALIGN_REF=data/references/silva.bacteria.align

# we will remove any contig with an N in it; unique them, and then align them
# to the full silva.bacteria.align reference 
mothur "screen.seqs(fasta=$CONTIG_FASTA, maxambig=0, processors=12);
	unique.seqs(fasta=current);
	align.seqs(fasta=current, reference=$ALIGN_REF, processors=4);"
			
ALL_ALIGN=$(echo $CONTIG_FASTA | sed -E s/fasta/good.unique.align/)
ALL_NAMES=$(echo $CONTIG_FASTA | sed -E s/fasta/good.names/)
ALL_GOOD_ALIGN=$(echo $CONTIG_FASTA | sed -E s/fasta/good.unique.good.align/)
ALL_GOOD_NAMES=$(echo $CONTIG_FASTA | sed -E s/fasta/good.good.names/)


# now we run screen.seqs with the data in data/references/start_stop.positions
# to pull out the v4 region
V4_ALIGN=$(echo $CONTIG_FASTA | sed -E s/fasta/v4.align/)
V4_NAMES=$(echo $CONTIG_FASTA | sed -E s/fasta/v4.names/)
V4_START=$(grep "V4 " data/references/start_stop.positions | cut -f 2 -d " ")
V4_END=$(grep "V4 " data/references/start_stop.positions | cut -f 3 -d " ")

mothur "#screen.seqs(fasta=$ALL_ALIGN, name=$ALL_NAMES, start=$V4_START, end=$V4_END, maxlength=260, processors=12)"
mv $ALL_GOOD_ALIGN $V4_ALIGN
mv $ALL_GOOD_NAMES $V4_NAMES


# now we run screen.seqs with the data in data/references/start_stop.positions
# to pull out the v34 region
V34_ALIGN=$(echo $CONTIG_FASTA | sed -E s/fasta/v34.align/)
V34_NAMES=$(echo $CONTIG_FASTA | sed -E s/fasta/v34.names/)
V34_START=$(grep "V34" data/references/start_stop.positions | cut -f 2 -d " ")
V34_END=$(grep "V34" data/references/start_stop.positions | cut -f 3 -d " ")

mothur "#screen.seqs(fasta=$ALL_ALIGN, name=$ALL_NAMES, start=$V34_START, end=$V34_END, maxlength=450, processors=12)"
mv $ALL_GOOD_ALIGN $V34_ALIGN
mv $ALL_GOOD_NAMES $V34_NAMES


# now we run screen.seqs with the data in data/references/start_stop.positions
# to pull out the v45 region
V45_ALIGN=$(echo $CONTIG_FASTA | sed -E s/fasta/v45.align/)
V45_NAMES=$(echo $CONTIG_FASTA | sed -E s/fasta/v45.names/)
V45_START=$(grep "V45" data/references/start_stop.positions | cut -f 2 -d " ")
V45_END=$(grep "V45" data/references/start_stop.positions | cut -f 3 -d " ")

mothur "#screen.seqs(fasta=$ALL_ALIGN, name=$ALL_NAMES, start=$V45_START, end=$V45_END, maxlength=400, processors=12)"
mv $ALL_GOOD_ALIGN $V45_ALIGN
mv $ALL_GOOD_NAMES $V45_NAMES


# here are the pretty standard mothur commands for sequence processing, 
# pre-clustering, chimera removal, clustering into OTUs, and determining the
# number of OTUs
run_mothur () {
	ALIGN=$1
	NAMES=$2
	mothur "#filter.seqs(fasta=$ALIGN, vertical=T, trump=., processors=12);
		unique.seqs(fasta=current, name=$NAMES);
		pre.cluster(fasta=current, name=current, diffs=2);
		chimera.uchime(fasta=current, name=current);
		remove.seqs(fasta=current, name=current, accnos=current);
		dist.seqs(fasta=current, cutoff=0.20, processors=8);
		cluster(column=current, name=current);
		summary.single(rabund=current, calc=nseqs-sobs, label=0.03, subsample=5000)"
}


# run the function on the three datasets...
run_mothur $V4_ALIGN $V4_NAMES
run_mothur $V34_ALIGN $V34_NAMES
run_mothur $V45_ALIGN $V45_NAMES



# garbage collection
CONTIG_STUB=$(echo $CONTIG_FASTA | sed -E s/.fasta//)
rm $CONTIG_STUB.v*.filter.unique.precluster.pick.an.list
rm $CONTIG_STUB.v*.filter.unique.precluster.pick.an.rabund
rm $CONTIG_STUB.v*.filter.unique.precluster.pick.an.sabund
rm $CONTIG_STUB.v*.filter.unique.precluster.pick.dist
rm $CONTIG_STUB.v*.filter.unique.precluster.uchime.chimeras
rm $CONTIG_STUB.v*.filter.unique.precluster.uchime.accnos
rm $CONTIG_STUB.v*.filter.unique.precluster.map
rm $CONTIG_STUB.v*.filter.fasta
rm $CONTIG_STUB.v*.names
rm $CONTIG_STUB.v*.align
rm $CONTIG_STUB.good.unique.flip.accnos
rm $CONTIG_STUB.good.unique.align.report
rm $CONTIG_STUB.good.unique.align
rm $CONTIG_STUB.good.names
rm $CONTIG_STUB.good.unique.bad.accnos
rm $CONTIG_STUB.good.unique.fasta
rm $CONTIG_STUB.bad.accnos
rm $CONTIG_STUB.good.fasta


# keeping...
# $CONTIG_STUB.v*.filter.unique.precluster.pick.an.ave-std.summary	#the number of OTUs w/ rarefaction to 5000 seqs
# $CONTIG_STUB.v*.filter.unique.precluster.pick.an.summary	#the number of OTUs and sequences w/o rarefaction
# $CONTIG_STUB.v*.filter.unique.precluster.pick.fasta	#the unique, filtered, region-specific alignment, post preclustering, and chimera removal
# $CONTIG_STUB.v*.filter.unique.precluster.pick.names	#the unique, filtered, region-specific alignment, post preclustering, and chimera removal
# $CONTIG_STUB.v*.filter.unique.precluster.names #the unique, filtered, region-specific alignment, post preclustering
# $CONTIG_STUB.v*.filter.unique.precluster.fasta #the unique, filtered, region-specific alignment, post preclustering
# $CONTIG_STUB.v*.filter.names		#the unique, filtered, region-specific alignment
# $CONTIG_STUB.v*.filter.unique.fasta #the unique, filtered, region-specific alignment
# $CONTIG_STUB.report	#from make.contigs
# $CONTIG_STUB.fasta	#from make.contigs
