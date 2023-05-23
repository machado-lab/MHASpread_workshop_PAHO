# Workshop (December 12-15, 2022): Use of transmission models to simulate the spread of livestock diseases [![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)



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



## Pre workshop activities 

| **Topic**                          | **Activity and assignment**                                                                                                       | **Date** |
|------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|----------|
| R packages installation videocall | Install all R packages depencies via videocall. [Link to call click here.](https://ncsu.zoom.us/j/99221345276?pwd=K0hFY1dQR3AzUlJXTjFZSU1PblNBdz09)                                               | November 29; 14:00 - 16:00(GMT-05:00) Eastern Time - New York |
| [R & RStudio](https://github.com/machado-lab/workshop_MHASpread/tree/main/install_RStudio_and_packages)| Final installation and validation                                                                                   | December 10 and 11 |
| Introduction to disease spread     | [A Practical Introduction to Mechanistic Modeling of Disease Transmission in Veterinary Science](https://doi.org/10.3389/fvets.2020.546651)                                    | November/28/22 |
| Use of data to prepare against FMD | [Challenges and opportunities for using national animal datasets to support foot-and-mouth disease control]( https://doi.org/10.1111/tbed.13858)                         | December/05/22 |
| Prepare countries data to be used during the workshop and MHASpread package | Instructors and country members face-to-face meeting | December 10 and 11 |

## :calendar: Calendar 
Pre-workshop software installation December 10-11, 2022.

| **Day-1 (December 12)** | **Topics** |  
|---|---|
| Review the global and regional risk situation of FMD *Morning (9:00 AM-12:00 AM) | _Welcome & introductions_  <br />  <br />  1. Importance of the response plan in outbreak events <br /> 2. Briefly discuss the key content on the FMD contingency plans on the countries (and the strategies to control). <br /> 3. In an overview of the regional antigen bank, BANVACO. <br /> 4. Emergency stockpile system in the Rio Grande do Sul Brazil. |  
| Important concepts of disease transmission modeling *Afternoon (1:00 PM-5:00 PM) |  _Gentle introduction of transmission models_  <br />  <br /> 1. Importance of the response plan in outbreak events. <br /> 2. Introduction to disease transmission models <br /> 3. How simulation models can help the design and update of control strategies. <br /> 4. How to integrate the model outputs with real case scenarios. |  
| **Day-2 (December 13)** | **Topics** |  
|  Introduction to Rstudio installing R/Rstudio and MHSpread   *Morning (9:00 AM-12:00 AM) | _The whole game: why R and Rstudio environment_ <br />  <br />  1. Installation of R, Rstudio, packages. <br /> 2. Setting up your computer system. <br /> 3. MHASpread architecture. <br /> 4. Load the package and set the environment. <br /> 5. Define initial conditions. <br /> 6. Select the originally infected farm. <br /> 7. Export output numeric summaries and plots. |  
| Simulating FMD epidemics with and without countermeasures.  *Afternoon (1:00 PM-6:00 PM) | _FMD epidemics_ <br />  <br /> 1. Select the initial infection condition (with your own data)  <br /> 2. Seeding infections and reconstruct spread (epidemic size). <br /> 3. Simulate control and eradication actions (vaccination, depopulation, movement restrictions. <br /> 4. Export output numeric summaries and plots. |  
| **Day-3 (December 14)** | **Topics** |  
| Simulating FMD epidemics with and without countermeasures.  *Morning (9:00 AM-12:00 AM) | _Simulate FMD introduction and spread from swine, bovine, and small ruminant populations_ <br />  <br />  1. Estimate epidemic trajectories. <br /> 2. Implementation of control and eradication actions and proposed next steps for elimination. <br /> 3. Extract model outputs to be used in decision-making.  <br /> 4. Simulation of alternative control scenarios <br /> 5. Enlarge control zone size. <br /> 6. Trace back in the contact networks.  <br /> 7. Increase the duration of control zones and surveillance activities. |  
| Revisiting key concepts of disease transmission modeling and hosting an FMD transmission and control expert opinion panel. *Afternoon (1:00 PM-6:00 PM) | _FMD model parameters expert opinion panel_ <br /> <br /> Expert opinion will use to select and adjust transmission parameters in various scenarios (i.e., estimates on time intervals for laboratory confirmation after the detection of infected premises and for starting the depopulation protocol) Hot wash |  
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


