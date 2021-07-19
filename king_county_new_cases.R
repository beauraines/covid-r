library(tidyverse)
library(ggplot2)
library(dplyr)
library(zoo)
library(lubridate)
library(plotly)
# Get Data
fips = read.csv("https://www2.census.gov/geo/docs/reference/codes/files/national_county.txt")
nytimes= read.csv("https://github.com/nytimes/covid-19-data/blob/master/us-counties.csv?raw=true")
county_population = read.csv("https://www2.census.gov/programs-surveys/popest/datasets/2010-2019/counties/totals/co-est2019-alldata.csv")


# Cleanse Data

nytimes$date  = ymd(nytimes$date)


# Subset the Data

king_county = subset(nytimes,state =='Washington' & county == "King")
washington = subset(nytimes,state =='Washington')


data <- data.frame(date = as.Date(tail(king_county$date,-1)), new_cases = diff(king_county$cases))
## missing very very first day
p <- ggplot(data, aes(x=date, y=new_cases)) +
  # geom_line() +
  geom_bar(stat = "identity") +
  xlab("")+ylab("New Cases")
p+scale_x_date(date_labels = "%b-%y",date_breaks = "2 month")
p

x<-zoo(data$new_cases)

rolling_average = data.frame(date = as.Date(tail(king_county$date,-14)), rolling_new_cases_14d = rollmean(x,14))

p2 = ggplot(data=rolling_average, aes(x=date,y=rolling_new_cases_14d,group=1))+geom_line()+xlab("")
p2 +ylab("14 Day Rolling Average New Cases")
p2 +scale_x_date(date_labels = "%b-%y",date_breaks = "2 month")

combined_plot = ggplot() +
  geom_bar(stat="identity",data=data, aes(x=date, y=new_cases),fill="#FF9999", colour="#FF9999") +
  geom_line(data=rolling_average, colour= "darkblue", aes(x=date,y=rolling_new_cases_14d,group=1)) +
  scale_x_date(date_labels = "%b-%y",date_breaks = "2 month") +
  xlab("") + ylab("Cases")
combined_plot

# Add annotation
#combined_plot +
#  annotate(geom="text",x =as.Date('2020-12-15'),subset(data,date=='2020-12-15')$new_cases,label="Christmas Day") +
#  annotate(geom="point",x =as.Date('2020-12-15'),subset(data,date=='2020-12-15')$new_cases, size=10, shape=21, fill="transparent")

## Add titles
combined_plot = combined_plot +
  labs(title="King County Covid-19 Cases",caption="Data sourced from NY Times GitHub")

cases_per_100K_14d = sum(tail(data$new_cases,14))/subset(county_population, STNAME == 'Washington' & CTYNAME == "King County" ,select=POPESTIMATE2019)*100000


## Write on plot
combined_plot = combined_plot + annotate(geom="text",x=as.Date(Sys.Date()-21),y=2000,label=paste("Cases per 100k pop:",round(cases_per_100K_14d,2),sep="\n"))

# In IPSUM Theme
combined_plot =combined_plot
combined_plot  + 
  theme_ipsum()

ggplotly(combined_plot)  %>%
  layout(
    xaxis = list(
      rangeslider = list(type = "date")
      )
  )
