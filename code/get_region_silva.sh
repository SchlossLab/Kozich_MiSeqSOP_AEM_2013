#!/bin/bash

################################################################################
#
# get_region_silva.sh
#
#
# Here we generate region-specific versions of silva.bacteria.align based on
# the coordinates in data/references/start_stop.positions
#
# Dependencies...
# * silva.bacteria.align
# * data/references/start_stop.positions
#
# Produces...
#
################################################################################

ALIGN_REF=data/references/silva.bacteria.align
POS_REF=data/references/start_stop.positions
OUTPUT=data/references


run_mothur (){
	START=$1
	END=$2
	REGION=$3
		
	mothur "#set.dir(output=$OUTPUT/);
			pcr.seqs(fasta=$ALIGN_REF, start=$START, end=$END, keepdots=F, processors=12);
			unique.seqs(fasta=current);"

	mv $OUTPUT/silva.bacteria.pcr.unique.align $OUTPUT/silva.$REGION.align
}



V4_START=$(grep "V4 " $POS_REF | cut -f 2 -d " ")
V4_END=$(grep "V4 " $POS_REF | cut -f 3 -d " ")
run_mothur $V4_START $V4_END v4

V34_START=$(grep "V34" $POS_REF | cut -f 2 -d " ")
V34_END=$(grep "V34" $POS_REF | cut -f 3 -d " ")
run_mothur $V34_START $V34_END v34

V45_START=$(grep "V45" $POS_REF | cut -f 2 -d " ")
V45_END=$(grep "V45" $POS_REF | cut -f 3 -d " ")
run_mothur $V45_START $V45_END v45

V45_START=$(grep "V35" $POS_REF | cut -f 2 -d " ")
V45_END=$(grep "V35" $POS_REF | cut -f 3 -d " ")
run_mothur $V35_START $V35_END v35

# garbage collection
rm data/references/silva.bacteria.pcr.align
rm data/references/silva.bacteria.pcr.names
