## Week to week goals and actions

#### Week 1: 5th - 10th May

Goals:  
1) Summary of isolates and maybe a draft map showing their location.  
2) Basic understanding of VCF filtering and getting rid of low quality SNPs and low quality individuals.  

Actions:  
- Completed goal 2 (readformat_VCF_FILTER_PCA_commmented..md)  
- Exploring metadata  
- Completed goal 1 (mapping.rmd, IMGS/pop_size_location.png)  


#### Week 2: 11th - 18th May

Goals:  
1) Continue to explore the data  
2) Consider which populations to use  
3) Look into FST, particularly sliding window FST  

Actions:  
1) Completed VCF subset to include drought populations and exclude the Hamilton+ cluster (as seen on PCA) (drought_status_pops.rmd)  
2) Made SNP matrix, ran into dfficulties using it, temporarily ignoring this  
3) Tried some sliding window FST pipelines, ran into problems  

#### Week 3: 18th - 24th May

Goals:  
1) Continue to work on SW FST, see what I can get working.  

Actions:  
1) Ran into problems with sample labelling, which took some fixing, but now the two populations (pre- and post-drought) are correctly labelled in both current workflows (prepareation_for_pcaadapt.rmd)  
2) re-made SNP-matrix with corrected labels (snp_matrix.rmd)  
3) Proceeding through the pcadapt (R package for population analysis) with correctly labelled samples (pcadapt_workflow.Rmd)  
4) Produced PCA showing separation of the two populations (IMGS/pre_post_drought_PCA.html)  
5) Ready to proceed once exams are over.  

#### Week 4: 25th May - 31st May

Goals:  
Exam week, so no clear objectives other than to continue with workflows when time allows.  

Actions:  
1) Working with SNP matrix and PopGenome package.  
- Snp matrix very large, using 10gb RAM in R, when heatmap attempted, memory requirements exceed what is avaiable (16Gb)  
2) Re-code main VCF on a per-chromosome basis to reduce size of data  
3) Produce SNP matrix for each new VCF  
4) Produce heatmaps for each snp matrix  

#### Week 5: 1st - 7th June

Goals:  
Remove the individuals that have high missingness and see why they slipped through the filter  
Do some writing about the heatmaps, a summary paragraph, maybe include a table of loci that have not changed across pops.  
There seems to be some structural event that has occurred on Chr15, investigate this.  
- Redo heatmaps  
- Do linkage map maybe  

Actions:  
1) Errant individuals (x3) removed (high_missing_indv.Rmd) and heatmaps redone (using_snpmatrix.Rmd)  
  - Improved and semi-automated WF to produce snp matrices (bychrom_snp_matrix.Rmd)
  - Heatmaps for each chrom in /IMGS/
  

#### Week 6: 8th - 14th June

Actions:  
1) FST calcuated using VCFTools (modded for haploid data), wf: vcftoolsFST.txt    
  - /data_sheets/fst_file.csv
  - merged above with SNP index (SnpIndex_FST.Rmd), output: /data_sheets/FST_SNPindex.csv
3) Explored FST data:  
  - Decent manhattan plot produced: /IMGS/Manhattan_All_FST.png  
  - Graphed high variation between pops >0.9 FST (High_Variation_FST.Rmd) 
    - chrs 5,6,7, and 16 had more than a few snps @ this threshhold,        graphs produced: /IMGS/chrXX_HighVar.png  
  - Looked at low variation between pops <0.1 FST (Least_Variation.Rmd). A lot more data here. only looked at a bit.  
  - Played around with plotting both v high and v low variation allelles (High_n_Low_Plot.Rmd), this caught a problem with formatting of data, which was corrected.  
4) Looking into software: STRUCTURE. Not sure if I should use this, could not get it to work on Linux, but does work on Windows. Need to format my data in a very particular way, this can be done with Mega2. Needs to be installed on linux.  

To Do:
- LD plots, one for each population
(See McDonald paper section 2.8): -hap-r2 option in VCFTOOLS, followed by LDHeatmap R package.  
- Summarise general populatin traits
    - avg allelic diversity
    - Nei's GD https://en.wikipedia.org/wiki/Genetic_distance#Nei's_standard_genetic_distance  
    - Avg rate of LD

#### Week 7: 15th - 22nd June
To Do:
1) Write outline plan/headings for introducton
  - What / why / what story are we trying to tell
2) Do methods outlines in sections 2.5 and 2.6 in the main referene paper.
  - 2.6 uses the FST values
3) Summarise FST
  - Boxplot by chromosome
  - Selection test
    - ??
  - Sliding window 
    - avg LD decay for window size

Actions:
1) Calculated LD for both populations
  - This is an overwhelmingly large amount of data.
  - Thin it? Select secific areas?
  - Too much to plot
  - Finding it impossible to calculat average LD decay!
