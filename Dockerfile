FROM rocker/tidyverse as base

FROM base as pandoc
RUN apt update && \
apt install -y pandoc fonts-humor-sans libjpeg-dev libpng-dev libssl-dev libxml2-dev libcairo2-dev libfontconfig1-dev vim

FROM pandoc as r_libs
RUN sudo su - -c "R -e \"install.packages(c('zoo','rmarkdown','RSocrata','hrbrthemes','flexdashboard','zoo','plotly','emojifont','choroplethr'), repos='http://cran.rstudio.com/')\""

FROM r_libs as dashboard
COPY CovidDashboard.Rmd .

FROM dashboard
RUN Rscript -e "rmarkdown::render('CovidDashboard.Rmd')"

