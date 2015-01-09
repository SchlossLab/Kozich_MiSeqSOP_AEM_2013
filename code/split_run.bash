TEMP_FILE=$1
LINES=$2

split -l $LINES $TEMP_FILE
for X in x??
do
	cat head.batch $X tail.batch > $X.qsub
	qsub $X.qsub
	rm $X.qsub $X
done

