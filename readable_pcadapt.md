---
title: "pcadapt"
author: "Georgina Robertson"
date: "19/05/2021"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```
## First step
As i ran into problems before with population labelling, am starting again with the following step.

Put the isolates in population order in the VCF file.

Our populations.
Read in the relevant data:
note: the making of these subset text files is detailed in: "drought_status_pops.rmd"
```{r}
# pre-drought subset
pre <- read.csv("data_sheets/preDsamples.txt", sep = "", header = F)

# post drought subset
post <- read.csv("data_sheets/postDsamples.txt", sep = "", header = F)

# this is all the isolates in the order they appear in the VCF file
all <- read.csv("data_sheets/excl_hamil_cluster.txt", sep = "", header = F)
```

You can see the problem with the order here
```{r}
match(pre$V1,all$V1)
```
> [1] 186 209   1   3   5   7   9  11  13  15  17  19  21 320 321
[16]  29 200

And here
```{r}
match(post$V1,all$V1)
```
>  [1] 212   2   4   6   8  10  12  14  16  18  20 194 197 190 211
 [16] 339 340 341 342 343 344 345 346 347 348 349 350  22  23  24
 [31]  25  26  27  28 322 323 324 325 326 327 328 329 330 331 332
 [46] 333 334 335 336 337 338  60  88  89  90  91  92  93  94  95
 [61]  96  97  98  99 100 101 102 103 106 107 108 109  61  62  63
 [76]  64  66  79  80  81  82  83  84  86  87  51  52  59  68  30
 [91]  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45
[106]  46  47  48  49  50  69  70  71  72  73  74  75  76  77  78
[121]  53  54  55  57  58 115 116 119 120 121 132 133 134 135 136
[136] 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151
[151] 152 154 122 123 125 126 127 128 129 130 131 174 175 180 181
[166] 182 183 184 185 187 188 189 191 192 193 195 196 198 199 201
[181] 202 203 204 205 206 207 208 210 110 111 112 113 114 117 153
[196] 155 156 158 159 160 161 162 163 164 165 166 167 168 169 170
[211] 171 172 173 176 177 178 179 118 213 214 215 216 217 218 219
[226] 220 221 222 223 224 225 157 239 240 241 242 243 244 245 246
[241] 247 248 249 262 263 264 265 266 267 226 227 228 229 230 268
[256] 269 270 271 272 273 274 275 276 277 278 279 280 281 282 236
[271] 237 238 250 251 253 254 255 256 257 258 259 260 261 296 297
[286] 302 303 304 305 306 231 232 233 234 235 283 284 285 286 287
[301] 288 289 290 291 292 293 294 295 298 299 300 301 307 308 309
[316] 310 311 312 313 314 315 316 317 318 319  56  65  67  85 104
[331] 105 124 252

So I will make a new sample list and use it to re-order the vcf file.
```{r}
sortedsamples <- rbind(pre, post)
write(sortedsamples$V1, "data_sheets/sorted_samples.txt", sep = "")
# NOTE: am going to manually comment this text file with the number of pre and post samples for easy reference AFTER I have used it to reorder the vcf
```

Then:
```{bash}
$ bcftools query -l EXCL_HAMIL_CLUS.biallelicSNP.maf0.5.miss0.9.recode.vcf| sort > sorted_samples.txt

$ bcftools view -S sorted_samples.txt EXCL_HAMIL_CLUS.biallelicSNP.maf0.5.miss0.9.recode.vcf > drought_pops_sorted.vcf
```

# Using pcadapt to detect local adaptation
Following the walkthrough from:
https://bcm-uga.github.io/pcadapt/articles/pcadapt.html
```{r}
# install.packages("pcadapt")
library(pcadapt)
```

## Read in data
```{r}
path_to_file <- "FST/drought_pops_sorted.vcf"
filename <- read.pcadapt(path_to_file, type = "vcf")
```
Didn't work, message was:
> Error in check_file_size(input) : It seems that the input file is quite large. For large 'vcf' or 'ped' files, please use PLINK (>= 1.9) to convert them to 'bed' format.

So moving to PLINK to do what it said to do
```{bash}
plink2 --vcf drought_pops_sorted.vcf --make-bed --out drought_pop_final
```
> Error: Invalid chromosome code 'WAI332_chr_01' on line 67 of --vcf file.
(Use --allow-extra-chr to force it to be accepted.)

So:
```{bash}
plink2 --vcf drought_pops_sorted.vcf --make-bed --allow-extra-chr --out drought_pop_final
## WORKED
```

Back to Read in Data:
```{r}
path_to_file <- "FST/drought_pop_final.bed"
filename <- read.pcadapt(path_to_file, type = "bed")
```

## Choosing number of PCs (K)
Perform PCA:
```{r}
x <- pcadapt(input = filename, ploidy = 1, K =20)
```

Scree plots:
```{r}
plot(x, option = "screeplot")
# saved as scree_plot_k20 in IMGS folder
```
Looks like first two PCs explain most of variance, confirmed below too.
```{r}
plot(x, option = "screeplot", K=10)
# saved as scree_plot_k10 in IMGS folder
```

## Score Plot

So now the preparation was done in reordering the samples, it will be a lot easier to assign the populations.

```{r}
poplist.names <- c(rep("Pre", 17), rep("Post", 333))
```
```{r}
plot(x, option = "scores", pop = poplist.names)
# saved as Dpops_PCA_1_2.png in IMGS folder
```

#### saved as Dpops_PCA_1_2.png in IMGS folder  

**Note 1**

Hmm, some of the "post" are clustering with the "pre". This doesn't seem right, i will double-check how I designated the two populations:

Referring to the document [drought_status_pops.rmd]

So the samples that I assigned to "post" without finding on the PCA (by process of elimiation i found the others on the less busy areas of the plot and not these ones, so i assumed they were from the busy area). If any samples might be wrongly assigned the it's probably these:
[1] "WAI1857"  "WAI1881"  "WAI1883"  "WAI1970D" "WAI2210"  "WAI2216" 
[7] "WAI2911R" "WAI3628b"

It would be nice to find out exactly which isolates from Post are in the small cluster ^^, but i'm unsure how to do that just now.


Projection onto PCs 2 and 3 == worse
```{r}
plot(x, option = "scores", i = 2, j = 3, pop = poplist.names)
```

Will see if i can get the names on the PCA so i can see which post isolates are in the left cluster and compare them to the above.


```{r}
library(plotly)
```

```{r}
interative_drought_PCA <- plot(x, option = "scores", pop = poplist.names, plt.pkg = "plotly")
# static version saved as Dpops_PCA_1_2.png in IMGS folder
```

Reading them off the chart...
> Index values:
18, 19, 20, 21, 29, 186, 200, 209, 211, 212, 320, 321

get sample list directly from VCF
```{bash}
SOURCEVCF="drought_pops_sorted.vcf" 

vcf-query -l $SOURCEVCF > samples_from_vcf_doublecheck.txt
```

```{r}
samples_from_vcf <- read.csv("FST/samples_from_vcf_doublecheck.txt", sep = "", header = F)
```

```{r}
query_samples <- samples_from_vcf[c(18, 19, 20, 21, 29, 186, 200, 209, 211, 212, 320, 321),]

print(query_samples)
```
>[1] "SRR3740308"       
 [2] "SRR3740319"       
 [3] "SRR3740330"       
 [4] "SRR3740341"       
 [5] "WAI147_SRR2866536"
 [6] "WAI320"           
 [7] "WAI324"           
 [8] "WAI326"           
 [9] "WAI328"           
[10] "WAI329"           
[11] "WAI55_SRR2866532" 
[12] "WAI56_SRR2866534" 

So it's none of these from **Note 1**
[1] "WAI1857"  "WAI1881"  "WAI1883"  "WAI1970D" "WAI2210"  "WAI2216" 
[7] "WAI2911R" "WAI3628b"
Which means they were assigned correctly.
So i can forget about these!

Will now get additional info on query_samples
```{r}
library(readxl)

all_isolates<- read_excel("data_sheets/WGS_STB_Populations.xlsx", sheet = 1)
```
Query samples in excel sheet
```{r}
query_samples_info <- all_isolates[all_isolates$ID %in% query_samples,]

print(query_samples_info$ID)
```
> [1] "WAI320"     "WAI326"    
[3] "WAI329"     "SRR3740308"
[5] "SRR3740319" "SRR3740330"
[7] "SRR3740341" "WAI328"    

Query samples NOT in excel sheet
```{r}
print(setdiff(query_samples,query_samples_info$ID))
```
>[1] "WAI147_SRR2866536"
[2] "WAI324"           
[3] "WAI55_SRR2866532" 
[4] "WAI56_SRR2866534" 

I think these are some of the ones collected by another researcher. I failed to note down more details, will double-check.

First will check the year on the ones we do know about:
```{r}
print(query_samples_info[, c("ID", "COL_YEAR", "Population_name")])
```


> ID            COL_YEAR Population_name
<chr>           <dbl>     <chr>
WAI320	        1980	Wagga Wagga__1980_1		
WAI326	        2001	Lockhart__2001_1		
WAI329	        2001	Lockhart__2001_1		
SRR3740308	2001	Lockhart__2001_1		
SRR3740319	2001	Lockhart__2001_1		
SRR3740330	2001	Lockhart__2001_1		
SRR3740341	2001	Lockhart__2001_1		
WAI328	        2012	Inverleigh__2012_1		
8 rows
