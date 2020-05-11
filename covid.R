library(dplyr)
library(ggplot2)

# Pull data from csv files
covid.all <- read.csv("~/DataRepo/covid-19-data/us-states.csv", stringsAsFactors = FALSE)
covid.county <- read.csv("~/DataRepo/covid-19-data/us-counties.csv", stringsAsFactors = FALSE)

# Clean state data
covid.in <-filter(covid.all,state == 'Indiana') %>%
  mutate(date = as.Date(date)) %>%
  rename(IN.Cases = cases, IN.Deaths = deaths) %>%
  select(date,IN.Cases,IN.Deaths)

# Clean county data
covid.madison <-filter(covid.county, county == 'Madison', state == 'Indiana') %>%
  mutate(date = as.Date(date)) %>%
  rename(Mad.Cases = cases, Mad.Deaths = deaths) %>%
  select(date,Mad.Cases,Mad.Deaths)

# Merge state and county data; replace NA with 0
covid <- full_join(covid.in,covid.madison, by="date") %>%
  replace(is.na(.),1)

# Plot State Cases and Deaths
ggplot(covid, aes(x=date)) +
  geom_line(aes(y=IN.Cases, color="Cases"), size=1, alpha=0.9, linetype=1) +
  geom_line(aes(y=IN.Deaths,color="Deaths"), size=1, alpha=0.9, linetype=1) +
  scale_color_manual(name='', values=c('Cases' = 'blue', 'Deaths' = 'red')) +
  scale_x_date(date_breaks = "weeks", date_labels = "%b %d") +
  ggtitle("Indiana COVID-19 Cases and Deaths") +
  xlab("Date") +
  ylab("Count")

# Plot County Cases and Deaths
ggplot(covid, aes(x=date)) +
  geom_line(aes(y=Mad.Cases, color="Cases"), size=1, alpha=0.9, linetype=1) +
  geom_line(aes(y=Mad.Deaths, color="Deaths"), size=1, alpha=0.9, linetype=1) +
  scale_color_manual(name='', values=c('Cases' = 'blue', 'Deaths' = 'red')) +
  scale_x_date(date_breaks = "weeks", date_labels = "%b %d") +
  ggtitle("Madison County COVID-19 Cases and Deaths") +
  xlab("Date") +
  ylab("Count")

ggplot(covid, aes(x=date)) +
  geom_line(aes(y=IN.Cases, color="State"), size=1, alpha=0.9, linetype=1) +
  geom_line(aes(y=Mad.Cases, color="County"), size=1, alpha=0.9, linetype=1) +
  scale_color_manual(name='', values=c('State' = 'blue', 'County' = 'green')) +
  scale_x_date(date_breaks = "weeks", date_labels = "%b %d") +
  ggtitle("State vs County Cases") +
  xlab("Date") +
  ylab("Count")

ggplot(covid, aes(x=date)) +
  geom_line(aes(y=IN.Deaths, color="State"), size=1, alpha=0.9, linetype=1) +
  geom_line(aes(y=Mad.Deaths, color="County"), size=1, alpha=0.9, linetype=1) +
  scale_color_manual(name='', values=c('State' = 'blue', 'County' = 'green')) +
  scale_x_date(date_breaks = "weeks", date_labels = "%b %d") +
  ggtitle("State vs County Deaths") +
  xlab("Date") +
  ylab("Count")