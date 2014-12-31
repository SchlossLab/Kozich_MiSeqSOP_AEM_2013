# Names of Runs - would be nice to automate this with info from the server
RUNS = 121203 121205 121207 130125 130211 130220 130306 130401 130403 130417 130422

# The 24 fastq files that come with each run
F_FASTQS = Mock1_S1_L001_R1_001.fastq Mock2_S2_L001_R1_001.fastq \
	Mock3_S3_L001_R1_001.fastq Human1_S7_L001_R1_001.fastq \
	Human2_S8_L001_R1_001.fastq Human3_S9_L001_R1_001.fastq \
	Mouse1_S10_L001_R1_001.fastq Mouse2_S11_L001_R1_001.fastq \
	Mouse3_S12_L001_R1_001.fastq Soil1_S4_L001_R1_001.fastq \
	Soil2_S5_L001_R1_001.fastq Soil3_S6_L001_R1_001.fastq

R_FASTQS = Mock1_S1_L001_R2_001.fastq Mock2_S2_L001_R2_001.fastq \
	Mock3_S3_L001_R2_001.fastq Human1_S7_L001_R2_001.fastq \
	Human2_S8_L001_R2_001.fastq Human3_S9_L001_R2_001.fastq \
	Mouse1_S10_L001_R2_001.fastq Mouse2_S11_L001_R2_001.fastq \
	Mouse3_S12_L001_R2_001.fastq Soil1_S4_L001_R2_001.fastq \
	Soil2_S5_L001_R2_001.fastq Soil3_S6_L001_R2_001.fastq

FASTQS = $(F_FASTQS) $(R_FASTQS)

# Location of raw runs' data on local machine
RAW_DATA = data/raw/
RAW_RUNSPATH = $(addprefix $(RAW_DATA),$(RUNS))

# Location of processed runs' data on local machine
PROC_DATA = data/process/
PROC_RUNSPATH = $(addprefix $(PROC_DATA),$(RUNS))

# Location of references
REFS = data/references/

# Utility function
print-%:
	@echo '$*=$($*)'


# Let's get ready to rumble...

# We need to find the start and end coordinates for each region within the
# HMP_MOCK reference alignment

$(REFS)start_stop.positions : code/get_region_coordinates.sh $(REFS)HMP_MOCK.align
	sh code/get_region_coordinates.sh






# We need to get our reference files:
#Location of reference files
REFS = data/references/

get_references: $(REFS)silva.bacteria.align $(REFS)HMP_MOCK.fasta $(REFS)HMP_MOCK.align

$(REFS)silva.bacteria.align :
	wget -N -P $(REFS) http://www.mothur.org/w/images/2/27/Silva.nr_v119.tgz; \
	tar xvzf $(REFS)Silva.nr_v119.tgz -C $(REFS) silva.nr_v119.align silva.nr_v119.tax; \
	mothur "#get.lineage(fasta=$(REFS)silva.nr_v119.align, taxonomy=$(REFS)silva.nr_v119.tax, taxon=Bacteria)"; \
	mv $(REFS)silva.nr_v119.pick.align $(REFS)silva.bacteria.align;

$(REFS)HMP_MOCK.fasta :
	wget -N -P $(REFS) http://www.mothur.org/MiSeqDevelopmentData/HMP_MOCK.fasta

$(REFS)HMP_MOCK.align : $(REFS)HMP_MOCK.fasta
	mothur "#align.seqs(fasta=$(REFS)HMP_MOCK.fasta, reference=$(REFS)silva.bacteria.align)"



# Let's get the raw data
# The cross product of all runs and fastq files
ALL_FASTQ = $(foreach R, $(RAW_RUNSPATH), $(foreach F, $(FASTQS), $(R)/$(F)))

get_fastqs : $(ALL_FASTQ)

$(ALL_FASTQ) :
	wget -N -P $(dir $@) http://www.mothur.org/MiSeqDevelopmentData/$(patsubst data/raw/%/,%, $(dir $@)).tar
	tar xvf $(dir $@)*.tar -C $(dir $@); \
	bunzip2 -f $(dir $@)*bz2; \
	rm $(dir $@)*.tar



# Let's open up all of the fastq files
RAW_FASTA = $(subst fastq,fasta,$(ALL_FASTQ))
RAW_QUAL = $(subst fastq,qual,$(ALL_FASTQ))

run_fastq_info : get_fastqs $(RAW_FASTA) $(RAW_QUAL)

$(RAW_FASTA) :
	mothur "#fastq.info(fastq=$(subst fasta,fastq,$@))"

$(RAW_QUAL) :
	mothur "#fastq.info(fastq=$(subst qual,fastq,$@))"



# Now we're going to start working with the Mock community data...

# The mock community fastq files
MOCK_FQ = Mock1_S1_L001_R1_001.fastq Mock1_S1_L001_R2_001.fastq \
		Mock2_S2_L001_R1_001.fastq Mock2_S2_L001_R2_001.fastq \
		Mock3_S3_L001_R1_001.fastq Mock3_S3_L001_R2_001.fastq

# Get the names of the Mock community fastq files
RAW_MOCK_FQ = $(foreach R, $(RAW_RUNSPATH), $(foreach F, $(MOCK_FQ), $(R)/$(F)))
RAW_MOCK_FA = $(subst fastq,fasta,$(RAW_MOCK_FQ))


# We want to get the error data for the individual Mock community sequence reads
# from each sequencing run

PROC_MOCK_TEMP = $(subst R2_001,R2_001.rc, $(subst raw,process,$(RAW_MOCK_FA)))
ERR_SUMMARY = $(subst fasta,filter.error.summary,$(PROC_MOCK_TEMP))
ERR_MATRIX = $(subst fasta,filter.error.matrix,$(PROC_MOCK_TEMP))
ERR_QUAL = $(subst fasta,filter.error.quality,$(PROC_MOCK_TEMP))

single_read_error : $(ERR_SUMMARY) $(ERR_MATRIX) $(ERR_QUAL) $(ALIGN_SUMMARY)

$(ERR_SUMMARY) : get_references run_fastq_info code/single_read_analysis.sh
	$(eval FASTA=$(subst .rc,,$(subst filter.error.summary,fasta,$(subst process,raw, $@)))) \
	sh code/single_read_analysis.sh $(FASTA)
$(ERR_MATRIX) : get_references run_fastq_info code/single_read_analysis.sh
	$(eval FASTA=$(subst .rc,,$(subst filter.error.summary,fasta,$(subst process,raw, $@)))); \
	sh code/single_read_analysis.sh $(FASTA)
$(ERR_QUAL) : get_references run_fastq_info code/single_read_analysis.sh
	$(eval FASTA=$(subst .rc,,$(subst filter.error.summary,fasta,$(subst process,raw, $@)))); \
	sh code/single_read_analysis.sh $(FASTA)
$(ALIGN_SUMMARY) : get_references run_fastq_info code/single_read_analysis.sh
	$(eval FASTA=$(subst .rc,,$(subst filter.error.summary,fasta,$(subst process,raw, $@)))); \
	sh code/single_read_analysis.sh $(FASTA)



# We want to build contigs with between 0 and 10 quality score differences using
# the mock community libraries

DIFFS =  0 1 2 3 4 5 6 7 8 9 10
FOR_MOCK_FQ = Mock1_S1_L001_R1_001.fastq Mock2_S2_L001_R1_001.fastq Mock3_S3_L001_R1_001.fastq
FILE_STUB = $(subst fastq,,$(FOR_MOCK_FQ))

QDIFF_CONTIG_FA = $(addsuffix .contigs.fasta,$(foreach P, $(PROC_RUNSPATH), $(foreach F, $(FILE_STUB), $(foreach D, $(DIFFS), $(P)/$(F)$(D)))))
QDIFF_CONTIG_REP = $(addsuffix .contigs.report,$(foreach P, $(PROC_RUNSPATH), $(foreach F, $(FILE_STUB), $(foreach D, $(DIFFS), $(P)/$(F)$(D)))))


build_mock_contigs : $(QDIFF_CONTIG_FA) $(QDIFF_CONTIG_REP)

#ugly
$(QDIFF_CONTIG_FA) : $(addsuffix .fastq,$(basename $(subst .contigs.fasta, , $(subst process,raw,$@)))) $(addsuffix .fastq,$(subst R1,R2,$(basename $(subst .contigs.fasta, , $(subst process,raw,$@))))) code/titrate_deltaq.sh
	$(eval FFASTQ=$(basename $(subst .contigs.fasta, , $(subst process,raw,$@))).fastq) \
	$(eval RFASTQ=$(subst R1,R2,$(basename $(subst .contigs.fasta, , $(subst process,raw,$@)))).fastq) \
	$(eval QDEL=$(subst .,,$(suffix $(subst .contigs.fasta, , $(subst process,raw,$@))))) \
	sh code/titrate_deltaq.sh $(FFASTQ) $(RFASTQ) $(QDEL)

$(QDIFF_CONTIG_REP) : $(basename $(subst .contigs.report, , $(subst process,raw,$@))).fastq $(subst R1,R2,$(basename $(subst .contigs.report, , $(subst process,raw,$@))).fastq) code/titrate_deltaq.sh
	$(eval FFASTQ=$(basename $(subst .contigs.report, , $(subst process,raw,$@))).fastq) \
	$(eval RFASTQ=$(subst R1,R2,$(basename $(subst .contigs.report, , $(subst process,raw,$@)))).fastq) \
	$(eval QDEL=$(subst .,,$(suffix $(subst .contigs.report, , $(subst process,raw,$@))))) \
	sh code/titrate_deltaq.sh $(FFASTQ) $(RFASTQ) $(QDEL)


# Now we want to take those contigs and get their alignment positions in the
# reference alignment space and quantify the error rate
CONTIG_ALIGN_SUMMARY = $(subst fasta,summary,$(QDIFF_CONTIG_FA))
CONTIG_ERROR_SUMMARY = $(subst fasta,filter.error.summary,$(QDIFF_CONTIG_FA))

contig_error_rate : $(CONTIG_ALIGN_SUMMARY) $(CONTIG_ERROR_SUMMARY)

$(CONTIG_ALIGN_SUMMARY) : $(subst summary,fasta,$@) code/contig_error_analysis.sh
	sh code/contig_error_analysis.sh $(subst summary,fasta,$@)

$(CONTIG_ERROR_SUMMARY) : $(subst error.summary,fasta,$@) code/contig_error_analysis.sh
	sh code/contig_error_analysis.sh $(subst filter.error.summary,fasta,$@)




# Now we want to make sure we have all of the contigs for the 12 libraries using
# a qdel of 6...
DELTA_Q = 6

FINAL_CONTIGS = $(foreach P, $(PROC_RUNSPATH), $(foreach F, $(subst fastq,6.contigs.fasta, $(F_FASTQS)), $P/$F))

build_all_contigs : $(FINAL_CONTIGS) code/build_final_contigs.sh 

$(FINAL_CONTIGS) : code/build_final_contigs.sh $(subst R1_001.6.contigs.fasta,R1_001.fastq, $(subst process,raw, $@)) $(subst R1_001.6.contigs.fasta,R2_001.fastq, $(subst process,raw, $@))
	sh code/build_final_contigs.sh $(DELTA_Q)  \
		$(subst R1_001.6.contigs.fasta,R1_001.fastq, $(subst process,raw, $@)) \
		$(subst R1_001.6.contigs.fasta,R2_001.fastq, $(subst process,raw, $@))
	


# Now we want to split the files into the three different regions using
# screen.seqs and the positions that we determined earlier 
# [$(REFS)start_stop.positions]


# Need to...
# *	separate by region
# *	align/filter (v=T, t=.)/unique/precluster


write.paper: get_references get_fastqs run_fastq_info single_read_error build_mock_contigs contig_error_rate
