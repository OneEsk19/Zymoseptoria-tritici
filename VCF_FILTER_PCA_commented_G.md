---
title: "VCF_filtering_and_PCA"
author: "Megan McDonald"
date: "07/05/2020"
output: html_doccment
editor_options: 
  chunk_output_type: console
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## FILTER all sites with filter flag
This removes variants (rows).

All variants with anything other than "PASS" in the FILTER field are excluded and recoded into new vcf.
```{bash}
# input file
VCF="Global_vcf_450.may2020.vcf"
# output files
OUTVCF="AUS_NZ_450.filtered1"

# -remoove-filtered-all fairly self explanatory here
vcftools --vcf $VCF --remove-filtered-all --recode --out $OUTVCF

```

## 2) GET AUS ISOLATES ONLY
This removes samples/isolates (columns).
```{bash}
# input vcf
BASE_VCF="AUS_NZ_450.filtered1"
# output vcf
OUT_VCF="AUS_375.biallelic"

KEEP_FILE="AUS_names.txt"

vcftools --vcf ${BASE_VCF}.recode.vcf --min-alleles 2 --max-alleles 2 --keep ${KEEP_FILE} --recode --out ${OUT_VCF}

# 1) min alleles 2 means keep variants where there is at least the ref allele and one alt allele
# 2) max-alleles is 2 which restricts variants to biallelic only
```

QUESTION 1: Do we want biallelic because they are haploid organisms, or because a second alternate allele is extremely unlikely or both? 

## 3) FILTER FOR BIALLELIC SITES AND INDELS AUS only
This removes samples/isolates (columns).

Get Info on isolates that are missing too much data
```{bash}
OUT_VCF="AUS_375.biallelic"

## --missing-indv Generates a file reporting the missingness on a per-individual (sample/isolate) basis.
vcftools --vcf ${OUT_VCF}.recode.vcf --missing-indv
ls
less out.imiss # reads it.
```
N_MISS column is the number of variants that the isolate has no data for
F_MISS column is the frequency of missing data for the isolate, calculated as : N_MISS / TOTAL SITES.

```{bash}
# Calculate missing XX% of the total genotypes for each isolate
awk '{printf "%.1f\n", $5}' out.imiss | sort | uniq -c | sort -nrk2,2
```
%.1f means to print the value of a float number to one decimal place  
$5 is column5  
first sort sorts col 5 (descending?)  
uniq finds unique values  
second sort sorts the unique values (i think descending)  

Output was:  
2 0.6  
1 0.5  
94 0.2  
278 0.1  
1 0.0  

I think this means that there were 2 isolates with 60% missing snips, one with 50%, 94 with 20%, 278 with 10% and only one with < 10% missing.  


# Make list of isolates missing 10% of their genotypes
```{bash}
awk '$5 >  0.05{print $1}' out.imiss > Ten_percent.missing.indv
cat Ten_percent.missing.indv
######## ten percent missing what? ##### SNP calls?
# rm out.imiss
# rm out.log
# rm Ten_percent.missing.indv

## Didn't quite work as expected because without filtering the MAF and MISSING SNPs first then there are too many isolates with missing data

## So filtered SNPs based on MAF and missingness first. Then filtered out isolates with too much missing data (WAI1857, WAI1881, WAI1883)
```
awk '$5 >  0.05{print $1}' out.imiss > Ten_percent.missing.indv  
means:  
write in file: column one where the values in column 5 are greater than 0.05  
cat then outputs the file
I won't paste the output, but wc reports 376 isolates  

Question: Is this wrong?  It's meant to be 10% missingness, but the awk command asked for greater than 5%.


This removes variants (rows).
```{bash}
FINAL_VCF="AUS372.biallelic.maf0.5.miss0.9"
# --max-missing-count <integer> excludes sites with more than this number of missing genotypes over all individuals.
# maf is the frequency at which the second most common allele occurs in a given population 
# --maf includes only sites with a Minor Allele Frequency greater than or equal to the stated value.

vcftools --vcf ${OUT_VCF}.recode.vcf --max-missing 0.9 --maf 0.05 --recode --out ${FINAL_VCF}

# so if more than 90% of genotypes are missing across isolates, that variant is removed
# If a minor/ alt allele occurs less than 5% of the time across isolates, that allele is removed from the vcf.


## Regenerate out.imiss
vcftools --vcf ${FINAL_VCF}.recode.vcf --missing-indv

# Calculate missing XX% of the total genotypes for each isolate
awk '{printf "%.1f\n", $5}' out.imiss | sort | uniq -c | sort -nrk2,2
#  2 0.6
#  1 0.5
#  373 0.0


# Make list of isolates missing 10% of their genotypes
awk '$5 >  0.05{print $1}' out.imiss > high.missing.indv
cat high.missing.indv
# INDV
# WAI1857
# WAI1881
# WAI1883

# Exclude isolates missing 10% or more of the genotype calls

#Now filter for Minor Allele Frequency and site missingness
#Get rid of sites with a very low MAF and sites that are missing for most of the samples
#Come back to this step and repeat if you want to exclude other indviduals 
#(i.e. MAF will change depending on what individuals you include in the analysis)
tail -n 3 high.missing.indv > remove.indv
cat remove.indv
# WAI1857
# WAI1881
# WAI1883

FINAL_VCF="AUS372.biallelic.maf0.5.miss0.9"
OUT_NOMISS="AUS372.biallelic.maf0.5.miss0.9.nomiss"

vcftools --vcf ${FINAL_VCF}.recode.vcf --remove remove.indv --recode --out ${OUT_NOMISS}

```
_____________________________________________________________________________________
## Make PCA for VCF file to get a sense of where all AUS isolates are sitting
Note after running once I will comment out some of these steps because the genofiles XXXX.gds only need to be created once
#snpgdsVCF2GDS("./joint_genotype/AUS372.biallelic.maf0.5.miss0.9.nomiss.recode.vcf", "AUS_372.gds")

```{r}
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("SNPRelate")
```


```{r}
library("ggplot2")
library("SNPRelate")
# SNPRelate: Parallel computing toolset for relatedness and principal component analysis of SNP data
# https://www.rdocumentation.org/packages/SNPRelate/versions/1.6.4
library("plotly")
```

Tutorials for SNPRelate: http://corearray.sourceforge.net/tutorials/SNPRelate/

```{r}

setwd("../Data/May2020_gadi_genotyping/")
getwd()

snpgdsVCF2GDS("joint_genotype/AUS372.biallelic.maf0.5.miss0.9.nomiss.recode.vcf", "AUS_372.gds")
# Reformats a vcf file to GDS
# https://www.rdocumentation.org/packages/SNPRelate/versions/1.6.4/topics/snpgdsVCF2GDS

genofile1<-openfn.gds("AUS_372.gds")

AUS372_pca1<-snpgdsPCA(genofile1, autosome.only=F)
# autosome = non-sex chromosome. Not sure if this organism has any, but it's switched off anyway.

# Principal Component Analysis (PCA) on genotypes:
# Excluding 0 SNP (monomorphic: TRUE, MAF: NaN, missing rate: NaN)
#     # of samples: 372
#     # of SNPs: 370,375
#     using 1 thread
#     # of principal components: 32
# PCA:    the sum of all selected genotypes (0,1,2) = 67799637
# CPU capabilities: Double-Precision SSE2
sample.IDs<-read.table("Isolate_details/AUS372_popfile.txt", header=T)

AUS372_pca1$sample <-sample.IDs$pop[which(AUS372_pca1$sample == sample.IDs$sample)]

pca.dat1 <- data.frame(eigen1=AUS372_pca1$eigenvect[,1],eigen2=AUS372_pca1$eigenvect[,2], pop=AUS372_pca1$sample, samplename=AUS372_pca1$sample.id)

PCA_AUS372<-ggplot(pca.dat1, aes(x=eigen1, y=eigen2, color=pop)) +geom_point(size=0.01)+ geom_text(aes(label=samplename),position = "jitter")+theme(legend.position = "None")
ggsave("./01_VCF_quality_check/PCA_AUS372.pdf", PCA_AUS372, height = 12,width=16,dpi=300,units = "cm")

interactive_AUS372<-ggplotly(PCA_AUS372)
interactive_AUS372

```

## For Downstream analyses 400K SNPs is too many. Will subset data by sampling a SNP every 500 bp
```{bash}
OUT_NOMISS="AUS372.biallelic.maf0.5.miss0.9.nomiss"
SUBSET="AUS_372_biallelic.maf0.5.miss0.9.nomiss_500bp"

vcftools --vcf ${OUT_NOMISS}.recode.vcf --thin 500 --recode --out ${SUBSET}
# --thin <integer> = Thin sites so that no two sites are within the specified distance from one another.
```


```{bash}
OUT_NOMISS="AUS372.biallelic.maf0.5.miss0.9.nomiss"
SUBSET="AUS_372_biallelic.maf0.5.miss0.9.nomiss_500bp_SNPonly"

vcftools --vcf ${OUT_NOMISS}.recode.vcf --remove-indels --thin 500 --recode --out ${SUBSET}
# remove indels, self exaplanatory
```


## Make PCA file for Nannan with only 25 isolates that group together with Lorikeet Hamilton isolates
### Subset AUS_375.biallelic VCF down to the 25 isolates which group together with the Hamilton Lorikeet isolates

Need to start back at pretty much the unfiltered AUS_375.biallelic vcf to get the correct SNPs in the final filtered VCF
You will lose a lot of info if you start at your filtered biallelic.maf0.5.miss0.9 vcf.
Makes sense!
```{bash}
#set output file names
FULLAUS_VCF="AUS_375.biallelic"
SUBSET_LIST="AUS25_Lorikeet"

## first filter based on isolates alone
vcftools --vcf ${FULLAUS_VCF}.recode.vcf --keep ../Isolate_details/avrstb19.keep --recode --out ${SUBSET_LIST}

## run proper filter for biallelic SNPs only with maf >= 0.05 and SNPs not missing in >90% of isolates
SUBSET_MAF="AUS25_Lorikeet.biallelicSNP.maf0.5.miss0.9"
vcftools --vcf $SUBSET_LIST.recode.vcf --min-alleles 2 --max-alleles 2 --maf 0.05 --max-missing 0.9 --recode --out $SUBSET_MAF

## make a AUS_25_popyear.txt file from the big set so that you can nicely plot population in PCA below
for file in `cat ../Isolate_details/avrstb19.keep `; do  echo ${file} | grep -f /dev/stdin ../Isolate_details/AUS372_popfile.txt >> ../Isolate_details/AUS_25_popyear.txt; done

```

## Come back to R and generate PCA from VCF file
This code reads in our filtered vcf with only 25 isolates and makes a small PCA with that VCF file

```{r}

# getwd()
# setwd("/Volumes/Solomon_Lab/Megan/ZYMO_GWAS/May2020_gadi_genotyping/")
snpgdsVCF2GDS("../Data/May2020_gadi_genotyping/joint_genotype/AUS25_Lorikeet.biallelicSNP.maf0.5.miss0.9.recode.vcf", "AUS_25.gds")

genofile25<-openfn.gds("AUS_25.gds")

AUS25_pca1<-snpgdsPCA(genofile25, autosome.only=F)
# Principal Component Analysis (PCA) on genotypes:
# Excluding 0 SNP (monomorphic: TRUE, MAF: NaN, missing rate: NaN)
#     # of samples: 25
#     # of SNPs: 373
#     using 1 thread
#     # of principal components: 32
# PCA:    the sum of all selected genotypes (0,1,2) = 5267
# CPU capabilities: Double-Precision SSE2
sample.IDs<-read.table("../Data/May2020_gadi_genotyping/Isolate_details/AUS_25_popyear.txt", header=T)

AUS25_pca1$sample <-sample.IDs$pop[which(AUS25_pca1$sample == sample.IDs$sample)]

pca.dat1 <- data.frame(eigen1=AUS25_pca1$eigenvect[,1],eigen2=AUS25_pca1$eigenvect[,2], pop=AUS25_pca1$sample, samplename=AUS25_pca1$sample.id)

PCA_AUS25<-ggplot(pca.dat1, aes(x=eigen1, y=eigen2, color=pop)) +geom_point(size=0.01)+ geom_text(aes(label=samplename))
PCA_AUS25
ggsave("PCA_AUS25.pdf", PCA_AUS25, height = 12,width=16,dpi=300,units = "cm")

interactive_AUS25<-ggplotly(PCA_AUS25)
interactive_AUS25
```
So this was for isolates from 2017
- this will be useful for looking at different drought status subsets.

## Make VCF file for 109 isolates with Phenotyping data
(actually 105 if you exlcude isolates whose sequencing failed)
Start filtering from AUS372.biallelic vcf file

```{bash}
#set output file names
FULLAUS_VCF="AUS_375.biallelic"
SUBSET_LIST="AUS102_phenotyped"

## first filter based on isolates alone
vcftools --vcf ${FULLAUS_VCF}.recode.vcf --keep ../Isolate_details/AUS_Pheno102.txt --recode --out ${SUBSET_LIST}

## run proper filter for biallelic SNPs only with maf >= 0.05 and SNPs not missing in >90% of isolates
SUBSET_MAF="AUS102_phenotyped.biallelicSNP.maf0.5.miss0.9"
vcftools --vcf $SUBSET_LIST.recode.vcf --min-alleles 2 --max-alleles 2 --maf 0.05 --max-missing 0.9 --recode --out $SUBSET_MAF
# After filtering, kept 382512 out of a possible 1106434 Sites

## make a AUS_102_popyear.txt file from the big set so that you can nicely plot population in PCA below
for file in `cat ../Isolate_details/AUS_Pheno102.txt `; do  echo ${file} | grep -f /dev/stdin ../Isolate_details/AUS372_popfile.txt >> ../Isolate_details/AUS_102_popyear.txt; done
```

## Come back to R and generate PCA from VCF file
This code reads in our filtered vcf with only 105 isolates and makes a small PCA with that VCF file

```{r}
snpgdsVCF2GDS("../Data/May2020_gadi_genotyping/joint_genotype/AUS102_phenotyped.biallelicSNP.maf0.5.miss0.9.recode.vcf", "AUS_102.gds")
genofile102<-openfn.gds("AUS_102.gds")

AUS102_pca1<-snpgdsPCA(genofile102, autosome.only=F)
# Principal Component Analysis (PCA) on genotypes:
# Excluding 0 SNP (monomorphic: TRUE, MAF: NaN, missing rate: NaN)
#     # of samples: 102
#     # of SNPs: 346,574
#     using 1 thread
#     # of principal components: 32
# PCA:    the sum of all selected genotypes (0,1,2) = 15540375
# CPU capabilities: Double-Precision SSE2

sample.IDs<-read.table("../Data/May2020_gadi_genotyping/Isolate_details/AUS_102_popyear.txt", header=T)

AUS102_pca1$sample <-sample.IDs$pop[which(AUS102_pca1$sample == sample.IDs$sample)]

AUS102_pca1$sample
AUS102_pca1$sample.id

################################################################################################################  

pca.dat1 <- data.frame(eigen1=AUS102_pca1$eigenvect[,1],eigen2=AUS102_pca1$eigenvect[,2], pop=AUS102_pca1$sample, samplename=AUS102_pca1$sample.id)

PCA_AUS102<-ggplot(pca.dat1, aes(x=eigen1, y=eigen2, color=pop)) +geom_point(size=0.01)+ geom_text(aes(label=samplename))
PCA_AUS102
ggsave("/Volumes/Solomon_Lab/Megan/ZYMO_GWAS/May2020_gadi_genotyping/01_VCF_quality_check/PCA_AUS102.pdf", PCA_AUS102, height = 12,width=16,dpi=300,units = "cm")

interactive_AUS102<-ggplotly(PCA_AUS102)
interactive_AUS102
```
