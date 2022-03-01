#!/bin/bash
#set -x

wget https://raw.githubusercontent.com/beauraines/covid-r/main/CovidDashboard.Rmd
wget https://raw.githubusercontent.com/beauraines/covid-r/main/CumulativeDeathsAndCases.R

Rscript -e "rmarkdown::render('CovidDashboard.Rmd')"
Rscript upload.R $AWS_KEY $AWS_SECRET $AWS_REGION $AWS_BUCKET

