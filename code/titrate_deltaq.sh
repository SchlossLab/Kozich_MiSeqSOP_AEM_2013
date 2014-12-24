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
# * *.trim.contigs.fasta
# * *.trim.contigs.report
#
################################################################################

F_FASTQ=$1
R_FASTQ=$2

RAW_DIR=$(echo $F_FASTQ | sed -e s/Mock.*//)
PROC_DIR=$(echo $RAW_DIR | sed -e s/raw/process/)

mothur "#make.contigs(ffastq=$F_FASTQ, rfastq=$R_FASTQ, outputdir=$PROC_DIR, processors=12)"

#
#   delete:
#       data/process/121203/Mock1_S1_L001_R1_001.scrap.contigs.fasta
#

rm $(echo $F_FASTQ | sed -e s/fastq/scrap.contigs.fasta/)
