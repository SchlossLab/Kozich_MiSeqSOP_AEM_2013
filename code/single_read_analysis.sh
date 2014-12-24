################################################################################
#
# single_read_analysis.sh
#
#
# Here we get the error rates for the individual sequence reads
#
# Dependencies...
# * The *.fasta and *.qual files out of the data/raw/ directory
#
# Produces
# * The error rates for each individual read
# * From each read file, we will need...
#   - *.error.summary
#   - *.error.matrix
#   - *.error.quality
# * These will be used to make box plots showing the relationship between the
#   quality scores and error type, the effect of the position in the read on
#   the error rate, and the substitution matrix
#
################################################################################

FASTA=$1
QUAL=$(echo $FASTA | sed -e s/fasta/qual/)

#need to get the paths
RAW_PATH=$(echo $FASTA | sed -e s/\/Mock.*fasta//)
PROCESS_PATH=$(echo $RAW_PATH | sed -e s/raw/process/)
FILE_STUB=$(echo $FASTA | sed -e 's/.*\/\(Mock.*\).fasta/\1/')
PROCESS_STUB=$PROCESS_PATH/$FILE_STUB

mkdir -p $PROCESS_PATH

if [[ $FASTA == *"R1"* ]]; then
    mothur "#set.dir(output=$PROCESS_PATH/);
        align.seqs(fasta=$FASTA, reference=data/references/HMP_MOCK.align, processors=12);
        filter.seqs(fasta=current-data/references/HMP_MOCK.align, vertical=T);
        seq.error(fasta=current, qfile=$QUAL, report=$PROCESS_STUB.align.report, reference=$PROCESS_PATH/HMP_MOCK.filter.fasta);"

        rm $PROCESS_STUB.align
        rm $PROCESS_STUB.align.report
        rm $PROCESS_STUB.filter.fasta
else
    mothur "#set.dir(output=$PROCESS_PATH/);
        reverse.seqs(fasta=$FASTA, qfile=$QUAL);
        align.seqs(fasta=current, reference=data/references/HMP_MOCK.align, processors=12);
        filter.seqs(fasta=current-data/references/HMP_MOCK.align, vertical=T);
        seq.error(fasta=current, qfile=$QUAL, report=$PROCESS_STUB.rc.align.report, reference=$PROCESS_PATH/HMP_MOCK.filter.fasta);"

        rm $PROCESS_STUB.rc.align
        rm $PROCESS_STUB.rc.align.report
        rm $PROCESS_STUB.rc.filter.fasta
fi
