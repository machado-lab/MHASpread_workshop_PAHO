# Workshop: Use of transmission models to simulate the spread of livestock diseases [![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)



<a href="url"><img src="https://github.com/ncespedesc/logos_nc_state/blob/main/MHASpread_logo.png?raw=true" align="left" height="150" width="150" ></a>

## :mortar_board: About this workshop

> In this four-day workshop, we provide a gentle introduction to a range of mathematical models used to simulate the spread and control of livestock diseases. You learn how such models can be used to make informed decisions **before**, **during**, and **after** an animal health emergency.
<br /> We will focus on the application of such epidemiological models while demonstrating their use with real data while simulating FMD outbreaks.

We use the MHASpread: A multi-host animal spread stochastic multilevel model (version 0.1.1) which is an R package to be used throughout the training. The MHASpread allows for explicit specification of species-specific disease transmission probability, among other important transmission dynamics of disease infecting multiple species, such as FMD. This model considers the entry and exit of animals given between-farm animal movements, movements into slaughterhouses, births, and, deaths, for each species. 
You will learn how to use MHASpread, including the simulation of the introduction, and dissemination of FMD in our own country. You will have access to highly specialized computational and epidemiological tools within an easy-to-use workflow. 



<br /> 

## :bomb: Aims of the workshop
* Learn how to use the MHASpread v.0.1.0 package, introduction, and control of FMD.
    - [ ]  Overview of the model outputs and their interpretation.
    - [ ]  MHASpread to simulate FMD countermeasure actions (depopulation, vaccination, and traceability). 
    - [ ]  To be exposed to additional transmission models.

<br /> 

## :floppy_disk: Data and files required 

We will focus on the application of such epidemiological models using data with more than one species (i.e. Bovine, swine, and Small ruminants) while demonstrating their use with real data while simulating FMD outbreaks. The real data we will need includes:

1. List of farms with unique identification, geolocation (lat and long), and a number of animals per premise by species (e.i., farm A has 10 cattle, 100 swine, and 3 goats).
2. Number of animals born alive and mortality per premise and species.
3. Between-farm and slaughterhouse movement data, which include:    
   * Unique identification at origin and at the destination.
   * Date of the movement.
   * The number of animals transported for each species.

## :computer: Computer requirements

- [ ]  Intel Core i5 (4 CPUs)  6th generation or above or equivalent AMD X8 FX-8350 @ 4GHZ (8 CPUs) or above. 
- [ ]  Memory: 8GB.
- [ ]  HDD Space: 65GB.



## Pre workshop activities 

| **Topic**                          | **Activity and assignment**                                                                                                       | **Date** |
|------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|----------|
| [R & RStudio](https://github.com/machado-lab/workshop_MHASpread/tree/main/install_RStudio_and_packages)| Video call to set Rstudio in your computer [_link to call here:_](https://ncsu.zoom.us/j/98163871036?pwd=b0g2dnRSWUJ3UDFidWFES2p0TGtpZz09)                                                                                         | Thursday, November 10 |
| Introduction to disease spread     | [A Practical Introduction to Mechanistic Modeling of Disease Transmission in Veterinary Science](https://doi.org/10.3389/fvets.2020.546651)                                    | November/28/22 |
| Use of data to prepare against FMD | [Challenges and opportunities for using national animal datasets to support foot-and-mouth disease control]( https://doi.org/10.1111/tbed.13858)                         | December/05/22 |


## :calendar: Calendar 

| **Day-1 (December 12)** | **Topics** |  
|---|---|
| Review the global and regional risk situation of FMD *Morning (9:00 AM-12:00 AM) | <br /> Briefly discuss the key content on the FMD contingency plans on the countries (and the strategies to control). <br /> In an overview of the regional antigen bank, BANVACO. <br /> Emergency stockpile system in the Rio Grande do Sul Brazil. |  
| Important concepts of disease transmission modeling *Afternoon (1:00 PM-5:00 PM) | _Welcome & introductions_ <br /> Importance of the response plan in outbreak events. <br /> Introduction to disease transmission models <br /> How simulation models can help the design and update of control strategies. <br /> How to integrate the model outputs with real case scenarios._ |  
| **Day-2 (December 13)** | **Topics** |  
|  Introduction to Rstudio installing R/Rstudio and MHSpread   *Morning (9:00 AM-12:00 AM) | The whole game: why R and Rstudio environment. <br /> Installation of R, Rstudio, packages. <br /> Setting up your computer system. <br /> MHASpread architecture. <br /> Load the package and set the environment. <br /> Define initial conditions. <br /> Select the originally infected farm. <br />Export output numeric summaries and plots. |  
| Simulating FMD epidemics with and without countermeasures.  *Afternoon (1:00 PM-6:00 PM) | Select the initial infection condition (with your own data)  <br /> Seeding infections and reconstruct spread (epidemic size). <br /> Simulate control and eradication actions (vaccination, depopulation, movement restrictions. <br /> Export output numeric summaries and plots. |  
| **Day-3 (December 14)** | **Topics** |  
| Simulating FMD epidemics with and without countermeasures.  *Morning (9:00 AM-12:00 AM) | Simulate FMD introduction and spread from swine, bovine, and small ruminant populations  Estimate epidemic trajectories. <br /> Implementation of control and eradication actions and proposed next steps for elimination. <br /> Extract model outputs to be used in decision-making.  <br /> Simulation of alternative control scenarios <br /> Enlarge control zone size. <br /> Trace back in the contact networks.  <br /> Increase the duration of control zones and surveillance activities. |  
| Revisiting key concepts of disease transmission modeling and hosting an FMD transmission and control expert opinion panel. *Afternoon (1:00 PM-6:00 PM) | FMD model parameters expert opinion panel <br />Expert opinion will use to select and adjust transmission parameters in various scenarios (i.e., estimates on time intervals for laboratory confirmation after the detection of infected premises and for starting the depopulation protocol) Hot wash |  
| **Day-4 (December 15)** | **Topics** |  |
| Participants present their key outputs *Morning (9:00 AM-12:00 AM) | Based on the simulations you have run, what would revise from your current FMD contingency plan? |  |

### Usefull links
- [ ]  [How to install R and Rstudio](https://github.com/machado-lab/workshop_MHASpread/blob/main/install_RStudio_and_packages/README.md) 
- [ ]  [Necessary packages to run the model](https://github.com/machado-lab/workshop_MHASpread/blob/main/install_RStudio_and_packages/package_to_install.R) 

## Authors
Nicolas Cespedes Cardenas [![ORCIDiD](https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png)](https://orcid.org/0000-0001-7884-2353)

Gustavo Machado [![ORCIDiD](https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png)](https://orcid.org/0000-0001-7552-6144)

## Reference 

[Modeling foot-and-mouth disease dissemination in Brazil and evaluating the effectiveness of control measures](https://www.biorxiv.org/content/10.1101/2022.06.14.496159v2)


## :computer: Website
[MachadoLAb](https://machado-lab.github.io/) 

## :muscle: Sponsors
<a href="url"><img src="https://github.com/ncespedesc/logos_nc_state/blob/main/pahologo.png?raw=true" align="center" width="600" ></a>
<a href="url"><img src="https://github.com/ncespedesc/logos_nc_state/blob/main/fundesalogo.jpg?raw=true" align="left" width="300" ></a>

<a href="url"><img src="https://github.com/ncespedesc/logos_nc_state/blob/main/ncstate-type-4x1-red-min.png?raw=true" align="right" width="300" ></a>


<a href="url"><img src="https://github.com/ncespedesc/logos_nc_state/blob/main/seapilogo.png?raw=true" align="center" width="300" ></a>


