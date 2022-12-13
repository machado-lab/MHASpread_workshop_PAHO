#=========================================================#
#       Control actions disease workshop code #1          #
#=========================================================#
#Note:
library(MHASpread)                         # Load the package with all SEIR model functions
if (webshot::is_phantomjs_installed()==F) {  # additional software to screen shot
  webshot::install_phantomjs()
}

#==========================================================================#
#                                                                          #
# Initial scenarios without control ---------------------------------------
#                                                                          #
#==========================================================================#
# Select the farm or farms to be infected
## here we will use the population database
population <- MHASpread::population                                                # Get the population data example
population$I_small_pop[population$node== 134479] <- 10                             # Infected 20 small ruminants in farm with 3 host species
# select the in and out farm dynamics (movements, births, deaths etc.. )
events <- MHASpread::events                                                        # load the events database


#==========================================================================#
#                                                                          #
# Run the initial condition for  the model ---------------------------------
#                                                                          #
#==========================================================================#
##  Note: run the FMD model without any control action
model_1     <- SEIR_model(population = population,                                                 #  Population database
                          events = events,                                                         #  Events database
                          simulation_name = "scenario_4_init",                                     #  Simulation tag name
                          days_of_simulation = 10,                                                 #  Population database
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


# here use the model output to update the population data for the control actions
population <- update_population_in_model(original_population = MHASpread::population,
                                         model_1$populationdb )

#==========================================================================#
#                                                                          #
# Explore the initial scenario (Non control actions) -----------------------
#                                                                          #
#==========================================================================#

## lets see the initial spread epidemic curves of farms
epi_curves_farms_plot <- plot_infected_farms_curve(model_output = model_1)          # generates the plot
epi_curves_farms_plot                                                               # print the plot in the plot viewer

#save the plot
ggsave(plot= epi_curves_farms_plot,                                       # Plot to save
       filename = "epidemic_curves_farms_plot.png",                       # Path and name of the file to save in .png format
       width = 10, height = 6)                                            # Plot dimensions

## what about epidemic curves over animal populations
plot_SEIR_animals(model_output = model_1,               # Model output
                  plot_suceptible_compartment = F,      # Sometimes is useful not consider the S compartment for data visualization purposes
                  by_host = T)                          # Select whether plot by specie or all species together


# see the geo-location of the farms
farms_location <- plot_leaflet_map_farms(population = model_1$populationdb)     # Creates the map
farms_location                                                                  # Plot the interactive map on viewer
mapview::mapshot(farms_location, file = "initial_outbreak_farms_location.png")  # Save the map

# lets explore how the control area looks like assuming 100% of detection
zones_arond_inft_farms <- assign_control_zones(population = population,                      # Population database
                                               infected_size = 3,                               # Ratio size in Km of the infected zone
                                               buffer_size = 7,                                 # Ratio size in Km of the buffer zone
                                               surveillance_size = 15,                          # Ratio size in Km of the surveillance zone
                                               detected_farms.id = model_1$populationdb$node,   # Farms that have been detected
                                               num_threads = parallel::detectCores()/2)         # Computer threads to be used (please don't overload your computer)

plot_farms_in_control_zones_areas(zones_arond_inft_farms, model_1$populationdb$node)         # Plot interactive map


#==========================================================================#
#                                                                          #
# Control action modelling          ---------------------------------------
#                                                                          #
#==========================================================================#
initial_day_control <- 21                                                                              # Seed the initial day of infection in the day 21
days_of_control_action <- 90                                                                           # Select 30 days working on control actions
days_to_test <- seq(initial_day_control, (initial_day_control+days_of_control_action), by= 7)          # Create the data that will be used to test and update the buffer control areas
detectection_rate <- 50                                                                                # percentage of detection of the infectious farms
my_infeted_farms <- c()                                                                                # Create an empty object to save the FMD positive farms detected
my_new_infeted_farms <- c()                                                                            # Create an empty object to save the FMD positive new farms detected
banco_summary <- c()                                                                                   # Create an empty object to save the model output
banco_summ_cntl_acts_depop <- c()
banco_summ_cntl_acts_vac <- c()


# Here open a loop to simulate the control action and FDM infection by day
t1 <- Sys.time()
for (day in initial_day_control:(initial_day_control+days_of_control_action)) {
  print(day)


  #====================================#
  ##     check point of the loop      ----
  #====================================#
  ## check if there are no more infectious or exposed animals, if so break the loop
  mystatement <- id_of_infectious_farms(population = population, only_infected_comp = F)
  if (identical(mystatement, numeric(0))) {print("No more infectious animals"); break }

  #============================================#
  ##   modeling the farm that will be detected ----
  #============================================#
  # note: Here, we select the number of farms that will be detected in this day i of run

  my_infeted_farms <- unique(c(my_infeted_farms, my_new_infeted_farms))                        # get the id of the infected farms
  my_new_infeted_farms  <- id_of_infectious_farms(population = population,                     # database with the population
                                                  only_infected_comp = T,                      # if FALSE statement return the Exposed and Infected farms otherwise just infected
                                                  prob = detectection_rate,                    # Is the probability of detection of the surveillance system per day
                                                  previous.farms = my_infeted_farms)           # Farms that have been previously detected
  my_infeted_farms <- my_new_infeted_farms


  #=======================================#
  ##   establish the control areas zones ----
  #=======================================#

  if (day %in% days_to_test) {

    control_zones_areas <- assign_control_zones(population = population,                         # Population database
                                                infected_size = 3,                               # Ratio size in Km of the infected zone
                                                buffer_size = 7,                                 # Ratio size in Km of the buffer zone
                                                surveillance_size = 15,                          # Ratio size in Km of the surveillance zone
                                                detected_farms.id = my_infeted_farms,            # farms that have been detected
                                                num_threads = 2)         # parallel::detectCores()/2 computer threads to be used (please don't overload your computer)

  }

  #=======================================#
  ##      farm standstill          ----
  #=======================================#



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
  print("movement ban done!")

  #=======================================#
  ##      depopulation per farm       ----
  #=======================================#

  depop_result <- depop_farms_ca(population = population,                 #  Population database
                                 limit_per_day_farms = 10,                  #  10 farm will be depopulated by day
                                 infected_zone = T,                         #  Depopulation will be applied to infected zone
                                 farms_in_zones = control_zones_areas,      #  Object with the farms in control areas
                                 only_depop_infect_farms = T ,
                                 infected_farms = my_infeted_farms)         #  Id of the farms that have been detected
  population <- depop_result$population                                   # Update the population database


  # Update depopulation count
  depopdata <- depop_result$depopulated
  depopdata  <- depopdata %>% mutate(day = day)
  banco_summ_cntl_acts_depop <- rbind(banco_summ_cntl_acts_depop, depopdata )
  print("Depopulation done!")

  #=======================================#
  ##      vaccination per farm        ----
  #=======================================#
  #select the animals vaccinated in the previous round
  farms_prev_vaccinated <- population%>%
    mutate(animals_vaccinated = rowSums(select(., starts_with("V_")))) %>%
    filter(animals_vaccinated>0) %>%
    pull(node)


  # Run the vaccination function bases on the selected parameters
  output_vacc_pop <- vaccinate_farms_ca(population = population,                       # Population database
                                        limit_per_day_farms = 100,                     # Maximum number of farms to be vaccinated
                                        infected_zone = T,                             # If true vaccination will be applied to infected zone
                                        vacc_infectious_farms = T,                     # If true vaccination will be applied to infected farms
                                        buffer_zone = T,                               # If true vaccination will be applied to buffer zone
                                        surveillance_zone = F,                         # If true vaccination will be applied to surveillance zone
                                        control_zones_db = control_zones_areas,        # Object with the control areas zones
                                        vacc_bovine = T,                               # If true vaccine bovine population
                                        vacc_swine = F,                                # If true vaccine swine population
                                        vacc_small = T,                                # If true vaccine small ruminants population
                                        vaccine_efficacy =0.9,                         # Efficacy of the vaccine
                                        vaccinated_farms = farms_prev_vaccinated,      # IDs of the farms that have been previously vaccinated
                                        detected_farms = my_infeted_farms,             # Infected farms that have been detected
                                        num_threads = 2)       # parallel::detectCores()/2 Number of computer threads

  print("vaccination done!")
  # update vaccine count
  vaccdata <- output_vacc_pop$banco_vac
  vaccdata  <- vaccdata %>% mutate(day = day)
  banco_summ_cntl_acts_vac <- rbind(banco_summ_cntl_acts_vac,vaccdata )
  farms_prev_vaccinated <-  output_vacc_pop$banco_vac$node
  population <- output_vacc_pop$population


  #=======================================#
  ##             SEIR dynamics        ----
  #=======================================#
  # if there are no more exposed or infected farms skip the SEIR model dynamics
  if (identical(id_of_infectious_farms(population, only_infected_comp = F),numeric(0))) {
    next
  }



  model_in_loop     <- SEIR_model(population = population,                                                 #  Population database
                                  events = events,                                                         #  Events database
                                  simulation_name = "scenario_4_control",                                  #  Simulation tag name
                                  days_of_simulation = 1,                                                  #  Population database
                                  initial_day_simulation=day,                                              #  Initial day of simulation
                                  max_distance_in_km= 40,                                                  #  Max distance kernel by local disease spread
                                  num_threads=1,                                                           #  Number of CPU to parallel tasks; set 1 to not overload your computer
                                  a = 0.012,                                                               #  To set kernel curve max infection rate (S*I)/N when animals are in the same area
                                  b =  0.6 ,                                                               #  Shape of the kernel curve
                                  beta_bov_to_bov= c(min = 0.01833333, mode = 0.025, max = 0.05666667),    #  Transmission coefficient of bovine infects bovine
                                  beta_bov_to_swi= c(min = 0.01833333, mode = 0.025, max = 0.05666667),    #  Transmission coefficient of bovine infects swine
                                  beta_bov_to_SR=c(min = 0.012, mode = 0.031, max = 0.065),                #  Transmission coefficient of bovine infects small ruminants
                                  lambda1_bov=c(min = 5, mode = 6, max = 16),                              #  Rate from exposed (E) to infectious (I) in bovine
                                  lambda2_bov=c(min = 6, mode = 15, max = 20),                             #  Rate from infectious (I) to recovered (R) in bovine
                                  beta_swi_to_swi=c(min = 0.044, mode = 0.14, max = 0.33) ,                #  Transmission coefficient of swine infects swine
                                  beta_swi_to_bov=c(min = 0.014, mode = 0.033, max = 0.044) ,              #  Transmission coefficient of swine infects bovine
                                  beta_swi_to_SR= c(min = 0.014, mode = 0.033, max = 0.044),               #  Transmission coefficient of swine infects small ruminants
                                  lambda1_swi=c(min = 3, mode = 5.9, max = 16),                            #  Rate from exposed (E) to infectious (I) in swine
                                  lambda2_swi=c(min = 5, mode = 6.44, max = 14) ,                          #  Rate from infectious (I) to recovered (R) in swine
                                  beta_SR_to_SR=c(min = 0.16, mode = 0.24, max = 0.5) ,                    #  Transmission coefficient of small ruminants infects small ruminants
                                  beta_SR_to_bov=c(min=0.012,mode=0.031,max= 0.033) ,                      #  Transmission coefficient of small ruminants infects bovine
                                  beta_SR_to_swi=c(min = 0.006, mode = 0.024, max = 0.09),                 #  Transmission coefficient of small ruminants infects swine
                                  lambda1_SR=c(min = 4, mode = 5, max = 14) ,                              #  Rate from exposed (E) to infectious (I) in small ruminants
                                  lambda2_SR=c(min = 6, mode = 15, max = 20) )                             #  Rate from infectious (I) to recovered (R) in bovine

  # Update the population and model summary

  # Update population database
  population <- update_population_in_model(original_population = population, model_in_loop$populationdb)
  banco_summary <- rbind(banco_summary, model_in_loop)

  #save backup
  save(model_1, banco_summary, banco_summ_cntl_acts_vac, banco_summ_cntl_acts_depop, file = "backup.Rdata")

}

t2 <- Sys.time()

t2-t1

#==========================================================================#
#                                                                          #
# Plot results of control action modelling ---------------------------------
#                                                                          #
#==========================================================================#
## plot the number of infected farm considering initial spread + the control action----
plot_contol_actns <- plot_epi_curve_mean_and_cntrl_act(model_inital = model_1,
                                                       model_control = banco_summary,
                                                       control_action_start_day = 21,
                                                       plot_only_total_farms = F)
plot_contol_actns

#save the plot
ggsave(plot= plot_contol_actns,                                       # Plot to save
       filename = "epidemic_and_control_curves_farms_plot.png",       # Path and name of the file to save in .png format
       width = 10, height = 6)                                        # Plot dimensions


## plot the number of depopulated  farms during the control actions simulated period ----
# farm level #
depop_plot <- plot_depopulation(depopulation_data = banco_summ_cntl_acts_depop, level_plot = "farms")

depop_plot

ggsave(plot= depop_plot,                                         # Plot to save
       filename = "depopulation_farms_plot.png",                 # Path and name of the file to save in .png format
       width = 10, height = 6)                                   # Plot dimensions

# animal level #
depop_plot2 <- plot_depopulation(depopulation_data = banco_summ_cntl_acts_depop, level_plot = "animals")
depop_plot2

ggsave(plot= depop_plot2,                                         # Plot to save
       filename = "depopulation_animals_plot.png",                # Path and name of the file to save in .png format
       width = 10, height = 6)                                    # Plot dimensions

## plot the number of vaccinated  farms during the control actions simulated period ----
#farm level
plotvacc <- plot_vaccination(vaccination_data = banco_summ_cntl_acts_vac, level_plot = "farms")
plotvacc

ggsave(plot= plotvacc,                                         # Plot to save
       filename = "vaccinated_farms_plot.png",                 # Path and name of the file to save in .png format
       width = 10, height = 6)                                 # Plot dimensions

#farm level
plotvacc2 <- plot_vaccination(vaccination_data = banco_summ_cntl_acts_vac, level_plot = "animals")
plotvacc2

ggsave(plot= plotvacc2,                                         # Plot to save
       filename = "vaccinated_animal_plot.png",               # Path and name of the file to save in .png format
       width = 10, height = 6)                                  # Plot dimensions

