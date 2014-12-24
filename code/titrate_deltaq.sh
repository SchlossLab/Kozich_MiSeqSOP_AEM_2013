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
# Produces
# * Contigs formed between pairs of reads
#
################################################################################

F_FASTQ=$1
R_FASTQ=$2

RAW_DIR=$(echo $F_FASTQ | sed -e s/Mock.*//)
PROC_DIR=$(echo $RAW_DIR | sed -e s/raw/process/)

mothur "#make.contigs(ffastq=$F_FASTQ, rfastq=$R_FASTQ, outputdir=$PROC_DIR, processors=12)"
