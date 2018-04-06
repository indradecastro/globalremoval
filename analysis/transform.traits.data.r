# LOAD DATA
raw <- read.table("data/for.mpd/traits.csv", sep=",", header=T)

# AVERAGE MORPHOLOGIC TRAITS
library(reshape)
avg <- cast(raw, trait ~ sp, fun.aggregate=mean, na.rm=T)

# FIND RELOCATION STRATEGY AND ADD IT TO THE MEAN VALUES OF MORPHOLOGIC TRAITS
guild <- unique(raw[,c("sp", "reloc")])

# MERGE
library(plyr)
guild <- arrange(guild, sp)
tavg <- t(avg)
tavg <- cbind("sp"=colnames(avg)[-1], tavg)
complete <- merge(tavg, guild)

####################################################
mynum <- function(x){as.numeric(as.character(x))}
complete$tot.len <- with(complete, mynum(hl) + mynum(pl) + mynum(el))
complete[complete$sp=="Heliocopris_bucephalus",c("sp", "reloc", "hl", "pl", "el", "tot.len")]

# classify according to classes of size defined in chap 2 and 3 of Noriegas thesis
# CRUCIAL POINT !!!!!!!!!!!!!!!!
# small: < 10 mm
# medium: 10 - 17.9 mm
# big: > 18 mm

complete$size <- cut(complete$tot.len, breaks=c(min(complete$tot.len), 10, 18, max(complete$tot.len)),
    labels=c("small", "medium", "big"), include.lowest=T)

sizes <- complete[,c("sp", "reloc", "size", "tot.len")]
sizes <- arrange(sizes, reloc, tot.len)
# write.table(sizes, "data/all1.sizes.txt", row.names=F, quote=F)
hist(complete[complete$reloc=="Endocoprids","tot.len"], breaks=20)

complete$reloc.size <- paste0(tolower(substr(complete$reloc, 1, 4)),
                              ".", substr(complete$size, 1, 3))

complete <- complete[,-which(names(complete) %in% c("tot.len","size", "reloc"))]


####################################################
# FD requires species as rownames
fd.traits <- complete
# rownames(fd.traits) <- fd.traits$sp
# fd.traits$sp <- NULL
write.table(fd.traits, "data/fd.traits.csv", sep=",", quote=F, row.names=F, col.names=T)

####################################################
# funnull1 requires species as columns
tcomp <- t(complete)

rownames(tcomp)
tcomp <- data.frame("subtraits" = c("subtraits", rownames(tcomp)[-1]),
                    "traits" = c("traits", rep(c("morph", "behav"), c(10,1))),
                    "trait.group" = c("trait.group", rep(c("morph", "behav"), c(10,1))),
                    tcomp
)

# SAVE THE NEW FORAMTED TRAIT TABLE
write.table(tcomp, "data/for.mpd/format.traits.csv", sep=",", quote=F, row.names=F, col.names=F)
