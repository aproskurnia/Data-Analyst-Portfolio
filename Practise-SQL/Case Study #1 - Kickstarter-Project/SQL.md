#### Top 3 countries with the largest number of financially successful projects (calculating the percentage)

```SQL
SELECT 
  country,
  ROUND((COUNT(CASE WHEN state = 'successful' THEN 1 END)/ (SELECT COUNT(DISTINCT ID) FROM `tests-413723.ks.ks-projects-201801` AS k))*100,2) AS projects_perc
FROM `tests-413723.ks.ks-projects-201801` AS k
GROUP BY country
ORDER BY projects_perc DESC
LIMIT 3;
```

Output:
| Row| country| projects_perc|
| --- | --- | --- |
|1| US| 28.86|
|2| GB| 3.19|
|3|	CA| 1.09|

#### Which 5 countries have the highest percentage of project success?

```SQL
SELECT 
  country,
  ROUND((COUNT(CASE WHEN state = 'successful' THEN 1 END)/ COUNT(DISTINCT ID))*100,2) AS projects_perc
FROM `tests-413723.ks.ks-projects-201801` AS k
GROUP BY country
ORDER BY projects_perc DESC
LIMIT 5;
```

Output:
| Row| country| projects_perc|
| --- | --- | --- |
|1|	US| 37.35|
|2|	GB| 35.84|
|3|	HK| 34.95|
|4|	DK| 32.35|
|5| SG| 32.07|

#### Which 7 categories have the highest percentage of project failures? There should be at least 1000 projects in the category.

```SQL
SELECT
  category,
  main_category,
  ROUND((COUNT(CASE WHEN state = 'failed' THEN 1 END) / COUNT(DISTINCT ID))*100,2) AS failed_proj_perc
FROM `tests-413723.ks.ks-projects-201801` AS k
GROUP BY category, main_category
HAVING COUNT(DISTINCT ID) >= 1000
ORDER BY failed_proj_perc DESC
LIMIT 7;
```

Output:
| Row| category| main_category| failed_proj_perc|
| --- | --- | --- | --- |
|1| Food Trucks| Food| 77.45|
|2| Apps| Technology| 77.37|
|3|	Web| Technology| 76.27|
|4| Restaurants| Food| 73.15|
|5|	Hip-Hop| Music| 73.03|
|6|	Software| Technology| 72.24|
|7| Mobile Games| Games| 72.11|

#### The authors of which projects had the greatest lack of confidence in their abilities (that is, they underestimated their ability to collect)? We consider only projects where the goal was at least $1,000

```SQL
SELECT
  name,
  usd_pledged_real,
  usd_goal_real,
  usd_pledged_real/usd_goal_real AS conversion
FROM `tests-413723.ks.ks-projects-201801` AS k
WHERE usd_goal_real < usd_pledged_real
AND usd_goal_real >= 1000
ORDER BY conversion DESC
LIMIT 3;
```

Output:
| Row| name| usd_pledged_real| usd_goal_real| conversion|
| --- | --- | --- | --- | --- |
|1|	Exploding Kittens| 8782571.99| 10000.0| 878.257199|
|2|	The World's Best TRAVEL JACKET with 15 Features || BAUBAX| 9192055.66| 20000.0| 459.602783|
|3| Fidget Cube: A Vinyl Desk Toy| 6465690.3| 15000.0| 431.04602|

#### How long does a campaign last on average depending on the status?

```SQL
SELECT
  state,
  ROUND(AVG(DATE_DIFF(CAST(deadline AS DATE), CAST(launched AS DATE), DAY)),0) AS time_diff
FROM `tests-413723.ks.ks-projects-201801` AS k
GROUP BY state
ORDER BY time_diff ASC;
```

Output:
|Row | state| time_diff|
| --- | --- | --- |
|1|	successful| 32.0|
|2|	undefined| 33.0|
|3|	failed| 35.0|
|4|	canceled| 38.0|
|5| live| 40.0|
|6|	suspended| 44.0|

#### If there is a correlation between goal and pledged?

```SQL
SELECT
  CORR(usd_goal_real, usd_pledged_real) AS correlation_coefficient
FROM `tests-413723.ks.ks-projects-201801` AS k;
```

Output:
|Row |correlation_coefficient|
| --- | --- |
|1|	0.00559611166594|

#### Interesting facts that we could use for an article in Australian Forbes about local projects on Kickstarter
1.TOP3 Succesfull Projects with the highest pledged

```SQL
SELECT
  name,
  usd_goal_real,
  usd_pledged_real
FROM `tests-413723.ks.ks-projects-201801` AS k
WHERE country = 'AU' 
AND state = 'successful'
ORDER BY usd_pledged_real DESC
LIMIT 3;
```

Output:
|Row | name| usd_goal_real| usd_pledged_real|
| --- | --- | --- | --- |
|1| FaceCradle Travel Pillow - Upgrade to Sleeping Class!| 15160.7| 1121309.26|
|2|	SCORKL - Breathe underwater with TOTAL freedom| 23279.27| 1004646.54|
|3|	"Oi" - The bike bell that doesn't look like a bike bell| 15360.98| 828444.27|

2.Total pledged of all succesfull projects

```SQL
SELECT
  SUM(usd_pledged_real) AS total_pledged
FROM `tests-413723.ks.ks-projects-201801` AS k
WHERE country = 'AU'
AND state = 'successful';
```

Output:
|Row | total_pledged|
| --- | --- |
|1| 37703715.9700000|

3.Top3 most popular categories with the highest number of succesfull projects

```SQL
SELECT
  category,
  main_category,
  COUNT(ID) AS num_projects
FROM `tests-413723.ks.ks-projects-201801` AS k
WHERE country = 'AU'
AND state = 'successful'
GROUP BY category, main_category
ORDER BY num_projects DESC
LIMIT 3;
```

Output:
|Row | category| main_category| num_projects|
| --- | --- | --- | --- |
|1|	Product Design| Design| 252|
|2|	Tabletop Games| Games| 135| 
|3|	Video Games| Games| 75|

4.Percent of projects by state

```SQL
SELECT
  state,
  ROUND(COUNT(DISTINCT ID)*100/(SELECT COUNT(DISTINCT ID) FROM `tests-413723.ks.ks-projects-201801` AS k WHERE country = 'AU'),2) AS Perc_of_proj
FROM `tests-413723.ks.ks-projects-201801` AS k
WHERE country = 'AU'
GROUP BY state
ORDER BY Perc_of_proj DESC;
```

Output:
|Row|	state| Perc_of_proj|
| --- | --- | --- |
|1|	failed| 58.76|
|2|	successful| 25.64|
|3|	canceled| 13.59|
|4|	suspended| 1.12|
|5|	live| 0.89|

5.Percents of projects by main_category

```SQL
SELECT 
  main_category,
  ROUND(COUNT(DISTINCT ID)*100/(SELECT COUNT(DISTINCT ID) FROM `tests-413723.ks.ks-projects-201801` AS k WHERE country = 'AU'), 2) AS Perc_of_projects
FROM `tests-413723.ks.ks-projects-201801` AS k
WHERE country = 'AU'
GROUP BY main_category
ORDER BY Perc_of_projects DESC;
```

Output:
|Row| main_category| Perc_of_projects|
| --- | --- | --- |
|1| Technology| 15.5|
|2| Games| 12.26|
|3| Film & Video| 11.99|
|4| Design| 11.85|
|5| Publishing| 10.63|
|6| Fashion| 9.15|
