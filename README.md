# Workshop use of transmission models to simulate the spread of livestock diseases [![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)

<a href="url"><img src="https://github.com/ncespedesc/logos_nc_state/blob/main/MHASpread_logo.png?raw=true" align="left" height="150" width="150" ></a>

## :mortar_board: About this workshop

> In this four-day workshop, we provide a gentle introduction to a range of mathematical models used to simulate the spread and control of livestock diseases. You learn how such models can be used to make informed decisions **before**, **during**, and **after** an animal health emergency.
<br /> We will focus on the application of such epidemiological models while demonstrating their use with real data while simulating FMD outbreaks.

>We use the MHASpread: A multi-host animal spread stochastic multilevel model (version 0.1.1) which is an R package to be used throughout the training. The MHASpread allows for explicit specification of species-specific disease transmission probability, among other important transmission dynamics of disease infecting multiple species, such as FMD. This model considers the entry and exit of animals given between-farm animal movements, movements into slaughterhouses, births, and, deaths, for each species. 
>You will learn how to use MHASpread, including the simulation of the introduction, and dissemination of FMD in our own country. You will have access to highly specialized computational and epidemiological tools within an easy-to-use workflow. 


## :bomb: Aims of the workshop
* Learn how to use the MHASpread v.0.1.0 package, introduction, and control of FMD.
    - [ ]  Overview of the model outputs and their interpretation.
    - [ ]  MHASpread to simulate FMD countermeasure actions (depopulation, vaccination, and traceability). 
    - [ ]  To be exposed to additional transmission models.

## :floppy_disk: Data and files required 

We will focus on the application of such epidemiological models using data with more than one species (i.e. Bovine, swine, and Small ruminants) while demonstrating their use with real data while simulating FMD outbreaks. The real data we will need includes:

1. List of farms with unique identification, geolocation (lat and long), and a number of animals per premise by species (e.i., farm A has 10 cattle, 100 swine, and 3 goats).
2. Number of animals born alive and mortality per premise and species.
3. Between-farm and slaughterhouse movement data, which include:    
   * Unique identification at origin and at the destination.
   * Date of the movement.
   * The number of animals transported for each species.

## :computer: Computer requirements
In general, any computer medium to high quality released during the last five years should be able to support R and Rstudio, however, there are minimum computer requirements that should be considered.

- [ ]  Intel Core i5 (4 CPUs)  6th generation or above or equivalent AMD X8  @ 4GHZ (8 CPUs) or above. 
- [ ]  Memory: 8GB.
- [ ]  HDD Space: 65GB.

### Usefull links
- [ ]  [How to install R and Rstudio](https://github.com/machado-lab/workshop_MHASpread/blob/main/install_RStudio_and_packages/README.md) 
- [ ]  [Necessary packages to run the model](https://github.com/machado-lab/workshop_MHASpread/blob/main/install_RStudio_and_packages/package_to_install.R) 

## Authors
Nicolas Cespedes Cardenas [![ORCIDiD](https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png)](https://orcid.org/0000-0001-7884-2353)

Gustavo Machado [![ORCIDiD](https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png)](https://orcid.org/0000-0001-7552-6144)

## Reference 

[Modeling foot-and-mouth disease dissemination in Brazil and evaluating the effectiveness of control measures](https://www.biorxiv.org/content/10.1101/2022.06.14.496159v2)


## :computer: Website
[Machado Laboratory website](https://machado-lab.github.io/) 

## :muscle: Sponsors
<a href="url"><img src="https://github.com/ncespedesc/logos_nc_state/blob/main/pahologo.png?raw=true" align="center" width="300" ></a>
<a href="url"><img src="https://github.com/ncespedesc/logos_nc_state/blob/main/fundesalogo.jpg?raw=true" align="left" width="300" ></a>

<a href="url"><img src="https://github.com/ncespedesc/logos_nc_state/blob/main/ncstate-type-4x1-red-min.png?raw=true" align="right" width="300" ></a>


<a href="url"><img src="https://github.com/ncespedesc/logos_nc_state/blob/main/seapilogo.png?raw=true" align="center" width="300" ></a>


