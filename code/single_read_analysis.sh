################################################################################
#
# single_read_analysis.sh
#
#
# Here we get the error rates for the individual sequence reads
#
# Dependencies...
# * The 24 *.fastq files for each sequencing run
#
# Produces
# * The error rates for each individual read
# * From each read file, we will need...
#   - *error.summary
#   - *error.matrix
#   - *error.quality
# * These will be used to make box plots showing the relationship between the
#   quality scores and error type, the effect of the position in the read on
#   the error rate, and the substitution matrix
#
################################################################################

FOLDER=$1
PATH=data/raw/$FOLDER

mkdir -p $PATH

for FASTA in Mock*R1*fasta
do
    QUAL=$(echo $FASTA | sed -e s/fasta/qual/)

    mothur "#setdir(folder=$PATH);
        align.seqs(fasta=$FASTA, reference=../HMP_MOCK.v35.filter.unique.align, processors=12);
        filter.seqs(fasta=current-../data/references/HMP_MOCK.align, vertical=T);
        seq.error(fasta=current, qfile=, reference=);"
done

for FASTA in Mock*R2*fasta
do
    QUAL=$(echo $FASTA | sed -e s/fasta/qual/)

    mothur "#setdir(folder=$PATH);
        reverse.seqs(fasta=$FASTA, qfile=$QUAL)
        align.seqs(fasta=current, reference=../HMP_MOCK.v35.filter.unique.align, processors=12)
        filter.seqs(fasta=current-../data/references/HMP_MOCK.align, vertical=T);
        seq.error(fasta=current, qfile=current, reference=);"
done
