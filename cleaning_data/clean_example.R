#===========================================#
#     check a clean data       ----- 
#===========================================#

# load data 
load("~/Downloads/Paraguay.Rdata")

# check the names population 
names(MHASpread::population)[!names(MHASpread::population) 
                             %in% names(population)]

str(population)

# check the names events 
names(MHASpread::events)[!names(MHASpread::events) 
                             %in% names(events_Paraguay_final)]
table(events_Paraguay_final$event_type)
head(events_Paraguay_final)

events_Paraguay_final   <- 
  events_Paraguay_final %>%
  rename(to = To )


# check inf all farms in movements are in the population data 
#nodes in events data 
nodes.in.events <- events_Paraguay_final %>%
  pull(from, to ) %>% unique()

# table how many are 
table(nodes.in.events %in% population$node)


# cleaning events 
events_Paraguay_final <- events_Paraguay_final %>%
  filter(to %in% population$node) %>%
  filter(from %in% population$node)

save(population, events_Paraguay_final, file = "Paraguay.Rdata")
