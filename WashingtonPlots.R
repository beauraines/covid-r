

# https://stackoverflow.com/questions/29402528/append-data-frames-together-in-a-for-loop/29419402

first_case = NULL





outlist = list()

#Remove unknown county
washington <- subset(washington,county != 'Unknown')
nytimes <- subset(nytimes,county != 'Unknown')

foo = tibble()

for (c in unique(washington$county)) {
  print(c)
  county_info <-subset(washington,county == c & county != 'Unknown')
  county_fips = unique(county_info$fips)
  fooSTATE = as.numeric(substr(county_fips, 1, 2))
  fooCOUNTY = as.numeric(substr(county_fips, nchar(county_fips)-3+1, nchar(county_fips)))
  population = subset(county_population,STATE == fooSTATE & COUNTY == fooCOUNTY,select=c('POPESTIMATE2019'),na=0)$POPESTIMATE2019
  first_case_reported <- min(county_info$date)
  foo <- bind_rows(foo,tibble(state ='Washington',
                        county = c,
                        date = tail(county_info$date,-1),
                        new_cases = diff(county_info$cases),
                        new_deaths = diff(county_info$deaths) )
  )
  last_14d_cases <- sum(subset(new_cases,date >= Sys.Date()-14)$new_cases)
  last_7d_cases <- sum(subset(new_cases,date >= Sys.Date()-7)$new_cases)
  out <- data.frame(state = unique(county_info$state),
                    county = unique(county_info$county),
                    county_fips = county_fips,
                    region = unique(county_info$fips),
                    first_case_reported = first_case_reported,
                    last_14d_cases = last_14d_cases,
                    last_7d_cases = last_7d_cases,
                    population = coalesce(population,0),
                    last_14d_cases_per_100k = coalesce(last_14d_cases / population *100000,0) ,
                    last_7d_cases_per_100k = coalesce(last_7d_cases / population *100000,0))
  outlist[[unique(county_info$fips)]] <- out
}



metrics = do.call(rbind,outlist)

library(hrbrthemes)

foo$date <- as.Date(foo$date)
foo %>% 
  # filter(date >='2021-01-01') %>%
ggplot(aes(x=date,y=new_cases))+
  geom_line(group=1) +
  facet_wrap(~county,scales = "free") +
  labs(x="", y="",
       title="New Cases by county") + 
  theme_ipsum()


library(choroplethr)
metrics$value = metrics$last_7d_cases_per_100k
choroplethr::county_choropleth(metrics)               

choroplethr::county_choropleth(metrics,title="Last 7 Days Cases per 100k population",num_colors = 4,state_zoom = 'washington')+ scale_fill_brewer(palette=7)   




library(urbnmapr)

metrics <- left_join(metrics, counties, by = "county_fips") 


metrics %>%
  ggplot(aes(long, lat, group = group, fill = last_14d_cases)) +
  geom_polygon(color = NA) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  labs(fill = "Last 14 Days Cases")+
  scale_fill_gradient(low = "forestgreen", high = "red")

metrics %>%
  ggplot(aes(long, lat, group = group, fill = last_7d_cases)) +
  geom_polygon(color = NA) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  labs(fill = "Last 7 Days Cases")+
  scale_fill_gradient(low = "forestgreen", high = "red")

metrics %>%
  ggplot(aes(long, lat, group = group, fill = last_7d_cases_per_100k)) +
  geom_polygon(color = "white") +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  labs(fill = "Last 7 Days Cases per 100k Population") +
  scale_fill_gradient(low = "forestgreen", high = "red")



