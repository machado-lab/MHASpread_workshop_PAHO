library(MHASpread)

population <- MHASpread::population                                                # Get the population data example
population$I_bov_pop[population$node== 196734] <- 40    #   Infected 40 bovine in the farm id = 196734
events <- MHASpread::events

# run the 5 stochastic simulation
model_output <- stochastic_SEIR(number_of_simulation = 10,
                                number_of_threads = 5, #parallel::detectCores()-1,
                                population = population,                                                 #  Population database
                                events = events,                                                         #  Events database
                                simulation_name = "scenario_1_init",                                     #  Simulation tag name
                                days_of_simulation = 7,                                                 #  Population database
                                initial_day_simulation=5,                                                #  Initial day of simulation
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
                                beta_swi_to_bov=c(min = 0.014, mode = 0.033, max = 0.044) ,               #  Transmission coefficient of swine infects bovine
                                beta_swi_to_SR= c(min = 0.014, mode = 0.033, max = 0.044),                #  Transmission coefficient of swine infects small ruminants
                                lambda1_swi=c(min = 3, mode = 5.9, max = 16),                            #  Rate from exposed (E) to infectious (I) in swine
                                lambda2_swi=c(min = 5, mode = 6.44, max = 14) ,                          #  Rate from infectious (I) to recovered (R) in swine
                                beta_SR_to_SR=c(min = 0.16, mode = 0.24, max = 0.5) ,                    #  Transmission coefficient of small ruminants infects small ruminants
                                beta_SR_to_bov=c(min=0.012,mode=0.031,max= 0.033) ,                      #  Transmission coefficient of small ruminants infects bovine
                                beta_SR_to_swi=c(min = 0.006, mode = 0.024, max = 0.09),                 #  Transmission coefficient of small ruminants infects swine
                                lambda1_SR=c(min = 4, mode = 5, max = 14) ,                              #  Rate from exposed (E) to infectious (I) in small ruminants
                                lambda2_SR=c(min = 6, mode = 15, max = 20))

#=========================================================#
##  Initial spread epidemic curves of farms   ----
#=========================================================#
# Plot farms infected curves considering all species
plot_infected_farms_curve(model_output = model_output, host = "All host")
# Plot farms infected curves considering bovine species
plot_infected_farms_curve(model_output = model_output, host = "Bovine")
# Plot farms infected curves considering swine species
plot_infected_farms_curve(model_output = model_output, host = "Swine")
# Plot farms infected curves considering small ruminants species
plot_infected_farms_curve(model_output = model_output, host = "Small ruminants")


#=========================================================#
##  Initial spread epidemic curves of animals   ----
#=========================================================#
# Plot  animal infected curves considering all species
plot_SEIR_animals(model_output = model_output,
                  plot_suceptible_compartment = F,
                  by_host = F)

# Plot  animal infected curves considering by species
plot_SEIR_animals(model_output = model_output,
                  plot_suceptible_compartment = F,
                  by_host = T)


# see the geo-location of the farms
farms_location <-plot_nodes_kernel_map(model_output = model_output, population = population)
farms_location
#take a snapshot of the map
mapview::mapshot(farms_location, file = "initial_outbreak_farms_location.png")  # Save the map



#=========================================================#
##               Control zones areas    ----
#=========================================================#
# so if we establish control areas zones from a specific simulation == 1 looks like:
detected_farms.id <- MHASpread::id_of_infectious_farms(model_output[[1]]$populationdb,
                                                       only_infected_comp = F)

zones_arond_inft_farms <- assign_control_zones(population = population,                      # Population database
                                               infected_size = 3,                               # Ratio size in Km of the infected zone
                                               buffer_size = 7,                                 # Ratio size in Km of the buffer zone
                                               surveillance_size = 15,                          # Ratio size in Km of the surveillance zone
                                               detected_farms.id = detected_farms.id,    # Farms that have been detected
                                               num_threads = 10)         # Computer threads to be used (please don't overload your computer)

plot_farms_in_control_zones_areas(zones_arond_inft_farms, detected_farms.id)         # Plot interactive map

#==========================================================================#
#                                                                          #
# Control action modelling          ---------------------------------------
#                                                                          #
#==========================================================================#
# the next lines run the control action based on the previous initial spread simulations

control_model <- control_actions(
  # MODEL SETUP
  num_threads = 4,                           # Number of CPUs
  model_output = model_output,               # Output object of the function stochastic_SEIR()
  population_data = MHASpread::population,   # Naive population  before the simulations
  events = MHASpread::events,                # Initial Scheduled movements
  break_sim_if = 50,                         # Breaks the simulation if there ar more than n infectious farms

  # INITIAL CONDITION OF THE CONTROL ACTIONS
  days_of_control_action = 10,               # Number of days to be working on control actions
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
  limit_per_day_farms_dep = 8,               #  Farm will be depopulated by day
  infected_zone_dep = T,                     #  Depopulation will be applied to infected zone
  only_depop_infect_farms = T,               #  If False stamping out all farms in the infected zone

  # VACCINATION SETUP
  days_to_get_inmunity = 15,                 # How many days to be considered 100% immune
  limit_per_day_farms = 20,                  # Maximum number of farms to be vaccinated in BUFFER area
  limit_per_day_farms_infct = 30,            # Maximum number of farms to be vaccinated in INFECTED area
  vacc_eff = 0.7,                            # Numeric value between 0 and 1 indicating the efficacy of the vaccine
  dt = 1/15,                                 # Rate of conversion to SEIR -> V compartment i.e 1/15
  vacc_swine = T,                            # If true vaccine swine
  vacc_bovine = T,                           # If true vaccine bovine
  vacc_small = T,                            # If true vaccine small ruminants
  infected_zone_vac =T ,                     # If true vaccine over infected control zone area
  buffer_zone_vac = T,                       # If true vaccine over buffer control zone area
  vacc_infectious_farms =   T,               # If true infectious farms will be vaccinated
  vacc_delay = 5)                            # How many days until start the vaccination

#==========================================#
#            Epidemic distribution     ----
#==========================================#
# Lets see the results of the control actions when considering all farms types
plot_epi_curve_mean_and_cntrl_act(model_inital = model_output,
                                  model_control = control_model,
                                  control_action_start_day = 5,
                                  plot_only_total_farms = T)

# Lets see the results of the control actions by each farms types
plot_epi_curve_mean_and_cntrl_act(model_inital = model_output,
                                  model_control = control_model,
                                  control_action_start_day = 5,
                                  plot_only_total_farms = F)

#==========================================#
#    Depopulated farms distribution    ----
#==========================================#
# Lets see the results of the depopulated farms over all simulation
plot_depopulation(control_output = control_model, level_plot = "farms")

# Lets see the results of the depopulated animals over all simulation
plot_depopulation(control_output = control_model, level_plot = "animals")

#==========================================#
#    vaccinated farms distribution    ----
#==========================================#
# Lets see the results of the vaccinated farms over all simulation
plot_vaccination(control_output = control_model, population = population, level_plot = "farms")

# Lets see the results of the vaccinated animals over all simulation
plot_vaccination(control_output = control_model, population = population, level_plot = "animals")

