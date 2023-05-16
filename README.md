# PSY6422
## About
This project was created to visualise differences in willingness to consume alternative proteins (such as soy, lentils and even insects!) across the regions of England and Wales.  
### Motivation  
Large scale consumption of meat and animal-based proteins has adverse effects on the environment . Its consumption has also been linked to certain lifestyle diseases. In response to these challenges, consumers have started adopting sustainable diets - diets that include plant based and alternative proteins. In spite of the supposed benefits of such a diet, some consumers are resistant to any changes in their meat-eating habits. This visualisation will try to indicate how resistant consumers are to switching to a more sustainable diet.  
### Project Organisation 
Individual components of the project are housed in different folders. 
1. The 'data' folder contains the raw data, that is, the data available on [here](https://data.food.gov.uk/catalog/datasets/4353459f-a369-44e1-b4d0-8d06a1ccc479) and the shapefile containing information about the regional boundaries (files are available in shp, prj, dbf and shx formats). Information for regional boundaries can be found [here](https://borders.ukdataservice.ac.uk/bds.html)
2. The 'notes' folder contains a codebook explaining the variable names and levels. 
3. The 'plots' folder contains the key visualisation as a .png file. 
4. The 'processed data' contains an .Rdata file with the tidied data.  
### Essential packages that you may need 
* here - Version 1.0.1
* tidyverse - Version 2.0.0
* rgdal - Version 1.6.5
* viridis - Version 0.6.3
