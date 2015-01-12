#!/bin/bash

################################################################################
#
# get_summary_from_precluster.sh.sh
#
#
# Here we run the *precluster.fasta and *precluster.names files through mothur
# like we would in a normal study to get a sense of the number of OTUs we would
# observe
#
# Dependencies...
# * *.precluster.fasta
# * *.precluster.names
#
# Produces...
# * OTU assignments for each of the three regions
# * *.v#.filter.unique.precluster.pick.an.ave-std.summary, which contains the
#   number of OTUs that were observed after rarefying to 5000 sequences
# * *.v#.filter.unique.precluster.pick.an.summary, which contains the number of
#	OTUs and sequences that were observed without rarefying
#
################################################################################

FASTA=$1
NAMES=$2

# here are the pretty standard mothur commands for sequence processing, 
# pre-clustering, chimera removal, clustering into OTUs, and determining the
# number of OTUs
run_mothur () {
	PRECLUSTER_FASTA=$1
	PRECLUSTER_NAMES=$2
	
	mothur "chimera.uchime(fasta=$PRECLUSTER_FASTA, name=$PRECLUSTER_NAMES);
		remove.seqs(fasta=current, name=current, accnos=current);
		dist.seqs(fasta=current, cutoff=0.20, processors=8);
		cluster(column=current, name=current);
		summary.single(rabund=current, calc=nseqs-sobs, label=0.03, subsample=5000)"
	
	
	touch $(echo $PRECLUSTER_FASTA | sed 's/.fasta//').pick.an.ave-std.summary
	touch $(echo $PRECLUSTER_FASTA | sed 's/.fasta//').pick.an.summary
}


# run the function on the three datasets...
run_mothur $FASTA $NAMES



# garbage collection
PRECLUSTER_STUB=$(echo $FASTA | sed -E s/.fasta//)
rm $PRECLUSTER_STUB.pick.an.list
rm $PRECLUSTER_STUB.pick.an.rabund
rm $PRECLUSTER_STUB.pick.an.sabund
rm $PRECLUSTER_STUB.pick.dist
rm $PRECLUSTER_STUB.uchime.chimeras
rm $PRECLUSTER_STUB.uchime.accnos


# keeping...
# $PRECLUSTER_STUB.pick.an.ave-std.summary	#the number of OTUs w/ rarefaction to 5000 seqs
# $PRECLUSTER_STUB.pick.an.summary			#the number of OTUs and sequences w/o rarefaction
# $PRECLUSTER_STUB.pick.fasta				#the unique, filtered, region-specific alignment, post preclustering, and chimera removal
# $PRECLUSTER_STUB.pick.names				#the unique, filtered, region-specific alignment, post preclustering, and chimera removal
# $PRECLUSTER_STUB.v{34,4,45}.names 		#the unique, filtered, region-specific alignment, post preclustering
# $PRECLUSTER_STUB.v{34,4,45}.fasta 		#the unique, filtered, region-specific alignment, post preclustering
