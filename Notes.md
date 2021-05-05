# Z. tritici project notes

### Indroductory information
See Z.tritici Australian Population Dataset.docx

### Files

GATK is used to call SNPs.  
The last step is “joint genotyping”, where you take all of your preliminary vcfs (one vcf for each individual) and combine this into one giant VCF and do the SNP calling for all isolates together. This joint SNP calling makes sure that you assign unified quality scores for all SNPs across the whole dataset.  

The output of joint genotype:  
* Global_vcf_450.unfilt.vcf.gz”, in /May2020_gadi_genotyping  

Used GATK to “filter” this VCF file.  
"Filter" does not actually remove any SNPs from the VCF file, instead it simply labels SNPs with a “Filter” Flag, or “PASS”.  

Script used to “filter” VCF:  
* Run_filter_may2020.sh  
  - also used the GATK tool “VariantToTable” which outputs some of the data from my VCF into a tab deliminated file. This .tab file is much smaller than the 20GB vcf and allows me to look at the quality scores of all my SNPs.    
  
Rmd script which uses the .tab files to plot some of the quality metrics for SNPs across the whole dataset.  
* PlotFilteredSNPs.Rmd  

> You can learn more about what the different quality scores are here: https://gatk.broadinstitute.org/hc/en-us/articles/360035890471-Hard-filtering-germline-short-variants



So, I have flagged SNPs in my VCF using the quality scores shown in the “Run_filter_may2020.sh” script, attached. You can use the output file “Global_vcf_450.plain.may2020.tab” and the attached Rmd script “PloteFilteredSNPs.Rmd” to look at the distribution of the SNP quality scores. NOTE, I have made one very important edit to my output tab file before using the Rmd script. The output tab file has multiple filter flags and if a SNP is very low quality it will get assigned more than one flag. For example “Filter1,Filter2,Filter3”. In order to look just at FILTERED vs PASS I have used grep (or regex find replace in BBedit, sublime text) to find these more complex Filters and just replace with a simple “FILTERED”. This gives me a binary column with “FILTERED” or “PASS” that I can then use as a factor for ggplot2.

 

~~It would be great if you could have a look at “Global_vcf_450.plain.may2020.tab” and try to plot the SNP quality scores. Please download this locally or make a copy and then modify the filter flags so you only have FILTERED or PASS in the first column. Then you should be able to use my Rmd without much other input.~~  
**DONE**, see:  
* PlotFilteredSNPs.Rmd  (has been reused with file created by script below)  
* amendingfile.R = script to change filters and pass to binary

 

To move forward you can use either “Global_vcf_450.may2020.vcf” OR “Global_vcf_450.plain.may2020.vcf”. These two VCFs should be identical except for the filter flags have slightly different names.

 

To actually REMOVE low quality flagged SNPs I use VCF tools. You can see how I did this in the attached Rmd called “Generalized_VCF_filter_PCA.Rmd”. You may already have this script but I attach it here just in case.


### Map and code
Files:  
* WGS_survey maps megan.R  
* STBcollection site.png  


See if you can re-create and maybe improve. One suggestion would be dots of different sizes to represent the number of samples from a particular location?

 

> Tutorial on a different dataset but with different map packages, see “Making Maps in R with ggplot (July 15)”
https://bdsi.anu.edu.au/training-courses/tools-reproducible-science
