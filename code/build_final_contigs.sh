#!/bin/bash

################################################################################
#
# build_final_contigs.sh
#
#
# Here we build the contigs that will be used for assigning sequences to OTUs
#
# Dependencies...
# * The *.fastq files out of the data/raw/ directory
#
# Produces a file ending in *DELTA_Q.contigs.fasta
#
################################################################################

DELTA_Q=$1
F_FASTQ=$2
R_FASTQ=$3

#need to get the paths
RAW_PATH=$(echo $F_FASTQ | sed -E 's/(.*[0-9]{6}).*/\1/')
PROCESS_PATH=$(echo $RAW_PATH | sed -e s/raw/process/)


FILE_STUB=$(echo $FASTA | sed -e 's/.*\/\(Mock.*\).fasta/\1/')
PROCESS_STUB=$PROCESS_PATH/$FILE_STUB

mkdir -p $PROCESS_PATH

mothur "#set.dir(output=$PROCESS_PATH/);
		make.contigs(ffastq=$F_FASTQ, rfastq=$R_FASTQ, processors=12, deltaq=$DELTA_Q)"


TEMP=$(echo $F_FASTQ | sed -e s/raw/process/)
CONTIG_FASTA=$(echo $TEMP | sed -e s/fastq/trim.contigs.fasta/)
CONTIG_REPORT=$(echo $TEMP | sed -e s/fastq/contigs.report/)

mv $CONTIG_FASTA $(echo $CONTIG_FASTA | sed -e s/trim/$DELTA_Q/)
mv $CONTIG_REPORT $(echo $CONTIG_REPORT | sed -e s/contigs/$DELTA_Q.contigs/)

#
#   delete:
#       data/process/121203/Mock1_S1_L001_R1_001.scrap.contigs.fasta
#

rm $(echo $TEMP | sed -e s/fastq/scrap.contigs.fasta/)
