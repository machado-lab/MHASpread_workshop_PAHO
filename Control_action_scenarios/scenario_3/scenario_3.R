library(MHASpread);library(geobr)
if (!require(MHASpread)==F){hello()}

population <- MHASpread::population # Get the population data example
population$I_bov_pop[population$node== 259021] <- 10 # Infected 10 bovine in farm with id = 196734
events <- MHASpread::events # Load the events database

# Get the study region
RS <- read_municipality(
  code_muni = "RS", 
  year= 2010,
  showProgress = FALSE
)

# Selected seeded farm 
population_map <- population %>%
  st_as_sf(coords = c("longitude", "latitude"), crs=4326)%>%
  filter(population$node== 259021)

# Map seeded farm  
ggplot() +
  geom_sf(data = population_map, color="red") + 
  geom_sf(data = RS, fill = NA, color = "grey", size = 0.005, alpha = 2)+
  labs(subtitle="Municipalities de Rio Grand do Sul", size=8) 

# Run the stochastic simulation
model_output <- stochastic_SEIR (
  number_of_simulation = 20, # Number of model repeats
  number_of_threads = 4, #parallel::detectCores()-1, # Number of cores you will use
  population = population, # Population database
  events = events, # Events database
  simulation_name = "scenario_1_init", # Simulation tag name
  days_of_simulation = 15, # Number of days FMD will be spreading
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

#=========================================================#
#      Initial spread epidemic curves (farm-level)    ----
#=========================================================#
# Plot infected farms distribution, all species
plot_infected_farms_curve(model_output = model_output, host = "All host")+
  scale_x_continuous(name="Days") 

#Plot infected farms distribution, bovine
plot_infected_farms_curve(model_output = model_output, host = "Bovine")

# Plot infected farms distribution, swine
plot_infected_farms_curve(model_output = model_output, host = "Swine")

# Plot infected farms distribution, small ruminants
plot_infected_farms_curve(model_output = model_output, host = "Small ruminants")

#=========================================================#
#  Initial spread epidemic curves of animals   ----
#=========================================================#
# Plot infected animal distribution, all species
plot_SEIR_animals(model_output = model_output, # Model output
                  plot_suceptible_compartment = F, # FALSE to hide S animals
                  by_host = F) # Select whether plot by specie or all species together

# Plot infected animal distribution by species
plot_SEIR_animals(model_output = model_output, # Model output
                  plot_suceptible_compartment = F, # FALSE to hide S animals
                  by_host = T) # TRUE will plot all species together

# Epidemic spatial distribution
farms_location <-plot_nodes_kernel_map(model_output = model_output,
                                       population = population) # Save map of farms that participated in this simulation

farms_location

# Is possible to take a snapshot of the map by using the next line 
mapview::mapshot(farms_location, file = "initial_outbreak_farms_location.png")  # Save the map

#=========================================================#
#.                                 Control zones     ----
#=========================================================#
# So if we establish control areas zones from a specific simulation == 1 looks like:
detected_farms.id <- MHASpread::id_of_infectious_farms(model_output[[1]]$populationdb,
                                                       only_infected_comp = T) # FALSE will take all infection status

zones_arond_inft_farms <- assign_control_zones(
  population = population, # Population database
  infected_size = 3, # Size of the infected zone(s) in Km
  buffer_size = 7, # Size of the buffer zone(s) in Km
  surveillance_size = 15, # Size of the surveillance zone(s) in Km
  detected_farms.id = detected_farms.id,# Detected farms
  num_threads = 10) # Computer threads (don't overload your computer)

plot_farms_in_control_zones_areas(zones_arond_inft_farms, detected_farms.id) # Plot interactive map  

#==========================================================================#
# Control actions                                   -----------------------
#==========================================================================#
# The lines run the control action based on the previous initial spread simulations

control_model <- control_actions(
  # MODEL SETUP
  num_threads = 1,                           # Number of CPUs
  model_output = model_output,               # Output object from the initial infection [function stochastic_SEIR()]
  population_data = MHASpread::population,   # Population database, all animals are susceptible
  events = MHASpread::events,                # Movement events (in and/or out), birth or death
  break_sim_if = 50,                         # Stop simulation(s) if there are more than N infected farms
  
  # INITIAL CONDITION OF THE CONTROL ACTIONS
  days_of_control_action = 20,               # Number of days control actions will be applied for
  detectection_rate = 50,                    # Detection rate per day, in percentage % (chose from 0%-100%)
  only_infected_comp = T,                    # TRUE will detect only animal in the infectious compartment
  
  # CONTROL ZONES AREAS SETUP
  freq_updt_cntrl_zns = 7,                   # How often control zone(s) will be update i.e. 1, 7, 15 days
  infected_size_cz = 3,                      # Size of the infected zone(s) in Km
  buffer_size_cz = 7,                        # Size of the buffer zone(s) in Km
  surveillance_size_cz = 15,                 # Size of the surveillance zone(s) in Km
  
  # ANIMAL MOVEMENTS STANDSTILL SETUP
  ban_length = 30,                           #  Number of days of movements ban (standstill)
  infected_zone_mov = T,                     #  Animal movement ban (standstill) will be applied to infected zone(s)
  buffer_zone_mov = T,                       #  Animal movement ban (standstill) will be applied to buffer zone(s)
  surveillance_zone_mov = T,                 #  Animal movement ban (standstill) will be applied to surveillance zone(s)
  direct_contacts_mov = T,                   #  TRUE will ban movements of farm(s) outside of control zone(s) with contact with positive farms
  traceback_length_mov = 1,                  # Trace back in-going animal movement with infected farms
  
  # DEPOPULATION SETUP
  limit_per_day_farms_dep = 4,               #  Number of farm(s) to be depopulated by day
  infected_zone_dep = T,                     #  Depopulation will be applied to infected zone(s)
  only_depop_infect_farms = T,               #  FALSE stamping out all farms in infected zone(s)
  
  # VACCINATION SETUP
  days_to_get_inmunity = 15,                 # How many days farms become 100% protected (immunity)
  limit_per_day_farms = 25,                  # Maximum number of farms to be vaccinated in buffer zone(s)
  limit_per_day_farms_infct = 25,            # Maximum number of farms to be vaccinated in infected zone(s)
  vacc_eff = 0.7,                            # A numeric value between 0 and 1 indicates vaccine efficacy.
  dt = 1/15,                                 # Rate of conversion to SEIR -> V compartment, i.e 1/15
  vacc_swine = T,                            # TRUE vaccine swine
  vacc_bovine = T,                           # TRUE vaccine bovine
  vacc_small = T,                            # TRUE vaccine small ruminants
  infected_zone_vac =T ,                     # TRUE vaccine is applied in infected zone(s)
  buffer_zone_vac = T,                       # TRUE vaccine is applied in buffer zone(s)
  vacc_infectious_farms =   T,               # TRUE vaccinate infected animals
  vacc_delay = 5)                            # How many days until vaccination is started

#=============================================================#
#            Plot results of control action modelling     ----
#============================================================#
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
#    Results of total depopulated   ----
#==========================================#
# Lets see the results of the depopulated farms over all simulation
plot_depopulation(control_output = control_model,
                  level_plot = "farms")

# Lets see the results of the depopulated animals over all simulation
plot_depopulation(control_output = control_model,
                  level_plot = "animals")

#==========================================#
#   Results of total farms vaccinated   ----
#==========================================#
# Lets see the results of the vaccinated farms over all simulation
plot_vaccination(control_output = control_model,
                 population = population,
                 level_plot = "farms")

# Lets see the results of the vaccinated animals over all simulation
plot_vaccination(control_output = control_model,
                 population = population,
                 level_plot = "animals")

#==========================================#
#  Staff member overhead needed       ----
#==========================================#
# Number of staff to depopulate       
      
plot_staff_overhead(control_output = control_model,
                    population = population, parameter = "depopulation",
                    staff  = 2)

# Number of staff to vaccinate 
  
plot_staff_overhead(control_output = control_model,
                    population = population, parameter = "vaccination",
                    staff  = 2)

