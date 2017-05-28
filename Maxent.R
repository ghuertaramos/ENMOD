#! /usr/bin/Rscript
## Script to generate ENM and evaluations 
## Guillermo Huerta Ramos

# start with a new environment
rm(list = ls())

# load libraries
library('dismo')
library('raster')
library('rJava')

print(paste0("reading raster files"))
# read rasters
rasters<- list.files("./data/data_in/rasters",pattern='asc', full.names=TRUE )
# stack vectors to concatenate multiple vectors into a single vector along with a factor indicating where each observation originated.
print(paste0("stacking rasters"))
predictors<-stack(rasters)
# get species names from record files
species.names <- dir("./data/data_out/rarf")
# generate working directory for output data
dir.create("./data/data_out/maxent")

setwd("./data/data_out/maxent")

for (i in species.names){
  
setwd("../rarf")
  print(paste0("reading records"))
# read records
locs <- read.table(i, header = T, sep = ",",stringsAsFactors = F, row.names="X")
# subset only coordinates
locs <-subset(locs, select= c(lon,lat))

setwd("../pseudo")
print(paste0("reading pseudo absence records"))
# read pseudoabsence records
bglocs <- read.table(i, header = T, sep = ",",stringsAsFactors = F, row.names="X")
colnames(bglocs)<-c('lon','lat')
# generating data subgroups for test and training
print(paste0("generating subgroups"))
group_p=kfold(locs,5)
group_a=kfold(bglocs,5)

test<-sample(1:3,1)

train_p = locs[group_p!=test, c("lon","lat")]

train_a = bglocs[group_a!=test, c("lon","lat")]

test_p = locs[group_p==test, c("lon","lat")]

test_a = bglocs[group_a==test, c("lon","lat")]

setwd("../maxent")
# crate new directory to contain new model
dir.create(i)

print(paste0("generating model for ", i))

# generate model

me<-maxent(predictors,p=train_p, a=train_a,remove.duplicates=T,path=i)
print(paste0("generating evaluation data for ", i, " model"))
e = evaluate(test_p, test_a,me,predictors)

#threshold(e)
setwd(i)
# create graphs and file for evaluation
dir.create("./evaluation")
setwd("./evaluation")
png(filename=i)
plot(e, 'ROC')
plot(e, 'TPR')
boxplot(e)
density(e)
dev.off()
setwd("../")
# get model predictions and plot model on a map 
pred_me = predict(me, predictors, filename=i)
png(filename=i)
plot(pred_me, 1, cex=0.5, legend=T, mar=par("mar"), xaxt="n", yaxt="n", main="Predicted presence")
dev.off()
setwd("../")
}
print(paste0("Job finished"))