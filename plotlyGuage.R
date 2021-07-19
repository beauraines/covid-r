library(plotly)


cases_per_100K_14d = sum(tail(data$new_cases,14))/subset(county_population, STNAME == 'Washington' & CTYNAME == "King County" ,select=POPESTIMATE2019)*100000


fig <- plot_ly(
  domain = list(x = c(0, 1), y = c(0, 1)),
  value = cases_per_100K_14d[,1],
  title = list(text = "Cases per 100k Population"),
  type = "indicator",
  mode = "gauge+number+delta",
  delta = list(reference=52),
  gauge = list(
    bar = list(
      color = "gray"
    ),
    axis = list(
      range = c(0,150),
      dtick = 10
    ),
    steps = list(
      # list(range = c(0,25),color = "lightgreen"),
      # list(range = c(25,75), color = "lightyellow"),
      # list(range = c(75,100), color = "orange"),
      # list(range = c(100,150), color = "red")
      list(range = c(0,25),color = "lightgreen"),
      list(range = c(25,75), color = "lightyellow"),
      list(range = c(75,600), color = "red")
    )
  )) 
fig <- fig %>%
  layout(margin = list(l=20,r=30))

fig



fig <- plot_ly(
  domain = list(x = c(0, 1), y = c(0, 1)),
  value = 450,
  title = list(text = "Speed"),
  type = "indicator",
  mode = "gauge+number+delta",
  delta = list(reference = 380),
  gauge = list(
    axis =list(range = list(NULL, 500)),
    steps = list(
      list(range = c(0, 250), color = "lightgray"),
      list(range = c(250, 400), color = "gray")),
    threshold = list(
      line = list(color = "red", width = 4),
      thickness = 0.75,
      value = 490))) 
fig <- fig %>%
  layout(margin = list(l=20,r=30))

fig
