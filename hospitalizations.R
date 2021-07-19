library(RSocrata)
library(tidyverse)
hospitalizations = read.socrata("https://healthdata.gov/resource/g62h-syeh.csv")
hospitalizations$date = as.Date(hospitalizations$date)
unique(hospitalizations$state)

hospitalizations_wa = subset(hospitalizations,state == 'WA')

beds <-ggplot(hospitalizations_wa)+
  #geom_line(aes(x=date,y=total_adult_patients_hospitalized_confirmed_and_suspected_covid))+
  geom_line(aes(x=date,y=inpatient_beds_used_covid)) +
  geom_line(aes(x=date,y=inpatient_beds))


ggplot(hospitalizations_wa)+
     #geom_line(aes(x=date,y=total_adult_patients_hospitalized_confirmed_and_suspected_covid))+
     geom_line(aes(x=date,y=inpatient_bed_covid_utilization)) +
     geom_line(aes(x=date,y=inpatient_beds_utilization))

ggplot(hospitalizations_wa)+
  #geom_line(aes(x=date,y=total_adult_patients_hospitalized_confirmed_and_suspected_covid))+
  geom_line(aes(x=date,y=deaths_covid))

last_7_days_reported_deaths = sum(subset(hospitalizations_wa,date >= Sys.Date()-7,select=c(date,deaths_covid))$deaths_covid)

