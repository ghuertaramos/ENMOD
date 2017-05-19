#! /usr/bin/Rscript
## Script to extract climatic data from rasters
## raster files (.asc) must be provided by the user on a directory named "rasters" on "ENMOD"
## Guillermo Huerta Ramos

# start with a new environment
rm(list = ls())

# load libraries
library('raster')

# load raster files
rasters<- list.files("./ENMOD/rasters",pattern='asc', full.names=TRUE )
# stack vectors to concatenate multiple vectors into a single vector along with a factor indicating where each observation originated.
print(paste0("stacking vectors to create predictors variable"))
predictors<-stack(rasters)

# get file names from input data to use for the loop
file.names <- dir("./ENMOD/rarf")

# this directory will contain csv files with final data
dir.create("./ENMOD/vars")

# set working directory
setwd("./ENMOD/vars")

for(i in file.names){
  
setwd("../rarf")
  print(paste0("reading ", i, " records"))
# read record file  
vars <- read.table(i, header = T, sep = ",",stringsAsFactors = F, row.names = "X")

# subset geographic coordinates only
vars<-subset(vars, select=c(lon,lat))

# extract climatic data from each record based on raster files
print(paste0("extracting climatic data from rasters")) 
presvals <- extract(predictors, vars)

setwd("../vars")
# write new file with final data
print(paste0("writing climatic variables file for ", i))
write.csv(presvals,i)
}
