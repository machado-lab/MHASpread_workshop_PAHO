# Scenario 3 (Multispecies farm, initial infection in cattle)

Here, we describe the population and events data used for dissemination and control actions. The datasets provided are a fair representation of the actual farm density ratio distribution of the farms; in the same way, movement events provided here are similar to real between-farm movement networks.

## Backgroud 

The infection starts at the farm node with ID= `196734` which has a population of `100` animals. 
Here, FMD was first detected `7` days after the initial disease introduction (infection started with `40` infected animal cattle).

## Data preparation
1. Population data: total number of animals

```r 
population <- MHASpread::population # Get the population data example
population$I_bov_pop[population$node== 196734] <- 40 # Infected 40 bovine in farm with id = 196734
```
2. Events data: between farm movements (in and/or out), birth or death
```r 
# Select the in and out farm dynamics (movements, births, deaths)
events <- MHASpread::events # Load the events database
```

## Run the initial repeat without any control actions

In this simulation, we will consider different FMD transmission parameters obtained from actual data from Rio Grande do Sul and from the literature. For this workshop's purposes, we will utilize control intervention under the Brazilian emergency plan.


**Note:** Please, consider that this model is stochastic, which means that several runs are required to get a proper description of the inputs to be simulated. To increase the performance of those simulations, this model runs in different CPU threads. Therefore, the number of threads must be selected according to the computer's capacity, **_DO NOT OVERLOAD_** your computer. 

In the next box, chunk represent the code lines that you have to run in Rstudio:

```r
model_output <- stochastic_SEIR (
          number_of_simulation = 1, # Number of model repeats
          number_of_threads = 1, #parallel::detectCores()-1, # Number of cores you will use
          population = population, # Population database
          events = events, # Events database
          simulation_name = "scenario_1_init", # Simulation tag name
          days_of_simulation = 7, # Number of days FMD will be spreading
          initial_day_simulation=1, # Initial day of simulation
          max_distance_in_km= 40, # Maximum distance kernel for local disease spread
          num_threads=1, #  Number of CPU to parallel tasks; set 1 to not overload your computer
          a = 0.012, # To set kernel curve max infection rate (S*I)/N when animals are in the same area
          b =  0.6, # Shape of the kernel curve
          beta_bov_to_bov= c(min = 0.01833333, mode = 0.025, max = 0.05666667), # Transmission coefficient  bovine -> bovine
          beta_bov_to_swi= c(min = 0.01833333, mode = 0.025, max = 0.05666667), # Transmission coefficient bovine -> swine
          beta_bov_to_SR=c(min = 0.012, mode = 0.031, max = 0.065), # Transmission coefficient bovine -> small ruminants
          lambda1_bov=c(min = 3, mode = 5.9, max = 16), # Rate from exposed (E) to infectious (I) bovine
          lambda2_bov=c(min = 6, mode = 15, max = 20), # Rate from infectious (I) to recovered (R) bovine
          beta_swi_to_swi=c(min = 0.044, mode = 0.14, max = 0.33), # Transmission coefficient swine -> swine
          beta_swi_to_bov=c(min = 0.014, mode = 0.033, max = 0.044), # Transmission coefficient swine -> bovine
          beta_swi_to_SR= c(min = 0.014, mode = 0.033, max = 0.044), # Transmission coefficient of swine infects small ruminants
          lambda1_swi=c(min = 3, mode = 5.9, max = 16), # Rate from exposed (E) to infectious (I) swine
          lambda2_swi=c(min = 5, mode = 6.44, max = 14), #  Rate from infectious (I) to recovered (R) swine
          beta_SR_to_SR=c(min = 0.16, mode = 0.24, max = 0.5), # Transmission coefficient small ruminants -> small ruminants
          beta_SR_to_bov=c(min=0.012,mode=0.031,max= 0.033), # Transmission coefficient small ruminants -> bovine
          beta_SR_to_swi=c(min = 0.006, mode = 0.024, max = 0.09), # Transmission coefficient small ruminants -> swine
          lambda1_SR=c(min = 4, mode = 5, max = 14), # Rate from exposed (E) to infectious (I) small ruminants
          lambda2_SR=c(min = 6, mode = 15, max = 20)) # Rate from infectious (I) to recovered (R) bovine

```

----

### Model output is used to update the population data that will be used to apply control actions

After running this part, we can visualize an epidemic curve for each species according to the number of days selected for silent dissemination.

###  Initial spread epidemic curves (farm-level) 

*  Plot infected farms distribution, all species
```r
plot_infected_farms_curve(model_output = model_output, host = "All host")
```
*  Plot infected farms distribution, bovine
```r
plot_infected_farms_curve(model_output = model_output, host = "Bovine")
```
*  Plot infected farms distribution, swine
```r
plot_infected_farms_curve(model_output = model_output, host = "Swine")
```
*  Plot infected farms distribution, small ruminants
```r
plot_infected_farms_curve(model_output = model_output, host = "Small ruminants")
```

###  Initial spread epidemic curves (animal-level)  

* Plot infected animal distribution, all species
```r
plot_SEIR_animals(model_output = model_output, # Model output
                  plot_suceptible_compartment = F, # FALSE to hide S animals
                  by_host = F) # Select whether plot by specie or all species together
```

* Plot infected animal distribution by species
```r
plot_SEIR_animals(model_output = model_output, # Model output
                  plot_suceptible_compartment = F, # FALSE to hide S animals
                  by_host = T) # TRUE will plot all species together
```
### See the geo-location of the farms 
Creates an interactive map about the farm that has been infected overall simulation, 
in the background, the color bins represent the kernel density of the farm location weighted by the number of times in which the farm was infected. Thus, hots color highlights areas with farms that have been infected more times when compared with the others.

### Epidemic spatial distribution
```r 
farms_location <-plot_nodes_kernel_map(model_output = model_output,
              population = population)

farms_location
```
Is possible to take a snapshot of the map by using the next line 
```r
mapview::mapshot(farms_location, file = "initial_outbreak_farms_location.png")  # Save the map
```
----
# How control action simulations works

Control actions use the output of the initial spread. Control actions start in the next day post index case detection.

### Explore control zones assuming detection of 100%
Here, all control actions are placed according to specific control areas zones: infected, buffer, and surveillance zones, respectively. Let's check out an example of how these control zones look by selecting one of the previous simulation runs as an example of spatial distribution.

#=========================================================#
#                              Control zones          ----
#=========================================================#
 ```r
detected_farms.id <- MHASpread::id_of_infectious_farms(model_output[[1]]$populationdb,
                     only_infected_comp = F) # FALSE will take all infection status

zones_arond_inft_farms <- assign_control_zones(
            population = population, # Population database
            infected_size = 3, # Size of the infected zone in Km
            buffer_size = 7, # Size of the buffer zone
            surveillance_size = 15, # Size of the surveillance zone
            detected_farms.id = detected_farms.id,# Detected farms
            num_threads = 10) # Computer threads (don't overload your computer)

plot_farms_in_control_zones_areas(zones_arond_inft_farms, detected_farms.id) # Plot interactive map      

```
This will produce a interactive map in the *viewer tab*  like this: 

 <a href="url"><img src="https://user-images.githubusercontent.com/41584216/206781762-bb397ee0-4847-4b34-bddf-28b05d40d00a.png" align="center" width="400" ></a>


to take a snapshot use: 

```r
mapview::mapshot(farms_location, file = "initial_outbreak_farms_location.png")  # Save the map
```
the next large function has a bunch of arguments that control different *control actions* in the simulations to be performed. Then, the next paragraph will explain how to set those arguments *argument by argument* in the function:

```r
control_model <- control_actions(
  # MODEL SETUP
  num_threads = 4,                           # Number of CPUs
  model_output = model_output,               # Output object of the function stochastic_SEIR()
  population_data = MHASpread::population,   # Naive population  before the simulations
  events = MHASpread::events,                # Initial Scheduled movements
  break_sim_if = 50,                         # Breaks the simulation if there ar more than n infectious farms

  # INITIAL CONDITION OF THE CONTROL ACTIONS
  days_of_control_action = 20,               # Number of days to be working on control actions
  detectection_rate = 50,                    # Detection rate per day (in percentage % (0%-100%))
  only_infected_comp = T,                    # If True will detect only animal in the infectious compartment

  # CONTROL ZONES AREAS SETUP
  freq_updt_cntrl_zns = 7,                   # How often the control zones will be update i.e. 1, 7, 15 days
  infected_size_cz = 3,                      # Ratio size in Km of the infected zone
  buffer_size_cz = 7,                        # Ratio size in Km of the buffer zone
  surveillance_size_cz = 15,                 # Ratio size in Km of the surveillance zone

  # ANIMAL MOVEMENTS STANDSTILL SETUP
  ban_length = 30,                           #  30 days of movements ban
  infected_zone_mov = T,                     #  Animal ban will be applied to infected zone
  buffer_zone_mov = T,                       #  Animal ban will be applied to buffer zone
  surveillance_zone_mov = T,                 #  Animal ban will be applied to surveillance zone
  direct_contacts_mov = T,                   #  Ban farm outside of control zones with contact with positive farms
  traceback_length_mov = 1,                  #  Traceback in-going animals movements of infected farms

  # DEPOPULATION SETUP
  limit_per_day_farms_dep = 4,               #  Farm will be depopulated by day
  infected_zone_dep = T,                     #  Depopulation will be applied to infected zone
  only_depop_infect_farms = T,               #  If False stamping out all farms in the infected zone

  # VACCINATION SETUP
  days_to_get_inmunity = 15,                 # How many days to be considered 100% immune
  limit_per_day_farms = 25,                  # Maximum number of farms to be vaccinated in BUFFER area
  limit_per_day_farms_infct = 25,            # Maximum number of farms to be vaccinated in INFECTED area
  vacc_eff = 0.7,                            # Numeric value between 0 and 1 indicating the efficacy of the vaccine
  dt = 1/15,                                 # Rate of conversion to SEIR -> V compartment i.e 1/15
  vacc_swine = T,                            # If true vaccine swine
  vacc_bovine = T,                           # If true vaccine bovine
  vacc_small = T,                            # If true vaccine small ruminants
  infected_zone_vac =T ,                     # If true vaccine over infected control zone area
  buffer_zone_vac = T,                       # If true vaccine over buffer control zone area
  vacc_infectious_farms =   T,               # If true infectious farms will be vaccinated
  vacc_delay = 5)                            # How many days until start the vaccination
  ```
So, let me explain each section of the `control_actions` function in more detail here:

#### Model setup
This section set the initial conditions of the simulation based on the previous runs. 
- [ ] `num_threads` Is a numeric value with the total number of CPUs to be used.  
- [ ] `model_output` Object with the result of the initial spread generated by the function stochastic_SEIR().
- [ ] `population_data` Is a data frame with the initial population.
- [ ] `events Initial`  Are the scheduled movements (births, death, farm-to-farm, and farm-to-slaughterhouses)
- [ ] `break_sim_if` Breaks the simulation if there are more than *n* infectious farms in the simulation system.

#### Initial condition fo the control actions 
- [ ] `days_of_control_action`  represents the total number of days to be working on control actions
- [ ] `detectection_rate` Represents the percentage (0%-100%) of farms to be detected by day. Therefore if I have 100 infected farms and the detection rate is 50% the simulation will set control action in n= 50 farms which is 50% of the population.
- [ ] `only_infected_comp`  is a TRUE or FALSE statement, if TRUE will detect only animals in the infectious compartment, this is an approximation to say that only symptomatic and infectious and will be detected i.e. animals with clinical sing as blisters 

#### Control  zones areas set up 
This section setups the frequency at which the control zones are updated based on the informed detected infected farms (established in the previous chunk), here :

- [ ] `freq_updt_cntrl_zns`  Is a numeric value in days which represents how often the control zones will be updated i.e. 1, 7, 15 days.
- [ ] `infected_size_cz` Ratio size in Km of the infected zone.
- [ ] `buffer_size_cz`   Ratio size in Km of the buffer zone.
- [ ] `surveillance_size_cz` Ratio size in Km of the surveillance zone.

#### Animal movements standstill setup 
With this function, we will control the movements between farms from infected areas to uninfected regions. 

- [ ] `ban_length` Is a numeric value that will control the number of days in which the movement of farms will not be allowed.
- [ ] `infected_zone_mov` Is a TRUE or FALSE statement, if TRUE  animal ban movements will be applied to the infected zone
- [ ] `buffer_zone_mov` Is a TRUE or FALSE statement, if TRUE  animal ban movements will be applied to the buffer zone.
- [ ] `surveillance_zone_mov` Is a TRUE or FALSE statement, if TRUE animal ban movements will be applied to the  surveillance zone.
- [ ] `direct_contacts_mov`  Is a TRUE or FALSE statement, if TRUE animal ban movements will apply to farms outside of the control action areas but with registered movements with contact with positive farms.
- [ ] `traceback_length_mov` Is a numeric value that indicates how many steps in the network the ban of the movement can be extended.

#### Depopulation setup 
Here we are going to take into account the depopulation of farms. 
- [ ] `limit_per_day_farms_dep` For modeling purposes, we are going to set the maximum number of farms to be depopulated per day. Here, the properties will be prioritized according to the following criteria: > cattle population > swine population > small ruminant population. 
- [ ] `infected_zone_dep` Is a TRUE or FALSE statement, if TRUE will allow to depopulate farms in the *infected zone* even if they are not positive or vaccinated.
- [ ] only_depop_infect_farms Is a TRUE or FALSE statement, if TRUE will depopulated *ONLY* infected farms detected, otherwise will stamping out all farms in the infected zone.

#### Vaccination setup 
This function will implement daily on-farm vaccination in the simulated population.

- [ ] `days_to_get_inmunity` Numeric valuer that describes the number of days in which a population will be 100% immunized.
- [ ] `limit_per_day_farms` Numeric value that will set the maximum number of farms to be vaccinated per day in BUFFER area.
- [ ] `limit_per_day_farms_infct` Numeric value that will set the maximum number of farms to be vaccinated per day in INFECTED area.
- [ ] `vacc_eff` = Is a numeric value between 0 and 1 indicating the efficacy of the vaccine.
- [ ] `dt` = is a rate of conversion to SEIR population  to a vaccinated  compartment i.e 1/15.
- [ ] `vacc_swine` Is a TRUE or FALSE statement, if TRUE  will vaccine swine.
- [ ] `vacc_bovine`Is a TRUE or FALSE statement, if TRUE will vaccine bovine.
- [ ] `vacc_small ` Is a TRUE or FALSE statement, if TRUE will vaccine small-ruminants.
- [ ] `infected_zone_vac`Is a TRUE or FALSE statement, if TRUE will  vaccine over the infected control zone area.
- [ ] `buffer_zone_vac`Is a TRUE or FALSE statement, if TRUE will vaccine over buffer control zone area.
- [ ] `vacc_infectious_farms` Is a TRUE or FALSE statement, if TRUE infectious farms will be vaccinated.
- [ ] `vacc_delay` Will set how many days to prepare to vaccinate and  start to vaccinate animals. 

# Plot results of control action modelling

Here, we will visualize some results from the model after running the control actions in our simulations.

#### Plot the number of infected farm considering initial spread + the control actions
Lets see the results of the control actions when considering all farms types
```r
plot_epi_curve_mean_and_cntrl_act(model_inital = model_output,
                                  model_control = control_output,
                                  control_action_start_day = 11,
                                  plot_only_total_farms = T)
```
this function should produce a plot like this:

<a href="url"><img src="https://github.com/machado-lab/MHASpread_workshop_PAHO/assets/41584216/98dc45a5-d322-42fb-b485-4f07adee9ad1" align="center" width="400" ></a>


Now, Lets see the results of the control actions by each farms types

```r
plot_epi_curve_mean_and_cntrl_act(model_inital = model_output,
                                  model_control = control_output,
                                  control_action_start_day = 11,
                                  plot_only_total_farms = F)
```

<a href="url"><img src="https://github.com/machado-lab/MHASpread_workshop_PAHO/assets/41584216/132366a0-53de-490a-a5ad-8000a1aad356" align="center" width="400" ></a>

#### Depopulated farms distribution during the control actions simulated period 

Lets see the results of the depopulated farms over all simulation
```r
plot_depopulation(control_output = control_output, level_plot = "farms")
```
<a href="url"><img src="https://github.com/machado-lab/MHASpread_workshop_PAHO/assets/41584216/e4f349ca-4a68-4401-ae19-abbe7957f74d" align="center" width="400" ></a>


Lets see the results of the depopulated animals over all simulation
```r
plot_depopulation(control_output = control_output, level_plot = "animals")
```

<a href="url"><img src="https://github.com/machado-lab/MHASpread_workshop_PAHO/assets/41584216/70026a6e-6994-4ca7-8de7-5d4a2dde76ec" align="center" width="400" ></a>

#### vaccinated farms distribution during the control actions simulated period

Lets see the results of the vaccinated farms over all simulation
```r
plot_vaccination(control_output = control_output, population = population, level_plot = "farms")
```

<a href="url"><img src="https://github.com/machado-lab/MHASpread_workshop_PAHO/assets/41584216/2dfc24b9-3593-4746-81ec-700a12a4fdbb" align="center" width="400" ></a>


Lets see the results of the vaccinated animals over all simulation
```r
plot_vaccination(control_output = control_output, population = population, level_plot = "animals")
```
<a href="url"><img src="https://github.com/machado-lab/MHASpread_workshop_PAHO/assets/41584216/cad0ac86-d7a7-42ff-81f6-b9219e11efe8" align="center" width="400" ></a>












