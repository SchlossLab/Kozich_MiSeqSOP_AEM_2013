Reproduction and exploration of data from [Kozich et al (2013)](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3753973/)
=======

write.paper
-------

You can generate the final document by "simply" entering the following from a terminal on a
Mac OSX or Linux computer:

```
make write.paper
```

But that's probably a ***really bad*** idea. The data contained within represents 13 MiSeq sequencing
runs and would probably take several weeks to run on a single node of a computer. Unfortuantely,
you probably need to go through an individually build the targets of the Makefile on multiple
nodes. If you have suggestions on how to improve the Makefile to make it more automated for people
(i.e. me) using a pbs job scheduler, please let me know.


Dependencies...
---------
* [mothur v.1.34.0](http://www.mothur.org) 
* R packages:
  * knitr
  * vegan


Repository overview
--------

	project
	|- README		# the top level description of content (this file)
	|
	|- doc/			# documentation for the study
	|  |- notebook/		# preliminary analyses (dead branches of analysis)
	|  +- paper/		# manuscript(s), whether generated or not
	|
	|- data			# raw and primary data, are not changed once created
	|  |			#  the files in this directory are not maintained in repo
	|  |- references/	# reference files to be used in analysis
	|  +- raw/		# raw data, specifically fastq files and output from fastq.info
	|     |- '\d{6}'	#   YYMMDD stamp for when the libraries were sequenced					
	|     |- no_metag	#	mouse data from the run with no metagenomes
	|     +- w_metag	#	mouse data from the run with metagenomes
	|
	|  +- process/		# cleaned data:
	|     |- '\d{6}'	#   YYMMDD stamp for when the libraries were sequenced					
	|     |- noseq_error	#   OTU assignments when there are no seq errors/chimeras
	|     |- no_metag	#	mouse data from the run with no metagenomes
	|     +- w_metag	#	mouse data from the run with metagenomes
	|
	|- code/		# bash and R code
	|
	|- results		# all output from workflows and analyses
	|  |- tables/		# text version of tables to be rendered with kable in R
	|  |- figures/		# graphs, likely designated for manuscript figures
	|  +- pictures/		# diagrams, images, and other non-graph graphics
	|
	|- scratch/		# temporary files that can be safely deleted or lost
	|
	|- Kozich_AEM_2013.Rmd 	# executable Rmarkdown for the original Kozich et al
	|			# AEM 2013 manuscript
	|- Kozich_AEM_2013.md	# Markdown (GitHub) version of the *Rmd file
	|- Kozich_AEM_2013.html	# HTML version of *.Rmd file
	|- MiSeq_WetLab_SOP_v4.rmd # Rmarkdown for the MiSeq Wet Lab SOP
	|- MiSeq_WetLab_SOP_v4.pdf # PDF version of the Rmd file
	|
	+- Makefile		# executable Makefile for this study
