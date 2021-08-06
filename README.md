# Population genetics with *Zymoseptoria tritici* 

## Summary
Population selection (1-5) > Global analysis (6-11) > Population analysis and Selection tests (12-19) > Big plots (20-21) > Characterising loci of interest (22) > Population bias check (23)

## Workflow 

| Step | Process | Description | Workflow | Outputs |
|------|---------|-------------|----------|---------|
|1.|VCF Filtering I|Quality filtering of snps and isolates|Initial_VCF_FILTER_PCA.md|Locally stored vcf and misc files.|
|2.|Quality control|Reformatting VCF and producing QC plots|PlotFilteredSNPs.rmd|QC images = plots.pdf|
|3.|Final isolate subset|Using metadata to determine the isolates of interest for further analysis|drought_status_pops.Rmd |WGS_STB_Populations.xlsx<br>postDsamples.txt<br> preDsamples.txt<br>excl_hamil_cluser.keep|
|4.|VCF Filtering II|Subsetting final isolates from filtered VCF, and plotting PCA to show population clusters|AUS350.Rmd high_missing_indv.Rmd|Locally stored final VCF (drought_pops.recode.vcf) <br>PCA_AUS350.pdf (static)<br>PCA_AUS350.html (interactive)|
|5.|Isolate locations|Plot of isolate location on Australia map|Mapping.Rmd|Pop_size_location.png<br>mapgraphing_table.csv<br>WGS_STB_Populations.xlsx|
|6.|SNP Matrix|Creating SNP matrices for each chromosome from the VCF file|byChrom_snp_matrix.Rmd|Locally stored matrices and loci files <br>Dpop_ID_popname.csv<br>chromosomes.txt|
|7.|Heatmaps|Visualising variation in the data using snp matrices|snpmatrix_heatmaps.Rmd|by chromosome heatmaps<br>Dpop_ID_popname.csv|
|8.|FST I|Calculating FST and merging datasets|FST_file_prep.Rmd|FST-SNPindex.csv<br>fst_file.csv<br>pop1_vs_pop2.weir.fst|
|9.|FST II|Summary of FST data and results|FST_summary_boxplot.Rmd<br>FST_Results.Rmd|FST_summary.png|
|10.|High differentiation|Plotting highly differentiated SNPs by chromosome|High_Variation_FST.Rmd|highvariation_byLOCI.txt<br> Various images<br>fst_file.csv<br>FST_SNPindex.csv|
|11.|FST miscellaneous|Plotting distribution of FST values, and lnvestigating low differentiation|FST_Distribution.Rmd, Least_Variation.Rmd|IMAGES|
|12.|LD I|Calculating LD between pops, per chromosome and average linkage above r^2 =5|LD_Calc_VCFtools.Rmd<br>LD_Average.RmD|Locally stored .ld files<br>avg_LD_bychrom.xlsx/.csv<br>avg_LD.png|
|13.|LD II|Visualising Linkage decay|LD_binning.RMD <br> LD_binning_LOOP.Rmd|Image files in the format:(POST/PRE)_avgLDdecay_chrXX.png|
|14.|Nucleotide diversity<br> and Tajima's D|Computation workflow and preliminary plots|NT_TajD_COMPUTE.Rmd|diversity_plots.png|
|15.|Nucleotide diversity<br>and Tajima's D|Summary plots, t-tests and Taj D results|NT_TajD_core_summary.Rmd <br> t_tests_ND_TajD.Rmd<br>TajD_Results.Rmd|ND_TajD_boxplot.png<br>TajD_pcnt0.5.csv|
|16.|XP_EHH|Calculating cross population extended haplotype homozygosity and extracting results|XP-EHH_compute.Rmd XP_EHH_Results.Rmd|XPEHH_na.rm.csv XP_EHH_percentile_results.xlsx|
|17.|IHS|Calculating IHS witin population statistic<br>and extracting results|IHS.Rmd <br> iHS_Results.Rmd|ISH_Pre.csv <br> IHS_Frequency_Pre.csv<br>ISH_Post.csv<br> IHS_Frequency_Post.csv<br>iHS_percentile_results.xlsx|
|18.|IHS Plots|plotting IHS statistics per chrom + per pop| IHS_plots_POST.Rmd <br> IHS_plots_PRE.Rmd| WG_ISH_POST.png <br> WG_ISH.PRE.png|
|19.|CLR analysis|Composite likihood Ratio|CLR_Sweed.Rmd <br>CLR_plots_POST.Rmd <br>CLR_plots_PRE.Rmd<br>CLR_results.Rmd |WG_CLR_post.png<br>WG_CLR_pre.png<br>Results data files|
|20.|Integrated plot I|Plot to integrate iHS and CLR statistics|compountPlot_IHS_CLR.Rmd|compound_CLR_IHS.png| 
|21.|Integrated plot II|Plot to integrate FST, XP-EHH, CLR and iHS statistics|Compound_plot_v2.Rmd|Comound_v2.png<br> All necessary data files| 
|22.|BLAST results|Graphic for BLAST results|Blast_res_graph.R|BLAST_res.png|
|23.|Bias Check|Testing for population bias|Pop_size_bias.Rmd|analysis output files: (FST, TajD, ND)| 

## Abstract

*Zymoseptoria tritici* is a fungal wheat pathogen of global agroeconomic importance and in Europe, 70% of fungicides are used on controlling this pathogen. It is highly adaptable, has large effective population sizes and is wind dispersed making it exceptionally difficult to control. Here we examine two temporally separated populations from Australia that occur before and after a decade long drought during which the disease was absent in wheat crops. Bioinformatic tools were used to compare the two populations and examine the changes to the genome that enabled this pathogen to survive and then re-emerge after this bottleneck event. Concurrence between three of the statistical tests found evidence of a hard selective sweep on chromosome 5 where putative melanin genes and their regulatory elements were found.
