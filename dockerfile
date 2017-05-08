#Base image
FROM r-base

# Maintainer 
MAINTAINER Guillermo Huerta Ramos <ghuertaramos@gmail.com>

#Metadata

#Install neded packages and dependencies
RUN apt-get update 
RUN apt-get -y install libgeos-3.5.1
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile
RUN Rscript -e "install.packages(c('dismo','maptools','jsonlite','tidyr','raster', 'corrplot'))"

#Copyscripts

COPY . ./
WORKDIR ./

CMD ["Rscript", "Records.R"]
CMD ["Rscript", "Clean.R"]
CMD ["Rscript", "Rarf.R"]
CMD ["Rscript", "Pseudo.R"]
CMD ["Rscript", "Vars.R"]
CMD ["Rscript", "Corrls.R"]
