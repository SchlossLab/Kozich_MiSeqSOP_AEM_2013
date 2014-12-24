################################################################################
#
# titrate_detlaq.sh
#
#
# Here we get the contigs that are formed between pairs of sequence reads
#
# Dependencies...
# * Paired *.fastq files out of the data/raw/ directory
#
# Produces contigs formed between pairs of reads and a report:
# * *.#.contigs.fasta
# * *.#.contigs.report
#
################################################################################

F_FASTQ=$1
R_FASTQ=$2
DELTA_Q=$3

RAW_DIR=$(echo $F_FASTQ | sed -e s/Mock.*//)
PROC_DIR=$(echo $RAW_DIR | sed -e s/raw/process/)

mothur "#make.contigs(ffastq=$F_FASTQ, rfastq=$R_FASTQ, outputdir=$PROC_DIR, deltaq=$DELTA_Q, processors=12)"

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
