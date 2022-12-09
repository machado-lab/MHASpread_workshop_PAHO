
# Scenario 1 

For the dissemination and control action, the population and events data will be used. These datasets are synthetic datasets and were created to allow testing of the model. Furthermore, these datasets still preserve the density ratio distribution of the farms, and the events have scale free network properties which are common in animal movement data.

### Backgroud 

Infection starts at farm node= `196734` whic have a population of `100` animals. 
Here, foot-and-nouth-disease was first detected after `14` days of inital disease introduction (infection started with `40` infected animal).

```r 

population <- MHASpread::population  # Get the population data example
population$I_bov_pop[population$node== 196734] <- 40    #  # Infected 40 bovine in the farm id = 196734

# select the in and out farm dynamics (movements, births, deaths etc.. )
events <- MHASpread::events # load the events database

```

## Silent spread 

In this simulation we are going to consider different parameters for foot-and-mouth disease obtained from real data from Rio Grande do Sul. For the purposes of this workshop we are not going to alter the parameters that involve transmission rates between the different species, incubation period and infectious period.


In the next chunk are the lines to code this first bite:



```r
model_1     <- SEIR_model(population = population,                                                 #  Population database
                          events = events,                                                         #  Events database
                          simulation_name = "scenario_1_init",                                     #  Simulation tag name
                          days_of_simulation = 14,                                                 #  Population database
                          initial_day_simulation=1,                                                #  Initial day of simulation
                          max_distance_in_km= 40,                                                  #  Max distance kernel by local disease spread
                          num_threads=1,                                                           #  Number of CPU to parallel tasks; set 1 to not overload your computer
                          a = 0.012,                                                               #  To set kernel curve max infection rate (S*I)/N when animals are in the same area
                          b =  0.6 ,                                                               #  Shape of the kernel curve
                          beta_bov_to_bov= c(min = 0.01833333, mode = 0.025, max = 0.05666667),    #  Transmission coefficient of bovine infects bovine
                          beta_bov_to_swi= c(min = 0.01833333, mode = 0.025, max = 0.05666667),    #  Transmission coefficient of bovine infects swine
                          beta_bov_to_SR=c(min = 0.012, mode = 0.031, max = 0.065),                #  Transmission coefficient of bovine infects small ruminants
                          lambda1_bov=c(min = 3, mode = 5.9, max = 16),                            #  Rate from exposed (E) to infectious (I) in bovine
                          lambda2_bov=c(min = 6, mode = 15, max = 20),                             #  Rate from infectious (I) to recovered (R) in bovine
                          beta_swi_to_swi=c(min = 0.044, mode = 0.14, max = 0.33) ,                #  Transmission coefficient of swine infects swine
                          beta_swi_to_bov=c(min = 0.014, mode = 0.33, max = 0.044) ,               #  Transmission coefficient of swine infects bovine
                          beta_swi_to_SR= c(min = 0.014, mode = 0.33, max = 0.044),                #  Transmission coefficient of swine infects small ruminants
                          lambda1_swi=c(min = 3, mode = 5.9, max = 16),                            #  Rate from exposed (E) to infectious (I) in swine
                          lambda2_swi=c(min = 5, mode = 6.44, max = 14) ,                          #  Rate from infectious (I) to recovered (R) in swine
                          beta_SR_to_SR=c(min = 0.16, mode = 0.24, max = 0.5) ,                    #  Transmission coefficient of small ruminants infects small ruminants
                          beta_SR_to_bov=c(min=0.012,mode=0.031,max= 0.033) ,                      #  Transmission coefficient of small ruminants infects bovine
                          beta_SR_to_swi=c(min = 0.006, mode = 0.024, max = 0.09),                 #  Transmission coefficient of small ruminants infects swine
                          lambda1_SR=c(min = 4, mode = 5, max = 14) ,                              #  Rate from exposed (E) to infectious (I) in small ruminants
                          lambda2_SR=c(min = 6, mode = 15, max = 20) )                             #  Rate from infectious (I) to recovered (R) in bovine

```


----


After run this part we can visualize an epidemic curve for each species according to the period of time that was selected.


<a href="url"><img src="https://user-images.githubusercontent.com/41584216/206779480-609f2c26-847e-4aa3-9f77-70e1ac278373.png" align="center" width="400" ></a>

Also we are able to see the geolocation of the infected and the exposed farms:


<a href="url"><img src="https://user-images.githubusercontent.com/41584216/206780919-6c4be9c0-89d2-42de-8f25-f23c484b02d1.png" align="center" width="400" ></a>

---- 

 The MHAspread package alows to set and crerate specific control actions invervention in especific **Control zones areas** which could be vizualised as well
 
 <a href="url"><img src="https://user-images.githubusercontent.com/41584216/206781762-bb397ee0-4847-4b34-bddf-28b05d40d00a.png" align="center" width="400" ></a>

---- 

## Control action modelling 

in this scenario we gonna assume that control action will considers: 
- [ ] Establish control areas (infected zone = `3`km, buffer zone = `7`km, and surveillance `15` km)
- [ ] Animal movement restrictions fo `30` days. 
- [ ] Depopulate `4` animals per day
- [ ] Vaccinate `50` farms per day with a vaccination efficacy of 90%

how to Manage control actions with MHASpread:

#### Control zones areas

Control action may vary according to the control area, the radius in **kilomenters** of these can be changed through the parameters `infected_size` `buffer_size` and `surveillance_size`.
The following chiunk shows the function in R that encodes this part

```r

    control_zones_areas <- assign_control_zones(population = population,                 # Population database
                                                infected_size = 3,                       # Ratio size in Km of the infected zone
                                                buffer_size = 7,                         # Ratio size in Km of the buffer zone
                                                surveillance_size = 15,                  # Ratio size in Km of the surveillance zone
                                                detected_farms.id = my_infeted_farms,    # farms that have been detected
                                                num_threads = 10)         # Computer threads to be used (please don't overload your computer)
```

#### Farm standstill

With this function, we will control the movements between farms from infected areas to uninfected regions. The `ban_length` parameter will control the number of days in which the movement of farms will not be allowed, while the `infected_zone`,  `buffer_zone`,  `surveillance_zone` parameters refer to in whichzones  these ban will be applied. Finally, `direct_contacts` and `traceback_length` refer to blocking movement from positive properties and how many steps using the network these actions should be applied. 


```r
  events <- movement_control_ca(population = population,                #  Population database
                                events = events,                        #  Events database
                                day = day,                              #  Day of start the control movements
                                control_zones_db = control_zones_areas, #  Object with the farms in control areas
                                ban_length = 30,                        #  30 days of movements ban
                                infected_zone = T,                      #  Animal ban will be applied to infected zone
                                buffer_zone = T,                        #  Animal ban will be applied to buffer zone
                                surveillance_zone = T,                  #  Animal ban will be applied to surveillance zone
                                direct_contacts = T,                    #  Ban farm outside of control zones with contact with positive farms
                                traceback_length = 1)                   #  Traceback in-going animals movements of infected farms
```
#### Depopulation 

Here we are going to take account of the depopulation of farms, for modeling purposes we are going to set the maximum number of farms to be depopulated per day by using the parameter `limit_per_day_farms`. Here, the properties will be prioritized according to the following criteria: > cattle population > swine population > small ruminant population. In addition the the parameter `only_depop_infect_farms` allws to depopulate farms in the infected zone as well even if they are not possitive or vaccinated. 

```r
  depop_result <- depop_farms_ca(population = population,                 #  Population database
                                 limit_per_day_farms = 10,                  #  10 farm will be depopulated by day
                                 infected_zone = T,                         #  Depopulation will be applied to infected zone
                                 farms_in_zones = control_zones_areas,      #  Object with the farms in control areas
                                 only_depop_infect_farms = T ,
                                 infected_farms = my_infeted_farms)         #  Id of the farms that have been detected
````
#### Vaccination 

This function will implement daily on-farm vaccination in the simulated population. the parameter "limit_per_day_farms" will set the maximum number of farms to be vaccinated per day. The model also allows you to decide if you want to vaccinate infected farms or not "vacc_infectious_farms". Additionally, the parameters `infected_zone`, `buffer_zone`, and `surveillance_zone` will select in which areas the vaccination will be applied. Next, the parameters `vacc_bovine`, `vacc_swine`, and `vacc_small` will help to select in which species can be vaccinated or not. Finally we can set the vaccine efficacy for example 90% efficacy by using `vaccine_efficacy=0.9`


### Plot results of control action modelling

Here we will visualizase some result from the model after run the control actions simulation loop

#### Plot the number of infected farm considering initial spread + the control actions



 <a href="url"><img src="https://user-images.githubusercontent.com/41584216/206794779-c9ef3010-3e92-40e8-af33-6a5ed874abfe.png" align="center" width="400" ></a>

The y axis represent the number of infected farms. The x-axis represent the time stept period in days. Color line reprersents the total of infected farms, and farm-specie-related over time. The vertical dahsed line represent when the control ation were placed. 


#### Plot the number of depopulated farms during the control actions simulated period 

 <a href="url"><img src="https://user-images.githubusercontent.com/41584216/206796360-e35b80e6-6949-404a-bb8f-00147ad54a17.png" align="center" width="400" ></a>

The y axis represent the number of infected farms. The x-axis represent the time stept period in days. the color background reprersents the  farm-specie-related over time.

also can be plotted by animals as

 <a href="url"><img src="https://user-images.githubusercontent.com/41584216/206796955-099ee072-f12e-4735-ae07-5c70cb3d7137.png" align="center" width="400" ></a>

Here, the y-axis represent the number of infected farms. The x-axis represent the time stept period in days. the color line reprersents the number od depulated animals over time.



