



#Remove unknown county
state <- subset(washington,county != 'Unknown')
nytimes <- tibble(nytimes) %>% filter(!is.na(fips), county != 'Unknown')

outlist = list()
for (s in unique(nytimes$state)) 
{
  state <- subset(nytimes,state == s)
  print(str_c("State:",s))
  for (c in unique(state$county)) {
    county_info <-subset(state,county == c & county != 'Unknown')
    county_fips = unique(county_info$fips)
    fooSTATE = as.numeric(substr(county_fips, 1, 2))
    fooCOUNTY = as.numeric(substr(county_fips, nchar(county_fips)-3+1, nchar(county_fips)))
    population = coalesce(subset(county_population,STATE == fooSTATE & COUNTY == fooCOUNTY,select=c('POPESTIMATE2019'),na=0)$POPESTIMATE2019,0)
    first_case_reported <- min(county_info$date)
    new_cases =data.frame(date = tail(county_info$date,-1), new_cases = diff(county_info$cases))
    last_14d_cases <- sum(subset(new_cases,date >= Sys.Date()-14)$new_cases)
    last_7d_cases <- sum(subset(new_cases,date >= Sys.Date()-7)$new_cases)
    out <- tibble(state = unique(county_info$state),
                      county = unique(county_info$county),
                      county_fips = county_fips,
                      region = unique(county_info$fips),
                      first_case_reported = first_case_reported,
                      last_14d_cases = last_14d_cases,
                      last_7d_cases = last_7d_cases ,
                      population = population,
                      last_14d_cases_per_100k = coalesce(last_14d_cases / population *100000,0) ,
                      last_7d_cases_per_100k = coalesce(last_7d_cases / population *100000,0)
                  )
    outlist[[unique(county_info$fips)]] <- out
  }
}


metrics = do.call(rbind,outlist)


library(choroplethr)
metrics$value = metrics$last_7d_cases_per_100k
choroplethr::county_choropleth(metrics,title="Last 7 Days Cases per 100k population",num_colors = 4)+ scale_fill_brewer(palette=7)
