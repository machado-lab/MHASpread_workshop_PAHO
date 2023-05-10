# MHASpread:  A multi-host Animal Spread Stochastic Multilevel Model(version 0.2.0) 

![generic](https://img.shields.io/badge/Control_actions-up-green) ![generic1](https://img.shields.io/badge/Spatial_transmission-up-green) ![generic2](https://img.shields.io/badge/Network_level-up-green) ![generic3](https://img.shields.io/badge/Vital_dynamics-Up-green) ![generic4](https://img.shields.io/badge/SEIR_model-Up-green)

## Getting started
The MHASpread package works with two main files: 1) a file containing population data, `population`, and 2) a file containing movement data, `events`, that must be created the model is run.


### Population database 
The `population` database is a data frame object where each line represents a node (farm, premises, municipality) location, and the columns denote the features of this node. The next table describe the meaning of each column in the population database. 

**Note:** to prepare the data, the number of animals should be added in the over the suceptible compartment which means that is required to complete the columns **S\_bov\_pop** , **S\_swi\_pop**, and **S\_small\_pop** with the number of animals in each farm  according with the host-specie. farms without animals from specific specie should be complete with 0.

Please notice that will be require the geolocalion of the farms is requested as degree in the column **longitude** and **latitude** and also in UTM over the columns  **long**, and **lat**.   

| **Column**        | **Description**                                                        |
|-------------------|-------------------------------------------------------------------------|
| **node**          | Represents the unit of observation eg\. Farm or slaughterhouses          |
| **latitude**      | The latitude of the node in degrees                                    |
| **longitude**     | The longitude of the node in degrees                                   |
| **S\_bov\_pop**   | Represents the  susceptible bovine population                            |
| **E\_bov\_pop**   | Represents the exposed bovine population                               |
| **I\_bov\_pop**   | Represents the infected bovine population                              |
| **R\_bov\_pop**   | Represents the recovered bovine population                             |
| **V\_bov\_pop** | Represents the bovine population that have been vaccinated    |
| **D\_bov\_pop** | Represents the bovine population that have been depopulated    |
| **S\_swi\_pop**   | Represents the  susceptible swine population                             |
| **E\_swi\_pop**   | Represents the exposed swine population                                |
| **I\_swi\_pop**   | Represents the infected swine population                               |
| **R\_swi\_pop**   | Represents the recovered swine population                              |
| **V\_swi\_pop** | Represents the swine population that have been vaccinated    |
| **D\_swi\_pop** | Represents the swine population that have been depopulated    |
| **S\_small\_pop** | Represents the susceptible small ruminants population                  |
| **E\_small\_pop** | Represents the exposed small ruminants population                      |
| **I\_small\_pop** | Represents the infected small ruminants population                     |
| **R\_small\_pop** | Represents the recovered small ruminants population                    |
| **V\_small\_pop** | Represents the small ruminants population that have been vaccinated    |
| **D\_small\_pop** | Represents the small ruminants population that have been depopulated    |
| **long**          | The longitude of the node in Universal Transverse Mercator \(UTM\) |
| **lat**           | The latitude of the node in Universal Transverse Mercator \(UTM\)      |


### Events database 
The `events` database is a data frame object where each line represents a movement of animals from/to nodes. This dataframe includes the specific number pf animals moved, the species and the time step related to each movement. 

| **Column**      |  **Description**                                                                                                                                  |
|-----------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| **date**        | Timestep when the event occurs                                                                                                                |
| **event\_type** | Represents the type of the event where: <br /> **1**: movements farm to farm; <br /> **2**: movements to slaughterhouses; <br /> **3**: births of animals; <br /> **4** deaths of the animals |
| **from**        | ID of the origin farm/premise                                                                                                                               |
| **to**          | ID of the destination farm/premise                                                                                                                         |
| **host**        | Host species being moved must be one of the following options:<br /> **Bovine**;<br />**Swine**;<br />**Small ruminants** |
| **number**      | The number of animals related to the event                                                                                                      |


