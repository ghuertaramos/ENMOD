#! /usr/bin/Rscript
## Script to generate pseudoabsence points from record data
## each new file will contain 1000 pseudoabsence records
## Guillermo Huerta Ramos

# start with a new environment
rm(list = ls())

# load libraries
library("dismo")
library("maptools")

# get file names from input data to use for the loop
file.names <- dir("./data/data_out/rarf")

# this directory will contain csv files with final data
dir.create("./data/data_out/pseudo")

# this directory will contain png files with presence and pseudoabsence points
dir.create("./data/data_out/pseudomaps")

setwd("./data/data_out/pseudo")

for (i in file.names){
setwd("../rarf")
  print(paste0("reading ", i, " records"))
subs<-read.table(i, header = T, sep = ",",stringsAsFactors = F, row.names = "X")
attach(subs)

# define circles with a radius of 50 km around the subsampled points
x = circles(subs[,c("lon","lat")], d=50000, lonlat=T)

# draw random points that must fall within the circles in object x
bg = spsample(x@polygons, 1000, type='random', iter=1000)
mg=data.frame(bg)

##Draw custom map
setwd("../pseudomaps")
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
points(bg, col='black', pch=20, cex=0.75)

#plot pseudoabsence points
points(lon,lat, col='orange', pch=20, cex=0.75)

dev.off()
setwd("../pseudo")
print(paste0("writing peudoabscence file for ", i))
write.csv(bg,i)
detach(subs)
}
print(paste0("Job finished"))