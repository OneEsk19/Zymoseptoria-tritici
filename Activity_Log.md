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
1) Working with SNP matrix and PopGenome package
- Snp matrix very large, using 10gb RAM in R, when heatmap attempted, memory requirements exceed what is avaiable (16Gb)
2) Re-code main VCF on a per-chromosome basis to reduce size of data
3) Produce SNP matrix for each new VCF
4) Produce heatmaps for each snp matrix

#### Week 5: 1st - 7th June

Goals:
Remove the individuals that have high missingness and see why they slipped through the filter
Do some writing about the heatmaps, a summary paragraph, maybe include a table of loci that have not changed across pops.
There seems to be some structural event that has occurred on Chr15, investigate this.
- Redo heatmap
- Do linkage map maybe
