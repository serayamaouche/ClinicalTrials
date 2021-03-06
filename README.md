
# Searching, downloading, and visualizing clinical trials from ClinialTrials.Gov in R
By Seraya Maouche |
Latest update : 22 April 2017

The [rclinicaltrials R package](https://cran.r-project.org/web/packages/rclinicaltrials/index.html) provides functions to search, explore, and retrieve data from [ClinicalTrials.Gov](https://clinicaltrials.gov/).
The script [clinicalTrialsGov2R.R](https://github.com/serayamaouche/ClinicalTrials/blob/master/clinicalTrialsGov2R.R) provides an example on how to search and download clinical trials.
The script [vizClinicalTrials.R](https://github.com/serayamaouche/ClinicalTrials/blob/master/vizClinicalTrials.R) provides an exemple of clinical trials visualization on maps.


1- Install rclinicaltrials
```R
# Install rclinicaltrials package from CRAN
install.packages("rclinicaltrials")

# Install the lastest version using devtools::install_github()
install.packages("devtools")
library(devtools)
install_github("sachsmc/rclinicaltrials")
```

2- Searching ClinicalTrials.Gov
```R
res <- clinicaltrials_search(query = "colon cancer", count = 10)
str(res)
> str(res)
'data.frame':	20 obs. of  8 variables:
 $ score               : chr  "0.053361" "0.050978" "0.05088" "0.050038" ...
 $ nct_id              : chr  "NCT02159742" "NCT00601146" "NCT01238172" "NCT01141842" ...
 $ url                 : chr  "https://ClinicalTrials.gov/show/NCT02159742" "https://ClinicalTrials.gov/show/NCT00601146" "https://ClinicalTrials.gov/show/NCT01238172" "https://ClinicalTrials.gov/show/NCT01141842" ...
 $ title               : chr  "Prospective Follow-up of Outcomes in Patients Receiving Photodynamic Therapy for Neoplastic Diseases" "Low-Dose Chest Computed Tomography Screening for Lung Cancer in Survivors of Hodgkin's Disease" "Diet in Altering Disease Progression in Patients With Prostate Cancer on Active Surveillance" "Early Detection of Lung Tumors by Sniffer Dogs - Evaluation of Sensitivity and Specificity" ...
 $ status.text         : chr  "Recruiting" "Active, not recruiting" "Active, not recruiting" "Completed" ...
 $ condition_summary   : chr  "Neoplastic Disease" "Lung Cancer" "Prostate Cancer" "Lung Cancer; Chronic Obstructive Airway Disease" ...
 $ intervention_summary: chr  "Other: Data Collection" "Procedure: chest computed tomography scan" "Other: dietary education and counseling; Other: prostate cancer foundation booklet" "Procedure: exhalation analysis of breath sample; Procedure: exhalation analysis of breath sample; Procedure: exhalation analysi"| __truncated__ ...
 $ last_changed        : chr  "September 23, 2016" "February 17, 2016" "July 1, 2016" "May 6, 2013" ...

# Count the number of results for a given search
clinicaltrials_count(query = "breast cancer")
clinicaltrials_count(query = c('recr=Open', 'type=Intr', 'cond=melanoma'))
# count trials satisfying 'breast cancer AND France'
clinicaltrials_count(query = 'breast cancer AND France')
[1] 766

# Exploring the data
MI <- clinicaltrials_search(query = c("cond=Myocardial infarction", 
                                       "phase=2", 
                                       "type=Intr", "rslt=With"), 
                             count = 10000)
nrow(MI)
[1] 40
table(MI$status.text)

Active, not recruiting              Completed 
                     1                     30 
            Terminated 
                     9 
```

3 - Visualization of clinical trials in myocardial infarction
```R
ggplot(cts, aes(x = year, y = cumsum(count), color = Gender)) + 
  geom_line() + geom_point() + 
  labs(title = "Cumulative enrollment into Phase III, \n interventional trials in Myocardial infarction, by gender") + 
  scale_y_continuous("Cumulative Enrollment") 
``` 

<p align="center">
  <img src="https://github.com/serayamaouche/ClinicalTrials/blob/master/clinicalTrialsMI.png" width=""/>
</p>


### Links

* [CRAN - Package rclinicaltrials](https://cran.r-project.org/web/packages/rclinicaltrials/index.html)
* [ggmap R Package](https://cran.r-project.org/web/packages/ggmap/index.html)
* [rclinicaltrials on Github](https://github.com/sachsmc/rclinicaltrials)
* [Clinical Trials Data Visualization in Maps using R](http://rstudio-pubs-static.s3.amazonaws.com/209130_403f02103baa43aa8b5caa25daa4db57.html)
* [Clinical Trials Metadata Visualization using R](https://www.linkedin.com/pulse/clinical-trials-data-visualization-using-r-jose-i-rey)
* [clinicaltrials.gov](https://clinicaltrials.gov/)
* [clinicaltrials.gov API](https://clinicaltrials.gov/ct2/info/linking)
* [Creating heatmaps in R with ggmap](http://www.geo.ut.ee/aasa/LOOM02331/heatmap_in_R.html)
* [How to GeoCode a simple address using Data Science Toolbox](http://stackoverflow.com/questions/22887833/r-how-to-geocode-a-simple-address-using-data-science-toolbox)
* [Mapping The United States Census With {ggmap}](http://amunategui.github.io/ggmap-example/)
    





