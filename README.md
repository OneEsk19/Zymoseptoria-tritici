# Population genetics with *Zymoseptoria tritici* 

## Summary
Population selection (1-4) > Global analysis (5-11) > Population analysis and Selection tests (12-19) > Big plots (20-21)

## Workflow 

| Step | Process | Description | Workflow | Outputs |
|------|---------|-------------|----------|---------|
|1.|VCF Filtering I|Quality filtering of snps and isolates|Initial_VCF_FILTER_PCA.md|Locally stored vcf and misc files.|
|2.|Quality control|Reformatting VCF and producing QC plots|PlotFilteredSNPs.rmd|QC images in /IMGS .|
|3.|Final isolate subset|Using metadata to determine the isolates of interest for further analysis|drought_status_pops.Rmd|data_sheets/preDsamples.txt <br> data_sheets/postDsamples.txt|
|4.|VCF Filtering II|Subsetting final isolates from filtered VCF, and plotting PCA to show population clusters|AUS350.Rmd|Locally stored final VCF (drought_pops.recode.vcf) <br>/IMGS/PCA_AUS350.pdf (static)<br>/IMGS/PCA_AUS350.html (interactive)|
|5.|Isolate locations|Plot of isolate location on Australia map|Mapping.Rmd|/IMGS/Pop_size_location.png|
|6.|SNP Matrix|Creating SNP matrices for each chromosome from the VCF file|byChrom_snp_matrix.Rmd|Locally stored matrices and loci files|
|7.|Heatmaps|Visualising variation in the data using snp matrices|snpmatrix_heatmaps.Rmd|by chromosome heatmaps in /IMGS/|
|8.|FST I|Calculating FST and merging datasets|FST_file_prep.Rmd|in /data_sheets/: <br> fst_file.csv <br> FST_SNPIndex.csv|
|9.|FST II|Summary of FST data: Boxplot|FST_summary|/IMGS/FST_summary.png|
|10.|High differentiation|Plotting highly differentiated SNPs by chromosome|High_Variation_FST.Rmd|/data_sheets/highvariation_byLOCI.txt<br> /IMGS/chr(5,6,7,16)_HighVar.png|
|11.|Low differentiation|Plotting highly conserved SNPs by chromosome|Least_Variation.Rmd|***INCOMPLETE***|
|12.|LD I|Calculating LD between pops, per chromosome|LD_Calc_VCFtools.Rmd|Locally stored .ld files|
|13.|LD II|Visualising Linkage decay|LD_binning.RMD <br> LD_binning_LOOP.Rmd|/IMGS/(POST/PRE)_avgLDdecay_chrXX.png|
|14.|Nucleotide diversity|and Tajima's D computation|NT_TajD_COMPUTE.Rmd|/IMGS/diversity_plots.png|
|15.|Nucleotide diversity|and Tajima's D Plots|NT_TajD_core_summary.Rmd|/IMGS/ND_TajD_boxplot.png|
|16.|XP_EHH|Calculating cross population extended haplotype homozygosity|XP-EHH_compute.Rmd|/data_sheets/XPEHH_na.rm.csv|
|17.|IHS|Calculating IHS witin population statistic|IHS.Rmd|in /data_sheets/ <br> ISH_Pre.csv <br> IHS_Frequency_Pre.csv<br>ISH_Post.csv<br> IHS_Frequency_Post.csv|
|18.|IHS Plots|plotting IHS statistics per chrom + per pop| IHS_plots_POST.Rmd <br> IHS_plots_PRE.Rmd| in /IMGS/ <br> WG_ISH_POST.png <br> WG_ISH.PRE.png|
|19.|CLR analysis|Composite likihood Ratio|CLR_Sweed.Rmd <br>CLR_plots_POST.Rmd <br>CLR_plots_PRE.Rmd |IMGS/WG_CLR_post.png<br>IMGS/WG_CLR_pre.png|
|20.|Integrated plot I|Plot to integrate iHS and CLR statistics|compountPlot_IHS_CLR.Rmd|IMGS/compound_CLR_IHS.png| 
|21.|Integrated plot II|Plot to integrate FST and XP-EHH statistics|XP_EHH_longplots.Rmd first<br>FST_long_scatter.Rmd|/IMGS/FST_XPEHH.png| 

## Abstract
