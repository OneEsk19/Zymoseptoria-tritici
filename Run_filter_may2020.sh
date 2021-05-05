#!/bin/bash
#PBS -P aq97
#PBS -q normal
#PBS -l walltime=2:00:00,mem=32GB,ncpus=1,jobfs=100GB

module load java/jdk-8.40
module load gatk/4.1.4.0
module load samtools/1.9

cd $PBS_JOBFS
echo Copy GATK reference index and file to PBSjobs folder ###
cp /scratch/aq97/mcm106/Zymo_GWAS/WAI332_reference/WAI332.fasta ./
cp /scratch/aq97/mcm106/Zymo_GWAS/WAI332_reference/WAI332.fasta.fai ./
cp /scratch/aq97/mcm106/Zymo_GWAS/WAI332_reference/WAI332.dict ./
echo Copy BAM file to PBSjobfs folder ####
cp /scratch/aq97/mcm106/Zymo_GWAS/joint_genotype/Global_vcf_450.unfilt.vcf.gz ./
echo Finished copying /scratch/aq97/mcm106/Zymo_GWAS/WAI332_reference/ and Global_vcf_450 to job folder

echo Start GATK indexing
gatk IndexFeatureFile -F Global_vcf_450.unfilt.vcf.gz
echo Done indexing VCF file
echo Start filtration
gatk VariantFiltration --reference WAI332.fasta --variant Global_vcf_450.unfilt.vcf.gz --output Global_vcf_450.may2020.vcf --filter-expression "QUAL <250" --filter-name "QUALFilter" --filter-expression "QD < 20.0" --filter-name "QDFilter" --filter-expression "FS > 0.1" --filter-name "FSFilter" --filter-expression "MQ < 30.0" --filter-name "MQFilter" --filter-expression "SOR > 3.0" --filter-name "SORFilter" --filter-expression "MQRankSum < -2.5" --filter-name "MQRSFilterLow" --filter-expression "MQRankSum > 2.5" --filter-name "MQRSFilterHigh" --filter-expression "ReadPosRankSum < -2.0" --filter-name "RPRSFilterLow" --filter-expression "ReadPosRankSum > 2.0" --filter-name "RPRSFilterHigh"


gatk VariantFiltration --reference WAI332.fasta --variant Global_vcf_450.unfilt.vcf.gz --output Global_vcf_450.plain.may2020.vcf --filter-expression "QUAL <250" --filter-name "FILTERED1" --filter-expression "QD < 20.0" --filter-name "FILTERED2" --filter-expression "FS > 0.1" --filter-name "FILTERED3" --filter-expression "MQ < 30.0" --filter-name "FILTERED4" --filter-expression "SOR > 3.0" --filter-name "FILTERED5" --filter-expression "MQRankSum < -2.5" --filter-name "FILTERED6" --filter-expression "MQRankSum > 2.5" --filter-name "FILTERED7" --filter-expression "ReadPosRankSum < -2.0" --filter-name "FILTERED8" --filter-expression "ReadPosRankSum > 2.0" --filter-name "FILTERED9"

gatk VariantsToTable -F CHROM -F POS -F TYPE -F EVENTLENGTH -F NSAMPLES -F NCALLED -F QUAL -F AC -F AF -F AN -F DP -F QD -F FS -F MLEAC -F MLEAC -F MQ -F MQRankSum -F ReadPosRankSum -F SOR --variant Global_vcf_450.may2020.vcf --output Global_vcf_450.may2020.tab

gatk VariantsToTable --show-filtered -F FILTER -F CHROM -F POS -F TYPE -F EVENTLENGTH -F NSAMPLES -F NCALLED -F QUAL -F AC -F AF -F AN -F DP -F QD -F FS -F MLEAC -F MLEAC -F MQ -F MQRankSum -F ReadPosRankSum -F SOR --variant Global_vcf_450.plain.may2020.vcf --output Global_vcf_450.plain.may2020.tab

cp Global_vcf_450.may2020.vcf* /scratch/aq97/mcm106/Zymo_GWAS/joint_genotype/
cp Global_vcf_450.plain.may2020.vcf* /scratch/aq97/mcm106/Zymo_GWAS/joint_genotype/
cp Global_vcf_450.may2020.tab* /scratch/aq97/mcm106/Zymo_GWAS/joint_genotype/
cp Global_vcf_450.plain.may2020.tab /scratch/aq97/mcm106/Zymo_GWAS/joint_genotype/


