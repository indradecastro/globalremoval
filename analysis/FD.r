setwd("/home/indra/Documents/20160101.Noriega.exp.remocion")

### LOAD SITES IN STANDARD INPUT STRUCTURE ###
raw.abun <- read.table("data/traps.csv", header=T, sep=",")

library(plyr)
groupColumns <- c("code")
dataColumns <- names(raw.abun)[-which(names(raw.abun) %in% c("site", "code", "manejo", "trap"))]
abun <- ddply(raw.abun, groupColumns, function(x){colSums(x[dataColumns])})
rownames(abun) <- abun$code
abun$code <- NULL
abun <- abun[,sort(names(abun))]
abun$Trichonotulus_scrofa <- NULL

### LOAD TRAITS IN STANDARD INPUT STRUCTURE ###
raw.traits <- read.table("data/fd.traits.csv", header=T, sep=",")
traits <- raw.traits
traits <- traits[sort(traits$sp),]
rownames(traits) <- traits$sp
traits$sp <- NULL

###########################################################
### LOAD FD ###
library(FD)

### RUN FD ONLY WITH MORPHOLOGICAL TRAITS ###
# ex7 <- dbFD(tussock$trait, tussock$abun, corr = "lingoes")
morpho.traits <- traits[,-which(names(traits) %in% "reloc.size")]
allfd <- dbFD(morpho.traits, abun, corr="cailliez")
dffd <- do.call(cbind, allfd[-which(names(allfd) %in% "qual.FRic")])
# write nicely formated
dffd <- data.frame("code" = rownames(dffd), dffd)
write.table(dffd, "data/fd.morph.csv", sep=",", quote=F, row.names=F, col.names=T)

### RUN FD ONLY WITH MORPHOLOGICAL TRAITS ###
behav.traits <- traits[,"reloc.size",drop=F]
allfd <- dbFD(behav.traits, abun, corr="cailliez")
dffd <- do.call(cbind, allfd[-which(names(allfd) %in% "qual.FRic")])
# write nicely formated
dffd <- data.frame("code" = rownames(dffd), dffd)
write.table(dffd, "data/fd.behav.csv", sep=",", quote=F, row.names=F, col.names=T)
