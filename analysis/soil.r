library(soilDB)
library(rgdal)

# el unico q funciono una vez
# b <- c(-78.85012,  36.09012, -78.85011,  36.09013)

# un sitio conocido para probar
# site: SPA01Int
# lat: 40.707
# lon: -4.0899416667
b <- c(40.70695,  -4.0905, 40.70700,  -4.08910)

mapunits <- mapunit_geom_by_ll_bbox(b)

plot(mapunits)
mapunits
