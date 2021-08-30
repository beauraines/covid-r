library(RSocrata)
library(tidyverse)
library(lubridate)
library(hrbrthemes)
library(geofacet)
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


## Hospitalizations by age group

hospitalizations_wa %>%
  # filter(date>='2021-05-01') %>%
  select(c("state","date",starts_with("previous_day_admission_adult_covid"))) %>%
  select(-c(ends_with("coverage"),"previous_day_admission_adult_covid_confirmed","previous_day_admission_adult_covid_suspected")) %>%
  pivot_longer(cols=starts_with("previous_day_admission_adult_covid"),
               names_to="age_range",
               values_to = "admissions",
               names_prefix = "previous_day_admission_adult_covid_") %>%
  separate(age_range,c("type","age_range"),"ed_") %>%
  # filter(type != "suspect") %>%
  mutate(week_start=floor_date(date,'week')) %>%
  group_by(week_start, age_range) %>%
  summarise(weekly_admissions = sum(admissions)) %>%
  ggplot(aes(x=week_start,y=weekly_admissions,fill=age_range,color=age_range)) + 
    geom_area() +
    ylab("Weekly Admissions (confirmed and suspected)") 


## Currently Hospitalized

hospitalizations_wa %>%
  filter(date == max(date)) %>%
  select(state,
         date,
         inpatient_beds,
         inpatient_beds_used,
         inpatient_beds_utilization, ## This should be a KPI card
         inpatient_bed_covid_utilization, ## This should be a KPI card
         percent_of_inpatients_with_covid,
         total_adult_patients_hospitalized_confirmed_and_suspected_covid,
         total_pediatric_patients_hospitalized_confirmed_and_suspected_covid,
         total_staffed_adult_icu_beds,
         staffed_adult_icu_bed_occupancy, ## This should be a KPI card
         staffed_icu_adult_patients_confirmed_and_suspected_covid,
         adult_icu_bed_covid_utilization) ## This should be a KPI card

### Hospitalized

hospitalizations_wa %>%
  filter(date>='2021-08-01') %>%
  select(state,
         date,
         inpatient_beds,
         inpatient_beds_used,
         inpatient_beds_used_covid) %>%
  pivot_longer(cols=starts_with("inpatient"),
               names_to="measure",
               values_to = "beds",
               names_prefix = "inpatient_") %>%
  ggplot(aes(x=date,y=beds,color=measure)) +
    geom_line()

hospitalizations_wa %>%
  filter(date>='2021-01-01' & inpatient_beds_coverage > 98) %>%
  select(state,
         date,
         inpatient_beds_utilization,
         inpatient_bed_covid_utilization) %>%
  pivot_longer(cols=any_of(c("inpatient_beds_utilization","inpatient_bed_covid_utilization","inpatient_beds_coverage")),
               names_to="measure",
               values_to = "utilization") %>%
  ggplot(aes(x=date,y=utilization,color=measure)) +
  geom_line()

hospitalizations_wa %>%
  filter(date>='2021-01-01' & adult_icu_bed_utilization_coverage > 98) %>%
  select(state,
         date,
         adult_icu_bed_utilization,
         adult_icu_bed_covid_utilization) %>%
  pivot_longer(cols=any_of(c("adult_icu_bed_utilization","adult_icu_bed_covid_utilization")),
               names_to="measure",
               values_to = "utilization") %>%
  ggplot(aes(x=date,y=utilization,color=measure)) +
  geom_line()

hospitalizations_wa %>%
  filter(date>='2021-01-01' & inpatient_beds_coverage > 98) %>%
  select(state,
         date,
         `Inpatient_beds utilized` = inpatient_beds_utilization,
         `Inpatient_beds used for covid` = inpatient_bed_covid_utilization,
         `Adult ICU_beds utilized` = adult_icu_bed_utilization,
         `Adult ICU_beds used for covid` = adult_icu_bed_covid_utilization) %>%
  pivot_longer(cols=any_of(c("Inpatient_beds utilized", "Inpatient_beds used for covid", "Adult ICU_beds utilized", "Adult ICU_beds used for covid")),
               names_to="measure",
               values_to = "utilization") %>%
  separate(measure,into= c("bed_type","measure"),sep ="_") %>%
  ggplot(aes(x=date,y=utilization,color=measure)) +
  geom_line() + 
  scale_y_continuous(labels = scales::percent) +
  scale_x_date(date_labels = "%b-%y",date_breaks = "1 month") +
  ylab('') + xlab('') +
  facet_wrap(~bed_type) +
  theme_ipsum_rc() + theme(legend.title = element_blank())


hospitalizations %>%
  filter(date>='2021-07-01') %>%
  select(state,
         date,
         `Inpatient_beds utilized` = inpatient_beds_utilization,
         `Inpatient_beds used for covid` = inpatient_bed_covid_utilization,
         `Adult ICU_beds utilized` = adult_icu_bed_utilization,
         `Adult ICU_beds used for covid` = adult_icu_bed_covid_utilization) %>%
  pivot_longer(cols=any_of(c("Inpatient_beds utilized", "Adult ICU_beds utilized")),
               names_to="measure",
               values_to = "utilization") %>%
  separate(measure,into= c("bed_type","measure"),sep ="_") %>%
  ggplot(aes(x=date,y=utilization,color=bed_type)) +
  geom_line() + 
  scale_y_continuous(labels = scales::percent) +
  scale_x_date(date_labels = "%b-%y",date_breaks = "1 month") +
  ylab('') + xlab('') +
  geofacet::facet_geo(~ state) +
  theme_ft_rc() + theme(legend.title = element_blank())

## US Daily Hospitalizations
#confirmed only
hospitalizations %>%
  filter(date >= '2020-06-01') %>%
  select(date,previous_day_admission_adult_covid_confirmed,previous_day_admission_pediatric_covid_confirmed)%>%
  group_by(date) %>%
  summarise(previous_day_addmissions = sum(previous_day_admission_adult_covid_confirmed + previous_day_admission_pediatric_covid_confirmed)) %>%
ggplot(aes(x=date,y=previous_day_addmissions))+
  geom_line() + 
  scale_y_continuous(labels = scales::comma) +
  scale_x_date(date_labels = "%b-%y",date_breaks = "2 month") +
  ylab('') + xlab('') +
  labs(title="Previous Days Hospitalizations",caption="Includes both adult and pediatric admissions. Data from COVID-19 Reported Patient Impact and Hospital Capacity by State Timeseries https://healthdata.gov/resource/g62h-syeh") +
  theme_ft_rc() 

