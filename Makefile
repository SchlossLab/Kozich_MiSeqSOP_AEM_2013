# Location of raw data directories
RAWDATA = data/raw/

# Names of Runs - would be nice to automate this with info from the server
RUNS = 121203 121205 121207 130125 130211 130220 130306 130401 130403 130417 130422

# Location of runs' data on local machine
RUNSPATH = $(addprefix $(RAWDATA),$(RUNS))

# The 24 fastq files that come with eachh run
FASTQS = Mock1_S1_L001_R1_001.fastq Mock1_S1_L001_R2_001.fastq Mock2_S2_L001_R1_001.fastq \
	Mock2_S2_L001_R2_001.fastq Mock3_S3_L001_R1_001.fastq Mock3_S3_L001_R2_001.fastq \
	Human1_S7_L001_R1_001.fastq Human1_S7_L001_R2_001.fastq Human2_S8_L001_R1_001.fastq \
	Human2_S8_L001_R2_001.fastq Human3_S9_L001_R1_001.fastq Human3_S9_L001_R2_001.fastq \
	Mouse1_S10_L001_R1_001.fastq Mouse1_S10_L001_R2_001.fastq Mouse2_S11_L001_R1_001.fastq \
	Mouse2_S11_L001_R2_001.fastq Mouse3_S12_L001_R1_001.fastq Mouse3_S12_L001_R2_001.fastq \
	Soil1_S4_L001_R1_001.fastq Soil1_S4_L001_R2_001.fastq Soil2_S5_L001_R1_001.fastq \
	Soil2_S5_L001_R2_001.fastq Soil3_S6_L001_R1_001.fastq Soil3_S6_L001_R2_001.fastq


# Utility function
print-%:
	@echo '$*=$($*)'


# Let's get ready to rumble...


# We need to get our reference files:
#Location of reference files
REFS = data/references/

get.references: $(REFS)silva.bacteria.fasta $(REFS)HMP_MOCK.fasta $(REFS)HMP_MOCK.align

$(REFS)silva.bacteria.fasta :
	wget -N -P $(REFS) http://www.mothur.org/w/images/2/27/Silva.nr_v119.tgz; \
	tar xvzf $(REFS)Silva.nr_v119.tgz; \
	mothur "#get.lineage(fasta=$(REFS)silva.nr_v119.align, taxonomy=$(REFS)silva.nr_v119.tax, taxon=Bacteria)"; \
	mv $(REFS)silva.nr_v119.pick.align $(REFS)silva.bacteria.align;

$(REFS)HMP_MOCK.fasta :
	wget -N -P $(REFS) http://www.mothur.org/MiSeqDevelopmentData/HMP_MOCK.fasta

$(REFS)HMP_MOCK.align : $(REFS)HMP_MOCK.fasta
	mothur "#align.seqs(fasta=$(REFS)HMP_MOCK.fasta, reference=$(REFS)silva.bacteria.align)"


# Let's get the raw data
# The cross product of all runs and fastq files
RAWFASTQ = $(foreach R, $(RUNSPATH), $(foreach F, $(FASTQS), $(R)/$(F)))

get.fastqs : $(RAWFASTQ)

$(RAWFASTQ) :
	wget -N -P $(dir $@) http://www.mothur.org/MiSeqDevelopmentData/$(patsubst data/raw/%/,%, $(dir $@)).tar
	tar xvf $(dir $@)*.tar -C $(dir $@); \
	bunzip2 -f $(dir $@)*bz2; \
	rm $(dir $@)*.tar



# Let's open up all of the fastq files
RAWFASTA = $(subst fastq,fasta,$(RAWFASTQ))
RAWQUAL = $(subst fastq,qual,$(RAWFASTQ))

fastq.info : get.fastqs $(RAWFASTA) $(RAWQUAL)

$(RAWFASTA) :
	mothur "#fastq.info(fastq=$(subst fasta,fastq,$@))"

$(RAWQUAL) :
	mothur "#fastq.info(fastq=$(subst qual,fastq,$@))"



# We want to get the error data for the individual sequence reads from each
# sequencing run
PROCFASTA = $(subst raw,process,$(RAWFASTA))
ERRSUMMARY = $(subst fasta,error.summary,$(PROCFASTA))
ERRMATRIX = $(subst fasta,error.matrix,$(PROCFASTA))
ERRQUAL = $(subst fasta,error.quality,$(PROCFASTA))

single_read.error : fastq.info $(ERRSUMMARY) $(ERRMATRIX) $(ERRQUAL)

$(ERRSUMMARY) :
	FASTA=$(subst error.summary,fasta,$(subst process,raw, $@)); \
	sh code/single_read_analysis.sh $(FASTA)
$(ERRMATRIX) :
	FASTA=$(subst error.summary,fasta,$(subst process,raw, $@)); \
	sh code/single_read_analysis.sh $(FASTA)
$(ERRQUAL) :
	FASTA=$(subst error.summary,fasta,$(subst process,raw, $@)); \
	sh code/single_read_analysis.sh $(FASTA)






write.paper: get.references get.fastqs fastq.info single_read.error
