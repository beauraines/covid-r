

library(tidyverse)

last_14_day_cases <- nytimes %>%
filter( date >= Sys.Date() - 15) %>%
group_by(state, county, fips) %>%
summarise(last_14_days_cases = sum(diff(cases)))
last_14_day_cases = left_join(last_14_day_cases,county_population,by=c("state"="STNAME","county"= "CTYNAME"))
last_14_day_cases = subset(last_14_day_cases, select = c("state","county","fips","last_14_days_cases","POPESTIMATE2019", "cases_per_100K_14d"))
last_14_day_cases$cases_per_100K_14d = last_14_day_cases$last_14_days_cases / last_14_day_cases$POPESTIMATE2019 * 100000

library("choroplethr")

last_14_day_cases$value = last_14_day_cases$cases_per_100K_14d

county_choropleth(last_14_day_cases)


