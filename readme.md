# ENMOD

# Ecological Niche Modeling on Docker


Docker image and scripts to develop and analize ecological niche models (ENM). 
 This repository allows the user to download data from Global Biodiversity Information Facility (GBIF) to generate ocurrence maps, and ENMs on batch mode.
 
### Current available functions are:

**Records.R**
 Downloads records from GBIF database and produces `.csv` files for query species.
 
**Clean.R**
 Eliminates duplicate records, Not applicabble Data (NA), and generates maps
 
 **Rarf.R** 
 Excludes close records (less than 1km) using the grid method. It also  generates maps for output records. It is not used for species with less than 30 records by default.

**Pseudo.R**
 Generates pseudoabsence points from record data.

 **Vars.R**
 Extract climatic data from rasters based on species records.

 **Corrls.R**
 Generate correlation coefficients significancies and plots from climatic data.

**Maxent.R**
Generates Ecological Niche Model for input species, it also generates output data for model evaluation.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.
This  series of scripts are intended to wrok as a single pipeline but using certain format will allows the user to use any script from own data.

### Prerequisites

You will need a directory containing:

- An input file  "especies.csv"
(Required for Records.R)


This file must include a column with the species names you are interested.

 Use the following format:

|Species            |
|--------------------|
| Ipomoea sagittata  |
| Ipomoea stans      |
| Ipomoea suaveolens |


- Raster files from [WorldClim Database ](http://www.worldclim.org/) in `.asc` format
(Required for Vars.R and Maxent.R)

These files should be included in a directory named "rasters" inside ENMOD directory


- Docker software installed

Further information can be found on docker website:

[![Docker](https://www.shippable.com/assets/images/logos/docker-cloud.jpg)](https://docs.docker.com/engine/installation/)




- The scripts to be used

For docker you will need the previous files and also:

- Docker file

### Installing

A step by step series of examples that tell you have to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

```
misdatos=/home/memo/Documents/ENMODTESTS/PruebaDocker

docker run -v $misdatos:/ENMOD enmod Rscript nombrescript.R

docker run -v $misdatos:/ENMOD enmod Rscript Records.R
```
## Known issues

Add additional notes about how to deploy this on a live system

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
