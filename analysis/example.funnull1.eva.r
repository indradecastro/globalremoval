setwd("/media/indra/KREAS/edukinak/ongoing/funnull1.repos/")

### LOAD SITES IN STANDARD INPUT STRUCTURE ###
raw.sites.eva <- read.table('dat.eva.sites.txt', header=T, sep="\t")
### LOAD FUNCTION TO CONVERT STANDARD INPUT OF SITES INTO LIST OF SITE MATRIXES ###
source('sc.20121002.create.list.sites.r')
### EXECUTE ABOVE FUNCTION OVER STANDARD INPUT STRUCTURE ### (sites NOT grouped)
sites.eva.grouped <- create.list.sites(raw.sites.eva, cols.labels=1:4, col.subplots=3)


### LOAD TRAITS IN STANDARD INPUT STRUCTURE ###
raw.traits.eva <- read.table('dat.eva.traits.txt', header=T, sep="\t", dec=".")
### LOAD FUNCTION TO CONVERT STANDARD INPUT OF TRAIT VALUES INTO LIST OF TRAIT DISTANCES ###
source('sc.20121116.create.list.dists.r')
### EXECUTE ABOVE FUNCTION OVER STANDARD INPUT STRUCTURE ### (traits WILL BE grouped)
dists.eva.grouped <- create.list.dists(trait.data=raw.traits.eva, group.traits=T, cols.labels=1:3)

### LOAD FUNNULL1 ###
source('sc.20130324.funnull1.r')
results.eva <- funnull1(sites=sites.eva.grouped, dists=dists.eva.grouped, diversity.index="mpd", ses.type="ses.trad")
