# Workshop: Use of transmission models to simulate the spread of livestock diseases [![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)



<a href="url"><img src="https://github.com/ncespedesc/logos_nc_state/blob/main/MHASpread_logo.png?raw=true" align="left" height="150" width="150" ></a>

## :mortar_board: About this workshop

> In this four-day workshop, we provide a gentle introduction to a range of mathematical models used to simulate the spread and control of livestock diseases. You learn how such models can be used to make informed decisions **before**, **during**, and **after** an animal health emergency.
<br /> We will focus on the application of such epidemiological models while demonstrating their use with real data while simulating FMD outbreaks. The real data we will need includes


## :bomb: Aims of the workshop
* Learn how to use the MHASpread v.0.1.0 package, introduction, and control of FMD.
    - [ ]  Overview of the model outputs and their interpretation.
    - [ ]  MHASpread to simulate FMD countermeasure actions (depopulation, vaccination, and traceability). 
    - [ ]  To be exposed to additional transmission models.

## :floppy_disk: Data and files required 

We will focus on the application of such epidemiological models while demonstrating their use with real data while simulating FMD outbreaks. The real data we will need includes:

1. List of farms with unique identification, geolocation (lat and long), and a number of animals per premise by species (e.i., farm A has 10 cattle, 100 swine, and 3 goats).
2. Number of animals born alive and mortality per premise and species.
3. Between-farm and slaughterhouse movement data, which include:    
   * Unique identification at origin and at the destination.
   * Date of the movement.
   * The number of animals transported for each species.




## Pre workshop activities 

| **Topic**                          | **Activity and assignment**                                                                                                       | **Date** |
|------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|----------|
| [R & RStudio](https://github.com/machado-lab/workshop_MHASpread/tree/main/install_RStudio_and_packages)| Video call to set Rstudio in your computer [_link to call here:_](https://ncsu.zoom.us/j/93057927377?pwd=V2diU0ZaQmJjdWlTaUJGNXZFUG0zZz09)                                                                                         | Sep/12/22 |
| Introduction to disease spread     | [A Practical Introduction to Mechanistic Modeling of Disease Transmission in Veterinary Science](https://doi.org/10.3389/fvets.2020.546651)                                    | Sep/12/22 |
| Why use models                     | [Three questions to ask before using model outputs for decision support](https://doi.org/10.1038/s41467-020-17785-2)               | Sep/26/22 |
| Use of data to prepare against FMD | [Challenges and opportunities for using national animal datasets to support foot-and-mouth disease control]( https://doi.org/10.1111/tbed.13858)                         | Oct/01/22 |
| Main transmission routes           | [Understanding the transmission of foot-and-mouth disease virus at different scales](https://doi.org/10.1016/j.coviro.2017.11.013) | Oct/10/22 |


## :calendar: Calendar 

| **Day-1 (October 17)**                                                                                                                          | Topics                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
|---------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Review of FMD modeling outbreaks, the application of the MHASpread R package. We will use actual population and movement data *Morning      | Welcome & introductions Importance of the response plan in outbreak events. How simulation models can help the design and update of control strategies. How to integrate the model outputs with real case scenarios. The whole game: why R and Rstudio environment.                                                                                                                                                                                                                                                                                                                |
| Introduction to Rstudio installing R/Rstudio and MHSpread  *Afternoon                                                                       | Installation of R, Rstudio, packages. Setting up your computer system.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| **Day-2 (October 18)**                                                                                                                          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| Hands-on MHASpread  & Morning                                                                                                               | MHASpread architecture. Load the package and set the environment. Define initial conditions. Select the originally infected farm. Export output numeric summaries and plots.                                                                                                                                                                                                                                                                                                                                                                                                       |
| Simulating FMD epidemics within the state of Rio Grande do Sul.  *Afternoon                                                                 | Select the initial condition  Seeding infections and reconstruct spread along with epidemic sizes. Simulate control and eradication actions biweek. Export output numeric summaries and plots. MHASpread is integrated with the Rapid Access Biosecurity (RAB) app to expedite decision-making.                                                                                                                                                                                                                                                                                    |
| **Day-3 (October 19)**                                                                                                                          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| The simulation of FMD epidemics with index cases in swine, cattle, and small ruminants. & Morning and *Afternoon                            | Simulate FMD introduction and spread from swine, bovine, and small ruminants populations  Estimate epidemic trajectories. Implementation of control and eradication actions and proposed next steps for elimination. Extract model outputs and data into RABapp™ Simulation of alternative control scenarios Enlarge control zone size. Traceback in the contact networks.  Increase the duration of control zones and surveillance activities. Demonstrate the real model repeats (from the code stack). Simulate scenarios that will take place next week in the field exercise. |
| **Day-4 (October 20)** Afternoon                                                                                                                |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|Demonstration   of other transmission models <br /> Take home from the FMD model (25 min) [zoom video call link here](https://ncsu.zoom.us/j/92870293089)    | The Rio Grande do Sul, ASF transmission model ( Dr. G. Machado) (20min) <br />PigSpread ASF model U.S. (Abby Sykes, MSc via Zoom) (25 min) <br /> PigSpread PRRS model the U.S. (20 min) <br /> Between-farm vehicle movements and swine disease spread (Dr. Jason Galvis) (25   min) <br /> Depopulation welfare (Dr. Monique) (25 min) <br />                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| Question round other applications   & Morning                                                                                                        | Questions and future remarks                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |


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


