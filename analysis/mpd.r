setwd("/home/indra/Documents/20160101.Noriega.exp.remocion")

### LOAD SITES IN STANDARD INPUT STRUCTURE ###
raw.sites.world <- read.table('data/for.mpd/traps.mod.gazella.csv', header=T, sep=",")
### LOAD FUNCTION TO CONVERT STANDARD INPUT OF SITES INTO LIST OF SITE MATRIXES ###
source('data/for.mpd/sc.20121002.create.list.sites.r')
### EXECUTE ABOVE FUNCTION OVER STANDARD INPUT STRUCTURE ### (sites NOT grouped)
sites.world.grouped <- create.list.sites(raw.sites.world, cols.labels=1:4, col.subplots=3)


### LOAD TRAITS IN STANDARD INPUT STRUCTURE ###
raw.traits.world <- read.table('data/for.mpd/format.traits.csv', header=T, sep=",", dec=".")
### LOAD FUNCTION TO CONVERT STANDARD INPUT OF TRAIT VALUES INTO LIST OF TRAIT DISTANCES ###
source('data/for.mpd/sc.20121116.create.list.dists.r')
### EXECUTE ABOVE FUNCTION OVER STANDARD INPUT STRUCTURE ### (traits WILL BE grouped)
dists.world.grouped <- create.list.dists(trait.data=raw.traits.world, group.traits=T, cols.labels=1:3)

### LOAD FUNNULL1 ###
source('data/for.mpd/sc.20180322.funnull1.r')
### RUN FUNNULL1 ###
results.world <- funnull1(sites=sites.world.grouped, dists=dists.world.grouped,
                          diversity.index="mpd", ses.type="ses.trad", abundance.weighted=T)

#####################################################################
#####################################################################
### FORMAT RESULTS TRAP LEVEL###
# results.world$site.indices
# mpd <- lapply(results.world$cuadricule.indices, function(site.trait){
#       mean(site.trait$mpd.corrected.obs, na.rm=T)})
# mpd.df <- data.frame("site" = substr(names(mpd), 10, 18),
#              "trait" = substr(names(mpd), 22, 40),
#              "mpd" = unlist(mpd), row.names=NULL)
# library(plyr)
# finmpd <- reshape(mpd.df, v.names="mpd", idvar="site", timevar="trait", direction="wide")
# finmpd$rich <- results.world$site.indices$gamma.taxa.field
# finmpd[finmpd$mpd.morphology==1 | finmpd$mpd.behaviour==1 |
#              finmpd$mpd.morphology==0 | finmpd$mpd.behaviour==0 |
#              is.na(finmpd$mpd.behaviour) | is.na(finmpd$mpd.morphology),]

### FORMAT RESULTS SITES LEVEL###
# results.world$site.indices
mpd <- lapply(results.world$cuadricule.indices, function(site.trait){
      data.frame("manejo"=rownames(site.trait),
                 "mpd"=site.trait$"mpd.corrected.obs",
                 "rich"=site.trait$taxa.cuad)})
mpd <- do.call(rbind, mpd)
mpd.df <- data.frame("site" = substr(rownames(mpd), 10, 14),
                     "manejo" = mpd$manejo,
                     "trait" = substr(rownames(mpd), 18, 22),
                     "mpd" = mpd$mpd, row.names=NULL,
                     "rich"=mpd$rich)
library(plyr)
finmpd <- reshape(mpd.df, v.names=c("mpd", "rich"), idvar=c("site", "manejo"),
                  timevar=c("trait"), direction="wide")
finmpd$rich.behav <- NULL
names(finmpd)[names(finmpd)=="rich.morph"] <- "richness"

# check that mpd for behaviour is correct
finmpd[finmpd$mpd.morph==1 | finmpd$mpd.behav==1 |
             finmpd$mpd.morph==0 | finmpd$mpd.behav==0 |
             is.na(finmpd$mpd.behav) | is.na(finmpd$mpd.morph),]

# SAVE THE nicely MPD TABLE
write.table(finmpd, "data/mpd.csv", sep=",", quote=F, row.names=F, col.names=T)


# checking things
# site <- "2016.BRA03"
# manejo <- "Int"
# sps <- rownames(apply(sites.world.grouped[[site]][manejo,], 1, function(x){which(x!=0)}))
t(raw.traits.world[,sps])
