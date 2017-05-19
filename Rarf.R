#! /usr/bin/Rscript
## Script to exclude close records (less than 1km) using the grid method
## It works with species with more than 30 records
## Guillermo Huerta Ramos

# start with a new environment
rm(list = ls())

#install.packages('maptools')

# load libraries
library("maptools")

# create new directories
# this directory will contain csv files with final records
dir.create("./rarf")

# this directory will contain png files with final records
dir.create("./rarfmaps")

setwd("./rarf")

# get file names from input data to use for the loop
file.names <- dir("../clean")

# create sequences of latitude and longitude values to define a grid corresponding to the american continent
longrid = seq(-131,-38,0.05)
latgrid = seq(-49,55,0.05)

for(i in file.names){
  setwd("../clean")
  print(paste0("reading ", i, " records"))
  locs<-read.table(i, header = T, sep = ",",stringsAsFactors = F, row.names = "X")
  attach(locs)
# grid rarefaction to species with more than 30 records 
  if (nrow(locs)<30){
    setwd("../rarf")
    print(paste0("couldn't apply rarefaction script for ", i, " (less than 30 records)"))
    print(paste0("writing record file for ", i))
    write.csv(locs,i)
    #Draw custom map
    setwd("../rarfmaps")
    #Draw custom map
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
    print(paste0("writing plot file for ", i))
    png(filename=i)
    
    plot(wrld_simpl,xlim=xlim, ylim=ylim, axes=T)
    box()
# plot the presence points
    points(lon,lat, col='orange', pch=20, cex=0.75)
    dev.off()
  } else{
# rarefaction
# taken from Jeremy Yoder
# http://www.molecularecologist.com/2013/04/species-distribution-models-in-r/
# identify points within each grid cell, draw one at random
    print(paste0("applying rarefaction for ", i))
    subs = c()
    for(k in 1:(length(longrid)-1)){
      for(j in 1:(length(latgrid)-1)){
        gridsq = subset(locs, lat > latgrid[j] & lat < latgrid[j+1] & lon > longrid[k] & lon < longrid[k+1])
        if(dim(gridsq)[1]>0){
          subs = rbind(subs, gridsq[sample(1:dim(gridsq)[1],1 ), ])
        }
      }
    }
# draw custom map
    setwd("../rarf")
    print(paste0("writing record file for ", i))
    write.csv(subs,i)
    setwd("../rarfmaps")
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
    print(paste0("writing plot file for ", i))
    png(i)
    
    plot(wrld_simpl,xlim=xlim, ylim=ylim, axes=T)
    box()
    # plot the presence points
    points(lon,lat, col='orange', pch=20, cex=0.75)
    dev.off()
    
  }
  detach(locs)
}
