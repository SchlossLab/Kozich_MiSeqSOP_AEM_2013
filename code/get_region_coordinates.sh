#!/bin/bash

################################################################################
#
# get_region_coordinates.sh
#
#
# Here we find the coordinates within the reference alignment, which correspond
# to the start and end positions of the three regions that we analyzed
#
# Dependencies...
# * HMP_MOCK.align
#
# Produces data/references/start_stop.positions
#
################################################################################

V3F=CCTACGGGAGGCAGCAG
V4F=GTGCCAGCMGCCGCGGTAA
V4R=GGACTACHVGGGTWTCTAAT
V5R=CCCGTCAATTCMTTTRAGT

> data/references/start_stop.positions

echo "forward $V3F" > data/references/v34.oligos
echo "reverse $V4R" >> data/references/v34.oligos
mothur "#pcr.seqs(fasta=data/references/HMP_MOCK.align, oligos=data/references/v34.oligos); summary.seqs()"

START=$(tail -n +2 data/references/HMP_MOCK.pcr.summary | cut -f 2 | awk '{if(max==""){max=$1}; if($1>max) {max=$1} } END {print max}') 
END=$(tail -n +2 data/references/HMP_MOCK.pcr.summary | cut -f 3 | awk '{if(min==""){min=$1}; if($1<min) {min=$1} } END {print min}')
echo "V34 $START $END" >> data/references/start_stop.positions

echo "forward $V4F" > data/references/v4.oligos
echo "reverse $V4R" >> data/references/v4.oligos
mothur "#pcr.seqs(fasta=data/references/HMP_MOCK.align, oligos=data/references/v4.oligos); summary.seqs()"

START=$(tail -n +2 data/references/HMP_MOCK.pcr.summary | cut -f 2 | awk '{if(max==""){max=$1}; if($1>max) {max=$1} } END {print max}') 
END=$(tail -n +2 data/references/HMP_MOCK.pcr.summary | cut -f 3 | awk '{if(min==""){min=$1}; if($1<min) {min=$1} } END {print min}')
echo "V4 $START $END" >> data/references/start_stop.positions


echo "forward $V4F" > data/references/v45.oligos
echo "reverse $V5R" >> data/references/v45.oligos
mothur "#pcr.seqs(fasta=data/references/HMP_MOCK.align, oligos=data/references/v45.oligos); summary.seqs()"

START=$(tail -n +2 data/references/HMP_MOCK.pcr.summary | cut -f 2 | awk '{if(max==""){max=$1}; if($1>max) {max=$1} } END {print max}') 
END=$(tail -n +2 data/references/HMP_MOCK.pcr.summary | cut -f 3 | awk '{if(min==""){min=$1}; if($1<min) {min=$1} } END {print min}')
echo "V45 $START $END" >> data/references/start_stop.positions

rm data/references/*pcr*
rm data/references/*bad*
