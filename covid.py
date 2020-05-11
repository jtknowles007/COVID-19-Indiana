#! /usr/bin/env python3

import pandas as pd
import matplotlib.pyplot as plt
covid_state = pd.read_csv("~/DataRepo/covid-19-data/us-states.csv", parse_dates=['date'])
is_IN = covid_state['state'] == 'Indiana'
covid_IN = covid_state[is_IN]
covid_IN = covid_IN.drop(['state','fips'],1)
covid_IN = covid_IN.rename(columns = {"cases" : "IN_Cases", "deaths" : "IN_Deaths"})

covid_county = pd.read_csv("~/DataRepo/covid-19-data/us-counties.csv", parse_dates=['date'])
is_IN = covid_county['state'] == 'Indiana'
is_Mad = covid_county['county'] == 'Madison'
covid_Mad = covid_county[is_IN & is_Mad]
covid_Mad = covid_Mad.drop(['state','county','fips'],1)
covid_Mad = covid_Mad.rename(columns = {"cases" : "Mad_Cases", "deaths" : "Mad_Deaths"})


covid = covid_IN.join(covid_Mad.set_index('date'), on='date')
covid['Mad_Cases'] = covid['Mad_Cases'].fillna(0).astype(int)
covid['Mad_Deaths'] = covid['Mad_Deaths'].fillna(0).astype(int)

thedate = covid['date']
incases = covid['IN_Cases']
fig, ax = plt.subplots()
ax.plot(thedate,incases, color='blue')
ax.set_ylabel('Indiana Cases', color='blue', fontsize=14)

ax2 = ax.twinx()
ax2.plot(thedate,covid['Mad_Cases'], color='green')
ax2.set_ylabel('Madison County Cases', color='green', fontsize=14)
ax.set_title('Indiana COVID-19 Cases and Deaths')
plt.xticks(rotation=45, horizontalalignment='right')
plt.show()


