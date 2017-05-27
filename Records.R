#! /usr/bin/Rscript
## Script to download records from gbif.org database
## Guillermo Huerta Ramos

# start with a new environment
rm(list = ls())

# Uncomment if using script outside docker
#install.packages(c("dismo","maptools","jsonlite","tidyr",repos = "http://cran.rstudio.com/"))

# load libraries
library('dismo')
library('maptools')
library('jsonlite')
library('tidyr')

# set path for input (list of species) in this case the input is in the same working directory
path = "./data/data_in/species.csv"

# read list of species
species.names <- read.csv(path, header = T, colClasses=c('character'), sep = ",")

# transpose the names of species to asign different variables
species.names<-t(species.names)

# generate directory in current path to store generated files
dir.create("./data/data_out/records")

# set previous path
setwd("./data/data_out/records")
for(i in species.names) {

# separate genus and species for the gbif function
  singlespecies<-as.data.frame(i)
  binarynames<-separate(singlespecies,"i",c("genus", "species"), sep = " ", remove=T)
  
  # retrieve all occurrences of selected species from gbif
  print(paste0("retrieving records for ", i))
  especies<-gbif(binarynames$genus, binarynames$species, geo=T, removeZeros=T) 
  
# subsetting with relevant fields
  attach(especies)
  esprelevant <- subset(especies,select=c(lon, lat, locality, gbifID, elevation, identifiedBy, identifier, recordNumber,occurrenceRemarks))

# generate new file 
  print(paste0("writing record file"))
   write.csv(esprelevant,i)
   detach(especies)
}

print(paste0("Job finished"))
