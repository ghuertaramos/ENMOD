#! /usr/bin/Rscript
## Script to generate ENM and evaluations 
## Guillermo Huerta Ramos

# start with a new environment
rm(list = ls())

# load libraries
library('dismo')
library('raster')
library('rJava')

# read rasters
print(paste0("reading raster files"))
rasters<- list.files("./data/data_in/rasters",pattern='bil', full.names=TRUE)

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
  # read pseudoabsence records
  setwd("../pseudo")
  bglocs <- read.table(i, header = T, sep = ",",stringsAsFactors = F, row.names="X")
  colnames(bglocs)<-c('lon','lat')
  
  #Extract climatic variables  
  print(paste0("extracting variables"))
  species_bc = extract(predictors, locs[,c("lon","lat")]) # for the subsampled presence points
  
  bg_bc = extract(predictors, bglocs) # for the pseudo-absence points  
  
  
  # generating data subgroups for test and training
  print(paste0("generating subgroups"))
  group_p=kfold(species_bc,5)
  group_a=kfold(bg_bc,5)
  
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
  setwd(i)
  
  dir.create("./model")
  
  setwd("./model")
  
  #generate maxent model 
  me<-maxent(predictors,p=train_p, a=train_a,remove.duplicates=T,path="output")
  
  #get evaluation data
  dir.create("./evaluation")
  setwd("./evaluation")
  print(paste0("generating evaluation data for ", i, " model"))
  e = evaluate(test_p, test_a,me,predictors)
  
  # create graphs and file for evaluation
  png(filename=i)
  #threshold(e)
  plot(e, 'ROC')
  plot(e, 'TPR')
  boxplot(e)
  density(e)
  dev.off()
  setwd("../")
  # get model predictions and plot model on a map 
  print(paste0("generating prediction files for ", i))
  dir.create("./prediction")
  setwd("./prediction")
  pred_me = predict(me, predictors, filename=i)
  png(filename=i)
  plot(pred_me, 1, cex=0.5, legend=T, mar=par("mar"), xaxt="n", yaxt="n", main="Predicted presence")
  dev.off()
  setwd("../../../")
}
print(paste0("Job finished"))