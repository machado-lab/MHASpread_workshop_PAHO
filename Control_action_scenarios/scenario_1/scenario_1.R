#################################################
#      Test the package with EpiShark           #
#################################################
#setwd("~/Documents/repos/EpiShark/developer/examples_files")
# Install and load the EpiShark package from GitHub
# devtools::install_github(repo='machado-lab/EpiShark',
#                          auth_token = "paste_token_here",
#                          force=T)

library(EpiShark)

# Run SEIR dynamic in a single farm
# Initialize parameters for SEIR model simulation
run_one_farm_seir(Susceptible_pop = 100,       # Initial susceptible population
                  Host = "swi",                 # Host species (e.g., bovine)
                  initial_num_infected = 1,     # Initial number of infected individuals
                  days_of_simulation = 10,      # Duration of simulation in days
                  number_of_simulation= 1)      # Number of simulations

# Run SEIR model 20 repeats to observe stochastic dynamics
run_one_farm_seir(Susceptible_pop = 100,       # Initial susceptible population
                  Host = "swi",                 # Host species (e.g., bovine)
                  initial_num_infected = 1,     # Initial number of infected individuals
                  days_of_simulation = 30,      # Duration of simulation in days
                  number_of_simulation= 20)     # Number of simulations

###############################################################
# Run SEIR model with one or many initially infected farms ----
###############################################################

# Load example population data
population = EpiShark::population

# Select the farm to be infected (Farm ID: 666)
initial_infected_farm_id = 666
population$I_bov_pop[population$node == initial_infected_farm_id] <- 1

# Run the SEIR model to simulate disease spread without control measures
resultado <- disease_spread_sim(
  population =  population,              # Population database
  events = EpiShark::events,             # Events database
  simulation_name = "scenario_1_init",   # Simulation tag name
  days_of_simulation = 30,               # Duration of simulation in days
  initial_day_simulation=1)              # Initial day of simulation

#=========================================================#
##  Initial Spread Epidemic Curves of Farms           ----
#=========================================================#

# Plot infected farms curves considering all host species
plot_infected_farms_curve(model_output = resultado)
ggsave(last_plot(), file = "plot_infected_farms_curve_all.png", width = 10, height = 8)

# Plot infected farms curves considering bovine species
plot_infected_farms_curve(model_output = resultado, host = "Bovine")
ggsave(last_plot(), file = "plot_infected_farms_curve_bov.png", width = 10, height = 8)

# Plot infected farms curves considering swine species
plot_infected_farms_curve(model_output = resultado, host = "Swine")
ggsave(last_plot(), file = "plot_infected_farms_curve_swi.png", width = 10, height = 8)

# Plot infected farms curves considering small ruminants species
plot_infected_farms_curve(model_output = resultado, host = "Small ruminants")
ggsave(last_plot(), file = "plot_infected_farms_curve_small.png", width = 10, height = 8)

#========================================================#
##  Initial Spread Epidemic Curves of Animals       ----
#========================================================#

# Plot infected animal curves considering all host species
plot_SEIR_animals(model_output = resultado, plot_suceptible_compartment = F, by_host = FALSE)
ggsave(last_plot(), file = "plot_SEIR_animals_by_host.png", width = 10, height = 8)

# Plot infected animal curves considering by host species
plot_SEIR_animals(model_output = resultado, plot_suceptible_compartment = FALSE, by_host = TRUE)
ggsave(last_plot(), file = "plot_SEIR_animals_all.png", width = 10, height = 8)

# Explore the geo-location of the farms
farms_location <- plot_nodes_kernel_map(model_output = resultado,
                                        population = population,
                                        initial_infected_farm = initial_infected_farm_id)
farms_location
mapview::mapshot(farms_location, file = "initial_outbreak_farms_location.png")  # Save the map

#========================================================#
##             Simulate control actions            ----
#========================================================#

##  Control Zones Areas ----

# Detect the infected farms for control zone setup
detected_farms.id <- get_infected_farms(
  resultado$populationdb[resultado$populationdb$day == max(resultado$populationdb$day), ],
  only_infected_comp = TRUE
)

# Assign control zones based on infected farms
reticulate::source_python(system.file("python/control_zones.py", package = "EpiShark"))
control_zones_areas = assign_control_zones(population = population,
                                           infected_size = 3,
                                           buffer_size = 7,
                                           surveillance_size = 15,
                                           detected_farms_id = detected_farms.id)

# Plot interactive map for control zones
control_zones_plot = plot_farms_in_control_zones_areas(control_zones_areas, detected_farms.id)
control_zones_plot
mapview::mapshot(control_zones_plot, file = "Control_zones_example.png")  # Save the map

##############################################################
# Simulate control action                               ------
##############################################################

# Model setup
model_output = resultado  # Output of the SEIR model representing the spread of the disease
break_sim_if = 100  # Threshold for terminating the simulation if the number of infected farms exceeds this value
first_detectn_proportion = 0.1  # Proportion of initially detected infected farms

# Initial condition for control actions
days_of_control_action = 60  # Number of days for which control actions will be implemented

# Control zones setup
infected_size_cz = 3  # Size in kilometers of the infected zone
buffer_size_cz = 7  # Size in kilometers of the buffer zone
surveillance_size_cz = 15  # Size in kilometers of the surveillance zone

# Animal movement standstill setup
ban_length = 30  # Duration of animal movement standstill in days
infected_zone_mov = TRUE  # Indicator for applying the animal movement ban to the infected zone
buffer_zone_mov = TRUE  # Indicator for applying the animal movement ban to the buffer zone
surveillance_zone_mov = FALSE  # Indicator for applying the animal movement ban to the surveillance zone
direct_contacts_mov = TRUE  # Indicator for subjecting farms outside control zones with contact with positive farms to movement restrictions
traceback_length_mov = 1  # Number of steps to traceback in-going animal movements of infected farms

# Depopulation setup
limit_per_day_farms_dep = 3  # Limit of farms to be depopulated per day
depopulate_infected_zone = TRUE  # Indicator for applying depopulation in the infected area
depopulate_detected_farms = TRUE  # Indicator for only depopulating detected farms in the infected area

# Vaccination setup
days_to_get_inmunity = 15  # Number of days for full immunity (100% immune)
limit_per_day_farms_vac = 40  # Limit of farms to be vaccinated per day in the buffer area
limit_per_day_farms_infct_vac = 40  # Limit of farms to be vaccinated per day in the infected area
vacc_eff = 0.9  # Proportion indicating the effectiveness of the vaccine
vacc_bovine = TRUE  # Indicator for vaccinating bovine population
vacc_swine = FALSE  # Indicator for vaccinating swine population
vacc_small = FALSE  # Indicator for vaccinating small ruminants population
infected_zone_vac = TRUE  # Indicator for applying vaccination to the infected zone
buffer_zone_vac = TRUE  # Indicator for applying vaccination to the buffer zone
vacc_infectious_farms = TRUE  # Indicator for applying vaccination to infectious farms
vacc_delay = 1  # Number of days for vaccine delay

# Run all control actions ----
control_model = control_actions_sim(resultado, population, events, break_sim_if,
                                    days_of_control_action, infected_size_cz,
                                    buffer_size_cz, surveillance_size_cz,
                                    ban_length, infected_zone_mov, buffer_zone_mov,
                                    surveillance_zone_mov, direct_contacts_mov,
                                    traceback_length_mov, limit_per_day_farms_dep,
                                    depopulate_infected_zone, depopulate_detected_farms,
                                    limit_per_day_farms_vac, limit_per_day_farms_infct_vac,
                                    days_to_get_inmunity, vacc_eff, vacc_swine,
                                    vacc_bovine, vacc_small, infected_zone_vac,
                                    buffer_zone_vac, vacc_infectious_farms, vacc_delay)


# Plot epidemic curves and control actions results for all farm types
plot_epi_curve_mean_and_cntrl_act(
  model_inital = resultado,
  model_control = control_model,
  control_action_start_day = min(control_model[[2]]$population_by_day$day),
  plot_only_total_farms = TRUE
)
ggsave(last_plot(), file = "plot_epi_curve_mean_and_cntrl_act_all_farm.png", width = 10, height = 8)

# Lets see the results of the control actions by each farms types
plot_epi_curve_mean_and_cntrl_act(model_inital = resultado,
                                  model_control = control_model,
                                  control_action_start_day =  min(control_model[[2]]$population_by_day$day),
                                  plot_only_total_farms = FALSE)
ggsave(last_plot(), file = "plot_epi_curve_mean_and_cntrl_act_by_host.png",width = 10, height = 8)

# Visualize nodes by day in an interactive map
plotNodesByDay(model_output = resultado, control_output = control_model)

#==========================================#
#    Depopulated farms distribution    ----
#==========================================#

# Plot distribution of depopulated farms and animals over all simulations
plot_depopulation(control_output = control_model, level_plot = "farms")
ggsave(last_plot(), file = "plot_depopulation_farm.png", width = 10, height = 8)

plot_depopulation(control_output = control_model, level_plot = "animals")
ggsave(last_plot(), file = "plot_depopulation_animal.png", width = 10, height = 8)

# Explore the cost of depopulation based on previous results
plot_depopulation_cost(control_output = control_model,
                       level_plot = "animals", cost = 250,
                       cumulative = T)
ggsave(last_plot(), file = "plot_depopulation_cost_ani.png", width = 10, height = 8)

plot_depopulation_cost(control_output = control_model,
                       level_plot = "farms", cost = 1000,
                       cumulative = T)
ggsave(last_plot(), file = "plot_depopulation_cost_farm.png", width = 10, height = 8)

#===================================================#
#  Vaccinated results of the control actions    ----
#===================================================#

# Plot results of vaccinated farms and animals over all simulations
plot_vaccination(control_output = control_model,
                 population = population,
                 level_plot = "farms",
                 vaccine_bov = T,
                 vaccine_swi = F,
                 vaccine_small = F)
ggsave(last_plot(), file = "plot_vaccination_farms.png", width = 10, height = 8)

plot_vaccination(control_output = control_model,
                 population = population,
                 level_plot = "animals",
                 vaccine_bov = T,
                 vaccine_swi = F,
                 vaccine_small = F)
ggsave(last_plot(), file = "plot_vaccination_animals.png",  width = 10, height = 8)

# Explore the cost of vaccination based on previous results
plot_vaccination_cost(control_output = control_model, population = population,
                      level_plot = "animals", cost = 5, cumulative = F,
                      vaccine_bov = T, vaccine_swi = F, vaccine_small = F)
ggsave(last_plot(), file = "plot_vaccination_cost_animals.png",  width = 10, height = 8)

plot_vaccination_cost(control_output = control_model, population = population,
                      level_plot = "farms", cost = 5, cumulative = T,
                      vaccine_bov = T, vaccine_swi = F, vaccine_small = F)
ggsave(last_plot(), file = "plot_vaccination_cost_farms.png",  width = 10, height = 8)

### Calculate the number of staff members for each control action
# Number of staff to depopulate and vaccinate
plot_staff_overhead(control_output = control_model,
                    population = population, parameter = "depopulation",
                    staff  = 2)
plot_staff_overhead(control_output = control_model,
                    population = population, parameter = "vaccination",
                    staff  = 1)

# Plot Number of Farms by Control Zone over time
plot_number_farm_by_control_zone(control_model)