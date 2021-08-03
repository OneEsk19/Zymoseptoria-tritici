
# Data copy pasted from the excel sheet S1 in Supplementary

Test <- c("FST", "CLR", "TajD")
Start <- c(1819995, 1829207, 1810000)
End <- c(2102387, 2073778, 2320000)

loci <- data.frame(Test, Start, End)

ST <- c(1837887,1871865, 1932467,1933378,
        1937253, 1963908, 1964968, 1966969, 
        1883060,1956074, 1969417,1986686,
        2016857, 2017925, 2034728,
        2047542)
EN <- c(1839559, 1872560, 1932685, 1937208, 
        1938500, 1964819, 1966788, 1967240,
        1883483, 1957380, 1971365, 1992272,
        2017234, 2019322, 2034026,
        2048806)
Feature <- c("Transposon","Transposon","Transposon",
             "Transposon","Transposon","Transposon",
             "Transposon","Transposon","Ref_Anno", 
             "Ref_Anno", "Ref_Anno", "Ref_Anno", "Ref_Anno",
             "Ref_Anno","Ref_Anno","Ref_Anno")

feats <- data.frame(ST, EN, Feature)
 

library(ggplot2)

ggplot()+
  scale_x_continuous(name = "Chromosome 5 loci (bp)")+
  geom_errorbarh(data = loci, mapping = aes(xmin=Start, xmax=End,
                y=Test), size=1)+
  geom_rect(data=feats, mapping = aes(xmin=ST, xmax=EN, 
            ymin=0, ymax=Inf, fill=Feature))+
  ylab("")


              


