library(RSocrata)
library(tidyverse)
hospitalizations = read.socrata("https://healthdata.gov/resource/g62h-syeh.csv")
hospitalizations$date = as.Date(hospitalizations$date)
hospitalizations <-tibble(hospitalizations)
unique(hospitalizations$state)

hospitalizations_wa = subset(hospitalizations,state == 'WA')

ggplot(hospitalizations_wa)+
  #geom_line(aes(x=date,y=total_adult_patients_hospitalized_confirmed_and_suspected_covid))+
  geom_line(aes(x=date,y=inpatient_beds))


## Hospitalizations for Covid are on the rise
ggplot(hospitalizations_wa)+
  geom_line(aes(x=date,y=inpatient_beds_utilization))



ggplot(hospitalizations_wa)+
     #geom_line(aes(x=date,y=total_adult_patients_hospitalized_confirmed_and_suspected_covid))+
     geom_line(aes(x=date,y=inpatient_bed_covid_utilization))

ggplot(hospitalizations_wa)+
  geom_line(aes(x=date,y=inpatient_bed_covid_utilization)) + 
  geom_line(aes(x=date,y=inpatient_beds_utilization))


hospitalizations_wa %>%
  filter(date == max(date)) %>%
  select(date,
         inpatient_beds,
         inpatient_beds_used,
         inpatient_beds_utilization,
         inpatient_bed_covid_utilization,
         percent_of_inpatients_with_covid,
         staffed_adult_icu_bed_occupancy,
         staffed_icu_adult_patients_confirmed_and_suspected_covid,
         total_adult_patients_hospitalized_confirmed_and_suspected_covid)



## Deaths
ggplot(hospitalizations_wa)+
  #geom_line(aes(x=date,y=total_adult_patients_hospitalized_confirmed_and_suspected_covid))+
  geom_line(aes(x=date,y=deaths_covid))

last_7_days_reported_deaths = sum(subset(hospitalizations_wa,date >= Sys.Date()-7,select=c(date,deaths_covid))$deaths_covid)

