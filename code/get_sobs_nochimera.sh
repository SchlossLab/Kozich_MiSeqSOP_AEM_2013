#!/bin/bash

################################################################################
#
# get_sobs_nochimera.sh
#
#
# Here we get the number of OTUs that are observed when the error rate is
# maintained, but we can perfectly remove all chimeras
#
# Dependencies...
# * *.error.su,,ary
#
# Produces
# * *.perfect.an.ave-std.summary
# * *.perfect.an.summary
#
################################################################################

ERROR_SUMMARY=$1

STUB=$(echo $ERROR_SUMMARY | sed 's/.error.summary//')

grep "2$" $ERROR_SUMMARY | cut -f 1 > $STUB.perfect.accnos

mothur "#remove.seqs(fasta=$STUB.fasta, name=$STUB.names, accnos=$STUB.perfect.accnos);
    system(mv $STUB.pick.fasta $STUB.perfect.fasta);
    system(mv $STUB.pick.names $STUB.perfect.names);
    dist.seqs(fasta=$STUB.perfect.fasta, cutoff=0.2);
    cluster(column=current, name=$STUB.perfect.names);
    summary.single(rabund=current, calc=nseqs-sobs, label=0.03, subsample=5000)"

touch $STUB.perfect.an.ave-std.summary
touch $STUB.perfect.an.summary

#garbage collection...
rm $STUB.perfect.accnos
rm $STUB.perfect.names
rm $STUB.perfect.fasta
rm $STUB.perfect.dist
rm $STUB.perfect.an.sabund
rm $STUB.perfect.an.rabund
rm $STUB.perfect.an.list

rm $STUB.error.chimera
rm $STUB.error.count
rm $STUB.error.matrix
rm $STUB.error.ref
rm $STUB.error.seq
rm $STUB.error.seq.forward
rm $STUB.error.seq.reverse
