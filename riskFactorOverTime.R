# King County Historical Risk Factor

risk_data <- tibble(date = data$date,
              new_cases = data$new_cases,
              last_14_day_cases = NULL,
              last_14_day_cases_per_100k_pop = NULL
         )

for (i in 1:nrow(risk_data)) {
  startdate = risk_data[i,'date']$date
  enddate = risk_data[i,'date']$date -14
  risk_data$last_14_day_cases[i] <- risk_data %>%
                                subset(date <= startdate & date >= enddate) %>%
                                select(new_cases) %>% 
                                sum(na.rm=TRUE)
  risk_data$last_14_day_cases_per_100k_pop[i] <- risk_data$last_14_day_cases[i] / 2252782 * 100000
  if(risk_data$last_14_day_cases_per_100k_pop[i] >= 75) {
    risk_data$risk[i] = "High"
  } else if (cases_per_100K_14d >= 25 ){
    risk_data$risk[i] = "Moderate"
  } else {
    risk_data$risk[i] = "Low"
  }
}

# for (i in 1:nrow(risk_data)) {
#   risk_data$last_14_day_cases_per_100k_pop[i] <- risk_data$last_14_day_cases[i] / 2252782 * 100000
#   if(risk_data$last_14_day_cases_per_100k_pop[i] >= 75) {
#     risk_data$risk[i] = "High"
#   } else if (cases_per_100K_14d >= 25 ){
#     risk_data$risk[i] = "Moderate"
#   } else {
#     risk_data$risk[i] = "Low"
#   }
# }

ggplot(data = risk_data, mapping=aes(x=date,y=last_14_day_cases_per_100k_pop)) +
  geom_area(fill="lightgray",aes()) +
  geom_hline(yintercept=25,linetype="dashed",color="yellow")+
  geom_hline(yintercept=75,linetype="dashed",color="red") +
  labs(title="King County 14 Day Risk per 100k population",
       subtitle="Using Washington state risk factors: Less than 25, low, 25 - 75 medium, greater than 75, high. Effective June 30, 2021, Washington state lifted their mask mandate and switched to the CDC Risk factors.",
       caption="") +
  xlab("") +
  ylab("Cases per 100k population in last 14 days") +
  scale_x_date(date_labels = "%b-%y",date_breaks = "2 month")
  
