
library(tidyverse)
library(rvest)

url <- "https://ballotpedia.org/List_of_governors_of_the_American_states"
df <- url %>%
read_html() %>%
html_elements("table") %>%
html_table(fill = T)
governors <- df[1][[1]] %>%
  mutate(Office = str_remove(Office,"Governor of "),State = str_remove(Office,"the ")) %>%
  select(State, Name, Party) %>%
  tibble()
governors


## Party can be used as a factor on the State plots
governors$Party %>% unique()


governors %>%
  mutate(region=str_to_lower(State),value=Party) %>%
  filter(!region %in% c("american samoa", "guam", "puerto rico", "northern mariana islands", "u.s. virgin islands")) %>%
  choroplethr::state_choropleth(title="State Party") +
  scale_fill_brewer(palette=9)

