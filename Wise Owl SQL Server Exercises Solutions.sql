--https://www.wiseowl.co.uk/sql/exercises/standard/

--SIMPLE QUERIES

/*Create a query to list out the following columns from the tblEvent table, with the most recent first
(for which you'll need to use an ORDER BY clause):
The event name
The event date*/
use WorldEvents
select EventName, EventDate from tblEvent order by EventDate desc

--Create a query to list out the id number and name of the last 3 categories from the tblCategory table in alphabetical order:
use WorldEvents
select top 3 CategoryID, CategoryName from tblCategory order by CategoryName desc

--Write a query to show the first 5 events (in date order) from the tblEvent table:
use WorldEvents
select top 5 EventName What, EventDetails Details from tblEvent order by EventDate

--Create a query which uses two separate SELECT statements to show the first and last 2 events in date order from the tblEvent table:
use WorldEvents
select top 2 EventName What, EventDate [When] from tblEvent order by EventDate
select top 2 EventName What, EventDate [When] from tblEvent order by EventDate desc

--SETTING CRITERIA USING WHERE

/*Write a query to list out all of the events from the tblEvent table in category number 11
(which corresponds to Love and Relationships, as it happens):*/
use WorldEvents
select EventName, EventDate from tblEvent where CategoryID=11

--Create a query which lists out all of the events which took place in February 2005:
use WorldEvents
select EventName What, EventDate [When] from tblEvent where YEAR(EventDate)=2005 and MONTH(EventDate)=2

--Create a query which lists out all of the tblEvent events which include the word Teletubbies:
use WorldEvents
select EventName, EventDate from tblEvent where EventName like 'Teletubbies%'

--Now add an OR condition to your query so that it lists out all events whose: Name includes Teletubbies or Name includes Pandy
use WorldEvents
select EventName, EventDate from tblEvent where EventName like 'Teletubbies%' or EventName like '%Pandy%'

/*First show a list of all events which might have something to do water. Wise Owl interpretation of this is one or more of the following is true:
They take place in one of the island countries (8, 22, 30 and 35, corresponding to Japan, the Marshall Islands, Cuba and Sri Lanka respectively)
Their EventDetails column contains the word Water (not the text Water, but the word)
Their category is number 4 (Natural World)
This should return 11 rows.
Now add a criterion to show only those events which happened since 1970*/
use WorldEvents
select EventName, EventDetails, EventDate from tblEvent where (CountryID in (8,22,30,35) or EventDetails like '% Water %' or CategoryID=4)

select EventName, EventDetails, EventDate from tblEvent where (CountryID in (8,22,30,35) or EventDetails like '% Water %' or CategoryID=4)
and YEAR(EventDate)>1970

--Events which aren't in the Transport category (number 14), but which nevertheless include the text Train in the EventDetails column.
use WorldEvents
select EventName, EventDetails, EventDate from tblEvent where CategoryID!=14 and EventDetails like '%Train%'

--Events which are in the Space country (number 13), but which don't mention Space in either the event name or the event details columns.
use WorldEvents
select EventName, EventDetails, EventDate from tblEvent where CountryID=13 and not(EventName like '%Space%' or EventDetails like '%Space%')

--Events which are in categories 5 or 6 (War/conflict and Death/disaster), but which don't mention either War or Death in the EventDetails column.
use WorldEvents
select EventName, EventDetails, EventDate from tblEvent where CategoryID in (5,6) and not(EventDetails like '%War%' or EventDetails like '%Death%')

--CALCULATIONS

--Create a query listing out each event with the length of its name, with the "shortest event" first:
use WorldEvents
select EventName, LEN(EventName) [Length of Name] from tblEvent order by [Length of Name]

/*Create a query to list out for each event the category number that it belongs to:
Apply a WHERE criteria to show only those events in country number 1 (Ukraine)*/
use WorldEvents
select EventName+' (category '+CAST(CategoryID as varchar)+')' [Event (category)], EventDate from tblEvent where CountryID=1

select CONCAT(EventName,' (category ',CAST(CategoryID as varchar),')') [Event (category)], EventDate from tblEvent where CountryID=1

/*The tblContinent table lists out the world's continents, but there are gaps:
You need to fill in the gaps!  Read on ...
Add up to 3 columns to show a message where a summary is missing:
Here's what your 3 columns should use:
Using ISNULL	Use the IsNull function to substitute the words No summary for rows where the Summary column is null.
Using COALESCE	Do the same thing, but using the COALESCE function instead.
Using CASE	Use a CASE WHEN statement to show different things according to whether the Summary column is null or not.*/
use WorldEvents
select ContinentName, Summary, ISNULL(Summary,'No Summary') 'Summary Using ISNULL', COALESCE(Summary,'No Summary') 'Summary Using COALESCE',
case when Summary is null then 'No Summary' else Summary end 'Summary Using CASE' from tblContinent

/*Write a query to divide countries into these groups:
Continent id	Belongs to	Actual continent (for interest)
1 or 3	Eurasia	Europe or Asia
5 or 6	Americas	North and South America
2 or 4	Somewhere hot	Africa and Australasia
7	Somewhere cold	Antarctica
Otherwise	Somewhere else	International
Your query (based only on the tblCountry table) should show the following results:*/
use WorldEvents
select CountryName, case when ContinentID in (1,3) then 'Eurasia' when ContinentID in (5,6) then 'Americas' when ContinentID in (2,4) then
'Somewhere hot' when ContinentID=7 then 'Somewhere cold' else 'Somewhere else' end CountryLocation from tblCountry order by CountryLocation desc

/*The aim of this exercise is to find this and that in the EventDetails column (in that order).
There are 3 rows containing both words, but these are the only 2 containing them in the right order.*/
use WorldEvents
select EventName, EventDate, CHARINDEX('this',EventDetails) thisPosition, CHARINDEX('that',EventDetails) thatPosition,
CHARINDEX('that',EventDetails) - CHARINDEX('this',EventDetails) Offset
from tblEvent where EventDetails like '%this%' and EventDetails like '%that%'
and CHARINDEX('that',EventDetails) - CHARINDEX('this',EventDetails) > 0

--Write a query to list out all of the non-boring events:
use WorldEvents
select EventName, case when LEFT(EventName,1) like '[aeiou]%' and RIGHT(EventName,1) like '[aeiou]%' then
'Begins and ends with vowel' when LEFT(EventName,1)=RIGHT(EventName,1) then 'Same Letter' end 'Verdict' from tblEvent where
(LEFT(EventName,1) like '[aeiou]%' and RIGHT(EventName,1) like '[aeiou]%') or (LEFT(EventName,1)=RIGHT(EventName,1))
order by EventDate
--OR
select EventName, case when LEFT(EventName,1) in ('a','e','i','o','u') and RIGHT(EventName,1) in ('a','e','i','o','u') then
'Begins and ends with vowel' when LEFT(EventName,1)=RIGHT(EventName,1) then 'Same Letter' end 'Verdict' from tblEvent where
(LEFT(EventName,1) in ('a','e','i','o','u') and RIGHT(EventName,1) in ('a','e','i','o','u')) or (LEFT(EventName,1)=RIGHT(EventName,1))
order by EventDate

--CALCULATIONS USING DATES

/*First create a query showing events which took place in your year of birth, neatly formatted.
Amend your query so that it shows the event date neatly formatted:
Once using the FORMAT function; and Once using the CONVERT function.*/
use WorldEvents
select EventName, EventDate NotFormatted, FORMAT(EventDate,'dd/MM/yyyy') UsingFormat, CONVERT(varchar,EventDate,103) UsingConvert
from tblEvent where YEAR(EventDate)=1980 order by EventDate

/*What was happening in the world around the time when you were born. First create a query to show the number of days
which have elapsed for any event since your birthday:
The ABS function returns the absolute value of a number (for example, ABS(42) and ABS(-42) both equal 42).
Use this to list the events in order of closeness to your birthday:*/
use WorldEvents
select EventName, EventDate, DATEDIFF(DAY,'1980-04-20',EventDate) DaysOffset, ABS(DATEDIFF(DAY,'1980-04-20',EventDate)) DaysDifference
from tblEvent order by DaysDifference

--Create a query to show the day of the week and also the day number on which each event occurred:
use WorldEvents
select EventName, EventDate, DATENAME(WEEKDAY,EventDate) 'Day of week', DATEPART(D,EventDate) 'Day number' from tblEvent
--OR
select EventName, EventDate, DATENAME(WEEKDAY,EventDate) 'Day of week', DAY(EventDate) 'Day number' from tblEvent

--Create a query to show the full dates for any event:
use WorldEvents
select EventName, CONCAT(DATENAME(WEEKDAY,EventDate),' ',DAY(EventDate),'th ',DATENAME(M,EventDate),' ',YEAR(EventDate)) 'Full date'
from tblEvent order by EventDate

--BASIC JOINS

/*Add columns and filters to your query so that it shows who wrote the "special" episodes (there should be 13 listed out,
of which the first few in alphabetical order are shown below):*/
use DoctorWho
select tblAuthor.AuthorName, Title, EpisodeType from tblEpisode inner join tblAuthor on tblEpisode.AuthorId=tblAuthor.AuthorId
where EpisodeType like '%special%' order by Title

--Choose to show the country name, event name and event date in ascending date order, giving aliases to each column.
use WorldEvents
select CountryName Country, EventName 'What happened', EventDate 'When happened' from tblCountry
inner join tblEvent on tblCountry.CountryID=tblEvent.CountryID order by EventDate

/*Create a join to list out all of the doctors who appeared in episodes made in 2010. When you run your query,
you should see that all but one of the 15 episodes made in this year starred Matt Smith:*/
use DoctorWho
select DoctorName, Title from tblDoctor inner join tblEpisode on tblDoctor.DoctorId=tblEpisode.DoctorId where YEAR(EpisodeDate)=2010

/*Your query should list out those events which took place in either:
the continent called Antarctic or the country called Russia*/
use WorldEvents
select EventName, EventDate, CountryName, ContinentName from tblEvent inner join tblCountry on tblEvent.CountryID=tblCountry.CountryID
inner join tblContinent on tblCountry.ContinentID=tblContinent.ContinentID where ContinentName='Antarctic' or CountryName='Russia'

/*Create a query which uses an inner join to link the categories table to the events table:
The first few of the 459 events in reverse date order. We weren't sure of the correct category for the first one.
Change the inner join to an outer join, so that you show for each category its events - even when there aren't any:
If you scroll down to the bottom of your query, you'll see you now have a couple of extra rows, making 461 in total.
Add a WHERE clause to show only those categories which don't have any corresponding events:*/
use WorldEvents
select EventName, EventDate, CategoryName from tblEvent
inner join tblCategory on tblEvent.CategoryID=tblCategory.CategoryID order by EventDate desc
select EventName, EventDate, CategoryName from tblEvent
right join tblCategory on tblEvent.CategoryID=tblCategory.CategoryID order by EventDate desc
select CategoryName from tblCategory left join tblEvent on tblCategory.CategoryID=tblEvent.CategoryID where EventName is null

--Write a query using inner joins to show all of the authors who have written episodes featuring the Daleks.
use DoctorWho
select AuthorName, Title, EpisodeType, EpisodeDate from tblAuthor
inner join tblEpisode on tblAuthor.AuthorId=tblEpisode.AuthorId inner join tblEpisodeEnemy on tblEpisode.EpisodeId=tblEpisodeEnemy.EpisodeId
inner join tblEnemy on tblEpisodeEnemy.EnemyId=tblEnemy.EnemyId where tblEnemy.EnemyName like '%Daleks%' order by EpisodeDate

/*Create a query to list out the appearances of enemies in episodes which have length under 40 characters, where the length is defined as the sum of:
the number of characters in the author's name; the number of characters in the episode's title;
the number of characters in the doctor's name; and the number of characters in the enemy's name.*/
use DoctorWho
select AuthorName, Title, DoctorName, EnemyName, LEN(AuthorName)+LEN(Title)+LEN(DoctorName)+LEN(EnemyName) 'Total length' from tblEpisode
inner join tblAuthor on tblEpisode.AuthorId=tblAuthor.AuthorId inner join tblDoctor on tblEpisode.DoctorId=tblDoctor.DoctorId
inner join tblEpisodeEnemy on tblEpisode.EpisodeId=tblEpisodeEnemy.EpisodeId inner join tblEnemy on tblEpisodeEnemy.EnemyId=tblEnemy.EnemyId
where LEN(AuthorName)+LEN(Title)+LEN(DoctorName)+LEN(EnemyName)<=40 order by 'Total length' desc

--Create a query using an outer join to list out those countries which have no corresponding events.
use WorldEvents
select CountryName, EventName from tblCountry left join tblEvent on tblCountry.CountryID=tblEvent.CountryID where EventName is null

--MORE EXOTIC JOINS

--List the names of the companions who haven't featured in any episodes.  You should find there's one of them
use DoctorWho
select CompanionName from tblCompanion left join tblEpisodeCompanion on tblCompanion.CompanionId=tblEpisodeCompanion.CompanionId
left join tblEpisode on tblEpisodeCompanion.EpisodeId=tblEpisode.EpisodeId where Title is null

/*Each row in this table contains a column called ParentFamilyId, which tells you which parent family any family belongs to
(the All categories family - number 25 - has no parent, and so sits at the top of the hierarchy).
Create a query which links 3 tables using outer joins as follows:
Table	Alias
tblFamily	Family
tblFamily	ParentFamily
tblFamily	TopFamily
Add calculated columns to your query so that it displays all 25 familes:*/
use WorldEvents
select TopFamily.FamilyName, ISNULL(Family.FamilyName+' -> ','')+ISNULL(ParentFamily.FamilyName+' -> ','')+TopFamily.FamilyName 'Family path'
from tblFamily Family right join tblFamily ParentFamily on Family.FamilyID=ParentFamily.ParentFamilyId
right join tblFamily TopFamily on ParentFamily.FamilyID=TopFamily.ParentFamilyId order by TopFamily.FamilyName

--AGGREGATIONS AND GROUPING

/*The following diagram shows how the authors and episodes tables are related:
Use this to show for each author:
the number of episodes they wrote;
their earliest episode date; and
their latest episode date.
If you sort these so that the most prolific authors come first, here are the first few of the 25 rows you should see:*/
use DoctorWho
select AuthorName, COUNT(Title) Episodes, MIN(EpisodeDate) 'Earliest date', MAX(EpisodeDate) 'Latest date' from tblAuthor
inner join tblEpisode on tblAuthor.AuthorId=tblEpisode.AuthorId group by AuthorName order by Episodes desc

--Create a query which groups by the category name from the category table; and counts the number of events for each.
use WorldEvents
select CategoryName, COUNT(EventName) 'Number of events' from tblCategory
inner join tblEvent on tblCategory.CategoryID=tblEvent.CategoryID group by CategoryName order by 'Number of events' desc

--Create a query to list out the following statistics from the table of events: You'll need to use the COUNT, MAX and MIN functions respectively.
use WorldEvents
select COUNT(EventDate) 'Number of events', MIN(EventDate) 'First date', MAX(EventDate) 'Last date' from tblEvent

/*Create a query listing out for each continent and country the number of events taking place therein:
Now change your query so that it omits events taking place in the continent of Europe:
Finally, change your query so that it only shows countries having 5 or more events:*/
use WorldEvents
select ContinentName, CountryName, COUNT(EventName) 'Number of events' from tblEvent inner join tblCountry on tblEvent.CountryID=tblCountry.CountryID
inner join tblContinent on tblCountry.ContinentID=tblContinent.ContinentID group by CountryName, ContinentName order by CountryName

select ContinentName, CountryName, COUNT(EventName) 'Number of events' from tblEvent
inner join tblCountry on tblEvent.CountryID=tblCountry.CountryID inner join tblContinent on tblCountry.ContinentID=tblContinent.ContinentID
where ContinentName<>'Europe' group by CountryName, ContinentName order by CountryName

select ContinentName, CountryName, COUNT(EventName) 'Number of events' from tblEvent
inner join tblCountry on tblEvent.CountryID=tblCountry.CountryID inner join tblContinent on tblCountry.ContinentID=tblContinent.ContinentID
where ContinentName<>'Europe' group by CountryName, ContinentName having COUNT(EventName)>=5 order by CountryName

/*Write a query to list out for each author and doctor the number of episodes made, but restrict your output to show only the author/doctor
combinations for which more than 5 episodes have been written*/
use DoctorWho
select AuthorName, DoctorName, COUNT(EpisodeId) Episodes from tblEpisode inner join tblAuthor on tblEpisode.AuthorId=tblAuthor.AuthorId
inner join tblDoctor on tblEpisode.DoctorId=tblDoctor.DoctorId group by AuthorName, DoctorName having COUNT(EpisodeId)>5 order by Episodes desc

/*Write a query to list out for each episode year and enemy the number of episodes made, but in addition:
Only show episodes made by doctors born before 1970; and Omit rows where an enemy appeared in only one episode in a particular year.*/
use DoctorWho
select YEAR(EpisodeDate) 'Episode year', EnemyName, COUNT(Title) 'Number of episodes' from tblEpisode
inner join tblEpisodeEnemy on tblEpisode.EpisodeId=tblEpisodeEnemy.EpisodeId inner join tblEnemy on tblEpisodeEnemy.EnemyId=tblEnemy.EnemyId
inner join tblDoctor on tblEpisode.DoctorId=tblDoctor.DoctorId where YEAR(BirthDate)<1970
group by EnemyName, YEAR(EpisodeDate) having COUNT(Title)>1 order by 'Number of episodes' desc, 'Episode year', EnemyName

/*Create a query which shows two statistics for each category initial: The number of events for categories beginning with this letter; and
The average length in characters of the event name for categories beginning with this letter.*/
use WorldEvents
select LEFT(CategoryName,1) 'Category initial', COUNT(EventName) 'Number of events', CAST(AVG(CAST(LEN(EventName) as decimal (4,2))) as decimal (4,2))
'Average event name length' from tblEvent inner join tblCategory on tblEvent.CategoryID=tblCategory.CategoryID group by LEFT(CategoryName,1)
--OR
select LEFT(CategoryName,1) 'Category initial', COUNT(EventName) 'Number of events', CONVERT(decimal(4,2),AVG(CONVERT(decimal(4,2),LEN(EventName))))
'Average event name length' from tblEvent inner join tblCategory on tblEvent.CategoryID=tblCategory.CategoryID group by LEFT(CategoryName,1)

--Create a query to show the following information: You'll need to calculate the century for each event date, and group by this.
use WorldEvents
select CAST(((YEAR(EventDate)/100)+1) as varchar)+'th Century' Century, COUNT(YEAR(EventDate)) 'Number of events'
from tblEvent group by cube(CAST(((YEAR(EventDate)/100)+1) as varchar)+'th Century')

--VIEWS

/*Include the tables tblAuthor, tblEpisode and tblDoctor, and use the view designer to create a view listing the episodes whose titles start with F,
with the following information: Tidy up the SQL so that it's easier to read, and change the criteria to show episodes starting with H.*/
use DoctorWho
go
create or alter view vw_EpisodesByFirstLetter as select AuthorName, DoctorName, Title, EpisodeDate from tblEpisode
left join tblAuthor on tblEpisode.AuthorId=tblAuthor.AuthorId left join tblDoctor on tblEpisode.DoctorId=tblDoctor.DoctorId where Title like 'h%'
go
select * from vw_EpisodesByFirstLetter

/*Write the script to generate a view called vwEverything (based on the tblCategory, tblEvent, tblCountry and tblContinent tables) to show this data:
Now write a query which selects data from this view to show the number of events by category within Africa:*/
use WorldEvents
go
create or alter view vw_Everything as
select CategoryName as Category, ContinentName as Continent, CountryName as Country, EventName, EventDate from tblEvent
left join tblCategory on tblEvent.CategoryID=tblCategory.CategoryID left join tblCountry on tblEvent.CountryID=tblCountry.CountryID
left join tblContinent on tblCountry.ContinentID=tblContinent.ContinentID
go
select * from vw_Everything
go--OR
create or alter view vw_EventsAfrica as select CategoryName as Category, count(EventName) as 'NumberEvents' from tblEvent
left join tblCategory on tblEvent.CategoryID=tblCategory.CategoryID left join tblCountry on tblEvent.CountryID=tblCountry.CountryID
left join tblContinent on tblCountry.ContinentID=tblContinent.ContinentID
group by CategoryName, ContinentName having ContinentName='Africa' order by NumberEvents desc offset 0 rows
go
select * from vw_EventsAfrica

/*Create a new query, and write script to create a new view. This should begin:
Finish your script so that it creates a view to show all of the episodes in series 1, then execute the script to create your view:*/
use DoctorWho
go
create or alter view vw_SeriesOne as select Title, SeriesNumber, EpisodeNumber from tblEpisode where SeriesNumber=1
go
select * from vw_SeriesOne

--Count the number of events by category (to add grouping in a view, right-click in the tables area at the top of view view and choose Add Group By)
use WorldEvents
go
create or alter view vw_EventsByCategory as select CategoryName as 'Category', count(EventName) as 'NumberEvents' from tblCategory
left join tblEvent on tblEvent.CategoryID=tblCategory.CategoryID group by CategoryName order by NumberEvents desc offset 0 rows
go
select * from vw_EventsByCategory
select * from vw_EventsByCategory where NumberEvents>50

/*Create a series of views which will ultimately list out all of the episodes which had both multiple enemies and multiple companions.
To achieve this, create (in this order) the following views:
vwEpisodeCompanion	List all of the episodes which had only a single companion.
vwEpisodeEnemy	List all of the episodes which had only a single enemy.
vwEpisodeSummary	List all of the episodes which have no corresponding rows in either the vwEpisodeCompanion or vwEpisodeEnemy tables.*/
use DoctorWho
go
create or alter view vw_EpisodeCompanion as select tblEpisode.EpisodeId, Title from tblEpisode
left join tblEpisodeCompanion on tblEpisode.EpisodeId=tblEpisodeCompanion.EpisodeId
group by tblEpisode.EpisodeId, tblEpisode.Title having count(tblEpisodeCompanion.CompanionID)=1
go
create or alter view vw_EpisodeEnemy as select tblEpisode.EpisodeId, Title from tblEpisode
left join tblEpisodeEnemy on tblEpisode.EpisodeId=tblEpisodeEnemy.EpisodeId
group by tblEpisode.EpisodeId, tblEpisode.Title having count(tblEpisodeEnemy.EnemyId)=1
go
create or alter view vw_EpisodeSummary as select tblEpisode.EpisodeId, tblEpisode.Title from tblEpisode
go
select * from vw_EpisodeSummary except select * from vw_EpisodeCompanion except select * from vw_EpisodeEnemy order by EpisodeId desc

--SUB-QUERIES

--Create a query which lists out all of the events in the tblEvent table which happened after the last one for country 21 (International) took place.
use WorldEvents
select EventName, EventDate, CountryName from tblEvent left join tblCountry on tblEvent.CountryID=tblCountry.CountryID
where EventDate>(select max(EventDate) from tblEvent where CountryID=21) order by EventDate

--Write a sub query to filter events to show only those which have an event name of longer than average length.
use WorldEvents
select EventName from tblEvent where len(EventName)>(select avg(len(EventName)) from tblEvent)

/*Write a SELECT statement to return events from the 3 continents with the fewest events.
To do this first write a SELECT query which returns all the continents and events.*/
use WorldEvents
select ContinentName, EventName from tblEvent left join tblCountry on tblEvent.CountryID=tblCountry.CountryID
left join tblContinent on tblCountry.ContinentID=tblContinent.ContinentID where ContinentName in
(select top 3 ContinentName from tblEvent left join tblCountry on tblEvent.CountryID=tblCountry.CountryID
left join tblContinent on tblCountry.ContinentID=tblContinent.ContinentID group by ContinentName order by COUNT(EventName))

--Write a query which lists out countries which have more than 8 events, using a correlated subquery rather than HAVING.
use WorldEvents
select CountryName from tblCountry left join tblEvent on tblCountry.CountryID = tblEvent.CountryID group by CountryName having count(tblEvent.EventID)>8

/*Create a subquery to list out all of those events whose:
Country id is not in the list of the last 30 country ids in alphabetical order; and
Category id is not in the list of the last 15 category ids in alphabetical order.*/
use WorldEvents
select EventName, EventDetails from tblEvent where CountryID not in (select top 30 CountryID from tblCountry order by CountryName desc) and
CategoryID not in (select top 15 CategoryID from tblCategory order by CategoryName desc)

--STORED PROCEDURES

--Create a stored procedure called usp_CountriesAsia to list out all the countries with ContinentId equal to 1, in alphabetical order:
use WorldEvents
go
create or alter procedure usp_CountriesAsia as select CountryName from tblCountry where ContinentID=1 order by CountryName
go
exec usp_CountriesAsia

/*Write a SELECT statement in SQL to list out all of the episodes which featured Matt Smith as the Doctor then store it as a stored procedure:
Change script so that it alters the stored procedure to list out only those episodes featuring Matt Smith made in 2012:*/
use DoctorWho
go
create or alter procedure usp_MattSmith as select SeriesNumber Series, EpisodeNumber Episode, Title, EpisodeDate 'Date of episode', DoctorName Docter
from tblEpisode inner join tblDoctor on tblEpisode.DoctorId=tblDoctor.DoctorId where DoctorName='Matt Smith'
go
exec usp_MattSmith
go
create or alter procedure usp_MattSmith as select SeriesNumber Series, EpisodeNumber Episode, Title, EpisodeDate 'Date of episode', DoctorName Docter
from tblEpisode inner join tblDoctor on tblEpisode.DoctorId=tblDoctor.DoctorId where DoctorName='Matt Smith' and year(EpisodeDate)=2012
go
exec usp_MattSmith

--The aim of this exercise is to create a stored procedure called usp_AugustEvents which will show all events that occurred in the month of August:
use WorldEvents
go
create or alter procedure usp_AugustEvents as select EventID, EventName, EventDetails, EventDate from tblEvent where month(EventDate)=8
go
exec usp_AugustEvents

/*Using the tblAuthor and tblEpisode tables, create a stored procedure called usp_Moffats to list out the 32 episodes written by Steven Moffat
in date order (with the most recent first):
Now amend your SQL so that it creates a different stored procedure called usp_Russell, listing out the 30 episodes penned by people called Russell:*/
use DoctorWho
go
create or alter procedure usp_Moffats as
select Title from tblEpisode inner join tblAuthor on tblEpisode.AuthorId=tblAuthor.AuthorId where AuthorName='Steven Moffat' order by EpisodeDate desc
go
exec usp_Moffats
go
create or alter procedure usp_Russell as select top 30 Title from tblEpisode inner join tblAuthor on tblEpisode.AuthorId=tblAuthor.AuthorId
where AuthorName like '%Russell%' order by EpisodeDate desc
go
exec usp_Russell

--Create a procedure called usp_SummariseEpisodes to show: 3 most frequently-appearing companions; then separately 3 most frequently-appearing enemies.
use DoctorWho
go
create or alter procedure usp_SummariseEpisodes as
select top 3 CompanionName, count(Title) Episodes from tblEpisode inner join tblEpisodeCompanion on tblEpisode.EpisodeId=tblEpisodeCompanion.CompanionId
inner join tblCompanion on tblEpisodeCompanion.CompanionId=tblCompanion.CompanionId group by CompanionName order by Episodes desc
select top 3 EnemyName, count(Title) Episodes from tblEpisode inner join tblEpisodeEnemy on tblEpisode.EpisodeId=tblEpisodeEnemy.EpisodeId
inner join tblEnemy on tblEpisodeEnemy.EnemyId=tblEnemy.EnemyId group by EnemyName order by Episodes desc
go
exec usp_SummariseEpisodes

--VARIABLES

/*The aim of this exercise is to use variables to present some information about yourself as a little sentence:
Start by declaring the variables you will need:
To hold	Use
Your name	varchar(N)
Your birth date	datetime
Your pet count	int
Finally concatenate your variables with appropriate text to SELECT the sentence shown at the start of this exercise*/
declare @Name varchar(50) = 'Rajat', @DOB datetime = '1980-04-20', @Pet_Count int = 2
select concat('My name is ',@Name,', I was born on ',FORMAT(@DOB,'dd/MM/yyyy'),' and I have ',@Pet_Count,' pets.') 'Fun Facts'
go--OR
declare @Name varchar(50), @DOB datetime, @Pet_Count int
set @Name = 'Rajat'
set @DOB = '1980-04-20'
set @Pet_Count = 2
select concat('My name is ',@Name,', I was born on ',CONVERT(varchar,@DOB,103),' and I have ',@Pet_Count,' pets.') 'Fun Facts'
go--OR
declare @Name varchar(50), @DOB datetime, @Pet_Count int
select @Name='Rajat', @DOB='1980-04-20', @Pet_Count=2
select concat('My name is ',@Name,', I was born on ',FORMAT(@DOB,'dd/MM/yyyy'),' and I have ',@Pet_Count,' pets.') 'Fun Facts'

/*The aim of this exercise is to summarise events using the MIN, MAX and COUNT functions: You're not allowed to use GROUP BY!
To do this, create variables to hold each of the aggregates:
Variable	What it will hold eventually
@EarliestDate	The earliest date
@LatestDate	The latest date
@NumberOfEvents	The number of events
@EventInfo	The title Summary of events
Now use a single SELECT clause to set the value for all of these variables
Write another SELECT clause to show the value of the variables, to show the summary output shown above.*/
use WorldEvents
declare @EarliestDate date, @LatestDate date, @NumberOfEvents int, @EventInfo varchar(20)
select @EventInfo='Summary of Events', @EarliestDate=min(EventDate), @LatestDate=max(EventDate), @NumberOfEvents=count(EventDate) from tblEvent
select @EventInfo Title,CONVERT(varchar,@EarliestDate,103)'Earliest Date',CONVERT(varchar,@LatestDate,103)'Latest Date',@NumberOfEvents'Number of Events'

/*Create a stored procedure called usp_CalculateAge which:
Declares an integer variable called @Age, Sets the value of this variable to be the difference in years between your date of birth and today's date
Prints out your age, the final result of running the stored procedure should look like this:*/
use DoctorWho
go
create or alter procedure usp_CalculateAge as
declare @Age date
set @Age = '1980-04-20'
print concat('You are ',datediff(year,@Age,getdate()),' years old!')
go
exec usp_CalculateAge

/*Start a query, creating a variable to hold the id number of the Doctor Who episode whose details you want to show:
The aim of this exercise is to get to the point where you can run this command:
Here's what this should show for episode id 54, for example:
First, create a variable called @EpisodeName and set this to hold the title of the episode with id number equal to the value of variable @EpisodeId.
Now create two variables and set their values as follows:
Variable name	Value
@NumberCompanions	The number of companions for this episode (ie the count of the number of rows in table tblEpisodeCompanion where the episode id equals the one contained in the variable @EpisodeId).
@NumberEnemies	The number of enemies for this episode (this time counting the number of rows for this episode in table tblEpisodeEnemy).
Complete and run your query to check that it gives this output if you change the episode id to 42:*/
use DoctorWho
declare @EpisodeId int = 42, @EpisodeName varchar(100), @NumberCompanions int, @NumberEnemies int
select @EpisodeName=Title from tblEpisode where EpisodeId=@EpisodeId
select @NumberCompanions=count(CompanionID) from tblEpisodeCompanion inner join tblEpisode on tblEpisodeCompanion.EpisodeId=tblEpisode.EpisodeId
group by tblEpisodeCompanion.EpisodeId having tblEpisodeCompanion.EpisodeId=@EpisodeId
select @NumberEnemies=count(EnemyID) from tblEpisodeEnemy inner join tblEpisode on tblEpisodeEnemy.EpisodeId=tblEpisode.EpisodeId
group by tblEpisodeEnemy.EpisodeId having tblEpisodeEnemy.EpisodeId=@EpisodeId
select @EpisodeName 'Title', @EpisodeId 'EpisodeID', @NumberCompanions 'Number of companions', @NumberEnemies 'Number of enemies'

/*The aim of this exercise is to show a list of all of the Doctor's enemies for a given episode:
To start this, create a variable in a new query to hold the episode number:
Now create another variable to hold the accumulated list of enemy names:
Write a SELECT statement which accumulates the list of enemy names for the chosen episode in a variable.*/
use DoctorWho
go
declare @EpisodeId int = 15, @EnemyList varchar(100)=''
select @EnemyList=@EnemyList+EnemyName+', ' from tblEnemy inner join tblEpisodeEnemy on tblEnemy.EnemyId=tblEpisodeEnemy.EnemyId
inner join tblEpisode on tblEpisodeEnemy.EpisodeId=tblEpisode.EpisodeId where tblEpisode.EpisodeId=@EpisodeId
select @EpisodeId 'EpisodeId', @EnemyList 'Enemies'

/*The aim of this exercise is to generate a list of events that occurred in the year that you were born:
To do this, first create two appropriately named variables to store the first date of your year of birth and the last,
then use these variables to filter your results to show only events occurring between these two dates.
Change the value of your variables to a different year's start/end, and rerun your query to check that it gives the correct events:*/
use WorldEvents
go
create or alter procedure usp_EventsInYear as
declare @StartDate date='1980-01-01', @EndDate date='1980-12-31'
select EventName, EventDate, CountryName from tblEvent inner join tblCountry on tblEvent.CountryID=tblCountry.CountryID
where EventDate between @StartDate and @EndDate
go
exec usp_EventsInYear

/*Write a SQL statement which brings back the top 3 events in your year of birth, in event name order. Running the SELECT statement will generate
a number of rows, but variables can only hold one. What we'd really like to do is to join the events into a single string variable:*/
use WorldEvents
go
create or alter procedure usp_EventfulYear as
declare @Year int=1992, @EventfulYear varchar(100)=''
select top 3 @EventfulYear=@EventfulYear+EventName+', ' from tblEvent where year(EventDate)=@Year order by EventName
select @EventfulYear 'Eventful Year'
go
exec usp_EventfulYear

--The aim of this exercise is to use the SQL PRINT statement to show the following information about the doctor you've chosen:
use DoctorWho
go
create or alter procedure usp_DoctorDetails as
declare @DoctorId int = 12, @DoctorName varchar(100), @NumberEpisodes int
select @DoctorName=DoctorName from tblDoctor where DoctorId=@DoctorId
select @NumberEpisodes=count(tblDoctor.DoctorId) from tblEpisode inner join tblDoctor on tblEpisode.DoctorId=tblDoctor.DoctorId where tblDoctor.DoctorId=@DoctorId
print 'Results for Doctor number: '+cast(@DoctorId as varchar(2))
print '---------------------------------'
print ''
print 'Doctor Name: '+@DoctorName
print ''
print 'Episodes appeared in: '+cast(@NumberEpisodes as varchar(2))
go
exec usp_DoctorDetails

--PARAMETERS AND RETURN VALUES

/*create a query to show all of the episodes which feature enemies containing the letters Dalek:
Now change this query into a stored procedure called usp_EnemyEpisodes, which lists out all of the episodes featuring a given enemy.*/
use DoctorWho
go
create or alter procedure usp_EnemyEpisodes @EnemyName varchar(100)='' as
select SeriesNumber, EpisodeNumber, Title from tblEpisode inner join tblEpisodeEnemy on tblEpisode.EpisodeId=tblEpisodeEnemy.EpisodeId
inner join tblEnemy on tblEpisodeEnemy.EnemyId=tblEnemy.EnemyId where EnemyName like '%'+@EnemyName+'%' order by SeriesNumber, EpisodeNumber
go 
exec usp_EnemyEpisodes @EnemyName='Dalek'
exec usp_EnemyEpisodes @EnemyName='ood'
exec usp_EnemyEpisodes @EnemyName='auton'
exec usp_EnemyEpisodes @EnemyName='silence'

/*Create a stored procedure to list out the category name, event date and category id for each event:
Incorporate parameters for the following:
Parameter	Should equal
@CategoryName	All or part of the name of the category you're looking for
@After	The earliest event date you're looking for
@CategoryId	The number of the category you're looking for
Now try adding default values to the parameters and you'll see that it's difficult:
what should the default be for @CategoryID? Instead assign NULL as the default value for all 3 parameters:*/
use WorldEvents
go
create or alter procedure usp_CategoryEventDate @CategoryName varchar(100)='', @After date='1776-03-09', @CategoryId int=100 as
select CategoryName, EventDate, tblEvent.CategoryID from tblEvent inner join tblCategory on tblEvent.CategoryID=tblCategory.CategoryID
where CategoryName like '%'+@CategoryName+'%' and EventDate>=@After and tblEvent.CategoryID
<=@CategoryId order by EventDate
go
exec usp_CategoryEventDate @CategoryName='death', @After='19900101'
exec usp_CategoryEventDate @CategoryId=16

/*Create a stored procedure to list out the EventName, EventDate and Country fields:
Add a parameter to your stored procedure that will take in the country name of interest and use this to filter the rows displayed:
Try passing in different countries or parts of country names to change the number of events returned.*/
use WorldEvents
go
create or alter procedure usp_CountryEvents @CountryNameHas varchar(50)='', @CountryNameStartsWith varchar(50)='' as
select EventName, EventDate, CountryName from tblEvent inner join tblCountry on tblEvent.CountryID=tblCountry.CountryID
where CountryName like '%'+@CountryNameHas+'%' and CountryName like @CountryNameStartsWith+'%' order by EventDate
go
exec usp_CountryEvents @CountryNameHas='d', @CountryNameStartsWith='s'

/*Create a stored procedure called usp_ContinentEvents which filters events to show only those:
which took place in a given continent; which took place on or after a given date; and which took place on or before a given date.*/
use WorldEvents
go
create or alter procedure usp_ContinentEvents @ContinentName varchar(30)='', @OnOrAfterDate date='1776-03-09', @TillDate date='2016-11-08' as
select ContinentName, EventName, EventDate from tblEvent
inner join tblCountry on tblEvent.CountryID=tblCountry.CountryID inner join tblContinent on tblCountry.ContinentID=tblContinent.ContinentID
where ContinentName like '%'+@ContinentName+'%' and EventDate between @OnOrAfterDate and @TillDate order by EventDate
go
exec usp_ContinentEvents @ContinentName='Asia', @OnOrAfterDate='1990-01-01', @TillDate='2000-01-01'

/*The aim of this exercise is to create a stored procedure which will output a variable containing a comma-delimited list of the continents
which have 50 or more events. Start by selecting these continents in a stored procedure, now turn this into a list variable separated using commas,
but don't worry about removing the trailing comma. Store this list variable in an output parameter, Execute the stored procedure on a new page
and capture the output in a variable, then remove the trailing comma*/
use WorldEvents
go
create or alter procedure usp_BigHappenings as declare @EventfulContinents varchar(200)=''
select @EventfulContinents=@EventfulContinents+ContinentName+', ' from tblContinent
inner join tblCountry on tblContinent.ContinentID=tblCountry.ContinentID inner join tblEvent on tblCountry.CountryID=tblEvent.CountryID
group by ContinentName having count(tblEvent.CountryID)>=50
select trim(', ' from @EventfulContinents) 'Big Happenings'
go
exec usp_BigHappenings

/*Create a stored procedure called usp_ListEpisodes to list out all of the episodes for a given series number.
Now set a default value of Null for your parameter, such that it lists out all of the episodes if you don't specify a series number:*/
use DoctorWho
go
create or alter procedure usp_ListEpisodes @SeriesNumber int=10 as
select EpisodeDate, Title, EpisodeNumber, SeriesNumber from tblEpisode where SeriesNumber<=@SeriesNumber order by EpisodeDate
go
exec usp_ListEpisodes 1

/*Create a procedure called usp_CompanionsForDoctor which will list out all of the companions for a given doctor (or all of the companions in the
database if you leave the doctor's name parameter out).
To test your procedure out, see if you get 3, 5 and 17 companions' names respectively when you run these tests: 'Ecc', 'matt', blank*/
use DoctorWho
go
create or alter procedure usp_CompanionsForDoctor @DoctorName varchar(100)='' as
select distinct CompanionName from tblCompanion inner join tblEpisodeCompanion on tblCompanion.CompanionId=
tblEpisodeCompanion.CompanionId inner join tblEpisode on tblEpisodeCompanion.EpisodeId=tblEpisode.EpisodeId inner join tblDoctor on tblEpisode.DoctorId=
tblDoctor.DoctorId where DoctorName like '%'+@DoctorName+'%'
go
exec usp_CompanionsForDoctor 'matt'

/*In this exercise you should create a stored procedure to calculate the difference in length between the longest and shortest EventName,
then return this difference and show it in a message:
Now DECLARE a new variable in the same window as your EXEC command. The script to put the RETURN value into the variable can be tricky.*/
use WorldEvents
go
create or alter procedure usp_HowMuchLonger as
declare @Diff int=''
select @Diff=max(len(EventName))-min(len(EventName)) from tblEvent
select concat('The difference between the longest EventName & the shortest is: ',cast(@Diff as varchar(3))) 'How much longer'
go
exec usp_HowMuchLonger

/*The aim of this exercise is to link two stored procedures together. Start by creating a stored procedure which shows the ContinentName where the first
event occurred. Now create a second stored procedure which filters events to show only those which happened in the continent passed in via a parameter.*/
use WorldEvents
go
create or alter procedure usp_FirstEvent @ContiFirstEvent varchar(100)='', @Output varchar(100)='' output as
select @ContiFirstEvent=ContinentName from tblContinent inner join tblCountry on tblContinent.ContinentID=tblCountry.ContinentID inner join tblEvent on 
tblCountry.CountryID=tblEvent.CountryID where EventDate=(select min(EventDate) from tblEvent)
select @Output=@ContiFirstEvent
go
create or alter procedure usp_ContiFirstEvent @Input varchar(100)='' as
exec usp_FirstEvent @Output=@Input output
select EventName, EventDate, ContinentName from tblEvent inner join tblCountry on tblEvent.CountryID=tblCountry.CountryID inner join tblContinent on
tblCountry.ContinentID=tblContinent.ContinentID where ContinentName=@Input
go
exec usp_ContiFirstEvent

/*The aim of this exercise is to create a stored procedure called usp_GoodAndBad which shows the number of Doctor Who's companions and enemies
for a given series number.*/
use DoctorWho
go
create or alter proc usp_GoodAndBad @SeriesNumber int=1 as
declare @NumEnemies int, @NumCompanions int
select @NumEnemies=count(distinct EnemyID) from tblEpisodeEnemy inner join tblEpisode on tblEpisodeEnemy.EpisodeId=tblEpisode.EpisodeId
where SeriesNumber=@SeriesNumber
select @NumCompanions=count(distinct CompanionID) from tblEpisodeCompanion inner join tblEpisode on tblEpisodeCompanion.EpisodeId=tblEpisode.EpisodeId
where SeriesNumber=@SeriesNumber
select @SeriesNumber SeriesNumber, @NumEnemies 'Number of enemies', @NumCompanions'Number of companions'
go
exec usp_GoodAndBad 5

/*First write a stored procedure to show which country has the most events:
Add two output parameters to your procedure:
Parameter	What it should take
@TopCountry	The country name
@EventCount	The number of events for it
Amend your procedure to capture the country name and number of events in these variables, within your SELECT clause:
Select the two variables to check the information has been successfully output.*/
use WorldEvents
go
create or alter proc usp_TopCountry @TopCountry varchar(max)='' output, @EventCount int='' output as
select top 1 @TopCountry=CountryName, @EventCount=count(tblEvent.CountryId) from tblEvent inner join tblCountry on tblEvent.CountryID=tblCountry.CountryID
group by CountryName order by count(tblEvent.CountryId) desc
go
create or alter proc usp_MostNumerous @CountryVar varchar(max)='', @EventCountVar int='' as
exec usp_TopCountry @TopCountry=@CountryVar output, @EventCount=@EventCountVar output
select @CountryVar 'Country Name', @EventCountVar 'Number of events'
go
exec usp_MostNumerous

--TESTING CONDITIONS

/*Using IF create a stored procedure that returns different results depending on the word passed in. You should be able to run:
exec uspInformation 'Event', exec uspInformation 'Country', exec uspInformation 'Continent'
When you have this working try putting a different (made-up) word in to see what happens - you should get this:
Add a section of code which gives a message if a wrong word is put in.*/
use WorldEvents
go
create or alter proc usp_Information @Name varchar(max) as
if @Name='Event' select EventName, EventDetails, EventDate from tblEvent else if @Name='Country' select CountryName from tblCountry else if 
@Name='Continent' select ContinentName from tblContinent else select 'You must enter: Event, Country or Continent' 'Nuh uh say the magic word'
go
exec usp_Information 'Event'
exec usp_Information 'Country'
exec usp_Information 'Continent'
exec usp_Information 'Rajat' 

--LOOPING

/*The aim of this exercise is to create a query to show the number of events which occurred in each year that you have been alive,
using a loop to run a separate select statement for each year:*/
use WorldEvents
declare @Counter int=1980, @EndValue int, @Statement varchar(max)
select @EndValue=year(max(EventDate)) from tblEvent
while @Counter<=@EndValue
begin
	select distinct @Statement=((cast(count(year(EventDate)) as varchar (max))+' events occured in '+cast(@Counter as varchar(max))))
	from tblEvent where year(EventDate)=@Counter
	print @Statement
	set @Counter=@Counter+1
end

--Your task is to write a query to show the first (say) 1000 primes.
--
--
--
--
--

/*Ever wondered which month is the most eventful? Or which month an event occurred in? Create a loop to list the events in each month,
by looping from month number 1 to 12:*/
use WorldEvents
go
declare @Month int=1, @Statement varchar(max), @EStatement varchar(max), @StartTime datetime=current_timestamp, @EndTime datetime
while @Month<=12
begin
	set @Statement=''
	set @EStatement=''
	select @Statement=@Statement+EventName+', ' from tblEvent where month(EventDate)=@Month
	select @EStatement='Events which occured in '+(select datename(m,'2222-'+CAST(@Month as varchar(2))+'-01'))+': '+(select trim(', ' from @Statement))
	print @EStatement
	set @Month=@Month+1
end
set @EndTime=current_timestamp
print datediff(ms, @StartTime, @EndTime)

--SCALAR FUNCTIONS

/*Write a function called ufn_Reign which uses the DateDiff function to return the number of days between any two given dates.
Call your squeaky clean new function within a query to show the relative duration of each doctor's "reign":*/
use DoctorWho
go
create or alter function udf_Reign (@Start date, @End date) returns int as
begin
return datediff(d,@Start,isnull(@End,CURRENT_TIMESTAMP))
end
go
select DoctorName, dbo.udf_Reign(FirstEpisodeDate,LastEpisodeDate) 'Reign in Days' from tblDoctor order by 'Reign in Days' desc

/*Create a function called udf_LetterCount which takes two parameters:
Parameter	What it should contain
@First	The name of an event
@Second	The details for an event
Your function should sum:
The length in letters of the event name (using the LEN function); and
The length in letters of the event details column (again using LEN).
Your function should then return this value as an integer.*/
use WorldEvents
go
create or alter function udf_LetterCount (@First varchar(max), @Second varchar(max)) returns int as
begin
return len(@First)+len(@Second)
end
go
select EventName, EventDetails, EventDate, dbo.udf_LetterCount(EventName,EventDetails) 'Total Letters' from tblEvent order by 'Total Letters'

/*The aim of this exercise is to create a function called udf_EpisodeDescription such that you can count how many episodes there are of each type:
To write this function use the CHARINDEX function to determine whether one string of text exists within another:*/
use DoctorWho
go
create or alter function udf_EpisodeDescription (@String varchar(max)) returns varchar(max) as
begin if (charindex('Part 1',@String)>0) return 'First Part' else if charindex('Part 2',@String)>0 return 'Second Part' return 'Single Episode' end
go
select dbo.udf_EpisodeDescription(Title) 'Episode Type', count(Title) 'Number of Episodes' from tblEpisode group by dbo.udf_EpisodeDescription(Title)

--Strangely there is no function that can return the name of a month when given a number 1 to 12. Luckily for you that is exactly what we will do:
use DoctorWho
go
create or alter function udf_MonthName (@MonthNo int) returns varchar(max) as begin return datename(m,'2222-'+CAST(@MonthNo as varchar(2))+'-01') end
go
declare @i int=1 while @i<=12 begin print dbo.udf_MonthName(@i) set @i=@i+1 end

/*See how many of the following functions you can create in the time left to you!
-- show all these functions working
SELECT EpisodeId, Title,
-- function to count number of companions for a given episode
dbo.udf_NumberCompanions(EpisodeId) AS Companions,
-- function to count the number of enemies for an episode
dbo.udf_NumberEnemies(EpisodeId) AS Enemies,
-- function to count the number of words
dbo.udf_Words(Title) AS Words FROM tblEpisode ORDER BY Words DESC*/
use DoctorWho
go
create or alter function udf_NumberCompanions (@EId int) returns int as
begin
declare @NumberCompanions int=1
select @NumberCompanions=count(CompanionID) from tblEpisodeCompanion inner join tblEpisode on tblEpisodeCompanion.EpisodeId=tblEpisode.EpisodeId
group by tblEpisodeCompanion.EpisodeId having tblEpisodeCompanion.EpisodeId=@EId
return @NumberCompanions
end
go
create or alter function udf_NumberEnemies (@EId int) returns int as
begin
declare @NumberEnemies int=1
select @NumberEnemies=count(EnemyID) from tblEpisodeEnemy inner join tblEpisode on tblEpisodeEnemy.EpisodeId=tblEpisode.EpisodeId
group by tblEpisodeEnemy.EpisodeId having tblEpisodeEnemy.EpisodeId=@EId
return @NumberEnemies
end
go
create or alter function udf_Words (@String varchar(max)) returns int as
begin
declare @Words int=0
set @Words=len(@String)-len(replace(@String,' ',''))+1
return @Words
end
go
select EpisodeId, Title, dbo.udf_NumberCompanions(EpisodeId) 'Companions', dbo.udf_NumberEnemies(EpisodeId) 'Enemies', dbo.udf_Words(Title) 'Words'
from tblEpisode order by Words desc, EpisodeId

/*Time to test the events and see who receives a podium finish! Create a function to test each event and classify it as the oldest, newest,
alphabetically first, alphabetically last or (in all other cases) as a loser:*/
use WorldEvents
go
create or alter function udf_WinnerStatus (@EName varchar(max)) returns varchar(max) as
begin
declare @WinnerStatus varchar(max)=''
select @WinnerStatus=case when @EName=(select top 1 EventName from tblEvent order by EventName) then 'Alphabetically First'
when @EName=(select top 1 EventName from tblEvent order by EventName desc) then 'Alphabetically Last'
when @EName=(select EventName from tblEvent where EventDate=(select min(EventDate) from tblEvent)) then 'Oldest Event'
when @EName=(select EventName from tblEvent where EventDate=(select max(EventDate) from tblEvent)) then 'Newest Event'
when @EName=(select EventName from tblEvent where len(EventName)=(select min(len(EventName)) from tblEvent)) then 'Shortest Event Name'
when @EName=(select EventName from tblEvent where len(EventName)=(select max(len(EventName)) from tblEvent)) then 'Longest Event Name'
when @EName=(select EventName from tblEvent where len(EventDetails)=(select min(len(EventDetails)) from tblEvent)) then 'Shortest Event Details'
when @EName=(select EventName from tblEvent where len(EventDetails)=(select max(len(EventDetails)) from tblEvent)) then 'Longest Event Details'
when @Ename=(select EventName from tblEvent where EventID=(select min(EventID) from tblEvent)) then 'Lowest EventId'
when @Ename=(select EventName from tblEvent where EventID=(select max(EventID) from tblEvent)) then 'Highest EventId'
else 'Not a winner' end from tblEvent
return @WinnerStatus
end
go
select EventName, dbo.udf_WinnerStatus(EventName) 'Winners' from tblEvent where dbo.udf_WinnerStatus(EventName)<>'Not a winner' order by 'Winners'

--TRANSACTIONS

/*Write a query to add Shaun the Sheep as Doctor Who number 13 in the tblDoctor table, but first begin a transaction:
Extend this query (without running it yet) so that it:
Tests to see whether 2 + 2 = 4; Rolls back the transaction if this is true; or Commits it if this is false.
Finally, display a list of all of the doctors (the rows from the tblDoctor table). Now run your query - it should show the original 12 doctors 
(Shaun the Sheep has not beeen added).
Amend your query to test whether 2 + 2 = 5, and rerun it.  You should now get your new doctor:
Manually delete this added row*/
use DoctorWho
begin transaction
insert into tblDoctor (DoctorName, DoctorNumber) values ('Shaun the Sheep',13)
if 2+2=4
rollback transaction
else
commit transaction
select * from tblDoctor
begin transaction
insert into tblDoctor (DoctorName, DoctorNumber) values ('Shaun the Sheep',13)
if 2+2=5
rollback transaction
else
commit transaction
select * from tblDoctor
delete from tblDoctor where DoctorNumber=13

/*Write an insert statement to add a new event with EventName called My DOB, with your date of birth as the Eventdate column and an appropriate entry
for the EventDetails column:
Now we can turn this insert into a transaction - but first, write a delete command to remove any events with an Eventname like My DOB.
Create a transaction which tests if an Eventname of My DOB exists already, adding it if it doesn't and giving a message if it does:*/
use WorldEvents
insert into tblEvent (EventName, EventDetails, EventDate, CountryID, CategoryID)
values ('My DOB', 'I was born and the world trembles', '1980-04-20', 24, 20)
select * from tblEvent
delete from tblEvent where EventName like 'My DOB'
begin tran
if (select EventName from tblEvent where EventName like 'My DOB') is null
begin
select 'This momentous event has now been added' 'EventResults'
insert into tblEvent (EventName, EventDetails, EventDate, CountryID, CategoryID)
values ('My DOB', 'I was born and the world trembles', '1980-04-20', 24, 20)
commit tran
end
else
begin
rollback tran
select 'The magnificent event already exists' 'EventResults'
end
select * from tblEvent where EventName like 'My DOB'

/*Generate a new column called NumberEnemies in the tblEpisode table:
Write an update query which will set this column to equal the number of enemies for each episode (but within a transaction), then:
Roll back this transaction if more than 100 rows are affected (displaying a suitable message); or
Commit it otherwise and show a list of all of the episodes, including the newly populated field.*/
use DoctorWho
alter table tblEpisode drop column if exists NumberEnemies
begin tran
alter table tblEpisode add NumberEnemies int
declare @RowCount int=''
update tblEpisode set NumberEnemies = (select count(*) from tblEpisodeEnemy ee where ee.EpisodeId=e.EpisodeId) from tblEpisode e
set @RowCount = @@ROWCOUNT
if @RowCount>100
--if @RowCount>120
begin
select cast(@RowCount as varchar(5))+' rows were updated, but change rolled back' 'NumberEnemiesUpdateResults'
rollback tran
end
else
begin
commit tran
select * from tblEpisode
end

/*Use an UPDATE statement on the tblCountry table to set the CountryName column to include the words (My Country) next to the country you call home:
Now change the code to add (Holiday destination) to the other countries within a transaction. After running the update statement:
roll back the transaction if 1 + 1 = 2 (it does); or commit it otherwise. When you run this query, nothing should change:
Change the condition to test whether 1 + 1 = 3 (it doesn't), and rerun it. Check that the extra text has been added:
If you have nothing better to do, change Holiday to Visited for countries you've been to.
Finally, as a bit of housekeeping please reset the country names, If you could also manually reset the name of your home country back to its former glory*/
use WorldEvents
update tblCountry set CountryName=CountryName+' (My Country - Hindustan)' where CountryID=24
begin tran
update tblCountry set CountryName=CountryName+' (Holiday Destination)' where CountryID<>24
--if 1+1=2
if 1+1=3
rollback tran
else
commit tran
update tblCountry set CountryName=replace(CountryName,' (Holiday Destination)','') where CountryID<>24
update tblCountry set CountryName=replace(CountryName,' (My Country - Hindustan)','') where CountryID=24
select * from tblCountry

/*First store the value of Westeros in a variable. Now write an insert statement to add the value of this variable into the ContinentName field:
After running the Insert statement, comment it out but leave the variable. Start a TRANSACTION to delete the continent held in the variable
If the first letter of your name is not equal to (<>) the first letter of the variable (W) then roll back the transaction:
Set the ELSE condition to show You have won and to then select all the continents. Outcome will depend on your name.
If it starts with W then you will see no continent:*/
use WorldEvents
declare @Continent varchar(50)='Westeros'
--set identity_insert tblContinent on
--insert into tblContinent (ContinentID, ContinentName) values (9,@Continent)
begin tran
delete tblContinent where ContinentName=@Continent
if left(@Continent,1)!='R'
begin
rollback tran
select 'You have died' 'Lost the Game'
update tblContinent set ContinentName='Seven Kingdoms' where ContinentID=9
end
else
begin
select 'You have won' 'Won the game of thrones'
commit tran
end
set identity_insert tblContinent off
select * from tblContinent

--CREATING TABLES

/*Write SQL to create a new table to contain the Doctor Who production companies:
Your table should have the following columns:
Column	Notes
ProductionCompanyId	The unique number of each company (starting at 1, and going up by 1 for each new company)
ProductionCompanyName	The name of each company
Abbreviation	The abbreviation for each company
Extend your query so that it inserts two new rows into this table:*/
use DoctorWho
drop table if exists tblProductionCompany
create table tblProductionCompany (ProductionCompanyId int identity(1,1) primary key, ProductionCompanyName varchar(100), Abbreviation varchar(10))
insert into tblProductionCompany (ProductionCompanyName, Abbreviation)
values ('British Broadcasting Corporation', 'BBC'), ('Canadian Broadcasting Corporation', 'CBC')
select * from tblProductionCompany

/*Create a query or stored procedure to create the following table of book genres called tblGenre (the rating is a number between 1 and 10 you can
assign to each genre): The table should have 3 columns - you get bonus points for indexing the GenreName column:
Now add code to insert records into this table then display them: Run your query to check it works:*/
use Books
go
create or alter proc usp_CreatetblGenre as
begin
drop table if exists tblGenre
create table tblGenre (GenreID int identity(1,1) primary key, GenreName varchar(50), Rating int Check (Rating>=1 and Rating<=10))
create nonclustered index ix_tblGenre on tblGenre(GenreName, Rating)
insert into tblGenre (GenreName, Rating)
select 'Romance',3 union all
select 'Science Fiction', 7 union all
select 'Thriller', 5 union all
select 'Humour', 3
end
go
print ''
print 'Last one added was number '+cast(@@identity as varchar)
print ''
select GenreID, GenreName, Rating from tblGenre order by GenreID

/*The aim of this exercise is to explicitly create a table, then insert the output from several select statements into it.
The final table should list out the count of events for each country, continent and two millennia.*/
use WorldEvents
drop table if exists tblEventSummary
create table tblEventSummary (SummaryItem varchar(100), CountEvents int)
insert into tblEventSummary select 'Last Millenium', count(EventDate) from tblEvent where EventDate<'2000-01-01'
insert into tblEventSummary select 'This Millenium', count(EventDate) from tblEvent where EventDate>='2000-01-01'
insert into tblEventSummary select CountryName, count(EventDate) from tblEvent inner join tblCountry on tblEvent.CountryID=tblCountry.CountryID
group by CountryName
insert into tblEventSummary select ContinentName, count(EventDate) from tblEvent inner join tblCountry on tblEvent.CountryID=tblCountry.CountryID
inner join tblContinent on tblCountry.ContinentID=tblContinent.ContinentID group by ContinentName
select * from tblEventSummary

/*The aim of this exercise is to create a new summary table listing all the continents.
Write a SELECT statement which returns the following summary data for each continent.*/
use WorldEvents
drop table if exists tblContinentSummary
select ContinentName, count(distinct(tblCountry.CountryID)) 'Countries in Continent', count(EventID) 'Events in Continent', min(EventDate)
'Earliest Continent Event', max(EventDate) 'Latest Continent Event' into tblContinentSummary from tblContinent inner join tblCountry
on tblContinent.ContinentID=tblCountry.ContinentID inner join tblEvent on tblCountry.CountryID=tblEvent.CountryID group by ContinentName
select * from tblContinentSummary

/*Write code to generate a table of genres of author called tblGenre (you may already have done this in the previous exercise): Now modify your code so
that it also creates a column called GenreId in the tblAuthor table (first checking that it doesn't already exist, and deleting it if it does).
Now add to your query to make it:
Create a foreign key constraint on this added column (linked to the GenreId column in the tblGenre table)
Update the authors so that they belong to the correct genre, using 3 UPDATE statements (one per author)
Use a SELECT statement to display each author with their corresponding genre, joining the tblAuthor and tblGenre tables
Now for the hardest part - make sure that your query works every time that you run it, and not just the first time!*/
use Books
if exists(select * from INFORMATION_SCHEMA.COLUMNS where table_name='tblAuthor' and column_name='GenreId')
begin
alter table tblAuthor drop constraint FK_GenreID
alter table tblAuthor drop column GenreID
alter table tblAuthor add GenreId int null
alter table tblAuthor add constraint FK_GenreId foreign key(GenreId) references tblGenre(GenreId)
end
update tblAuthor set GenreId=3 where AuthorId=1
update tblAuthor set GenreId=2 where AuthorId=2
update tblAuthor set GenreId=1 where AuthorId=3
select FirstName+' '+LastName 'Author', GenreName 'Genre' from tblAuthor inner join tblGenre on tblAuthor.GenreId=tblGenre.GenreID

--The aim of this exercise is to create a temporary table called #Characters containing all of the doctors, companions and enemies in the database.
use DoctorWho
drop table if exists #tblCharacters
select CompanionId  'CharacterId', CompanionName 'CharacterName', 'Companion' 'CharacterType' into #tblCharacters from tblCompanion
set identity_insert #tblCharacters on
insert into #tblCharacters (CharacterId, CharacterName, CharacterType) select DoctorId, DoctorName, 'Doctor' from tblDoctor
insert into #tblCharacters (CharacterId, CharacterName, CharacterType) select EnemyId, EnemyName, 'Enemy' from tblEnemy
select * from #tblCharacters order by CharacterName desc

--The aim of this exercise is to put all of the Doctors, companions and enemies into a single table variable called @characters.
use DoctorWho
declare @tblCharacters table (CharacterId int, CharacterName varchar(100), CharacterType varchar(10))
insert into @tblCharacters select DoctorId, DoctorName, 'Doctor' from tblDoctor
insert into @tblCharacters select CompanionId, CompanionName, 'Companion' from tblCompanion
insert into @tblCharacters select EnemyId, EnemyName, 'Enemy' from tblEnemy
select * from @tblCharacters order by CharacterName desc

/*Using the INTO syntax, create a temporary table holding a count of the number of event names beginning with the same letter.
The problem with INTO is that it decides the data type of the column based on the current data. Try adding XZ as a first letter with a count of 57
using INSERT INTO: This should generate an error:
Add a statement at the top of your query to create a new table called #EventsByLetter with two columns:
Now change your SELECT statement so that it adds the first letter summary rows into this table, rather than creating a new table.
When you run this revised query, it should accommodate the xz insertion also, and allow you to display the final results:*/
use WorldEvents
select left(EventName,1) 'First Letter', count(*) 'Number of Events' into #EventsByLetter from tblEvent group by left(EventName,1) order by [First Letter]
select * from #EventsByLetter
insert into #EventsByLetter values ('XZ',57)

drop table if exists #EventsByLetter
create table #EventsByLetter ([First Letter] varchar(2), [Number of Events] int)
insert into #EventsByLetter select left(EventName,1), count(*)from tblEvent group by left(EventName,1) order by left(EventName,1)
select * from #EventsByLetter
insert into #EventsByLetter values ('XZ',57)
select * from #EventsByLetter
delete #EventsByLetter where [First Letter]='XZ'

/*The aim of this exercise is to create a table variable, and populate it so that it holds the category, country and continent with the highest
number of events for each: The easiest way to start is to first write three select statements:
Now declare a TABLE variable with three columns: Source, Winner and Number of events. Insert the results of your three SELECT statements into
this table, either by using UNION or by using 3 separate INSERT statements.*/
use WorldEvents
select top 1 'Category' 'Source', CategoryName, count(tblEvent.EventID) 'EventCount' from tblCategory inner join tblEvent on tblCategory.CategoryID=
tblEvent.CategoryID group by CategoryName order by EventCount desc
select top 1 'Country' 'Source', CountryName, count(tblEvent.EventId) 'EventCount' from tblCountry inner join tblEvent on tblCountry.CountryID=
tblEvent.CountryID group by CountryName order by EventCount desc
select top 1 'Continent' 'Source', ContinentName, count(tblEvent.EventId) 'EventCount' from tblContinent inner join tblCountry on tblContinent.ContinentID=
tblCountry.ContinentID inner join tblEvent on tblCountry.CountryID=tblEvent.CountryID group by ContinentName order by EventCount desc

declare @tblWinners table ([Source] varchar(10), Winner varchar(15), [Number of Events] int)
insert into @tblWinners select top 1 'Category', CategoryName, count(tblEvent.EventID) from tblCategory inner join tblEvent on tblCategory.CategoryID=
tblEvent.CategoryID group by CategoryName order by count(tblEvent.EventID) desc
insert into @tblWinners select top 1 'Country', CountryName, count(tblEvent.EventId) from tblCountry inner join tblEvent on tblCountry.CountryID=
tblEvent.CountryID group by CountryName order by count(tblEvent.EventID) desc
insert into @tblWinners select top 1 'Continent', ContinentName, count(tblEvent.EventId) from tblContinent inner join tblCountry on
tblContinent.ContinentID=tblCountry.ContinentID inner join tblEvent on tblCountry.CountryID=tblEvent.CountryID
group by ContinentName order by count(tblEvent.EventID) desc
select * from @tblWinners order by [Number of Events] desc

/*The aim of this exercise is to create a table variable to store a list of "odd" countries, then join this to the events table to see events that
occurred in those odd countries. Start by selecting the odd countries.
Now, create a table variable called @OddCountries to hold 2 columns - OddName and OddNumber - and insert these countries into this table:
Join this table to the tblEvent table. Add two criteria to the WHERE clause:
Criteria	Details
Remove self-references	Don't show events whose names contain the country they occurred in.
Co-terminosity	Only show events where the event name and the OddName end in the same letter.*/
use WorldEvents
declare @OddCountries table(OddName varchar(25), OddId int)
insert into @OddCountries select CountryName, CountryID from tblCountry where CountryID%2<>0
select * from @OddCountries order by OddId desc
select EventName, OddName from @OddCountries o inner join tblCountry on o.OddId=tblCountry.CountryID inner join tblEvent on tblCountry.CountryID=
tblEvent.CountryID where EventName not like '%'+OddName+'%' and right(OddName,1)=right(EventName,1)

/*The aim of this exercise is to create a temporary table showing the most eventful country for each year. One way to do this is to create a 
temporary table, and populate its rows within a loop. First write a query to create a temporary table with 3 columns:
Column	            Contents
Year of events	    Each year in the database
Country of events	The country for that year having most events
Number of events	The number of events for this country in this year*/
use WorldEvents
drop table if exists #tblYearWiseEventfulCountries
create table #tblYearWiseEventfulCountries ([Year of Event] int,[Country of Events] varchar(25),[Number of Events] int)
declare @i int=(select year(min(EventDate)) from tblEvent)
while @i<=(select year(max(EventDate)) from tblEvent)
begin
insert into #tblYearWiseEventfulCountries select @i, (select top 1 CountryName from tblCountry inner join tblEvent on tblCountry.CountryID=
tblEvent.CountryID where YEAR(EventDate)=@i group by CountryName order by CountryName desc), (select top 1 count(EventId) from tblEvent inner join 
tblCountry on tblEvent.CountryID=tblCountry.CountryID where YEAR(EventDate)=@i group by CountryName order by CountryName desc)
set @i=@i+1
end
delete #tblYearWiseEventfulCountries where [Country of Events] is null
select * from #tblYearWiseEventfulCountries

/*The aim of this exercise is to create a single table containing all of the "best" Doctor Who episodes (ie those featuring Karen Gillan as Amy Pond
and/or those written by Steven Moffat).*/
use DoctorWho
drop table if exists #tblBestEpisodes
select EpisodeId, Title, SeriesNumber, EpisodeNumber, AuthorName 'Why' into #tblBestEpisodes from tblEpisode inner join tblAuthor on tblEpisode.AuthorId
=tblAuthor.AuthorId where AuthorName='Steven Moffat' order by EpisodeId
insert into #tblBestEpisodes select tblEpisode.EpisodeId, Title, SeriesNumber, EpisodeNumber, WhoPlayed from tblEpisode inner join tblEpisodeCompanion on tblEpisode.EpisodeId=
tblEpisodeCompanion.EpisodeId inner join tblCompanion on tblEpisodeCompanion.CompanionId=tblCompanion.CompanionId where WhoPlayed='Karen Gillan'
select * from #tblBestEpisodes

/*Your manager has told you that s/he wants to make the following two changes to the database:
Remove the Notes column from the tblEpisode table; and Shorten the Description column in the tblEnemy table to 75 characters.
He/she wants your guarantee that this won't cause any problems. Use a temporary table or table variable to accumulate the problems, and then display them*/
use DoctorWho
drop table if exists #tblProblems
create table #tblProblems (ProblemId int identity(1,1), TableName varchar(10), Id int, ColumnName varchar(15), ColumnValue varchar(100),
ProblemName varchar(30))
insert into #tblProblems (TableName, Id, ColumnName, ColumnValue, ProblemName) select 'tblEnemy', EnemyId, 'Description', Description,
'Description has '+cast(len(Description) as varchar)+' letters' from tblEnemy where len(Description)>75
insert into #tblProblems (TableName, Id, ColumnName, ColumnValue, ProblemName) select 'tblEpisode', EpisodeId, 'Notes', Notes, 'Notes field filled in'
from tblEpisode where Notes is not null
select * from #tblProblems

/*Run the following command in SQL:
-- show tables, views, etc in your database
SELECT * from sys.objects order by type
This should list out all of the tables, views, functions, stored procedures, etc in your database.  We're interested in the following two codes:
Code	What it is
P	Stored procedure
FN	Scalar function
Your manager has asked you to create a single table listing out the name, object type and date created for:
All of the non-system stored procedures (apart from those which contain the word Episodes); as well as
All of the non-system scalar functions.
Use a temporary table or table variable to accumulate this information.*/
drop table if exists #tblObjects
select name 'ObjectName', type_desc 'ObjectType', create_date 'DateCreated' into #tblObjects from sys.objects where type='FN' or (type='P' and name
not like '%Episodes%')
select * from #tblObjects order by ObjectType desc, DateCreated

--TABLE-VALUED FUNCTIONS

--The aim of this exercise is to create a table-valued function to show events for any given year.
use WorldEvents
go
create or alter function udf_EventsForYear (@Year int) returns table as return 
(select EventDate, EventName, EventDetails, CategoryID, CountryID from tblEvent where year(EventDate)=@Year)
go
select * from dbo.udf_EventsForYear(2016)

--Create a table-valued function to list out all of the episode details for a given doctor.
use DoctorWho
go
create or alter function udf_EpisodesByDoctor (@DoctorName varchar(max)) returns table as return
(select EpisodeId, Title, SeriesNumber, EpisodeNumber, AuthorId from tblEpisode inner join tblDoctor on tblEpisode.DoctorId=tblDoctor.DoctorId where
DoctorName like '%'+@DoctorName+'%')
go
select SeriesNumber, EpisodeNumber, Title, AuthorName from dbo.udf_EpisodesByDoctor('Chris') ebd inner join tblAuthor on ebd.AuthorId=tblAuthor.AuthorId

/*Create a function to list out the episodes for any given series number and part of an author name.
Functions can't have optional parameters, but you can pass dummy values and detect them. Amend your function so that it shows:
Episodes for any series if you pass the first argument as Null; Episodes for any author if you pass the second argument as Null.*/
use DoctorWho
go
create or alter function udf_ChosenEpisodes (@SeriesNumber int, @AuthorName varchar(max)) returns table as return
(select Title, AuthorName 'Author', DoctorName 'Doctor' from tblEpisode inner join tblDoctor on tblEpisode.DoctorId=tblDoctor.DoctorId inner join
tblAuthor on tblEpisode.AuthorId=tblAuthor.AuthorId where (SeriesNumber=@SeriesNumber or @SeriesNumber is null) and (AuthorName like '%'+@AuthorName+'%'
or @AuthorName is null))
go
select * from dbo.udf_ChosenEpisodes(1,'russell')
select * from dbo.udf_ChosenEpisodes(2,'moffat')
select * from dbo.udf_ChosenEpisodes(2,null)
select * from dbo.udf_ChosenEpisodes(null,'moffat')
select * from dbo.udf_ChosenEpisodes(null,null)

--The aim of this exercise is to create a function that returns summary information about a given continent during a chosen month.
use WorldEvents
go
create or alter function udf_ContinentSummary(@Continent varchar(25), @Month varchar(10)) returns table as return
(select ContinentName, (select count(distinct(EventID)) from tblEvent inner join tblCountry on tblEvent.CountryID=tblCountry.CountryID inner join
tblContinent on tblCountry.ContinentID=tblContinent.ContinentID where ContinentName=@Continent and DoctorWho.dbo.udf_MonthName(MONTH(EventDate))=@Month)
'Number of Events', (select count(distinct(tblEvent.CountryID)) from tblEvent inner join tblCountry on tblEvent.CountryID=tblCountry.CountryID inner join
tblContinent on tblCountry.ContinentID=tblContinent.ContinentID where ContinentName=@Continent and DoctorWho.dbo.udf_MonthName(MONTH(EventDate))=@Month)
'Number of Countries', (select count(distinct(tblEvent.CategoryID)) from tblEvent inner join tblCountry on tblEvent.CountryID=tblCountry.CountryID
inner join tblContinent on tblCountry.ContinentID=tblContinent.ContinentID where ContinentName=@Continent and DoctorWho.dbo.udf_MonthName(MONTH(EventDate))
=@Month) 'Number of Categories' from tblContinent where ContinentName=@Continent)
go
select * from udf_ContinentSummary('Europe','March')

/*Write a function which takes two arguments:
Argument	    Heading		                     Example
@CompanionName	Part or all of a companion name	 Wilf
@EnemyName	    Part or all of an enemy name	 Ood*/
use DoctorWho
go
create or alter function udf_Silly (@CompanionName varchar(100), @EnemyName varchar(100)) returns table as return
(select SeriesNumber, EpisodeNumber, Title, DoctorName, AuthorName, CompanionName 'Appearing' from tblEpisode e inner join tblDoctor d on e.DoctorId=
d.DoctorId inner join tblAuthor a on e.AuthorId=a.AuthorId inner join tblEpisodeCompanion ec on e.EpisodeId=ec.EpisodeId inner join tblCompanion c on
ec.CompanionId=c.CompanionId where CompanionName like '%'+@CompanionName+'%' union all
select SeriesNumber, EpisodeNumber, Title, DoctorName, AuthorName, EnemyName 'Appearing' from tblEpisode e inner join tblDoctor d on
e.DoctorId=d.DoctorId inner join tblAuthor a on e.AuthorId=a.AuthorId inner join tblEpisodeEnemy ee on e.EpisodeId=ee.EpisodeId inner join tblEnemy en on
ee.EnemyId=en.EnemyId where EnemyName like '%'+@EnemyName+'%')
go
select * from dbo.udf_Silly('wilf','ood')

/*Create a function which takes in a vowel and returns a table containing all of the categories, countries and continents which contain that vowel:
The function will need one parameter to take in the vowel and a table variable to store the output from each separate select.*/
use WorldEvents
go
create or alter function udf_CCC (@Vowel char(1)) returns @VowelTable table(Information varchar(max), Category varchar(max)) as 
begin
insert into @VowelTable (Information, Category) select CategoryName, 'Category' from tblCategory where CategoryName like '%'+@Vowel+'%'
insert into @VowelTable (Information, Category) select CountryName, 'Country' from tblCountry where CountryName like '%'+@Vowel+'%'
insert into @VowelTable (Information, Category) select ContinentName, 'Country' from tblContinent where ContinentName like '%'+@Vowel+'%'
return
end
go
select (select count(Information) from dbo.udf_CCC('a')) 'A_results', (select count(Information) from dbo.udf_CCC('e')) 'E_results', 
(select count(Information) from dbo.udf_CCC('i')) 'I_results', (select count(Information) from dbo.udf_CCC('o')) 'O_results',
(select count(Information) from dbo.udf_CCC('u')) 'U_results'

--DERIVED TABLES AND CTEs

--The aim of this exercise is to show the number of events whose descriptions contain the words this and/or that:
use WorldEvents
with cte_ThisAndThat (IfThis, IfThat, [Number of Events]) as
(select 0 'IfThis', 0 'IfThat', (select count(EventId) from tblEvent where EventDetails not like '%this%' and EventDetails not like '%that%')
'Number of Events' union all
select 1, 0, (select count(EventId) from tblEvent where EventDetails like '%this%' and EventDetails not like '%that%') union all
select 0, 1, (select count(EventId) from tblEvent where EventDetails not like '%this%' and EventDetails like '%that%') union all
select 1, 1, (select count(EventId) from tblEvent where EventDetails like '%this%' and EventDetails like '%that%'))
select * from cte_ThisAndThat;
with cte_ThisAndThat (EventName, EventDetails) as
(select EventName, EventDetails from tblEvent where EventDetails like '%this%' and EventDetails like '%that%')
select * from cte_ThisAndThat

/*The aim of this exercise is to use a CTE (Common Table Expression) to extract data from the database in two passes:
Get a list of all of the episodes written by authors with MP in their names.
Get a list of the companions featuring in these episodes.*/
use DoctorWho
;with cte_AuthorCompanion (EpisodeId) as
(select EpisodeId from tblEpisode e inner join tblAuthor a on e.AuthorId=a.AuthorId where AuthorName like '%mp%')
select * from cte_AuthorCompanion
;with cte_AuthorCompanion (EpisodeId) as
(select EpisodeId from tblEpisode e inner join tblAuthor a on e.AuthorId=a.AuthorId where AuthorName like '%mp%')
select distinct CompanionName from cte_AuthorCompanion cte inner join tblEpisodeCompanion ec on cte.EpisodeId=ec.EpisodeId inner join tblCompanion
c on ec.CompanionId=c.CompanionId

--The aim of this exercise is to count the number of events by a column called Era which you'll calculate, without including this calculation twice:
use WorldEvents
;with cte_Era (Era) as
(select case when year(EventDate)<1900 then '19th Century and earlier' when year(EventDate)<2000 then '20th Century' else '21st Century' end Era
from tblEvent)
select Era, count(Era) 'Number of Events' from cte_Era group by Era

--The aim of this exercise is to list out all the continents which have: At least 3 countries; but also At most 10 events.
use WorldEvents
;with cte_ManyCountries (ContinentName) as
(select ContinentName from tblContinent ct inner join tblCountry cy on ct.ContinentID=cy.ContinentID group by ContinentName having count(CountryName)>=3),
cte_FewEvents (ContinentName) as
(select ContinentName from tblContinent ct inner join tblCountry cy on ct.ContinentID=cy.ContinentID inner join tblEvent e on cy.CountryID=e.CountryID
group by ContinentName having count(EventID)<10)
select * from cte_ManyCountries intersect select * from cte_FewEvents

/*The aim of this exercise is to show a list of all of the enemies appearing in Doctor Who episodes featuring Rose Tyler, but not David Tennant.
First create a query to show the episode id numbers for the 13 episodes which feature Rose Tyler as a companion, but not David Tennant as the Doctor.
Linking to this as a CTE, show the 8 enemies which appear in these episodes (some more than once):*/
use DoctorWho
;with cte_EpisodeIds (EpisodeId) as
(select e.EpisodeId from tblEpisode e inner join tblDoctor d on e.DoctorId=d.DoctorId inner join tblEpisodeCompanion ec on e.EpisodeId=ec.EpisodeId
inner join tblCompanion c on ec.CompanionId=c.CompanionId where CompanionName='Rose Tyler' and DoctorName<>'David Tennant')
select distinct EnemyName from tblEnemy ey inner join tblEpisodeEnemy ee on ey.EnemyId=ee.EnemyId inner join tblEpisode e on ee.EpisodeId=e.EpisodeId
inner join cte_EpisodeIds cte on cte.EpisodeId=e.EpisodeId

/*This exercise shows how you can use a CTE to make a complicated question simple, by dividing it into two or more parts.
First create a query to list out for each event id the positions (if any) of the words this and that:*/
use WorldEvents
;with cte_ThisAndThat as
(select EventID, charindex('this',EventDetails,1) 'ThisPosition', charindex('that',EventDetails,1) 'ThatPosition' from tblEvent where
charindex('this',EventDetails,1)>0 and charindex('this',EventDetails,1)<charindex('that',EventDetails,1))
select EventName, EventDate from tblEvent e inner join cte_ThisAndThat cte on e.EventID=cte.EventID

/*The aim of this exercise is to use a CTE to hold some data, before joining another table to your CTE. Start by selecting only events which
start with a letter between A and M. Now turn this SELECT statement into a CTE called First_Half_CTE.
Now extend your query to join the tblCategory table to the CTE in the same way as you would join a normal table:*/
use WorldEvents
;with cte_FirstHalf as
(select EventName, CategoryId from tblEvent where left(EventName,1) between 'A' and 'M')
select CategoryName, EventName from cte_FirstHalf cte inner join tblCategory c on cte.CategoryID=c.CategoryID

/*The aim of this exercise is to use a derived table to hold data before joining this another table. Start by selecting only events which end with
a letter between N and Z. Now turn this select into a derived table called Second_Half_Derived.
Now join tblCountry to the derived table as you would for a normal table:*/
use WorldEvents
select CountryName, EventName from (select EventName, CountryId from tblEvent where right(EventName,1) between 'N' and 'Z') Second_Half_Derived
inner join tblCountry c on Second_Half_Derived.CountryID=c.CountryID

/*The aim of this exercise is to use CTEs to answer the following questions:
What to do																										Returns
Get a list of those events which contain none of the letters in the word OWL									3 rows
Use this to get a list of all of those events which take place in the countries for the events in list 1.		9 rows
Get a third list of all of the events which share the same categories as any of the events in the second list.	116 rows*/
/*use WorldEvents
select EventName from tblEvent te inner join tblCountry tc on te.CountryID=tc.CountryID where CountryName in (select distinct CountryName from
tblCountry c inner join tblEvent e on c.CountryID=e.CountryID where EventName in (select EventName from tblEvent where EventName not like '%[owl]%'))*/
--
--
--
--
--

/*The Carnival database contains a table called tblMenu. This contains all of the menus for a website. Each menu has an id number, and also contains
within its record the id of its parent. Use a recursive CTE based on this table to show all of the menus, with breadcrumbs:*/
--
--
--
--
--

/*Create two CTEs in the same query as follows:
CTE				What it should list out
TopCountries	The ids of the 3 countries with the most events (use TOP 3)
TopCategories	The ids of the 3 categories with the most events (use TOP 3 again)
Use these to show all possible combinations in a final SELECT statement. Now, use this to show the number of events for each combination*/
use WorldEvents
;with cte_TopCountries as
(select top 3 c.CountryID from tblCountry c inner join tblEvent e on c.CountryID=e.CountryID group by c.CountryID order by count(EventID) desc),
cte_TopCategories as
(select top 3 cy.CategoryID from tblCategory cy inner join tblEvent e on cy.CategoryID=e.CategoryID group by cy.CategoryID order by count(EventID) desc)
select cte_TopCountries.CountryID, cte_TopCategories.CategoryId from cte_TopCountries cross join cte_TopCategories

;with cte_TopCountries as
(select top 3 c.CountryID from tblCountry c inner join tblEvent e on c.CountryID=e.CountryID group by c.CountryID order by count(EventID) desc),
cte_TopCategories as
(select top 3 cy.CategoryID from tblCategory cy inner join tblEvent e on cy.CategoryID=e.CategoryID group by cy.CategoryID order by count(EventID) desc)
select CountryName, CategoryName, count(EventId) 'Number of Events' from tblEvent e inner join tblCountry c on e.CountryID=c.CountryID inner join
tblCategory cy on e.CategoryID=cy.CategoryID inner join cte_TopCountries tc on e.CountryID=tc.CountryID inner join cte_TopCategories tcy on
e.CategoryID=tcy.CategoryID group by CountryName, CategoryName order by [Number of Events] desc

--Create a query which lists the David Tennant episodes for which none of the enemies appear in any non-David Tennant episodes
use DoctorWho
select distinct e2.EpisodeId, Title from tblEpisode e2 full join tblEpisodeEnemy ee2 on e2.EpisodeId=ee2.EpisodeId full join tblEnemy ey2 on
ee2.EnemyId=ey2.EnemyId where ey2.EnemyName in (
select distinct EnemyName from tblEnemy ey full join tblEpisodeEnemy ee on ey.EnemyId=ee.EnemyId full join tblEpisode e on ee.EpisodeId=e.EpisodeId
full join tblDoctor d on e.DoctorId=d.DoctorId where DoctorName='David Tennant' except
select distinct EnemyName from tblEnemy ey1 full join tblEpisodeEnemy ee1 on ey1.EnemyId=ee1.EnemyId full join tblEpisode e1 on ee1.EpisodeId=
e1.EpisodeId full join tblDoctor d1 on e1.DoctorId=d1.DoctorId where DoctorName<>'David Tennant'
) order by Title

/*The aim of this exercise is to list out all the categories of events which occurred in the Space country. You'll then list all of the events which
didn't occur in Space, with their country names and categories. You can then show the 8 countries which had non-Space events in the same category as
one of the Space events.*/
use WorldEvents
select distinct CountryName, CategoryName from tblEvent join tblCountry on tblEvent.CountryID=tblCountry.CountryID join tblCategory on
tblEvent.CategoryID=tblCategory.CategoryID except
select distinct CountryName, CategoryName from tblEvent join tblCountry on tblEvent.CountryID=tblCountry.CountryID join tblCategory on
tblEvent.CategoryID=tblCategory.CategoryID where CountryName='Space'

--
--
--
--
--

--DYNAMIC SQL

--

--PIVOTS

--

--TRIGGERS

/*The aim of this exercise is to use a trigger to write any country changes made into a separate table. Here is what the table should show if you
rename Vietnam to Viet Nam and then insert and delete the (to date) fictitious country OwlLand:*/
use WorldEvents
if not exists (select * from sysobjects where name='tblCountryChanges' and xtype='U')
create table tblCountryChanges (CountryName varchar(100), Change varchar(100))
go
create or alter trigger trg_update_tblCountry on tblCountry after update as
insert into tblCountryChanges (CountryName, Change) select CountryName, 'Previous Name' from deleted
insert into tblCountryChanges (CountryName, Change) select CountryName, 'New Name' from inserted
go
create or alter trigger trg_insert_tblCountry on tblCountry after insert as
insert into tblCountryChanges (CountryName, Change) select CountryName, 'Inserted' from inserted
go
create or alter trigger trg_delete_tblCountry on tblCountry after delete as
insert into tblCountryChanges (CountryName, Change) select CountryName, 'Deleted' from deleted
go

update tblCountry set CountryName='Viet Nam' where CountryID=10
insert into tblCountry (CountryName, ContinentID) select 'OwlLand', 3
delete tblCountry where CountryName='OwlLand'

select * from tblCountryChanges

update tblCountry set CountryName='Vietnam' where CountryID=10
truncate table tblCountryChanges

/*The aim of this exercise it to stop anyone deleting events which happened in the UK (country number 7). To do this create a trigger which operates
on the tblEvent table.*/
/*use WorldEvents
go
create or alter trigger trg_update_tblEvent on tblEvent instead of update as begin
declare @EventID int, @CountryID int
set @EventID=EventID, @CountryID=CountryID
if @CountryID!=7
delete from tblEvent where EventID=@EventID
end*/
--
--
--
--
--

--ARCHIVED

--The aim of this exercise is to be able to pass different table names to a select statement, to show different sets of rows.
use WorldEvents
go
create or alter proc usp_ChangingTables @TableName varchar(max) as
declare @SQL varchar(max)='select * from '+@TableName
exec (@SQL)
go
exec usp_ChangingTables 'tblEvent'
exec usp_ChangingTables 'tblCountry'
exec usp_ChangingTables 'tblContinent'
exec usp_ChangingTables 'tblCategory'


use WorldEvents
select top 1 * from tblCategory
select top 1 * from tblContinent
select top 1 * from tblContinentSummary
select top 1 * from tblCountry
select top 1 * from tblEvent
select top 1 * from tblFamily
select top 1 * from tblEventSummary

use DoctorWho
select top 1 * from tblAuthor
select top 1 * from tblCompanion
select top 1 * from tblDoctor
select top 1 * from tblEnemy
select top 1 * from tblEpisode
select top 1 * from tblEpisodeCompanion
select top 1 * from tblEpisodeEnemy
select top 1 * from tblProductionCompany

use Books
select * from tblAuthor
select * from tblBook
select * from tblGenre order by GenreID

use Carnival
select * from tblMenu