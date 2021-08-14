FROM rstudio/r-base:4.0-focal
# ENV

RUN apt update && \
apt install -y pandoc fonts-humor-sans libjpeg-dev libpng-dev libssl-dev libxml2-dev libcairo2-dev libfontconfig1-dev vim && \
R -e "install.packages(c('tidyverse','zoo','rmarkdown','AzureStor','RSocrata','hrbrthemes'), repos='http://cran.rstudio.com/')"

COPY king_county_new_cases.R .
COPY KingCountyCovid.Rmd .
COPY hospitalizations.R .
COPY CountyCasePer100kPopulation.R .

