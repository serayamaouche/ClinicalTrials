#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Script File: clinicalTrialsGov2R.R
# Date of creation: 18 Feb 2017
# Date of last modification: 21 Feb 2017
# Author: Seraya Maouche <seraya.maouche@iscb.org>
# Short Description: This script provides an R interface to  
#                     ClinicalTrialsdotGov dataset
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

# Obtaining help
vignette("basics", "rclinicaltrials")
clinicaltrials_search()

# The function advanced_search_terms() provides Clinicaltrials.gov advanced search terms. Their keys, 
#descriptions, and links to help documents.
# http://clinicaltrials.gov/ct2/search/advanced
head(advanced_search_terms)
data(advanced_search_terms)
browseURL(advanced_search_terms["age", "help"])
browseURL(advanced_search_terms["cond", "help"])

# Searching clinicalTrials.Gov
res <- clinicaltrials_search(query = 'cancer+disease')
str(res)
res <- clinicaltrials_search(query = "colon cancer", count = 10)
str(res)

# Count the number of results for a given search
clinicaltrials_count(query = "breast cancer")
clinicaltrials_count(query = c('recr=Open', 'type=Intr', 'cond=melanoma'))
# count trials satisfying 'breast cancer AND France'
clinicaltrials_count(query = 'breast cancer AND France')

# Using a named list
clinicaltrials_count(query = list(recr='Open', type='Intr', cond='melanoma'))


# Downloads detailed information about clinical trials satisfying a
# query, including results
res <- clinicaltrials_download(query = 'cancer', count = 3, tframe = NULL,
                               include_results = TRUE,
                               include_textblocks = FALSE)
str(res)

clinicaltrials_download(query = 'heart disease AND stroke AND France', count = 10)


# Parses results from an xml object downloaded from clinicaltrials.gov
parse_study_xml(file, include_textblocks = FALSE, include_results = FALSE)


# Exploring the data
MI <- clinicaltrials_search(query = c("cond=Myocardial infarction", 
                                      "phase=2", 
                                      "type=Intr", "rslt=With"), 
                                      count = 10000)
nrow(MI)
table(MI$status.text)

MI_information <- clinicaltrials_download(query = c("cond=Myocardial infarction", 
                                                    "phase=2", 
                                                    "type=Intr", "rslt=With"), 
                                                    count = 10000, include_results = TRUE)
summary(MI_information$study_results$baseline_data)
byGender <- subset(MI_information$study_results$baseline_data, 
                    title == "Gender" & arm != "Total")

genderCounts <- byGender %>% group_by(nct_id, subtitle) %>% 
                do( data.frame(count = sum(as.numeric(paste(.$value)), 
                              na.rm = TRUE)
  ))

dates <- MI_information$study_information$study_info[, c("nct_id", "start_date")]
dates$year <- sapply(strsplit(paste(dates$start_date), " "), function(d) as.numeric(d[2]))
counts <- merge(genderCounts, dates, by = "nct_id")
cts <- counts %>% group_by(year, subtitle) %>%
summarize(count = sum(count))
colnames(cts)[2] <- "Gender"

ggplot(cts, aes(x = year, y = cumsum(count), color = Gender)) + 
  geom_line() + geom_point() + 
  labs(title = "Cumulative enrollment into Phase III, \n interventional trials in Myocardial infarction, by gender") + 
  scale_y_continuous("Cumulative Enrollment") 

