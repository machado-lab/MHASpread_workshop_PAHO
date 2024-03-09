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
# Initialize parameters for the SEIR model simulation
run_one_farm_seir(Susceptible_pop = 100,        # Initial susceptible population
                  Host = "bov",               # Host species (e.g. bov)
                  initial_num_infected = 1,     # Initial number of infected individuals
                  days_of_simulation = 10,      # Duration of simulation in days
                  number_of_simulation= 1)      # Number of simulations

# Run SEIR model 20 repeats to observe stochastic dynamics
run_one_farm_seir(Susceptible_pop = 100,        # Initial susceptible population
                  Host = "bov",               # Host species (e.g., bov)
                  initial_num_infected = 1,     # Initial number of infected individuals
                  days_of_simulation = 30,      # Duration of simulation in days
                  number_of_simulation= 20)     # Number of simulations

###############################################################
# Run SEIR model with one or many initially infected farms ----
###############################################################

# Load example population data
population = EpiShark::population

# Select the farm that you will like to have as the index infected farm (Farm ID: 666)
initial_infected_farm_id = 666
population$I_bov_pop[population$node == initial_infected_farm_id] <- 1 # One infected animal

# Run the SEIR model to simulate disease spread without control measures
results <- disease_spread_sim(
  population =  population,              # Population database (contains list of farms)
  events = EpiShark::events,             # Events database (e.g., contains list of movement events)
  simulation_name = "scenario_1_init",   # Simulation tag name (you can change to what you like)
  days_of_simulation = 30,               # Duration of simulation in days (for how how many days the spread will run)
  initial_day_simulation=1)              # Initial infection day (e.g., here we start infection on Jan, 1, 2023)

#=========================================================#
##  Initial spread: epidemic curve at farm level      ----
#=========================================================#

# Plot number of infected farms for all host species
plot_infected_farms_curve(model_output = results)
ggsave(last_plot(), file = "plot_infected_farms_curve_all.png", width = 10, height = 8)

# Plot number of infected farms for bovine
plot_infected_farms_curve(model_output = results, host = "Bovine")
ggsave(last_plot(), file = "plot_infected_farms_curve_bov.png", width = 10, height = 8)

# Plot number of infected farms for swine
plot_infected_farms_curve(model_output = results, host = "Swine")
ggsave(last_plot(), file = "plot_infected_farms_curve_swi.png", width = 10, height = 8)

# Plot number of infected farms for small ruminants
plot_infected_farms_curve(model_output = results, host = "Small ruminants")
ggsave(last_plot(), file = "plot_infected_farms_curve_small.png", width = 10, height = 8)

#========================================================#
##  Initial spread: epidemic curve at animal level   ----
#========================================================#

# Plot number of infected animals for all host species
plot_SEIR_animals(model_output = results, plot_suceptible_compartment = F, by_host = FALSE)
ggsave(last_plot(), file = "plot_SEIR_animals_by_host.png", width = 10, height = 8)

# Plot number of infected animals by host species
plot_SEIR_animals(model_output = results, plot_suceptible_compartment = FALSE, by_host = TRUE)
ggsave(last_plot(), file = "plot_SEIR_animals_all.png", width = 10, height = 8)

# Explore the spatial distribution of infected farms
farms_location <- plot_nodes_kernel_map(model_output = results,
                                        population = population,
                                        initial_infected_farm = initial_infected_farm_id)
farms_location
mapview::mapshot(farms_location, file = "initial_outbreak_farms_location.png")  # Save the map

#========================================================#
##  Examination number of farm in control zones       ----
#========================================================#

# Detect list of infected farms in control zones
detected_farms.id <- get_infected_farms(
  results$populationdb[results$populationdb$day == max(results$populationdb$day), ],
  only_infected_comp = TRUE)

# Assign control zones around infected farms
reticulate::source_python(system.file("python/control_zones.py", package = "EpiShark"))
control_zones_areas = assign_control_zones(population = population,
                                           infected_size = 3,
                                           buffer_size = 7,
                                           surveillance_size = 15,
                                           detected_farms_id = detected_farms.id)

# Plot interactive map of control zones
control_zones_plot = plot_farms_in_control_zones_areas(control_zones_areas, detected_farms.id)
control_zones_plot
mapview::mapshot(control_zones_plot, file = "Control_zones_example.png")  # Save the map

##############################################################
##.            Simulate control action                 ------
##############################################################

# Setup for control actions ----
model_output = results  # Output of the SEIR model
break_sim_if = 100 # Threshold for terminating simulations if the number of infected farms exceeds this value
first_detectn_proportion = 0.1 # Proportion of initially detected infected farms

# Initial condition for control actions ----
days_of_control_action = 60  # Number of days for which control actions will be implemented

# Control zones setup ----
infected_size_cz = 3  # Size in kilometers of the infected zone
buffer_size_cz = 7  # Size in kilometers of the buffer zone
surveillance_size_cz = 15  # Size in kilometers of the surveillance zone

# Animal movement standstill setup ----
ban_length = 30  # Duration of animal movement standstill in days
infected_zone_mov = TRUE  # Indicator for applying the animal movement ban to the infected zone
buffer_zone_mov = TRUE  # Indicator for applying the animal movement ban to the buffer zone
surveillance_zone_mov = FALSE  # Indicator for applying the animal movement ban to the surveillance zone
direct_contacts_mov = TRUE  # Indicator for subjecting farms outside control zones with contact with positive farms to movement restrictions
traceback_length_mov = 1  # Number of steps to traceback in-going animal movements of infected farms

# Depopulation setup ----
limit_per_day_farms_dep = 3  # Limit of farms to be depopulated per day
depopulate_infected_zone = TRUE  # Indicator for applying depopulation in the infected area
depopulate_detected_farms = TRUE  # Indicator for only depopulating detected farms in the infected area

# Vaccination setup
days_to_get_inmunity = 15 # Number of days for full immunity (100% immune)
limit_per_day_farms_vac = 40 # Limit of farms to be vaccinated per day in the buffer area
limit_per_day_farms_infct_vac = 40  # Limit of farms to be vaccinated per day in the infected area
vacc_eff = 0.9 # Proportion indicating the effectiveness of the vaccine
vacc_bovine = TRUE # Indicator for vaccinating bovine population
vacc_swine = FALSE # Indicator for vaccinating swine population
vacc_small = FALSE # Indicator for vaccinating small ruminants population
infected_zone_vac = TRUE # Indicator for applying vaccination to the infected zone
buffer_zone_vac = TRUE # Indicator for applying vaccination to the buffer zone
vacc_infectious_farms = TRUE # Indicator for applying vaccination to infectious farms
vacc_delay = 1 # Number of days for vaccine delay (e.g., time until animals received the first dose in the field)

# Run all control actions you defined in the previously  sections ----
control_model = control_actions_sim(results,
                                    population,
                                    events,
                                    break_sim_if,
                                    days_of_control_action,
                                    infected_size_cz,
                                    buffer_size_cz,
                                    surveillance_size_cz,
                                    ban_length,
                                    infected_zone_mov,
                                    buffer_zone_mov,
                                    surveillance_zone_mov,
                                    direct_contacts_mov,
                                    traceback_length_mov,
                                    limit_per_day_farms_dep,
                                    depopulate_infected_zone,
                                    depopulate_detected_farms,
                                    limit_per_day_farms_vac,
                                    limit_per_day_farms_infct_vac,
                                    days_to_get_inmunity,
                                    vacc_eff,
                                    vacc_swine,
                                    vacc_bovine,
                                    vacc_small,
                                    infected_zone_vac,
                                    buffer_zone_vac,
                                    vacc_infectious_farms,
                                    vacc_delay)


# Plot epidemic curves and control actions results for all farm types
plot_epi_curve_mean_and_cntrl_act(
  model_inital = results,
  model_control = control_model,
  control_action_start_day = min(control_model[[2]]$population_by_day$day),
  plot_only_total_farms = TRUE)

ggsave(last_plot(), file = "plot_epi_curve_mean_and_cntrl_act_all_farm.png", width = 10, height = 8)

# Lets see the results of the control actions by farms types
plot_epi_curve_mean_and_cntrl_act(model_inital = results,
                                  model_control = control_model,
                                  control_action_start_day =  min(control_model[[2]]$population_by_day$day),
                                  plot_only_total_farms = FALSE)
ggsave(last_plot(), file = "plot_epi_curve_mean_and_cntrl_act_by_host.png",width = 10, height = 8)

# Visualize the daily spread dynamics in  an interactive map
plotNodesByDay(model_output = results, control_output = control_model)

#===============================================#
##    The distribution of depopulated farms ----
#===============================================#

# Plot distribution of number of depopulated farms
plot_depopulation(control_output = control_model, level_plot = "farms")
ggsave(last_plot(), file = "plot_depopulation_farm.png", width = 10, height = 8)

# Plot distribution of number of depopulated animals
plot_depopulation(control_output = control_model, level_plot = "animals")
ggsave(last_plot(), file = "plot_depopulation_animal.png", width = 10, height = 8)

# Explore the cost of depopulation based on previous results
plot_depopulation_cost(control_output = control_model,
                       level_plot = "animals",
                       cost = 250,
                       cumulative = T)

ggsave(last_plot(), file = "plot_depopulation_cost_ani.png", width = 10, height = 8)

plot_depopulation_cost(control_output = control_model,
                       level_plot = "farms",
                       cost = 1000,
                       cumulative = T)

ggsave(last_plot(), file = "plot_depopulation_cost_farm.png", width = 10, height = 8)

#===================================================#
##                   Results of vaccination    ----
#===================================================#

# Plot results of vaccinated farms
plot_vaccination(control_output = control_model,
                 population = population,
                 level_plot = "farms",
                 vaccine_bov = T,
                 vaccine_swi = F,
                 vaccine_small = F)

ggsave(last_plot(), file = "plot_vaccination_farms.png", width = 10, height = 8)

# Plot results of vaccinated animals
plot_vaccination(control_output = control_model,
                 population = population,
                 level_plot = "animals",
                 vaccine_bov = T,
                 vaccine_swi = F,
                 vaccine_small = F)

ggsave(last_plot(), file = "plot_vaccination_animals.png",  width = 10, height = 8)

# Explore the cost of the total number of vaccinated animals
plot_vaccination_cost(control_output = control_model,
                      population = population,
                      level_plot = "animals",
                      cost = 5,
                      cumulative = F,
                      vaccine_bov = T,
                      vaccine_swi = F,
                      vaccine_small = F)

ggsave(last_plot(), file = "plot_vaccination_cost_animals.png",  width = 10, height = 8)

# Explore the cost of the total number of vaccinated farms
plot_vaccination_cost(control_output = control_model,
                      population = population,
                      level_plot = "farms",
                      cost = 5,
                      cumulative = T,
                      vaccine_bov = T,
                      vaccine_swi = F,
                      vaccine_small = F)

ggsave(last_plot(), file = "plot_vaccination_cost_farms.png",  width = 10, height = 8)

### Calculate the number of staff members needed

# Number of staff for depopulation and vaccinate
plot_staff_overhead(control_output = control_model,
                    population = population,
                    parameter = "depopulation",
                    staff  = 2)

# Number of staff for vaccination
plot_staff_overhead(control_output = control_model,
                    population = population, parameter = "vaccination",
                    staff  = 1)

# Plot the number of farms by control zone
plot_number_farm_by_control_zone(control_model)
