# MHASpread: Un modelo estocástico multinivel de diseminación multiespecie (versión 3.0.0)

![generic](https://img.shields.io/badge/Control_actions-up-green) ![generic1](https://img.shields.io/badge/Spatial_transmission-up-green) ![generic2](https://img.shields.io/badge/Network_level-up-green) ![generic3](https://img.shields.io/badge/Vital_dynamics-Up-green) ![generic4](https://img.shields.io/badge/SEIR_model-Up-green)

## Introducción
El paquete **MHASpread** trabaja con dos archivos principales:  
1) un archivo que contiene la información de la población, llamado `population`, y  
2) un archivo con los datos de movimientos, llamado `events`, que debe ser creado antes de ejecutar el modelo.

### Base de datos de población
La base de datos `population` es un objeto tipo *data frame* donde cada línea representa un nodo (granja, predio o municipio), y las columnas indican las características de ese nodo. La siguiente tabla describe el significado de cada columna en la base de datos de población.

**Nota:** para preparar los datos, el número de animales debe agregarse en el compartimento de susceptibles, lo que significa que es necesario completar las columnas **S_bov_pop**, **S_swi_pop** y **S_small_pop** con el número de animales en cada granja según la especie hospedadora. Las granjas sin animales de una especie específica deben completarse con 0.

Además, se requiere la geolocalización de las granjas en grados en las columnas **longitude** y **latitude**, y también en coordenadas UTM en las columnas **long** y **lat**.

| **Column**        | **Descripción**                                                                 |
|-------------------|---------------------------------------------------------------------------------|
| **node**          | Representa la unidad de observación, por ejemplo, una granja o un matadero      |
| **latitude**      | Latitud del nodo en grados                                                      |
| **longitude**     | Longitud del nodo en grados                                                     |
| **S_bov_pop**   | Población bovina susceptible                                                    |
| **E_bov_pop**   | Población bovina expuesta                                                       |
| **I_bov_pop**   | Población bovina infectada                                                      |
| **R_bov_pop**   | Población bovina recuperada                                                     |
| **V_bov_pop**   | Población bovina vacunada                                                       |
| **D_bov_pop**   | Población bovina despoblada                                                     |
| **S_swi_pop**   | Población porcina susceptible                                                   |
| **E_swi_pop**   | Población porcina expuesta                                                      |
| **I_swi_pop**   | Población porcina infectada                                                     |
| **R_swi_pop**   | Población porcina recuperada                                                    |
| **V_swi_pop**   | Población porcina vacunada                                                      |
| **D_swi_pop**   | Población porcina despoblada                                                    |
| **S_small_pop** | Población de pequeños rumiantes susceptible                                     |
| **E_small_pop** | Población de pequeños rumiantes expuesta                                        |
| **I_small_pop** | Población de pequeños rumiantes infectada                                       |
| **R_small_pop** | Población de pequeños rumiantes recuperada                                      |
| **V_small_pop** | Población de pequeños rumiantes vacunada                                        |
| **D_small_pop** | Población de pequeños rumiantes despoblada                                      |
| **long**          | Longitud del nodo en coordenadas UTM (Universal Transverse Mercator)            |
| **lat**           | Latitud del nodo en coordenadas UTM (Universal Transverse Mercator)             |

### Base de datos de eventos
La base de datos `events` es un objeto tipo *data frame* donde cada línea representa un movimiento de animales entre nodos. Este *data frame* incluye el número específico de animales movidos, la especie y el paso de tiempo asociado con cada movimiento.

| **Column**      | **Descripción**                                                                                                                                     |
|-----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| **date**        | Paso de tiempo en el que ocurre el evento                                                                                                           |
| **event_type** | Tipo de evento: <br /> **1**: movimiento granja a granja; <br /> **2**: movimiento a matadero; <br /> **3**: nacimiento de animales; <br /> **4**: muerte de animales |
| **from**        | ID de la granja/predio de origen                                                                                                                    |
| **to**          | ID de la granja/predio de destino                                                                                                                   |
| **host**        | Especie hospedadora movida, debe ser una de las siguientes opciones: <br /> **Bovine**; <br /> **Swine**; <br /> **Small ruminants**               |
| **number**      | Número de animales relacionados con el evento                                                                                                       |
