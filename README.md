# *** Exploratory Analysis of a Covid-19 Data Set ***

## Summary
Exploratory Analysis of a covid19 deaths data set from ourworldindata.org. It includes data on deaths, cases vaccinations per country, continent etc.

## File breakdown
The data can be found in the csvs and xlsx files in the main folder.
SQL script file included as Covid19_Analysis.sql
The raw SQL code used can be found in SQLCode.txt
Data extracts from the SQL server can be found in the "MySQL Exports" folder.
There is an accompanying word doc with a journal of notes that were kept throughout the project with links and screenshots of visualisations in Tableau.

## Tasks Done
Identified and filtered out unwanted or missing data using SQL.
  <br />
  <br />
Calculated Death Rate.
Showed the countries with highest death rates.
  <br />
  <br />
Worked out the % of the population that have tested positive for the virus.
  <br />
  <br />
Manually checked the total number of deaths in the world by filtering out non-countries and summing and grouping by country. Cross-checked this with the data for the region "World" in the data and found a suspected error in the data.
  <br />
  <br />
Used an inner join to investigate the effect of vaccinations on deaths.
  <br />
  <br />
Used both CTEs and Temp Tables to calculate the Cumulative Sum of Vaccinations and the cumulative % pop vaccinated<br />
<br />
### Case Study: Ireland																									
	- Cleaned missing data
	- Compared the total number of vaccinations vs the number of new deaths			
	- Calculated percentage of population vaccinated and the death rate to show the relationship. 
	- Identified a misleading characteristic in the data
	- Smoothed some data to avoid misleading stats
	- Exported the data into tableau and created a dashboard. (Link in the notes document in seciton 3.6)
	
## Screenshots
![alt text][Highest Death Rates Reached]
[Highest Death Rates Reached]: https://github.com/dilorourke/covid19/blob/main/Screenshots/Highest%20Death%20Rates%20(%25)%20Reached.png "Highest Death Rates Reached"

![alt text][Effects of Vaccinations on Deaths per day]
[Highest Death Rates Reached]: https://github.com/dilorourke/covid19/blob/main/Screenshots/Effect%20of%20Vaccines%20on%20DeathsDay.png "Effects of Vaccinations on Deaths per day"