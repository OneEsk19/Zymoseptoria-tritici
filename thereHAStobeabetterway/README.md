### There has to be a better way to do what I did!

I did this the long way as I knew the individual commands worked and needed it done so i can proceed.
I looked for more eloquent solutions but failed to get any of them to work.

Files in ths folder:

chromosomes.txt - the list of chromosome names in the maiin VCF file

split_chrom_vcf - the commands to split off each chromosome (while retaining the header*) from 
the big VCF and then recoding them into individual vcf files.
(*) Need the header for creating the snp matrix, it won't work without it.

chom_matrices_create.txt - command to create a snp matrix from each chrom.vcf

I wanted to do it the following way, but failed:

Do <the vcf split of the big file> for each entity in <chromosomes.txt> sequentially with the output vcfs
  based on the names in <chromosomes.txt>, then,
  Do <snp matrix creation> for each <WAI332_chr_?.recode.vcf> and outputting an appropriately named file
  
 I feel this may be trivial to an expert, if this is the case I would love to see how it can be done for future reference!
  
  
