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



# here are the pretty standard mothur commands for sequence processing, 
# pre-clustering, chimera removal, clustering into OTUs, and determining the
# number of OTUs
run_mothur () {
	ALIGN=$1
	NAMES=$2
	REGION=$3
	
	mothur "#filter.seqs(fasta=$ALIGN, vertical=T, trump=., processors=12);
		unique.seqs(fasta=current, name=$NAMES);
		pre.cluster(fasta=current, name=current, diffs=2);
		chimera.uchime(fasta=current, name=current);
		remove.seqs(fasta=current, name=current, accnos=current);
		dist.seqs(fasta=current, cutoff=0.20, processors=8);
		cluster(column=current, name=current);
		summary.single(rabund=current, calc=nseqs-sobs, label=0.03, subsample=5000)"
	
	
	touch $(echo $CONTIG_FASTA | sed 's/.fasta//').$REGION.filter.unique.precluster.pick.an.ave-std.summary
	touch $(echo $CONTIG_FASTA | sed 's/.fasta//').$REGION.filter.unique.precluster.pick.an.summary
}


# run the function on the three datasets...
run_mothur $V4_ALIGN $V4_NAMES v4
run_mothur $V34_ALIGN $V34_NAMES v34
run_mothur $V45_ALIGN $V45_NAMES v45



# garbage collection
CONTIG_STUB=$(echo $CONTIG_FASTA | sed -E s/.fasta//)
rm $CONTIG_STUB.v{34,4,45}.filter.unique.precluster.pick.an.list
rm $CONTIG_STUB.v{34,4,45}.filter.unique.precluster.pick.an.rabund
rm $CONTIG_STUB.v{34,4,45}.filter.unique.precluster.pick.an.sabund
rm $CONTIG_STUB.v{34,4,45}.filter.unique.precluster.pick.dist
rm $CONTIG_STUB.v{34,4,45}.filter.unique.precluster.uchime.chimeras
rm $CONTIG_STUB.v{34,4,45}.filter.unique.precluster.uchime.accnos


# keeping...
# $CONTIG_STUB.v{34,4,45}.filter.unique.precluster.pick.an.ave-std.summary	#the number of OTUs w/ rarefaction to 5000 seqs
# $CONTIG_STUB.v{34,4,45}.filter.unique.precluster.pick.an.summary	#the number of OTUs and sequences w/o rarefaction
# $CONTIG_STUB.v{34,4,45}.filter.unique.precluster.pick.fasta	#the unique, filtered, region-specific alignment, post preclustering, and chimera removal
# $CONTIG_STUB.v{34,4,45}.filter.unique.precluster.pick.names	#the unique, filtered, region-specific alignment, post preclustering, and chimera removal
# $CONTIG_STUB.v{34,4,45}.filter.unique.precluster.names #the unique, filtered, region-specific alignment, post preclustering
# $CONTIG_STUB.v{34,4,45}.filter.unique.precluster.fasta #the unique, filtered, region-specific alignment, post preclustering
# $CONTIG_STUB.v{34,4,45}.filter.names		#the unique, filtered, region-specific alignment
# $CONTIG_STUB.v{34,4,45}.filter.unique.fasta #the unique, filtered, region-specific alignment
# $CONTIG_STUB.report	#from make.contigs - not create here
# $CONTIG_STUB.fasta	#from make.contigs - not create here
