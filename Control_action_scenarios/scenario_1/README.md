
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

### Silent spread 

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


<a href="url"><img src="https://user-images.githubusercontent.com/41584216/206779480-609f2c26-847e-4aa3-9f77-70e1ac278373.png" align="center" width="600" ></a>

Also we are able to see the geolocation of the infected adn exposed farms :


<a href="url"><img src="[https://user-images.githubusercontent.com/41584216/206779480-609f2c26-847e-4aa3-9f77-70e1ac278373.png](https://user-images.githubusercontent.com/41584216/206780566-e25fac0e-3f21-49a3-984f-3dedf8f89ea4.png)" align="center" width="600" ></a>


