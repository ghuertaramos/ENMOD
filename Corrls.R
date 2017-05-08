#! /usr/bin/Rscript
## Script to generate correlation coefficients significancies and plots from climatic data
## Guillermo Huerta Ramos

# start with a fresh brain
rm(list = ls())

# load libraries
#install.packages("corrplot")
library('corrplot')

# get file names from input data to use for the loop
file.names <- dir("./ENMOD/vars")

# this directory will contain csv files with final data
dir.create("./ENMOD/corrls")

# this directory will contain png files with final data
dir.create("./ENMOD/corrlsgraphs")

# set working directory to begin loop
setwd("./ENMOD/corrlsgraphs")

for(x in file.names){
  
setwd("../vars")

  print(paste0("reading ", x, " file"))  

vars<-read.csv (x, header = TRUE,row.names="X", sep = ",")

# compute the correlations between the columns of x and the columns of y
varscor<-cor(vars, use = "complete.obs")

setwd("../corrls")

# generate the file with correlation coefficientes
print(paste0("writing ", x, " correlation file"))
write.table(varscor,x,sep = ",", row.names = TRUE, col.names = TRUE)

# to generate a plot  with significancies. As described in corrplot package
cor.mtest <- function(mat, conf.level = 0.95){
  mat <- as.matrix(mat)
  n <- ncol(mat)
  p.mat <- lowCI.mat <- uppCI.mat <- matrix(NA, n, n)
  diag(p.mat) <- 0
  diag(lowCI.mat) <- diag(uppCI.mat) <- 1
  for(i in 1:(n-1)){
    for(j in (i+1):n){
      tmp <- cor.test(mat[,i], mat[,j], conf.level = conf.level)
      p.mat[i,j] <- p.mat[j,i] <- tmp$p.value
      lowCI.mat[i,j] <- lowCI.mat[j,i] <- tmp$conf.int[1]
      uppCI.mat[i,j] <- uppCI.mat[j,i] <- tmp$conf.int[2]
    }
  }
  return(list(p.mat, lowCI.mat, uppCI.mat))
}

res1 <- cor.mtest(vars,0.95)
res2 <- cor.mtest(vars,0.99)

setwd("../corrlsgraphs")

## generate the plot file for the correlated variables with significancies under 0.05
print(paste0("writing ", x, " correlation plot"))
png(filename=x)
corrplot(varscor,method = "number",type = "lower", insig = "blank", p.mat = res1[[1]], sig.level=0.1, number.cex=0.6)
dev.off()
}