# ENMOD

# Ecological Niche Modeling on Docker


Docker image to develop and analize ecological niche models (ENM). 
 These scripts allows the user to download data from Global Biodiversity Information Facility (GBIF) to generate ocurrence files, ocurrence maps, and ENMs on batch mode.
 
### Current available functions are:

**Records.R**
 Downloads records from GBIF database and produces `.csv` files for query species.
 
**Clean.R**
 Eliminates duplicate records, not applicabble data (NA), and generates maps
 
 **Rarf.R** 
 Reduces the number of close records (less than 1km) using the grid method. It also  generates maps for output records. It is not used for species with less than 30 records by default.

**Pseudo.R**
 Generates pseudoabsence points from record data.

 **Vars.R**
 Extract climatic data from rasters based on species records.

 **Corrls.R**
 Generate correlation coefficients significancies and plots from climatic data.

**Maxent.R**
Generates Ecological Niche Model for input species, it also generates output data for model evaluation.

## Getting Started

This  series of scripts are intended to work as a single pipeline but using the provided format for each script will allows the user to use own data.

### Prerequisites

- Docker software installed

	Further information can be found on docker website:

[![Docker](https://www.shippable.com/assets/images/logos/docker-cloud.jpg)](https://docs.docker.com/engine/installation/)


- You will need a directory containing:

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

For docker you will need the previous files and also:



- Docker file

- The scripts to be used

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

docker pull enmod


```
mydatapath=/home/user/Documents/ENMOD/

docker run -v $mydatapath:/ENMOD enmod Rscript nombrescript.R

docker run -v $mydatapath:/ENMOD enmod Rscript Records.R
```
## Known issues

In Records.R if query species has no records on gbif database script will fail. This can also ocurr if the species name is misspelled.

Raster files must be trimmed to coincide with your species distribution. If climatic data is not available for a species record information won't be retrieved and there won't be an error.

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.


## Authors

* **Guillermo Huerta Ramos** - *Initial work* - [ghuertaramos](https://github.com/ghuertaramos)


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone who's code was used
* Inspiration
* etc
