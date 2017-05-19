# ENMOD

# Ecological Niche Modeling on Docker


Docker image to develop and analize ecological niche models (ENM). 
 These scripts allow the user to download data from Global Biodiversity Information Facility (GBIF) to generate ocurrence files, ocurrence maps, and ENMs on batch mode.
 
### Current available functions are:

**Records.R**
 Download records from GBIF database and produce `.csv` files for query species.
 
**Clean.R**
 Eliminate duplicate records, not applicabble data (NA), and generate maps
 
 **Rarf.R** 
 Reduce the number of records (less than 1km apart) using the grid method. It also generates maps for output records. This script is disabled for species with less than 30 records by default.

**Pseudo.R**
 Generate pseudoabsence points from record data.

 **Vars.R**
 Extract climatic data from rasters based on species records.

 **Corrls.R**
 Generate correlation coefficients significancies and plots from climatic data.
 
###Coming  soon:
  
 **Thinsp.R**
 Spatial rarefaction using ThinsSP algorithm (Aiello-Lammens *et al*. 2015)

**Maxent.R**
Generate Ecological Niche Model for input species, it also generates output data for model evaluation.

## Getting Started

This series of scripts are intended to work as a single pipeline but using the provided format for each script will allows the user to use own data fro each function separately.

### Prerequisites

- Docker software installed

	Further information can be found on docker website:

[![Docker](https://www.shippable.com/assets/images/logos/docker-cloud.jpg)](https://docs.docker.com/engine/installation/)


- You will need a working directory containing:

 - An input file,  "especies.csv"

(Required for Records.R)


This file must include a column with the species names you are interested.  Use the following format:

|Species            |
|--------------------|
| Ipomoea sagittata  |
| Ipomoea stans      |
| Ipomoea suaveolens |


 - Raster files from [WorldClim Database ](http://www.worldclim.org/) in `.asc` format.

(Required for Vars.R and Maxent.R)

The previous files should be included in a directory named "rasters".

### Installing

Dowload the latest image using the following command:

```
docker pull ghuertaramos/enmod:latest
```


## Running the tests

Once the image is pulled from docker cloud 

Preferably set a shortname for the path of your working directory

```
mydata=/home/user/Documents/mydirectory/
```
This directory must contain `especies.csv` file and `rasters` directory with 19 `.asc` files from worldclim database.

Then run the scripts using the following commands:

```
docker run -ephemeral -v $mydatapath:/ENMOD/data ghuertaramos/enmod Rscript Records.R
```
The flag `-ephemeral` deletes the container after the script execution.

The local directory shortened in  `mydata` is mounted new container  using the flag `-v`

`:/ENMOD/data` is the name of the volume inside the container, this name must be mantained for the scripts to work.

`ghuertaramos/ENMOD` is the name of the image we previously dowloaded

`Rscript Records.R` is the command to run the `Records.R` function, it can be changed for the other functions available on this image.

## Known issues


In Records.R if query species has no records on gbif database script will fail. This can also ocurr if the species name is misspelled.

Rarf.R may take a while to finish the rarefaction, it is also very important to noctice that current script only works for records in the americas. This beahaviour is caused because the grid coordinates are fixed.

Raster files must be trimmed to coincide with your species distribution. If climatic data is not available for a species record information won't be retrieved.

## Authors

* **Guillermo Huerta Ramos** - *Initial work* - [ghuertaramos](https://github.com/ghuertaramos)


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone who's code was used
* Inspiration
* etc
