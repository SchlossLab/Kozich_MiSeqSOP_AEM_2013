################################################################################
#
# split_big_contigs.sh
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
# * *.v#.filter.unique.precluster.fasta
# * *.v#.filter.unique.precluster.names
#
################################################################################

CONTIG_FASTA=$1
ALIGN_REF=data/references/silva.bacteria.align

# we will remove any contig with an N in it; unique them, and then align them
# to the full silva.bacteria.align reference 
mothur "#screen.seqs(fasta=$CONTIG_FASTA, maxambig=0, processors=12);
	unique.seqs(fasta=current);
	align.seqs(fasta=current, reference=$ALIGN_REF, processors=12);"
			
ALL_ALIGN=$(echo $CONTIG_FASTA | sed -E s/fasta/good.unique.align/)
ALL_NAMES=$(echo $CONTIG_FASTA | sed -E s/fasta/good.names/)


run_mothur_on_regions () {
	ALIGN=$1
	NAMES=$2
	REGION=$3
	MAXLENGTH=$4
	
	REGION_START=$(grep -i "$REGION " data/references/start_stop.positions | cut -f 2 -d " ")
	REGION_END=$(grep -i "$REGION " data/references/start_stop.positions | cut -f 3 -d " ")

	mothur "#screen.seqs(fasta=$ALIGN, name=$NAMES, start=$REGION_START, end=$REGION_END, maxlength=$MAXLENGTH, processors=12)"

	ALL_GOOD_ALIGN=$(echo $ALIGN | sed -E s/align/good.align/)
	ALL_GOOD_NAMES=$(echo $NAMES | sed -E s/names/good.names/)

	REGION_ALIGN=$(echo $ALL_GOOD_ALIGN | sed -E s/good.unique.good/$REGION/)
	REGION_NAMES=$(echo $ALL_GOOD_NAMES | sed -E s/good.good/$REGION/)

	mv $ALL_GOOD_ALIGN $REGION_ALIGN
	mv $ALL_GOOD_NAMES $REGION_NAMES

	mothur "#filter.seqs(fasta=$REGION_ALIGN, vertical=T, trump=., processors=12);
		unique.seqs(fasta=current, name=$REGION_NAMES);
		pre.cluster(fasta=current, name=current, diffs=2);"
}

run_mothur_on_regions $ALL_ALIGN $ALL_NAMES v4 260
run_mothur_on_regions $ALL_ALIGN $ALL_NAMES v34 450
run_mothur_on_regions $ALL_ALIGN $ALL_NAMES v45 400



# Garbage collection
CONTIG_STUB=$(echo $CONTIG_FASTA | sed -E s/.fasta//)
rm *.filter
rm $CONTIG_STUB.v{34,4,45}.filter.unique.precluster.map
rm $CONTIG_STUB.v{34,4,45}.filter.fasta
rm $CONTIG_STUB.v{34,4,45}.names
rm $CONTIG_STUB.v{34,4,45}.align
rm $CONTIG_STUB.good.unique.flip.accnos
rm $CONTIG_STUB.good.unique.align.report
rm $CONTIG_STUB.good.unique.align
rm $CONTIG_STUB.good.names
rm $CONTIG_STUB.good.unique.bad.accnos
rm $CONTIG_STUB.good.unique.fasta
rm $CONTIG_STUB.bad.accnos
rm $CONTIG_STUB.good.fasta
rm $CONTIG_STUB.good.unique.flip.accnos
rm $CONTIG_STUB.good.unique.align.report
rm $CONTIG_STUB.good.unique.align
rm $CONTIG_STUB.good.names
rm $CONTIG_STUB.good.unique.bad.accnos
rm $CONTIG_STUB.good.unique.fasta
rm $CONTIG_STUB.bad.accnos
rm $CONTIG_STUB.good.fasta


# Keeping...
# $CONTIG_STUB.v{34,4,45}.filter.unique.precluster.fasta
# $CONTIG_STUB.v{34,4,45}.filter.unique.precluster.names
# $CONTIG_STUB.report	#from make.contigs - not create here
# $CONTIG_STUB.fasta	#from make.contigs - not create here
