# Cumulative Deaths and Cases


max_date = max(as.Date(nytimes$date))

cumulative_state <- nytimes %>%
  filter(date == max_date) %>%
  # filter(state == 'Washington') %>%
  group_by(state) %>%
  summarise(cumulative_cases = sum(cases),cumulative_deaths = sum(deaths))

wa_cases = filter(cumulative_state, state == 'Washington')$cumulative_cases
wa_deaths = filter(cumulative_state, state == 'Washington')$cumulative_deaths

df <- data.frame(
  x = c(1,8.5),
  y = 2,
  h = 4.25,
  w = 6.25,
  value = c(wa_cases,wa_deaths),
  info = c("cumulative cases","cumulative deaths"),
  icon = c(emoji("nauseated_face"),emoji("coffin")),
  font_family = c("EmojiOne",
                  "EmojiOne"),
  color = factor(1:2)
)

wa_kpi <- ggplot(df, aes(x, y, height = h, width = w, label = info)) +
  ## Create the tiles using the `color` column
  geom_tile(aes(fill = color)) +
  ## Add the numeric values as text in `value` column
  geom_text(color = "white", fontface = "bold", size = 10,
            aes(label = value, x = x - 2.9, y = y + 1), hjust = 0) +
  ## Add the labels for each box stored in the `info` column
  geom_text(color = "white", fontface = "bold",
            aes(label = info, x = x - 2.9, y = y - 1), hjust = 0) +
  coord_fixed() +
  scale_fill_brewer(type = "qual",palette = "Dark2") +
  ## Use `geom_text()` to add the icons by specifying the unicode symbol.
  geom_text(size = 20, aes(label = icon, family = font_family,
                           x = x + 1.5, y = y + 0.5), alpha = 0.25) +
  theme_void() +
  guides(fill = "none")

us_cases = sum(cumulative_state$cumulative_cases,na.rm = TRUE)
us_deaths = sum(cumulative_state$cumulative_deaths,na.rm=TRUE)

df <- data.frame(
  x = c(1,8.5),
  y = 2,
  h = 4.25,
  w = 6.25,
  value = c(us_cases,us_deaths),
  info = c("cumulative cases","cumulative deaths"),
  icon = c(emoji("nauseated_face"),emoji("coffin")),
  font_family = c("EmojiOne",
                  "EmojiOne"),
  color = factor(1:2)
)

us_kpi <- ggplot(df, aes(x, y, height = h, width = w, label = info)) +
  ## Create the tiles using the `color` column
  geom_tile(aes(fill = color)) +
  ## Add the numeric values as text in `value` column
  geom_text(color = "white", fontface = "bold", size = 10,
            aes(label = value, x = x - 2.9, y = y + 1), hjust = 0) +
  ## Add the labels for each box stored in the `info` column
  geom_text(color = "white", fontface = "bold",
            aes(label = info, x = x - 2.9, y = y - 1), hjust = 0) +
  coord_fixed() +
  scale_fill_brewer(type = "qual",palette = "Dark2") +
  ## Use `geom_text()` to add the icons by specifying the unicode symbol.
  geom_text(size = 20, aes(label = icon, family = font_family,
                           x = x + 1.5, y = y + 0.5), alpha = 0.25) +
  theme_void() +
  guides(fill = "none")
