
# use find and replace on dts and vars
# IHS <- read.csv("./REHH/core_CHRs_EHH.csv")


IHS$CHR <- gsub("WAI332_chr_01", "01", IHS$CHR)
IHS$CHR <- gsub("WAI332_chr_02", "02", IHS$CHR)
IHS$CHR <- gsub("WAI332_chr_03", "03", IHS$CHR)
IHS$CHR <- gsub("WAI332_chr_04", "04", IHS$CHR)
IHS$CHR <- gsub("WAI332_chr_05", "05", IHS$CHR)
IHS$CHR <- gsub("WAI332_chr_06", "06", IHS$CHR)
IHS$CHR <- gsub("WAI332_chr_07", "07", IHS$CHR)
IHS$CHR <- gsub("WAI332_chr_08", "08", IHS$CHR)
IHS$CHR <- gsub("WAI332_chr_09", "09", IHS$CHR)
IHS$CHR <- gsub("WAI332_chr_10", "10", IHS$CHR)
IHS$CHR <- gsub("WAI332_chr_11", "11", IHS$CHR)
IHS$CHR <- gsub("WAI332_chr_12", "12", IHS$CHR)
IHS$CHR <- gsub("WAI332_chr_13", "13", IHS$CHR)
IHS$CHR <- gsub("WAI332_chr_14", "14", IHS$CHR)
IHS$CHR <- gsub("WAI332_chr_15", "15", IHS$CHR)
IHS$CHR <- gsub("WAI332_chr_16", "16", IHS$CHR)
IHS$CHR <- gsub("WAI332_chr_19", "19", IHS$CHR)
IHS$CHR <- gsub("WAI332_chr_20", "20", IHS$CHR)
IHS$CHR <- gsub("WAI332_chr_21", "21", IHS$CHR)

IHS1 <- IHS[,-1]

write.csv(IHS1, "./data_sheets/IHS_na.rm_POST.csv", row.names = F, quote = F)
