#===========================================#
#    Check and clean data             ----- 
#===========================================#

# Load data 
load("~/Downloads/example.Rdata")

# check the names population 
names(MHASpread::population)[!names(MHASpread::population) 
                             %in% names(population)]

str(population)

# check the events match the population list 
names(MHASpread::events)[!names(MHASpread::events) 
                             %in% names(events_final)]
table(events_final$event_type)
head(events_final)

events_final<- 
  events_final%>%
  rename(to = To )


# Check if all farms in movements are in the population data 
#nodes in events data 
nodes.in.events <- events_final %>%
  pull(from, to ) %>% unique()

# table how many events
table(nodes.in.events %in% population$node)

# cleaning events 
events_final <- events_final %>%
  filter(to %in% population$node) %>%
  filter(from %in% population$node)

save(population, events_final, file = "Example.Rdata")
