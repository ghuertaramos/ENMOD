#! /usr/bin/Rscript
## Script to generate ENM and evaluations 
## Guillermo Huerta Ramos

# start with a new environment
rm(list = ls())

# load libraries
install.packages("rJava")
library('dismo')
library('raster')
library('rJava')

print(paste0("reading raster files"))
# read rasters
rasters<- list.files("../data/data_in/rasters",pattern='asc', full.names=TRUE )
# stack vectors to concatenate multiple vectors into a single vector along with a factor indicating where each observation originated.
print(paste0("stacking rasters"))
predictors<-stack(rasters)

species.names <- dir("./data/data_out/rarf")

dir.create("./data/data_out/maxent")

setwd("./data/data_out/maxent")

for (i in species.names){
  
setwd("../rarf")

locs <- read.table(i, header = T, sep = ",",stringsAsFactors = F, row.names="X")

locs <-subset(locs, select= c(lon,lat))

setwd("../pseudo")

bglocs <- read.table(i, header = T, sep = ",",stringsAsFactors = F, row.names="X")
print(paste0("generating data groups"))
colnames(bglocs)<-c('lon','lat')

group_p=kfold(locs,5)
group_a=kfold(bglocs,5)

test<-sample(1:3,1)

train_p = locs[group_p!=test, c("lon","lat")]

train_a = bglocs[group_a!=test, c("lon","lat")]

test_p = locs[group_p==test, c("lon","lat")]

test_a = bglocs[group_a==test, c("lon","lat")]

setwd("../maxent")
# crate new directory to contain model
dir.create(i)

print(paste0("generating model for", i))
me<-maxent(predictors,p=train_p, a=train_a,remove.duplicates=T,path=i)
print(paste0("generating evaluation data for ", i, " model"))
e = evaluate(test_p, test_a,me,predictors)

#threshold(e)
setwd(i)
dir.create("./evaluation")
setwd("./evaluation")
png(filename=i)
plot(e, 'ROC')
plot(e, 'TPR')
boxplot(e)
density(e)
dev.off()
setwd("../")

pred_me = predict(me, predictors, filename=i)

setwd("../")
}
