#! /usr/bin/Rscript
## Script to eliminate duplicate records, missing data (NA), and narrow records located in the americas.
## this script also generates graphs to visualize output records.
## Guillermo Huerta Ramos

# start with a new environment
rm(list = ls())

#install.packages('maptools')

# load libraries
library("maptools")

# create new directories
# this directory will contain csv files with final records
dir.create("./data/data_out/clean")

# this directory will contain png files with final records
dir.create("./data/data_out/cleanmaps")
# change working directory
setwd("./data/data_out/clean")
# get file names from input data to use for the loop
file.names <- dir("../records")

for(i in file.names){
  setwd("../records")
  print(paste0("reading ", i, " records"))
  locs<-read.table(i, header = T, sep = ",",stringsAsFactors = F,row.names = "X")
  
# round up coordinates (doesn't work yet)
  #locs2<- locs[signif(lat,2), ]
# delete missing data (doesn't work but I found another way)
  #locs<-locs[na.omit(lon),]
  
# delete duplicate coordinates
  attach(locs)
  locs<-locs[!duplicated(lon), ]
  detach(locs)
# delete duplicated localities
  attach(locs)
  locs<-locs[!duplicated(locality, incomparables = NA), ]
  detach(locs)
# delete records outside the americas
  attach(locs)
  locs<-subset(locs, lon> -131 & lon< -38,na.rm = T)
  detach(locs)
  attach(locs)
  locs<-subset(locs, lat> -49 & lat< 55,na.rm = T)
  detach(locs)
    setwd("../clean")
    print(paste0("writing records file for ", i))
    write.csv(locs,i)
    attach(locs)
## draw maps (I should separate this step as a function)    
#  take the maximum and minimum values from coordinates to draw a custom map
    setwd("../cleanmaps")
    maxx<-max(lon,na.rm = T)
    if (maxx<0) {
      maxx<-(maxx+5)
    } else{
      maxx<-(maxx-5)
    }
    
    minx<-min(lon,na.rm = T)
    if (minx<0) {
      minx<-(minx-2)
    } else{
      minx<-(minx+2)
    }
    
    maxy<-max(lat,na.rm = T)
    if (maxy<0) {
      maxy<-(maxy-1)
    } else{
      maxy<-(maxy+1)
    }
    
    miny<-min(lat,na.rm = T)
    if (minx<0) {
      miny<-(miny-1)
    } else{
      miny<-(miny+1)
    }
    
    data(wrld_simpl)
    xlim=c(minx, maxx)
    ylim=c(miny, maxy)
    print(paste0("drawing map for ", i))
    png(i)
    plot(wrld_simpl,xlim=xlim, ylim=ylim, axes=T)
    box()
    # plot the presence points
    points(lon,lat, col='orange', pch=20, cex=0.75)
    dev.off()
    detach(locs)
}

print(paste0("Job finished"))