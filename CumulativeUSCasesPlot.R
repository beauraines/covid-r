

nytimes %>%
  group_by(date) %>%
  summarise(cumulative_cases = sum(cases), cumulative_deaths = sum(deaths)) %>%
  ggplot(aes(x=as.Date(date),y=cumulative_cases)) +
    # geom_point(color="red") + 
    geom_line(color="red") + 
    theme_ipsum() +
    ylab("Cases") + xlab("") +
    scale_x_date(date_labels = "%b-%y",date_breaks = "2 month") +
    scale_y_continuous(labels = scales::label_number_si(),minor_breaks = scales::breaks_width(1000000),limits = c(0,NA)) +
    labs(title="Cumulative US Cases",caption="Data sourced from NY Times GitHub")

