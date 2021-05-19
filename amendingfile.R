## trying to replace multiple "FILTERx" with just one "FILTERED"

thefile <- tabfile

thefile$FILTER[thefile$FILTER != "PASS"] <- "FILTERED" 
head(thefile)


thefile$FILTER <- as.character(thefile$FILTER)
thefile$FILTER[is.na(thefile$FILTER)] <- "FILTERED"
write.csv(thefile, "amemdedTABfile.tsv", sep = "/t")
