---
title: "VCF_filter_working"
author: "G.Robertson"
date: "08/05/2021"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## FILTER all sites with filter flag

```{bash}

VCF="Global_vcf_450.may2020.vcf"
OUTVCF="AUS_NZ_450.filtered1"

# removes everything that doesn't have "PASS" in the FILTER column
vcftools --vcf $VCF --remove-filtered-all --recode --out $OUTVCF

```

## GET AUS ISOLATES ONLY
use keepfile to filter out NZ isolates from our big VCF file
```{bash}
# input vcf
BASE_VCF="AUS_NZ_450.filtered1"
# output vcf
OUT_VCF="AUS_375.biallelic"

KEEP_FILE="AUS_names.txt"

vcftools --vcf ${BASE_VCF}.recode.vcf --min-alleles 2 --max-alleles 2 --keep ${KEEP_FILE} --recode --out ${OUT_VCF}
# min alleles 2 means keep observations where there is at least the ref allele and alt allele
# max-alleles is 2 because this is haploid, should there should only be one alt allele.
############################
# Is the above filters using information from the INFO column in the VCF?
# Such as "AC" and "AN"
############################
```
> from https://www.reneshbedre.com/blog/vcf-fields.html#af-alternate-allele-frequency
AF (Alternate allele frequency)
* AF is the frequency for an alternate allele
* AF is calculated (AC/AN)
* AF tag can be used to infer the minor allele frequency (MAF) (Check * bcftools fill-tags plugin)
* If AF < 0.5, then AF is equal to MAF
* rare variants generally has AF or MAF < 5 % (0.05)
MAF (Minor allele frequency)
* MAF refers to the minor allele (least frequent) frequency
* An alternate allele may not be always minor allele

## FILTER FOR BIALLELIC SITES AND INDELS AUS only
Get Info on isolates that are missing too much data
```{bash}
OUT_VCF="AUS_375.biallelic"

## --missing-indv Generates a file reporting the missingness on a per-individual(AS IN PER ISOATE/SAMPLE?) basis. Missingness of what?

vcftools --vcf ${OUT_VCF}.recode.vcf --missing-indv
ls
less out.imiss # reads it. I use more, but I guess less is more :D

#_________________________________________________________ 
# Calculate missing XX% of the total genotypes for each isolate
awk '{printf "%.1f\n", $5}' out.imiss | sort | uniq -c | sort -nrk2,2

######## AM UNCLEAR ON WHAT THIS ^ INPUT MEANS ##########
###### THEREFORE UNCLEAR ON OUTPUT TOO###
# Which was:
#  2 0.6
#  1 0.5
#  94 0.2
#  278 0.1
#   1 0.0

#__________________________________________________________

# Make list of isolates missing 10% of their genotypes

awk '$5 >  0.05{print $1}' out.imiss > Ten_percent.missing.indv
cat Ten_percent.missing.indv
######## ten percent missing what? ##### SNP calls?
# rm out.imiss
# rm out.log
# rm Ten_percent.missing.indv
# __________________________________________________________

## Didn't quite work as expected because without filtering the MAF and MISSING SNPs first then there are too many isolates with missing data

## So filtered SNPs based on MAF and missingness first. Then filtered out isolates with too much missing data (WAI1857, WAI1881, WAI1883)
# __________________________________________________________



FINAL_VCF="AUS372.biallelic.maf0.5.miss0.9"

# --max-missing-count <integer>
# Exclude sites with more than this number of missing genotypes over all individuals.

### SO THIS WILL REDUCE THE NUMBER OF ROWS RIGHT? ###

# maf is the frequency at which the second most common allele occurs in a given population
# maf Include only sites with a Minor Allele Frequency greater than or equal to the "--maf" value 
######### If AF < 0.5, then AF is equal to MAF ######

vcftools --vcf ${OUT_VCF}.recode.vcf --max-missing 0.9 --maf 0.05 --recode --out ${FINAL_VCF}

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

# Now filter for Minor Allele Frequency and site missingness
# Get rid of sites with a very low MAF and sites that are missing for most of the samples
# Come back to this step and repeat if you want to exclude other indviduals 
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