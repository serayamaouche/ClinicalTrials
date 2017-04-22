#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Script File: vizClinicalTrials.R
# Date of creation: 3 Apr 2017
# Date of last modification: 4 Apr 2017
# Author: Seraya Maouche <seraya.maouche@iscb.org>
# Short Description: This script provides functions for visualization of
#                    clinical trials in Maps using R. It is adapted from a tutorial by Jose Rey.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Install rclinicaltrials package from CRAN
install.packages("rclinicaltrials")

# Install the lastest version using devtools::install_github()
install.packages("devtools")
library(devtools)
install_github("sachsmc/rclinicaltrials")

# Required packages for visualization
library(maps)
library(proto)
library(RgoogleMaps)
library(png)
library(mapproj)
library(jpeg)
library(geosphere)
library(ggmap)


# Load rclinicaltrials
library(rclinicaltrials)
library(ggplot2)
library(dplyr)
library(httr)
library(rjson)

res <- clinicaltrials_download(query = c('term=breast AND cancer','recr=Open', 'type=Intr', 'cntry1=NA%3AUS'), count = 200, include_results = TRUE)

# Extract all the locations in the USA
location <- res[1]$study_information$locations
CT_USA <- location[which(location$address.country=='United States'), ]
head(CT_USA)


# Extract the address columns (City, State, and Country), zip code is only provided by some.
#addr <- CT_USA[CT_USA(2, 3, 5)]
addr  <- CT_USA[,c(2,3,5)]
addr$address <- paste(addr$address.city, addr$address.state, addr$address.country,sep=",")

# Sumarize the results with a frequency (cities with more than one clinical trial)
library(plyr)
ResWithFreq <- count(addr, 'address')
# Sort assending
ResWithFreq <- ResWithFreq[order(-ResWithFreq$freq),]

# Top occurence 20 results from the search
head(ResWithFreq, 20)

# Geolocation of the Cities
# To visualize the clinical trials of a map, we need Longitude and Latitude Coordinates. These informations are not
# available in the downloaded data
# This example uses the the Data Science Toolkit (http://www.datasciencetoolkit.org) to obain the data needed for geolocation.
# Here, the two packages httr and rjson will be used.

data      <- paste0("[",paste(paste0("\"",d$address,"\""),collapse=","),"]")
url       <- "http://www.datasciencetoolkit.org/street2coordinates"
response  <- POST(url,body=data)
json      <- fromJSON(content(response,type="text"))
geocode  <- as.data.frame(
  do.call(rbind,sapply(json,
    function(x) c(address=x$addess,lon=x$longitude,lat=x$latitude))))
geocode$address <- rownames(geocode)

# ************ Visualizing the clinical trials on maps
# Create a dataframes with required information to visualize on the maps  
# aggregatedFreq : data aggregated by frequency of incidence of clinical trials for each city that will be used for the map with location spots.
aggregatedFreq <- merge(ResWithFreq, geocode,by="address") # to use in density by location map
# dataset : the entire dataset without aggregating, it will be used for the heatmaps.
dataset <- merge(addr, geocode,by="address")  # to use for heatmaps
      
# Download the map image for the United States using the get_map() function from the ggmap package 
# Here the packages ggplot2 and ggmap will be used
# ggplot2 is used to add the circles representing the number of studies by location (color and size)
map <-get_map(location='united states', zoom=4, maptype = "terrain",
             source='google',color='color', force=TRUE)
      
# ** Plot the density by location map for breast cancer clinical trials      
ggmap(map) + geom_point(
  aes(x=lon, y=lat, show_guide = TRUE, colour=freq), 
  data=aggregatedFreq, alpha=.5, na.rm = T, size = aggregatedFreq$freq*0.8)  + 
  scale_color_gradient(low="green", high="red")
      
# ** Plot the heatmap for Breast Cancer clinical trials
# The code below uses geom_density2d and stat_density2d  (ggmap) to plot the density of locations as a heatmap
ggmap(map) + geom_density2d(data = dataset,  aes(x = lon, y = lat), size = 0.3)+
      stat_density2d(data=dataset, aes(fill = ..level.., alpha = ..level..), geom="polygon", bins=15) +
      scale_fill_gradient(low = "green", high = "red")+
      scale_alpha(range = c(0.1, 0.3), guide = FALSE)
