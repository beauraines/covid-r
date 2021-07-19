library(choroplethr)

cases_week_over_week <- nytimes %>%
  filter( date >= Sys.Date() - 15 & date <= Sys.Date() - 8) %>%
  group_by(state, county, fips) %>%
  summarise(last_14_days_cases = sum(diff(cases)))


cases_week_over_week <- inner_join(cases_week_over_week,
                                   nytimes %>%
                                    filter( date >= Sys.Date() - 8, county != 'Unknown', !is.na(fips)) %>%
                                    group_by(state, county, fips) %>%
                                    summarise(last_7_days_cases = sum(diff(cases))),
                                   by = NULL
                        )


cases_week_over_week$new_case_growth = (cases_week_over_week$last_7_days_cases-cases_week_over_week$last_14_days_cases)/cases_week_over_week$last_14_days_cases

cases_week_over_week$state_fips = substr(cases_week_over_week$fips,1,nchar(cases_week_over_week$fips)-3)

## Requires region and value for plot
cases_week_over_week$value = cases_week_over_week$new_case_growth
cases_week_over_week$region = cases_week_over_week$fips

choroplethr::county_choropleth(cases_week_over_week,title="New Case Growth",state_zoom = 'washington')+ scale_fill_brewer(palette='RdYlGn',direction = -1)
choroplethr::county_choropleth(cases_week_over_week,title="New Case Growth")+ scale_fill_brewer(palette='RdYlGn',direction = -1)

state_cases_week_over_week <- cases_week_over_week %>%
                                group_by(state,state_fips) %>%
                                summarise(last_7_days_cases = sum(last_7_days_cases), last_14_days_cases = sum(last_14_days_cases))

state_cases_week_over_week$region = str_to_lower(state_cases_week_over_week$state)
state_cases_week_over_week$value = (state_cases_week_over_week$last_7_days_cases-state_cases_week_over_week$last_14_days_cases)/state_cases_week_over_week$last_14_days_cases

choroplethr::state_choropleth(state_cases_week_over_week,title="New Case Growth")+ scale_fill_brewer(palette='RdYlGn',direction = -1)
