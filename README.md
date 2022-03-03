# covid19
--- Summary --- <br />
Exploratory Analysis of a covid19 deaths data set from ourworldindata.org. It includes data on deaths, cases vaccinations per country, continent etc.

---  File breakdown  --- <br />
The data can be found in the csvs and xlsx files in the main folder.
Data extracts from the SQL server can be found in the "MySQL Exports" folder.
The raw SQL code used can be found in SQLCode.txt
There is an accompanying word doc with a journal of notes that were kept throughout the project with links and screenshots of visualisations in Tableau.

---  Tasks Done  --- <br />
Identified and filtered out unwanted or missing data using SQL.
<br />
Calculated Death Rate.
Showed the countries with highest death rates.
<br />
Worked out the % of the population that have tested positive for the virus.
<br />
Manually checked the total number of deaths in the world by filtering out non-countries and summing and grouping by country. Cross-checked this with the data for the region "World" in the data and found a suspected error in the data.
<br />
Used an inner join to investigate the effect of vaccinations on deaths.
<br />
Case Study: Ireland																														
	- Cleaned missing data <br />
	- Compared the total number of vaccinations vs the number of new deaths	<br />				
	- Calculated percentage of population vaccinated and the death rate to show the relationship. <br />
	- Identified a misleading characteristic in the data <br />
	- Smoothed some data to avoid misleading stats <br />
	- Exported the data into tableau and created a dashboard. (Link in the notes document in seciton 3.6) <br />
	<br />
Used both CTEs and Temp Tables to calculate the Cumulative Sum of Vaccinations and the cumulative % pop vaccinated