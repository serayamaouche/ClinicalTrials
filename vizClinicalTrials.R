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

# Load rclinicaltrials
library(rclinicaltrials)
library(ggplot2)
library(dplyr)
