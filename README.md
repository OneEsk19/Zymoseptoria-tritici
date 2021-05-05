# Z.tritici

### Contents
* Generalised_VCF_filter_PCA.rmd
  - Subsetting AUS isolates from population
  - Applying folters
  - PCA to indicate clustering of isolates
  - SNP subsetting to reduce dimension
  - PCA of a different subset (describe this better when you understand it)
  - Combine isolates subset with phenotype data and make PCA

* PlotFilteredSNPs.rmd
  - PLots of various quality metrics from the filtered VCF of all isolates
    - From GATK pipeline which combined invidicual VCFs into one large VCF

* Run_filter_may2020.sh
  - GATK pipeline

* WGS_STB_Populations.xlsx 
  - metadata for all isolates

* amendingfile.R
  - script that modified GATK output VCF
  - used in PlotFilteredSNPs.rmd

* plots.pdf
  - output of quality metrics plots from PlotFilteredSNPs.rmd
