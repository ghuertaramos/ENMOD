#! /usr/bin/Rscript
## Script to generate ENM and evaluations 
## Guillermo Huerta Ramos

# start with a new environment
rm(list = ls())

# load libraries
#install.packages("rJava")
library('dismo')
library('raster')
library('rJava')


rasters<- list.files("./rasters",pattern='asc', full.names=TRUE )

predictors<-stack(rasters)

species.names <- dir("./rarf")

dir.create("./maxent")

setwd("./maxent")

for (i in species.names){
  
setwd("../rarf")

locs <- read.table(i, header = T, sep = ",",stringsAsFactors = F, row.names="X")

locs <-subset(locs, select= c(lon,lat))

setwd("../pseudo")

bglocs <- read.table(i, header = T, sep = ",",stringsAsFactors = F, row.names="X")

colnames(bglocs)<-c('lon','lat')

group_p=kfold(locs,5)
group_a=kfold(bglocs,5)

test<-sample(1:3,1)

train_p = locs[group_p!=test, c("lon","lat")]

train_a = bglocs[group_a!=test, c("lon","lat")]

test_p = locs[group_p==test, c("lon","lat")]

test_a = bglocs[group_a==test, c("lon","lat")]

setwd("../maxent")

dir.create(i)

me<-maxent(predictors,p=train_p, a=train_a,remove.duplicates=T,path=i)

e = evaluate(test_p, test_a,me,predictors)

#threshold(e)
getwd()
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
?predict
pred_me = predict(me, predictors, filename=i)
setwd("../")
}
