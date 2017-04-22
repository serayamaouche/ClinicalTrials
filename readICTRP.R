#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Script File:  
# Date of creation: 17 Feb 2016
# Date of last modification: 24 Feb 2016
# Author: Seraya Maouche <seraya.maouche@iscb.org>
# Project: BD4Cancer (http://bd4cancer.tbiscientific.com)
# Short Description: This script provides functionalities to read and parse clinical
                     # trial downloaded from WHO ICTRP Clinical Trial Registry
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

requiredPackages <- c("XML","tm","SnowballC","RColorBrewer","ggplot2","NLP",
                      "wordcloud","biclust","cluster","igraph","fpc")
                      
#install.packages(requiredPackages,repos="http://cran.r-project.org", dependencies=TRUE)

################ Load required packages
lapply(requiredPackages, require, character.only=TRUE)

DataDir <- "../BD4Cancer/data/WHO_ICTRP"
ResDir <- "../BD4Cancer/results/"
setwd(DataDir)
Files <- c(dir(DataDir))
length(Files)
summary(Files)

# Create a corpus from all XML files
fname   <- file.path(DataDir)
docs <- Corpus(DirSource(fname))

setwd(ResDir)
save(docs, file="WHO_ICTRP.RData")

#Parse XML files
doc = xmlTreeParse(dir(fname)[2], useInternal = TRUE)
class(doc)
top = xmlRoot(doc)
xmlName(top)
names(top)
length(names(top))
names(top[[1]])
#          Internal_Number                   TrialID         Last_Refreshed_on
#        "Internal_Number"                 "TrialID"       "Last_Refreshed_on"
#             Public_title          Scientific_title           Primary_sponsor
#           "Public_title"        "Scientific_title"         "Primary_sponsor"
#        Date_registration               Export_date           Source_Register
#      "Date_registration"             "Export_date"         "Source_Register"
#              web_address        Recruitment_Status             other_records
#            "web_address"      "Recruitment_Status"           "other_records"
#         Inclusion_agemin          Inclusion_agemax          Inclusion_gender
#       "Inclusion_agemin"        "Inclusion_agemax"        "Inclusion_gender"
#         Date_enrollement               Target_size                Study_type
#       "Date_enrollement"             "Target_size"              "Study_type"
#             Study_design                 Countries         Contact_Firstname
#           "Study_design"               "Countries"       "Contact_Firstname"
#         Contact_Lastname           Contact_Address             Contact_Email
#       "Contact_Lastname"         "Contact_Address"           "Contact_Email"
#              Contact_Tel       Contact_Affiliation        Inclusion_Criteria
#            "Contact_Tel"     "Contact_Affiliation"      "Inclusion_Criteria"
#       Exclusion_Criteria                 Condition              Intervention
#     "Exclusion_Criteria"               "Condition"            "Intervention"
#          Primary_outcome              Secondary_ID   Recruitment_status_code
#        "Primary_outcome"            "Secondary_ID" "Recruitment_status_code"

#Extract condition for the first clinical trial
cond = top[[1]] [["Condition"]]
cond
temp <- xmlSApply(top, function(x) xmlSApply(x, xmlValue))
