Reproduction and exploration of data from Kozich et al (2013)
=======


Repository overview
--------

	project
	|- README			# the top level description of content (this file)
	|
	|- doc/				# documentation for the study
	|  |- notebook/		# preliminary analyses (dead branches of analysis)
	|  +- paper/		# manuscript(s), whether generated or not
	|
	|- data				# raw and primary data, are not changed once created
	|  |				#  the files in this directory are not maintained in repo
	|  |- references/	# reference files to be used in analysis
	|  +- raw/			# raw data, specifically fastq files and output from fastq.info
	|     |- '\d{6}'	#   YYMMDD stamp for when the libraries were sequenced					
	|	  |-stability1	#	mouse data from the run with no metagenomes
	|	  +-stability2	#	mouse data from the run with metagenomes
	|
	|  +- process/		# cleaned data:
	|     |- '\d{6}'	#   YYMMDD stamp for when the libraries were sequenced					
	|	  |-noseq_error	#   OTU assignments when there are no seq errors/chimeras
	|	  |-stability1	#	mouse data from the run with no metagenomes
	|	  +-stability2	#	mouse data from the run with metagenomes
	|
	|- code/			# bash and R code
	|
	|- results			# all output from workflows and analyses
	|  |- figures/		# graphs, likely designated for manuscript figures
	|  +- pictures/		# diagrams, images, and other non-graph graphics
	|
	|- scratch/			# temporary files that can be safely deleted or lost
	|
	|- Kozich_AEM_2013.Rmd # executable Rmarkdown for the original Kozich et al
	|					#   AEM 2013 manuscript
	|- Makefile			# executable Makefile for this study
	|
	|- datapackage.json	# metadata for the (input and output) data files


