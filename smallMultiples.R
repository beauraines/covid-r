library(hrbrthemes)

#Remove unknown county
washington <- subset(washington,county != 'Unknown')
nytimes <- subset(nytimes,county != 'Unknown')

county_data = tibble()

for (c in unique(washington$county)) {
  print(c)
  county_info <-subset(washington,county == c & county != 'Unknown')
  county_fips = unique(county_info$fips)
  county_data <- bind_rows(county_data,tibble(state ='Washington',
                              county = c,
                              date = tail(county_info$date,-1),
                              new_cases = diff(county_info$cases),
                              new_deaths = diff(county_info$deaths) )
  )
}

county_data$date <- as.Date(county_data$date)

county_data %>% 
  # filter(date >='2021-01-01') %>%
  ggplot(aes(x=date,y=new_cases))+
  geom_line(group=1) +
  facet_wrap(~county,scales = "free") +
  labs(x="", y="",
       title="New Cases by county") + 
  theme_ipsum()
