#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Script File: ReadClinicalTrialsdotGov.R
# Date of creation: 18 Feb 2016
# Date of last modification: 20 Feb 2016
# Author: Seraya Maouche <seraya.maouche@iscb.org>
# Project: Epidemium BD4Cancer (http://bd4cancer.tbiscientific.com)
# Short Description: This script provides functionalities to read and QC
#                    the ClinicalTrialsdotGov dataset
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

DataDir <- "~/BD4Cancer/data/ClinicalTrialsdotGov"
ResDir <- "~/BD4Cancer/results/"
setwd(DataDir)
ClinicalTrials <- read.csv("study_fields.csv", header=T, dec=".",sep=",")
head(ClinicalTrials)
dim(ClinicalTrials)
names(ClinicalTrials)
summary(ClinicalTrials[,20])

# Clinical Trials by condition
summary(ClinicalTrials[,6])
write.table(summary(ClinicalTrials[,6]), file="SummaryCTcondition.txt")

# Clinical trials by gender
summary(ClinicalTrials[,9])
# Both : 170910
# Female : 19423      
# Male : 10466    
# null : 799


# Which phase ?
summary(ClinicalTrials[,11])
# Phase 0 : 1576         
# Phase 1 : 22928
# Phase 1|Phase 2  : 7675      
# Phase 2  : 33053
# Phase 2|Phase 3 : 3932        
# Phase 3 : 24812        
# Phase 4 : 20610

# Filter Clinicat Trials to retrieve all studies related to the different types of cancers
summary(ClinicalTrials$Conditions)

CancerRelated <- c("cancer","Cancer","Carcinoma","Malignancy","Neoplasms","Tumor","Breast Cancer",
"Prostate Cancer","Lung Cancer","Colorectal Cancer","Multiple Myeloma",
"Leukemia","Lymphoma","Pancreatic Cancer","Head and Neck Cancer","Melanoma",
"Unspecified Adult Solid Tumor, Protocol Specific",
"Hepatocellular Carcinoma","Ovarian Cancer","Brain and Central Nervous System Tumors",
"Gastric Cancer","Metastatic Breast Cancer","Neoplasms","Non-small Cell Lung Cancer",
"Breast Neoplasms","Non-Small Cell Lung Cancer","Glaucoma","Solid Tumors",
"Smoking Cessation","Carcinoma, Non-Small-Cell Lung","Cervical Cancer",
"Non Small Cell Lung Cancer","Metastatic Colorectal Cancer",
"Acute Myeloid Leukemia","Bladder Cancer")

dim(ClinicalTrials)
ClinicalTrialsFilt <- ClinicalTrials[ClinicalTrials$Conditions %in% CancerRelated,]
head(ClinicalTrialsFilt)
dim(ClinicalTrialsFilt)
summary(ClinicalTrialsFilt$Conditions)
