
# Searching, downloading, and visualizing clinical trials from ClinialTrials.Gov in R
# By Seraya Maouche
# Latest update : 22 April 2017

The [rclinicaltrials R package](https://cran.r-project.org/web/packages/rclinicaltrials/index.html)provides functions to search, explore, and retrieve data from [ClinicalTrials.Gov](https://clinicaltrials.gov/).
The script [clinicalTrialsGov2R.R](https://github.com/serayamaouche/ClinicalTrials/blob/master/clinicalTrialsGov2R.R) provides an example on how to search and download clinical trials.


a- Install rclinicaltrials
```R
# Install rclinicaltrials package from CRAN
install.packages("rclinicaltrials")

# Install the lastest version using devtools::install_github()
install.packages("devtools")
library(devtools)
install_github("sachsmc/rclinicaltrials")
```

a- Searching ClinicalTrials.Gov
```R
res <- clinicaltrials_search(query = "colon cancer", count = 10)
str(res)

# Count the number of results for a given search
clinicaltrials_count(query = "breast cancer")
clinicaltrials_count(query = c('recr=Open', 'type=Intr', 'cond=melanoma'))
# count trials satisfying 'breast cancer AND France'
clinicaltrials_count(query = 'breast cancer AND France')
```

<p align="center">
  <img src="https://github.com/serayamaouche/RGoogle/blob/master/CompareCS.png" width="450"/>
</p>

