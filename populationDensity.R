

# Datasource: https://neo.sci.gsfc.nasa.gov/view.php?datasetId=SEDAC_POP

library(raster)

################################################################################
# Get and understand population data 
################################################################################
file <- "SEDAC_POP_2000-01-01_rgb_3600x1800.CSV"
df <- read.csv(file , header=FALSE)
M  <- as.matrix(df) # population / (km * km)
missingMask <- M == 99999
M[missingMask] <- NA

# reverse lat is how these data are always stored
lat <- seq(90, -90, length.out = dim(df)[1])
lon <- seq(-180, 180, length.out = dim(df)[2])

# Get ride of data for colorado to make sure you understand that projections
# and have that all set
latMask <- lat >= 37 & lat <= 41
lonMask <- lon >= -109 & lon <= -102

dummy <- M

dummy[latMask, lonMask] <- NA
  

r <- raster(nrows=dim(df)[1], ncols=dim(df)[2], xmn=-180, xmx=180, ymn=-90, ymx=90, 
            vals=dummy)
map("state")
plot(r, add=T)
map("state", add=T)

# If Colorado shows no data these lat lon arrays work and I can move forward

# Append population data to fire occurance data
load("fireOccurrence.RData")

n <- dim(fire_data)[1]

pd <- rep(NA, n)

for (i in 1:n){
  
  flat <- fire_data$LATITUDE[i]
  flon <- fire_data$LONGITUDE[i]
  
  yi <- which.min(abs(flat - lat))
  xi <- which.min(abs(flon - lon))
  
  pd[i] <- M[yi, xi]
  
  
  print(paste("percent complete:", i/n*100))
  
}

fire_data$POPULATION_DENSITY <- pd

save(fire_data, file="fireOccurrence_Wpop.RData")




