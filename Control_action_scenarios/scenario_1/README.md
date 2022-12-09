
# Scenario 1 

For the dissemination and control action, the population and events data will be used. These datasets are synthetic datasets and were created to allow testing of the model. Furthermore, these datasets still preserve the density ratio distribution of the farms, and the events have scale free network properties which are common in animal movement data.

### backgroud 

Infection starts at farm node= `196734` whic have a population of `100` animals. 
Here, foot-and-nouth-disease was first detected after 14 days of inital disease introduction (infection started with `40` infected animal).

```r 

population <- MHASpread::population  # Get the population data example
population$I_bov_pop[population$node== 196734] <- 40    #  # Infected 40 bovine in the farm id = 196734

# select the in and out farm dynamics (movements, births, deaths etc.. )
events <- MHASpread::events # load the events database

```
