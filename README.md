Reproduction and exploration of data from Kozich et al (2013)
=======


Repository overview
--------

    project
    |- README          # the top level description of content (this file)
    |
    |- doc/            # documentation for the study
    |  |- notebook/    # preliminary analyses (dead branches of analysis)
    |  +- paper/       # manuscript(s), whether generated or not
    |
    |- data            # raw and primary data, are not changed once created
    |  |- references/  # reference files to be used in analysis
    |  |- raw/         # raw data, specifically fastq files and output from fastq.info
    |  +- clean/       # cleaned data, will not be altered once created. This
    |				   #   has subdirectories for the different runs and analyses
	|
    |- code/           # bash and R code
	|
    |- results         # all output from workflows and analyses
    |  |- figures/     # graphs, likely designated for manuscript figures
    |  +- pictures/    # diagrams, images, and other non-graph graphics
    |
    |- scratch/        # temporary files that can be safely deleted or lost
    |
    |- study.Rmd       # executable Rmarkdown for this study, if applicable
	|
    |- Makefile        # executable Makefile for this study, if applicable
	|
    |- datapackage.json # metadata for the (input and output) data files


