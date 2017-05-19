#Base image
FROM r-base

# Maintainer 
MAINTAINER Guillermo Huerta Ramos <ghuertaramos@gmail.com>

#Metadata

#Install neded packages and dependencies
RUN apt-get update 
RUN apt-get -y install libgeos-3.5.1
RUN apt-get -y install git
RUN git clone https://github.com/ghuertaramos/ENMOD.git ./ENMOD
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile
RUN Rscript -e "install.packages(c('dismo','maptools','jsonlite','tidyr','raster', 'corrplot'))"

#Set Working Directory
WORKDIR ./ENMOD

CMD ["Rscript", "Records.R"]
CMD ["Rscript", "Clean.R"]
CMD ["Rscript", "Rarf.R"]
CMD ["Rscript", "Pseudo.R"]
CMD ["Rscript", "Vars.R"]
CMD ["Rscript", "Corrls.R"]
