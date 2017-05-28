# ENMOD

# Ecological Niche Modeling on Docker


Docker image to develop and analize ecological niche models (ENM). 
 These scripts allow the user to download data from Global Biodiversity Information Facility (GBIF) to generate ocurrence files, ocurrence maps, and generate ENMs on batch mode.
 
### Current available functions are:

**Records.R** 

 Download records from GBIF database and produce `.csv` files for query species.
 
**Clean.R**

 Eliminate duplicate records, not applicable data (NA), and generate maps
 
 **Rarf.R** 
 
 Reduce the number of records (less than 1km apart) using the grid method. It also generates maps for output records. This script is disabled for species with less than 30 records by default.

**Pseudo.R**

 Generate pseudoabsence points from record data.

 **Vars.R**
 
 Extract climatic data from rasters based on species records.

 **Corrls.R**
 
 Generate correlation coefficients, significancies and plots from climatic data.
 
 **Maxent.R**
 
Generate Ecological Niche Model for input species, it also generates output data and graphs for model evaluation.

 
### Coming  soon:

**Merge.R**

Merge data from other databases.
  
 **Thinsp.R**
 
 Spatial rarefaction using ThinsSP algorithm (Aiello-Lammens *et al*. 2015)

## Getting Started

The scripts are intended to work as a single pipeline. Future versions will include compability with user provided databases.

Be aware this is work in progress. Thus scripts may be prone to bugs and errors. 

Generating ENMs is not an easy task, it demands a lot of knowledge on species biology, niche theory and niche modeling methodology. Please, carefuly evaluate every step of the pipeline and  tweak the scripts to suit your own needs. Current final ENMs are suitable at best for exploratory analysis 

Current version was designed as a final project for the course ["Introduction to bioinformatics and reproducible research  for genetic analyses"](https://github.com/AliciaMstt/BioinfInvRepro2017-II) by Alicia Yanes Mastretta and Azalea García 



 A tutorial on the use of ENMOD is available at [tutorial.md](https://github.com/ghuertaramos/ENMOD/blob/master/Tutorial.md)

![ ](https://github.com/ghuertaramos/ENMOD/blob/master/mdneflow.png  "Workflow")


### Prerequisites

- Docker software installed

	Further information can be found on docker website:

[![Docker](https://www.shippable.com/assets/images/logos/docker-cloud.jpg)](https://docs.docker.com/engine/installation/)


- You will need a working directory containing:

 - An input file,  "especies.csv"

(Required for `Records.R`)


This file must include a column with the species names you are interested.  Use the following format:

|Species            |
|--------------------|
| genus species  |

*Note first row is the column label

 - Raster files from [WorldClim Database ](http://www.worldclim.org/) in `.asc` format in a directory named "rasters".

Raster files must be clipped to coincide with your species distribution. If species records fall outside your raster coordinates  you will get NA data.

(Required for `Vars.R` and `Maxent.R`)


### Installing

Dowload the latest image using the following command:

```
docker pull ghuertaramos/enmod:latest
```


## Running the tests

Once the image is pulled from docker cloud. 

- You may set a shortname for the path of your working directory

```
mydata=/home/user/Documents/mydirectory/
```
This directory must contain `especies.csv` file and `rasters` directory with 19 `.asc` files from worldclim database.

- Run the scripts using the following command:

```
docker run --rm -v $mydatapath:/ENMOD/data ghuertaramos/enmod Rscript Records.R
```
The command beaks down as:

The flag `--rm` deletes the container after the script execution.

The local directory shortened in  `mydata` is mounted in a new container  using the flag `-v`

`:/ENMOD/data` is the name of the volume inside the container, this name must be mantained for the scripts to work.

`ghuertaramos/ENMOD` is the name of the image we previously dowloaded

`Rscript Records.R` is the command to run the `Records.R` function, it can be changed for the other functions available on this image.

## Known issues


In `Records.R` if query species has no records on gbif database, the script will fail. This can also ocurr if the species name is misspelled.

`Rarf.R` may take a long time to finish, it is also very important to notice that current script only works for records in the americas.
The exact ranges are:
Longitude: -131,-38
Latitude: -49,55

## Authors

* **Guillermo Huerta Ramos** - *Initial work* - [ghuertaramos](https://github.com/ghuertaramos)


## License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/ghuertaramos/ENMOD/blob/master/LICENSE.md) file for details

## Citations

Hadley Wickham (2017). tidyr: Easily Tidy Data with 'spread()'
  and 'gather()' Functions. R package version 0.6.3.
  
Robert J. Hijmans, Steven Phillips, John Leathwick and Jane Elith
  (2017). dismo: Species Distribution Modeling. R package version
  1.1-4.
  
 Robert J. Hijmans (2016). raster: Geographic Data Analysis and
  Modeling. R package version 2.5-8.
  
 Roger Bivand and Nicholas Lewin-Koh (2017). maptools: Tools for
 Reading and Handling Spatial Objects. R package version 0.9-2.
  
 Roger Bivand and Colin Rundel (2017). rgeos: Interface to
 Geometry Engine - Open Source (GEOS). R package version 0.3-23.
 
 Simon Urbanek (2016). rJava: Low-Level R to Java Interface. R
 package version 0.9-8.
  
Steven J. Phillips, Miroslav Dudík, Robert E. Schapire. [Internet] Maxent software for modeling species niches and distributions (Version 3.4.1). Available from url: http://biodiversityinformatics.amnh.org/open_source/maxent/.

Taiyun Wei and Viliam Simko (2016). corrplot: Visualization of a
  Correlation Matrix. R package version 0.77.

## Acknowledgments

* To anyone who's code was used (mentioned in each script)
* [Alicia Mastretta Yanes](https://github.com/AliciaMstt) For commentaries and guidance
* [Azalea Guerra García](https://github.com/AzaleaGuerra)  For commentaries and guidance
* [Ruth Delgado](https://github.com/REDD1326) For commentaries and troubleshooting
* [Jeremy Yoder](https://github.com/jbyoder) For code and guidance
