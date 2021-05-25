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
