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

res <- clinicaltrials_download(query = c('term=breast AND cancer','recr=Open', 'type=Intr', 'cntry1=NA%3AUS'), count = 200, include_results = TRUE)

# Extract all the locations in the USA
location <- res[1]$study_information$locations
CT_USA <- location[which(location$address.country=='United States'), ]
head(CT_USA)


# Extract the address columns (City, State, and Country), zip code is only provided by some.
addr <- CT_USA[CT_USA(2, 3, 5)]
addr$address <- paste(addr$address.city, addr$address.state, addr$address.country,sep=",")

# Sumarize the results with a frequency (cities with more than one clinical trial)
library(plyr)
ResWithFreq <- count(addr, 'address')
# Sort assending
ResWithFreq <- ResWithFreq[order(-ResWithFreq$freq),]

# Top occurence 20 results from the search
head(ResWithFreq, 20)


