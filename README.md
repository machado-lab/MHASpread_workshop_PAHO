# Taller: Uso de modelos de transmisión para simular la propagación de enfermedades en animales de producción [![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)

<a href="url"><img src="https://github.com/ncespedesc/logos_nc_state/blob/main/MHASpread_logo.png?raw=true" align="left" height="150" width="150"></a>

## 🎓 Bienvenido al taller

¡Bienvenido! 👋  
Durante cuatro días, aprenderás a usar modelos matemáticos para **simular la propagación y control de enfermedades en animales de producción**. Nuestro objetivo es ayudarte a comprender cómo estos modelos pueden apoyar la toma de decisiones **antes**, **durante** y **después** de una emergencia sanitaria animal.

El taller está enfocado en la aplicación práctica de modelos epidemiológicos, utilizando datos reales para simular brotes de **fiebre aftosa (FMD)**.  

> 🔍 **Usaremos MHASpread**: un modelo estocástico multinivel para la diseminación entre múltiples especies (versión 0.1.1). Este paquete de R permite definir parámetros de transmisión específicos por especie y simular dinámicas complejas, como movimientos entre granjas, traslados a mataderos, nacimientos y muertes.  

Aprenderás paso a paso cómo usar MHASpread para **simular la introducción y diseminación de la FMD**, explorando herramientas epidemiológicas y computacionales dentro de un flujo de trabajo fácil de seguir.

---

## 🎯 Objetivos del taller

Al finalizar este taller, podrás:

- 🧩 Comprender los principios básicos detrás del paquete **MHASpread v0.1.0**.  
- 📈 Interpretar los resultados y salidas del modelo.  
- 💉 Simular estrategias de control como **despoblación, vacunación y trazabilidad**.  
- 🔄 Conocer otros modelos de transmisión aplicables a la salud animal.  

---

## 💾 Datos y archivos necesarios

Trabajaremos con datos multiespecie (bovinos, porcinos y pequeños rumiantes) para explorar la aplicación real de los modelos. Los conjuntos de datos requeridos incluyen:

1. **Lista de granjas** con ID único, ubicación geográfica (latitud y longitud) y número de animales por especie.  
2. **Registros de natalidad y mortalidad** por granja y especie.  
3. **Movimientos entre granjas y hacia mataderos**, incluyendo:  
   - Identificación única de origen y destino.  
   - Fecha del movimiento.  
   - Número de animales transportados por especie.  

---

## 💻 Requisitos del equipo

Cualquier computadora moderna (de los últimos 5 años) puede ejecutar R y RStudio sin problema. Sin embargo, recomendamos lo siguiente:

- 🖥️ Procesador: Intel Core i5 (6ª generación o superior) o AMD X8 @ 4GHz.  
- 💾 Memoria RAM: mínimo 8 GB.  
- 📂 Espacio libre en disco: 65 GB.  

---

## 🔗 Enlaces útiles

- 📘 [Cómo instalar R y RStudio](https://github.com/machado-lab/workshop_MHASpread/blob/main/install_RStudio_and_packages/README.md)  
- 📦 [Paquetes necesarios para ejecutar el modelo](https://github.com/machado-lab/workshop_MHASpread/blob/main/install_RStudio_and_packages/package_to_install.R)  

---

## 👥 Autores  

**Nicolas Cardenas** [![ORCIDiD](https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png)](https://orcid.org/0000-0001-7884-2353)  
**Gustavo Machado** [![ORCIDiD](https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png)](https://orcid.org/0000-0001-7552-6144)  


---
## 🤓 Desarrolladores 
:computer: Nicolas Cardenas [![ORCIDiD](https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png)](https://orcid.org/0000-0001-7884-2353)
:computer: [LUMAC- Universidade Federal de Santa Maria](https://www.ufsm.br/orgaos-de-apoio/sai/welcome-to-ufsm)

---

## 📚 Referencias
- 📚
[Modeling foot-and-mouth disease dissemination in Brazil and evaluating the effectiveness of control measures](https://doi.org/10.3389/fvets.2024.1468864)
- 📚
[Foot-and-Mouth Disease in Bolivia: Simulation-Based Assessment of Control Strategies and Vaccination Requirements](https://doi.org/10.1155/tbed/9055612)
- 📚
[Integrating epidemiological and economic models to estimate the cost of simulated foot-and-mouth disease outbreaks in Brazil](https://doi.org/10.1016/j.prevetmed.2025.106558)


---

## 🌐 Sitio web

Visita el sitio oficial del laboratorio para más recursos e investigaciones:  
🔗 [Machado-lab](https://machado-lab.github.io/)  

---

## 💪 Patrocinadores

<a href="url"><img src="https://github.com/ncespedesc/logos_nc_state/blob/main/pahologo.png?raw=true" align="center" width="300"></a>  
<a href="url"><img src="https://github.com/ncespedesc/logos_nc_state/blob/main/fundesalogo.jpg?raw=true" align="left" width="300"></a>  

<a href="url"><img src="https://github.com/ncespedesc/logos_nc_state/blob/main/ncstate-type-4x1-red-min.png?raw=true" align="right" width="300"></a>  

<a href="url"><img src="https://github.com/ncespedesc/logos_nc_state/blob/main/seapilogo.png?raw=true" align="center" width="300"></a>
