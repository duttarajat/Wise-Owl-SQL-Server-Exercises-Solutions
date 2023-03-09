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
select top 2 EventName 'What', EventDate 'When' from tblEvent order by EventDate
select top 2 EventName 'What', EventDate 'When' from tblEvent order by EventDate desc

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
and YEAR(EventDate)=1970

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
create or alter proc usp_CountriesAsia as select CountryName from tblCountry where ContinentID=1 order by CountryName
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
create or alter proc usp_MattSmith as select SeriesNumber Series, EpisodeNumber Episode, Title, EpisodeDate 'Date of episode', DoctorName Docter
from tblEpisode inner join tblDoctor on tblEpisode.DoctorId=tblDoctor.DoctorId where DoctorName='Matt Smith' and year(EpisodeDate)=2012
go
exec usp_MattSmith

--The aim of this exercise is to create a stored procedure called usp_AugustEvents which will show all events that occurred in the month of August:
use WorldEvents
go
create or alter proc usp_AugustEvents as select EventID, EventName, EventDetails, EventDate from tblEvent where month(EventDate)=8
go
exec usp_AugustEvents

/*Using the tblAuthor and tblEpisode tables, create a stored procedure called usp_Moffats to list out the 32 episodes written by Steven Moffat
in date order (with the most recent first):
Now amend your SQL so that it creates a different stored procedure called usp_Russell, listing out the 30 episodes penned by people called Russell:*/
use DoctorWho
go
create or alter proc usp_Moffats as
select Title from tblEpisode inner join tblAuthor on tblEpisode.AuthorId=tblAuthor.AuthorId where AuthorName='Steven Moffat' order by EpisodeDate desc
go
exec usp_Moffats
go
create or alter proc usp_Russell as select top 30 Title from tblEpisode inner join tblAuthor on tblEpisode.AuthorId=tblAuthor.AuthorId
where AuthorName like '%Russell%' order by EpisodeDate desc
go
exec usp_Russell

--Create a procedure called usp_SummariseEpisodes to show: 3 most frequently-appearing companions; then separately 3 most frequently-appearing enemies.
use DoctorWho
go
create or alter proc usp_SummariseEpisodes as
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
create or alter proc usp_CalculateAge as
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
create or alter proc usp_EventsInYear as
declare @StartDate date='1980-01-01', @EndDate date='1980-12-31'
select EventName, EventDate, CountryName from tblEvent inner join tblCountry on tblEvent.CountryID=tblCountry.CountryID
where EventDate between @StartDate and @EndDate
go
exec usp_EventsInYear

/*Write a SQL statement which brings back the top 3 events in your year of birth, in event name order. Running the SELECT statement will generate
a number of rows, but variables can only hold one. What we'd really like to do is to join the events into a single string variable:*/
use WorldEvents
go
create or alter proc usp_EventfulYear as
declare @Year int=1992, @EventfulYear varchar(100)=''
select top 3 @EventfulYear=@EventfulYear+EventName+', ' from tblEvent where year(EventDate)=@Year order by EventName
select @EventfulYear 'Eventful Year'
go
exec usp_EventfulYear

--The aim of this exercise is to use the SQL PRINT statement to show the following information about the doctor you've chosen:
use DoctorWho
go
create or alter proc usp_DoctorDetails as
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
create or alter proc usp_EnemyEpisodes @EnemyName varchar(100)='' as
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
create or alter function udf_MonthName (@MonthNo int) returns varchar(10) as begin return datename(m,'2222-'+CAST(@MonthNo as varchar(2))+'-01') end
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
go
alter table tblEpisode add NumberEnemies int
go
begin tran
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

--TEMPORARY TABLES AND TABLE VARIABLES

--The aim of this exercise is to create a temporary table called #Characters containing all of the doctors, companions and enemies in the database.
use DoctorWho
drop table if exists #tblCharacters
select CompanionId  'CharacterId', CompanionName 'CharacterName', 'Companion' 'CharacterType' into #tblCharacters from tblCompanion
set identity_insert #tblCharacters on
insert into #tblCharacters (CharacterId, CharacterName, CharacterType) select DoctorId, DoctorName, 'Doctor' from tblDoctor
insert into #tblCharacters (CharacterId, CharacterName, CharacterType) select EnemyId, EnemyName, 'Enemy' from tblEnemy
set identity_insert #tblCharacters off
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
select * from udf_ContinentSummary('Europe','May')

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
go
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
select CountryName, CategoryName from tblEvent join tblCountry on tblEvent.CountryID=tblCountry.CountryID join tblCategory on
tblEvent.CategoryID=tblCategory.CategoryID where CountryName<>'Space'
--
--
--
--
--

--DYNAMIC SQL

--The aim of this exercise is to be able to pass different table names to a select statement, to show different sets of rows.
use WorldEvents
go
create or alter proc usp_ChangingTables @TableName varchar(max) as
declare @SQL varchar(max)='select * from '+@TableName --+convert(varchar(20), getdate(),103)
exec (@SQL)
go
exec usp_ChangingTables 'tblEvent'
exec usp_ChangingTables 'tblCountry'
exec usp_ChangingTables 'tblContinent'
exec usp_ChangingTables 'tblCategory'

/*Create a procedure called usp_EpisodesSorted which takes two parameters:
Parameter	What it does						Default value
@SortColumn	The name of the column to sort by	EpisodeId
@SortOrder	The order to sort by (ASC or DESC)	ASC
Declare and build up a string variable called @sql which contains a SELECT command based on the value of these two parameters:
You should now be able to list the Doctor Who episodes in different orders!*/
use DoctorWho
go
create or alter proc usp_EpisodesSorted @SortColumn	varchar(25)='EpisodeId', @SortOrder	varchar(4)='asc' as
declare @SQL varchar(max)='select * from tblEpisode order by '+@SortColumn+' '+@SortOrder
exec (@SQL)
go
exec usp_EpisodesSorted 'EpisodeNumber', 'desc'

/*Create a comma-delimited list variable containing all of the names of events that occurred in your decade of birth. Use LEFT to remove the
extra comma, and QUOTENAME to add apostrophes. Now use this list to filter another select statement which shows all of (*) the information about
those events from the event table. You will need to use dynamic SQL:*/
/*use WorldEvents
go
declare @EventName varchar(max)=''
select @EventName=@EventName+EventName+', ' from tblEvent where year(EventDate) between 1980 and 1989
set @EventName=concat('''',replace(@EventName,', ',''','''),'''')
--set @EventName=concat('(',left(@EventName,(len(@EventName)-3)),')')
set @EventName=left(@EventName,(len(@EventName)-3))
print @EventName
--select * from tblEvent where EventName in (@EventName)*/
--
--
--
--
--

--PIVOTS

/*Create a query to show for each episode the series number, year and episode id:
Now store this in a CTE, and pivot it to show the number of episodes by year and series number for the first 5 series:*/
use DoctorWho
;with cte_YearlyEpisodes as
(select year(EpisodeDate) 'EpisodeYear', SeriesNumber, EpisodeId from tblEpisode)
select * from (select EpisodeYear, SeriesNumber, EpisodeId from cte_YearlyEpisodes) as p
pivot (count(EpisodeID) for SeriesNumber in ([1],[2],[3],[4],[5])) as p1

/*Create and set the value of a variable to hold the first word of each episode type in the tblEpisode table:
Separately, write a query to show the first word of each episode type, along with the episode's doctor name and id, and pivot this to show the following:*/
/*use DoctorWho
drop table if exists #EpisodeTypeFirstWord
select distinct left(EpisodeType,(charindex(' ',EpisodeType)-1)) 'EpisodeTypeFirstWord'
into #EpisodeTypeFirstWord from tblEpisode order by EpisodeTypeFirstWord
declare @EpisodeTypeFirstWord varchar(max)=''
select @EpisodeTypeFirstWord=@EpisodeTypeFirstWord+cast(EpisodeTypeFirstWord as varchar)+'], [' from #EpisodeTypeFirstWord
set @EpisodeTypeFirstWord='['+left(@EpisodeTypeFirstWord,len(@EpisodeTypeFirstWord)-3)
select @EpisodeTypeFirstWord
select * from (select DoctorName, left(EpisodeType,(charindex(' ',EpisodeType)-1)) [EpisodeTypeFirstWord] from tblDoctor join tblEpisode on
tblDoctor.DoctorId=tblEpisode.DoctorId) bt pivot(count(EpisodeTypeFirstWord) for EpisodeTypeFirstWord in (@EpisodeTypeFirstWord)) pt*/

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
drop table tblCountryChanges

/*The aim of this exercise it to stop anyone deleting events which happened in the UK (country number 7). To do this create a trigger which operates
on the tblEvent table.*/
/*use WorldEvents
go
create or alter trigger trg_update_tblEvent on tblEvent instead of update as begin
declare @EventID int, @CountryID int*/
--
--
--
--
--

--ARCHIVED

/*Create a query to show all the people with really long names. When you run your query a second time, it should crash because the temporary table
#BigPeople already exists. Apply error trapping at the top of the query such that: Your query attempts to delete the table
If it already exists, the table is deleted and your query prints out a message saying that this has happened
If it didn't already exist, you get a message saying that nothing was deleted*/
use Training
if object_id('tempdb..#BigPeople') is not null begin drop table #BigPeople
select 'Dropped #BigPeople' '#BigPeople Status' end else select '#BigPeople did not exist' '#BigPeople Status'
create table #BigPeople (PersonId int identity(1,1) primary key, FirstName varchar(50), LastName varchar(50))
insert into #BigPeople (FirstName, LastName) select FirstName, LastName from tblPerson where len(FirstName)+len(LastName)>20
select * from #BigPeople

/*Create a function (called udf_WeekDay?) to show the day of the week for any given date. Use your function to show the number of events for each day
of the week*/
use WorldEvents
go
create or alter function udf_WeekDay (@Date date) returns varchar(10) as
begin
return datename(WEEKDAY, @Date)
end
go
select dbo.udf_WeekDay(EventDate) 'Day of Week', count(EventDate) 'Number of Events' from tblEvent group by cube (dbo.udf_WeekDay(EventDate)) order by
'Number of Events' desc

--Create a function called ufn_TableCourses to return a table of all of the courses which start and finish between two specified dates
use Training
go
create or alter function ufn_TableCourses (@SDate datetime2, @EDate datetime2) returns table as return
select ScheduleId, CourseName, StartDate from tblCourse join tblSchedule on tblCourse.CourseId=tblSchedule.CourseId where StartDate between @SDate and @EDate
go
select * from ufn_TableCourses ('01/01/2010', '01/31/2010') order by StartDate

/* Create a query to list out the following columns from the tblEvent table: EventName, EventDate
Your rows should appear in date order, with the most recent event coming first.*/
use HistoricalEvents
select EventName, EventDate from tblEvent order by EventDate desc

--Create a query using an inner join and table aliases to list out the non-European countries.
use HistoricalEvents
select CountryName, ContinentName from tblCountry cy join tblContinent ct on cy.ContinentId=ct.ContinentId where ContinentName<>'Europe'

--Create a query to show the number of events for each country (with the most "eventful" country coming at the top of the list)
use HistoricalEvents
select CountryName 'Country', count(tblEvent.EventName) 'NumberEvents' from tblCountry
join tblEvent on tblCountry.CountryId=tblEvent.CountryId group by CountryName order by NumberEvents desc

/*Create a stored procedure called usp_WebsitesByCategory which takes a single parameter - the name of a category - and displays all of the websites
which belong to that category.*/
use Websites
go
if exists (select name from sys.objects where type='P' and name='usp_WebsitesByCategory')
drop proc usp_WebsitesByCategory
go
create proc usp_WebsitesByCategory (@WebsiteName varchar(100)) as
select Name 'Name of website', Category from Data_at_14_Jan_2010 where Category=@WebsiteName order by 'Name of website'
go
exec usp_WebsitesByCategory[Search engine]
exec usp_WebsitesByCategory[Blogs]
exec usp_WebsitesByCategory[Finance]

/*We want to create a query which shows all companies which either are in the retail sector or which have more than 12 people working there.
To do this, first select all of the companies in the retail sector (there are only 2) into a new temporary table called #Org:
Now add code to insert all companies employing more than 12 people into the same table (you could use a subquery to do this):
Select all of the records from the temporary table that you've compiled.*/
use Training
go
drop table if exists #Org
select OrgId, OrgName into #Org from tblOrg join tblSector on tblOrg.SectorId=tblSector.SectorId where SectorName='Retail'
insert into #Org select o.OrgId, OrgName from tblOrg o where (select count(PersonId) from tblPerson p where p.OrgId=o.OrgId) >12
select OrgId, OrgName from #Org order by OrgId

/*Create a new query, and within this create a view called vw_SingleYear to show all those events occurring in 2000. Execute this query, then right-click 
on your Views to refresh them. You should now see your new view! Run this view - it should show 8 events. Right-click on the view to modify its design,
and use the View Design window to change the criteria so that you show the events in 2001 instead (there should be 7 of them).*/
use HistoricalEvents
go
create or alter view vw_SingleYear as select EventName, EventDate from tblEvent where year(EventDate)=2000
go
select * from vw_SingleYear

/*Create a function called udf_EndDate which takes in: The start date of a course; and The number of days it lasts. Your function should then return the
end date of the course. Incorporate your function within a query to show the start and end dates of all courses which start and end within January 2010.*/
use Training
go
create or alter function udf_EndDate (@SDate date, @NoDays int) returns date as 
begin
return dateadd(day,@NoDays-1,@SDate)
end
go
select CourseName 'Course Name', convert(varchar,StartDate,103) 'Start Date', convert(varchar,dbo.udf_EndDate(StartDate,NumberDays),103) 'End Date'
from tblSchedule join tblCourse on tblSchedule.CourseId=tblCourse.CourseId where year(StartDate)=2010 and month(StartDate)=1

--Create a query to show the name of each event, together with the length of its description, sorted so that the longest description appears first
use HistoricalEvents
select EventName, EventDate, len(Description) 'Length of Description' from tblEvent order by 'Length of Description' desc

/*Create the following query, using:
CONVERT to convert the date of each event to a more readable format; and
DATEDIFF to show the difference between each event's date and today in years*/
use HistoricalEvents
select EventName, convert(varchar,EventDate,103) 'Date of Event', datediff(year,EventDate,getdate()) 'Years Ago' from tblEvent order by EventDate desc

--Use a left outer join to show all of the continents with no matching countries
use HistoricalEvents
select distinct ContinentName 'Continent' from tblContinent left join tblCountry on tblContinent.ContinentId=tblCountry.ContinentId
group by ContinentName having count(CountryName)=0

/*Create a query listing out the event date and event name for all German events (ie for all events where the CountryId equals 7)
Now amend your WHERE clause so that you only see events which took place in Germany in the 1940s (ie where the EventDate column lies between 
1st January 1940 and 31st December 1949)*/
use HistoricalEvents
select EventDate, EventName from tblEvent where CountryId=7
select EventDate, EventName from tblEvent where CountryId=7 and (year(EventDate) between 1940 and 1949)

--Write a query which uses a cursor to step through the trainers one by one in alphabetical order, printing out the details for each
--use Training
--
--
--
--
--

/*Design a view to show all of the events occurring in Africa, in date order. Run your view - it should return 3 events only. Save this view as vw_Africa.
Right-click on the view to script it to a new window. Change the script in two ways:
Firstly, so that it creates a new view called vw_AfricaAsia, rather than altering the existing one; and
Secondly, so that it shows the events in Africa or Asia. Run this script, then close down its window. 
Refresh your list of views, and run your new vw_AfricaAsia view to show that it returns 23 events.*/
use HistoricalEvents
go
create or alter view vw_Africa as
select top 100 percent EventName, EventDate from tblEvent join tblCountry on tblEvent.CountryId=tblCountry.CountryId join tblContinent on tblCountry.ContinentId=
tblContinent.ContinentId where ContinentName='Africa' order by EventDate
go
select * from vw_Africa
select * from vw_AfricaAsia

/*Create a query which lists out the top 10 websites in the UK (ie ordered by AlexaRankUk, where the AlexaRankUk column is not null)
Now create a stored procedure from this query called usp_ListTopWebsites. Execute your stored procedure to check that it gives the same answer.
Alter your stored procedure (change the word CREATE to ALTER) so that it lists out the top 5 websites, not the top 10.*/
use Websites
go
create or alter proc usp_ListTopWebsites as
select top 10 WebsiteName 'Website', AlexaRankUk 'Rank' from tblWebsite where AlexaRankUk is not null order by AlexaRankUk
go
exec usp_ListTopWebsites
go
alter proc usp_ListTopWebsites as
select top 5 WebsiteName 'Website', AlexaRankUk 'Rank' from tblWebsite where AlexaRankUk is not null order by AlexaRankUk
go
exec usp_ListTopWebsites
go

--Create a stored procedure called usp_EventsBetweenDates, to list all of the events between two given dates.
use HistoricalEvents
go
create or alter proc usp_EventsBetweenDates (@Sdate date, @EDate date) as
select EventName 'Name of Event', convert(varchar,EventDate,103) 'Date of Event' from tblEvent where EventDate between @Sdate and @EDate
go
exec usp_EventsBetweenDates '01-01-1970', '12/31/1970'
go

--Create a query/subquery showing all of the events which happened after the last European Union event.
use HistoricalEvents
select EventName from tblEvent where EventDate > (select max(EventDate) from tblEvent join tblCountry on tblEvent.CountryId=tblCountry.CountryId where 
CountryName='European Union')

/*The aim of this exercise is to create a table variable holding all of those course ids where the course is either:
About C#; or Given by Gabriella Montez (the techiest trainer). To do this, first declare a table variable called @TechieCourses to hold one column only - 
each course's ScheduleId. Insert into this table all of those courses which have C# in the course name. Now insert into the same table all those courses
where the TrainerIds column contains number 2936 (that's Gabriella). To do this, add a comma to the start and end of each of the things you're comparing.
Create a SELECT statement joining your temporary table to the table of courses to show your results in course date order.*/
use Training
declare @TechieCourses table (CourseID int)
insert into @TechieCourses select CourseId from tblCourse where CourseName like '%C#' union
select tblCourse.CourseId from tblCourse join tblSchedule on tblCourse.CourseId=tblSchedule.CourseId where TrainerIds like '%2936%'
select * from @TechieCourses

--Create a query to show a list of the countries in the tblCountry table in reverse alphabetical order. Where a country has no continent id, replace this with 0
use HistoricalEvents
select CountryId, CountryName, isnull(ContinentId,0) ContinentId from tblCountry order by CountryName desc
--OR
select CountryId, CountryName, coalesce(ContinentId,0) ContinentId from tblCountry order by CountryName desc

/*Create a query to show the ids of the people who have attended 6 or more courses
Now turn this into a longer query to show the course names that these people have attended, using a CTE*/
use Training
;with cteImpPeople as (
select tblPerson.Personid from tblPerson join tblDelegate on tblPerson.Personid=tblDelegate.PersonId group by tblPerson.Personid having count(DelegateId)>5)
select cteImpPeople.Personid, DelegateId, CourseName from cteImpPeople join tblDelegate on cteImpPeople.Personid=tblDelegate.PersonId join tblSchedule on
tblDelegate.ScheduleId=tblSchedule.ScheduleId join tblCourse on tblSchedule.CourseId=tblCourse.CourseId

--Write out a SELECT statement to list out the names from tblDoctor in date of birth order
use DoctorWho
select DoctorId, DoctorName, BirthDate from tblDoctor order by BirthDate

/*Create a simple query to show the number of people who still work at their companies. Now, by declaring and using two variables (called @NumberCurrent and
@NumberObsolete) create a query to show how many people there are in the database for each of the two statuses - Current and Obsolete*/
use Training
declare @NumberCurrent int, @NumberObsolete int
select @NumberCurrent=count(*) from tblPerson join tblPersonStatus on tblPerson.PersonStatusId=tblPersonStatus.PersonStatusId where PersonStatusName='Current'
select @NumberObsolete=count(*) from tblPerson join tblPersonStatus on tblPerson.PersonStatusId=tblPersonStatus.PersonStatusId where PersonStatusName='Obsolete'
print 'Left: '+cast(@NumberObsolete as varchar)+', Current: '+cast(@NumberCurrent as varchar)

--Import the query called Extra text function. If you try running this query, it falls over - that's because the ufn_ExtraText function doesn't yet exist!
use HistoricalEvents
go
create or alter function ufn_ExtraText (@EventName varchar(510), @Description varchar(510)) returns varchar(1025) as
begin
return (case when len(@Description)>len(@EventName) then concat(@EventName,': ',@Description) else @Description end)
end
go
select EventName, Description, dbo.ufn_ExtraText(EventName,Description) 'Extra Text' from tblEvent order by 'Extra Text' desc

--Create a function called ufn_NiceDate to return a neatly formatted date: Your function should format dates as DAYNAME DAYNUMBER MONTHNAME YEARNUMBER
use HistoricalEvents
go
create or alter function ufn_NiceDate (@IDate date) returns varchar(max) as
begin
return datename(weekday,@IDate)+' '+cast(datepart(day,@IDate) as varchar)+' '+datename(month,@IDate)+' '+cast(datepart(year,@IDate) as varchar)
end
go
select EventName, EventDate, dbo.ufn_NiceDate(EventDate) 'Nice Date' from tblEvent order by EventDate desc

/*The aim of this exercise is to create a temporary table of all of the actors and directors born in 1969. To do this, first create a command to select all of the actors born in 1969
into a new temporary table. Now add a command to insert all of the directors born in 1969 into the temporary table.*/
use Movies
drop table if exists #FlowerChildren
create table #FlowerChildren (FlowerChildName nvarchar(510), Profession varchar(10), DOB datetime)
insert into #FlowerChildren select ActorName, 'Actor', ActorDOB from tblActor where year(ActorDOB)=1969
insert into #FlowerChildren select DirectorName, 'Director', DirectorDOB from tblDirector where year(DirectorDOB)=1969
select * from #FlowerChild*ren order by DOB
--OR Simply using SET operation:
use Movies
select ActorName 'FlowerChildName', 'Actor' 'Profession', ActorDOB 'DOB' from tblActor where year(ActorDOB)=1969 union
select DirectorName, 'Director', DirectorDOB from tblDirector where year(DirectorDOB)=1969 order by DOB

/*Create a new database called Historical_Events:
tblCountry, to hold various countries around the world
tblEvent, to hold famous dates in history (including the id number of the country in which they occurred), and link them
Each country can have many different historical events. Enter a few of the great dates in history (your birthday should be one of them).*/
use master
go

if exists(select name from sys.databases where name='Historical_Events')
begin
use Historical_Events
drop table if exists tblEvent
drop table if exists tblCountry
use master
drop database Historical_Events
end
go

create database Historical_Events
go
use Historical_Events
go
create table tblCountry 
(
	CountryId int identity (1,1) not null
	, CountryName varchar(255)
	, constraint [PK_tblCountry] primary key clustered (CountryId asc) on [PRIMARY]
)
go

set nocount on
go

insert into tblCountry
(
	CountryName
)
	select 'Afghanistan' union all
	select 'Albania' union all
	select 'Algeria' union all
	select 'Andorra' union all
	select 'Angola' union all
	select 'Antigua and Barbuda' union all
	select 'Argentina' union all
	select 'Armenia' union all
	select 'Australia' union all
	select 'Austria' union all
	select 'Azerbaijan' union all
	select 'Bahamas' union all
	select 'Bahrain' union all
	select 'Bangladesh' union all
	select 'Barbados' union all
	select 'Belarus' union all
	select 'Belgium' union all
	select 'Belize' union all
	select 'Benin' union all
	select 'Bhutan' union all
	select 'Bolivia' union all
	select 'Bosnia and Herzegovina' union all
	select 'Botswana' union all
	select 'Brazil' union all
	select 'Brunei' union all
	select 'Bulgaria' union all
	select 'Burkina Faso' union all
	select 'Burundi' union all
	select 'Côte d ''Ivoire' union all
	select 'Cabo Verde' union all
	select 'Cambodia' union all
	select 'Cameroon' union all
	select 'Canada' union all
	select 'Central African Republic' union all
	select 'Chad' union all
	select 'Chile' union all
	select 'Colombia' union all
	select 'Comoros' union all
	select 'Congo (Congo-Brazzaville)' union all
	select 'Costa Rica' union all
	select 'Croatia' union all
	select 'Cuba' union all
	select 'Cyprus' union all
	select 'Czechia (Czech Republic)' union all
	select 'Democratic Republic of the Congo' union all
	select 'Denmark' union all
	select 'Djibouti' union all
	select 'Dominica' union all
	select 'Dominican Republic' union all
	select 'Ecuador' union all
	select 'Egypt' union all
	select 'El Salvador' union all
	select 'Equatorial Guinea' union all
	select 'Eritrea' union all
	select 'Estonia' union all
	select 'Eswatini (fmr. "Swaziland")' union all
	select 'Ethiopia' union all
	select 'Fiji' union all
	select 'Finland' union all
	select 'France' union all
	select 'Gabon' union all
	select 'Gambia' union all
	select 'Georgia' union all
	select 'Germany' union all
	select 'Ghana' union all
	select 'Greece' union all
	select 'Grenada' union all
	select 'Guatemala' union all
	select 'Guinea' union all
	select 'Guinea-Bissau' union all
	select 'Guyana' union all
	select 'Haiti' union all
	select 'Holy See' union all
	select 'Honduras' union all
	select 'Hungary' union all
	select 'Iceland' union all
	select 'India' union all
	select 'Indonesia' union all
	select 'Iran' union all
	select 'Iraq' union all
	select 'Ireland' union all
	select 'Israel' union all
	select 'Italy' union all
	select 'Jamaica' union all
	select 'Japan' union all
	select 'Jordan' union all
	select 'Kazakhstan' union all
	select 'Kenya' union all
	select 'Kiribati' union all
	select 'Kuwait' union all
	select 'Kyrgyzstan' union all
	select 'Laos' union all
	select 'Latvia' union all
	select 'Lebanon' union all
	select 'Lesotho' union all
	select 'Liberia' union all
	select 'Libya' union all
	select 'Liechtenstein' union all
	select 'Lithuania' union all
	select 'Luxembourg' union all
	select 'Madagascar' union all
	select 'Malawi' union all
	select 'Malaysia' union all
	select 'Maldives' union all
	select 'Mali' union all
	select 'Malta' union all
	select 'Marshall Islands' union all
	select 'Mauritania' union all
	select 'Mauritius' union all
	select 'Mexico' union all
	select 'Micronesia' union all
	select 'Moldova' union all
	select 'Monaco' union all
	select 'Mongolia' union all
	select 'Montenegro' union all
	select 'Morocco' union all
	select 'Mozambique' union all
	select 'Myanmar (formerly Burma)' union all
	select 'Namibia' union all
	select 'Nauru' union all
	select 'Nepal' union all
	select 'Netherlands' union all
	select 'New Zealand' union all
	select 'Nicaragua' union all
	select 'Niger' union all
	select 'Nigeria' union all
	select 'North Korea' union all
	select 'North Macedonia' union all
	select 'Norway' union all
	select 'Oman' union all
	select 'Palau' union all
	select 'Palestine State' union all
	select 'Panama' union all
	select 'Papua New Guinea' union all
	select 'Paraguay' union all
	select 'Peru' union all
	select 'Philippines' union all
	select 'Poland' union all
	select 'Portugal' union all
	select 'Qatar' union all
	select 'Romania' union all
	select 'Russia' union all
	select 'Rwanda' union all
	select 'Saint Kitts and Nevis' union all
	select 'Saint Lucia' union all
	select 'Saint Vincent and the Grenadines' union all
	select 'Samoa' union all
	select 'San Marino' union all
	select 'Sao Tome and Principe' union all
	select 'Saudi Arabia' union all
	select 'Senegal' union all
	select 'Serbia' union all
	select 'Seychelles' union all
	select 'Sierra Leone' union all
	select 'Singapore' union all
	select 'Slovakia' union all
	select 'Slovenia' union all
	select 'Solomon Islands' union all
	select 'Somalia' union all
	select 'South Africa' union all
	select 'South Korea' union all
	select 'South Sudan' union all
	select 'Spain' union all
	select 'Sri Lanka' union all
	select 'Sudan' union all
	select 'Suriname' union all
	select 'Sweden' union all
	select 'Switzerland' union all
	select 'Syria' union all
	select 'Tajikistan' union all
	select 'Tanzania' union all
	select 'Thailand' union all
	select 'Timor-Leste' union all
	select 'Togo' union all
	select 'Tonga' union all
	select 'Trinidad and Tobago' union all
	select 'Tunisia' union all
	select 'Turkey' union all
	select 'Turkmenistan' union all
	select 'Tuvalu' union all
	select 'Uganda' union all
	select 'Ukraine' union all
	select 'United Arab Emirates' union all
	select 'United Kingdom' union all
	select 'United States of America' union all
	select 'Uruguay' union all
	select 'Uzbekistan' union all
	select 'Vanuatu' union all
	select 'Venezuela' union all
	select 'Vietnam' union all
	select 'Yemen' union all
	select 'Zambia' union all
	select 'Zimbabwe'
go

create table tblEvent
(
	EventId int identity (1,1) not null
	, EventName varchar(255) not null
	, EventDate datetime2 not null
	, Description varchar(510) not null
	, CountryId int not null
	, constraint PK_tblEvent primary key clustered (EventId asc) on [PRIMARY]
	, constraint FK_tblEvent_tblCountry foreign key (CountryId) references tblCountry(CountryId)
)
go

set identity_insert tblEvent on
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (1, N'VE Day', CAST(0x000040B300000000 AS DateTime), N'VE Day', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (2, N'Channel Islands liberated', CAST(0x000040B400000000 AS DateTime), N'Channel Islands liberated', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (3, N'UN Charter signed', CAST(0x000040E400000000 AS DateTime), N'UN Charter signed, in San Francisco', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (4, N'First ever atomic bomb exploded', CAST(0x000040F800000000 AS DateTime), N'First ever atomic bomb exploded in a test in New Mexico (although there were other forms of atomic device before that, such as the Pile at Stagg Field, first critical on 2nd Dec 1942)', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (5, N'Labour win UK General Election', CAST(0x0000410200000000 AS DateTime), N'Labour win UK General Election – Churchill out of office', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (6, N'BBC Light Programme starts', CAST(0x0000410500000000 AS DateTime), N'BBC Light Programme starts', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (7, N'Atomic bomb dropped on Hiroshima', CAST(0x0000410D00000000 AS DateTime), N'Atomic bomb dropped on Hiroshima', 12)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (8, N'Atomic bomb dropped on Nagasaki', CAST(0x0000411000000000 AS DateTime), N'Atomic bomb dropped on Nagasaki', 12)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (9, N'VJ Day', CAST(0x0000411600000000 AS DateTime), N'VJ Day', 12)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (10, N'Japanese surrender signed aboard', CAST(0x0000412800000000 AS DateTime), N'Japanese surrender was signed aboard USS Missouri', 12)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (11, N'UN founded', CAST(0x0000415C00000000 AS DateTime), N'United Nations Organisation comes into existence (charter ratified by the five permanent members of the Security Council – Republic of China, France, Soviet Union, United Kingdom, and United States – and by a majority of the other 46 signatories)', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (12, N'UNESCO founded', CAST(0x0000416700000000 AS DateTime), N'UNESCO founded', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (13, N'Bermuda Triangle legend starts', CAST(0x0000418600000000 AS DateTime), N'Loss of ''Flight 19'' on a training exercise starts the Bermuda Triangle legend', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (14, N'World Bank established', CAST(0x0000419C00000000 AS DateTime), N'World Bank established', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (15, N'First civil flight from Heathrow Airport', CAST(0x000041A100000000 AS DateTime), N'First civil flight from Heathrow Airport', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (16, N'Bank of England nationalised', CAST(0x000041DC00000000 AS DateTime), N'Bank of England nationalised', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (17, N'Iron Curtain used', CAST(0x000041E000000000 AS DateTime), N'Churchill uses the term ''Iron Curtain'' in a speech in Missouri', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (18, N'US starts nuclear tests', CAST(0x0000426E00000000 AS DateTime), N'US starts nuclear tests at Bikini Atoll – hence the name adopted for the garment which ''reveals the most potent forces of nature''!', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (19, N'Start of Dick Barton on radio', CAST(0x000042B800000000 AS DateTime), N'Start of Dick Barton, Special Agent on BBC radio – until March 1951', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (20, N'First session of UN', CAST(0x000042C800000000 AS DateTime), N'First session of new United Nations Organisation held, in Flushing Meadow, New York', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (21, N'Coal Mines nationalised', CAST(0x0000430E00000000 AS DateTime), N'Coal Mines nationalised', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (22, N'International Organization for Standardization (ISO) founded', CAST(0x0000434300000000 AS DateTime), N'International Organization for Standardization (ISO) founded', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (23, N'International Monetary Fund begins', CAST(0x0000434900000000 AS DateTime), N'International Monetary Fund begins financial operations', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (24, N'School leaving age raised to 15', CAST(0x0000436800000000 AS DateTime), N'School leaving age raised to 15 in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (25, N'India gains independence', CAST(0x000043EF00000000 AS DateTime), N'India gains independence: sub-continent partitioned to form India (Secular, Hindu majority) and Pakistan (Islamic)', 8)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (26, N'CSound barrier broken', CAST(0x0000442C00000000 AS DateTime), N'Chuck Yeager first to break the sound barrier', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (27, N'British military occupation ends in Iraq', CAST(0x0000443800000000 AS DateTime), N'British military occupation ends in Iraq', 9)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (28, N'Marriage of Princess Elizabeth', CAST(0x0000445100000000 AS DateTime), N'Marriage of Princess Elizabeth (later Elizabeth II) and Philip Mountbatten in Westminster Abbey', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (29, N'British Railways nationalised', CAST(0x0000447B00000000 AS DateTime), N'British Railways nationalised', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (30, N'Gandhi assassinated in Delhi', CAST(0x0000449800000000 AS DateTime), N'Gandhi assassinated in Delhi', 8)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (31, N'Marshall Plan signed', CAST(0x000044D800000000 AS DateTime), N'Marshall Plan signed by President Truman for rebuilding the allied countries of Europe (aid had started in 1947 and ended in 1951)', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (32, N'Berlin airlift starts', CAST(0x0000453100000000 AS DateTime), N'Berlin airlift starts (to 30 Sep 1949)', 7)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (33, N'NHS founded', CAST(0x0000453500000000 AS DateTime), N'National Health Service (NHS) begins in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (34, N'London Olympics begin', CAST(0x0000454D00000000 AS DateTime), N'London Olympics begin', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (35, N'Clothes rationing ends', CAST(0x0000463200000000 AS DateTime), N'Clothes rationing ends in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (36, N'NATO founded', CAST(0x0000464600000000 AS DateTime), N'Twelve nations sign The North Atlantic Treaty creating NATO', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (37, N'Russians lift the Berlin blockade', CAST(0x0000466C00000000 AS DateTime), N'Russians lift the Berlin blockade', 13)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (38, N'Berlin airlift ends', CAST(0x000046F900000000 AS DateTime), N'Berlin airlift ends', 7)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (39, N'Points rationing ends in Britain', CAST(0x000047E000000000 AS DateTime), N'Points rationing ends in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (40, N'Petrol rationing ends in Britain', CAST(0x000047E700000000 AS DateTime), N'Petrol rationing ends in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (41, N'Korean War starts', CAST(0x0000480500000000 AS DateTime), N'Korean War starts (to 27 Jul 1953)', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (42, N'Andy Pandy first seen on TV', CAST(0x0000481500000000 AS DateTime), N'Andy Pandy first seen on BBC TV', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (43, N'Soap rationing ends in Britain', CAST(0x0000485100000000 AS DateTime), N'Soap rationing ends in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (44, N'Peak District is the first National Park', CAST(0x000048BF00000000 AS DateTime), N'The Peak District becomes the Britain''s first National Park', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (45, N'Festival of Britain', CAST(0x0000493D00000000 AS DateTime), N'Festival of Britain and Royal Festival Hall open on South Bank, London', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (46, N'First Goon Show broadcast', CAST(0x0000495600000000 AS DateTime), N'First Goon Show broadcast', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (47, N'Electricity first produced by nuclear power', CAST(0x00004A2400000000 AS DateTime), N'Electricity first produced by nuclear power, from Experimental Breeder Reactor I in Idaho (see 1962)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (48, N'George VI dies; Elizabeth II queen', CAST(0x00004A5400000000 AS DateTime), N'George VI dies; Elizabeth II queen, returns from Kenya', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (49, N'Identity Cards abolished', CAST(0x00004A6300000000 AS DateTime), N'Identity Cards abolished in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (50, N'Utility furniture and clothing scheme ends', CAST(0x00004A7C00000000 AS DateTime), N'Utility furniture and clothing scheme ends', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (51, N'First commercial jet airliner service launched', CAST(0x00004AAA00000000 AS DateTime), N'First commercial jet airliner service launched, by BOACComet between London and Johannesburg', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (52, N'Last tram runs in London', CAST(0x00004AEA00000000 AS DateTime), N'Last tram runs in London (Woolwich to New Cross)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (53, N'Lynmouth flood disaster', CAST(0x00004B1400000000 AS DateTime), N'Lynmouth flood disaster', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (54, N'DH110 crashes at Farnborough', CAST(0x00004B2900000000 AS DateTime), N'DH110 crashes at Farnborough Air Show, 26 killed', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (55, N'John Cobb killed', CAST(0x00004B4000000000 AS DateTime), N'John Cobb killed in attempt on world water speed record on Loch Ness', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (56, N'End of tea rationing in Britain', CAST(0x00004B4400000000 AS DateTime), N'End of tea rationing in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (57, N'Harrow & Wealdstone rail crash', CAST(0x00004B4900000000 AS DateTime), N'Harrow & Wealdstone rail crash, 112 killed', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (58, N'First H Bomb exploded', CAST(0x00004B6100000000 AS DateTime), N'The first H-bomb ever (''Mike'') was exploded by the USA – the mushroom cloud was 8 miles across and 27 miles high. The canopy was 100 miles wide. Radioactive mud fell out of the sky followed by heavy rain. 80 million tons of earth was vaporised.', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (59, N'Eisenhower is US President', CAST(0x00004B6500000000 AS DateTime), N'Eisenhower sweeps to power as US President', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (60, N'First UK singles chart', CAST(0x00004B6E00000000 AS DateTime), N'First regular UK singles chart published by the New Musical Express', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (61, N'The Mousetrap opens', CAST(0x00004B7900000000 AS DateTime), N'Agatha Christie''s The Mousetrap opens in London', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (62, N'Great smog hits London', CAST(0x00004B8200000000 AS DateTime), N'Great smog hits London', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (63, N'Floods devastate the East Coast', CAST(0x00004BBC00000000 AS DateTime), N'Said to be the biggest civil catastrophe in Britain in the 20th century – severe storm and high tides caused the loss of hundreds of lives –- effects travelled from the west coast of Scotland round to the south-east coast of England', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (64, N'Sweet rationing ends in Britain', CAST(0x00004BC100000000 AS DateTime), N'Sweet rationing ends in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (65, N'Death of Stalin', CAST(0x00004BDD00000000 AS DateTime), N'Death of Stalin', 13)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (66, N'Jonas Salk announces his polio vaccine', CAST(0x00004BF200000000 AS DateTime), N'Jonas Salk announces his polio vaccine', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (67, N'Winston Churchill knighted', CAST(0x00004C0F00000000 AS DateTime), N'Winston Churchill knighted', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (68, N'DNA helix unravelled', CAST(0x00004C1000000000 AS DateTime), N'Francis Crick and James D Watson publish the double helix structure of DNA (see 1962)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (69, N'Everest conquered by Hillary and Tensing', CAST(0x00004C3200000000 AS DateTime), N'Everest conquered by Hillary and Tensing', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (70, N'Coronation of Elizabeth II', CAST(0x00004C3600000000 AS DateTime), N'Coronation of Elizabeth II', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (71, N'End of the Korean War', CAST(0x00004C6D00000000 AS DateTime), N'End of the Korean War', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (72, N'USSR explodes Hydrogen Bomb', CAST(0x00004C7D00000000 AS DateTime), N'USSR explodes Hydrogen Bomb', 13)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (73, N'Sugar rationing ends in Britain (after nearly 14 years)', CAST(0x00004CAA00000000 AS DateTime), N'Sugar rationing ends in Britain (after nearly 14 years)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (74, N'Piltdown Man skull declared a hoax', CAST(0x00004CE200000000 AS DateTime), N'Piltdown Man skull declared a hoax by the Natural History Museum', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (75, N'Hungary wins 6-3 at Wembley Stadium', CAST(0x00004CE600000000 AS DateTime), N'Hungary becomes the first football team outside the British Isles to beat England at home, winning 6-3 at Wembley Stadium', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (76, N'First sub 4 minute mile', CAST(0x00004D8800000000 AS DateTime), N'First sub 4 minute mile (Roger Bannister, 3 mins 59.4 secs)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (77, N'Rock Around the Clock released', CAST(0x00004D8C00000000 AS DateTime), N'Bill Haley and the Comets release Rock Around the Clock', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (78, N'Food rationing officially ends in Britain', CAST(0x00004DC200000000 AS DateTime), N'Food rationing officially ends in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (79, N'BBC broadcasts its first television news bulletin', CAST(0x00004DC400000000 AS DateTime), N'BBC broadcasts its first television news bulletin', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (80, N'First atomic powered sumbmarine', CAST(0x00004E1B00000000 AS DateTime), N'First atomic powered sumbmarine USS Nautilus commissioned', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (81, N'Anthony Eden becomes Prime Minister', CAST(0x00004ED800000000 AS DateTime), N'Anthony Eden becomes Prime Minister', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (82, N'Anti-polio vaccine developed', CAST(0x00004EDD00000000 AS DateTime), N'Anti-polio vaccine developed by Jonas Salk declared safe and effective to use (available to public 1 May 1956)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (83, N'Allied occupation of Austria ends', CAST(0x00004F4700000000 AS DateTime), N'Allied occupation of Austria (after WW2) ends', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (84, N'Commercial TV starts in Britain', CAST(0x00004F8000000000 AS DateTime), N'Commercial TV starts in Britain – first advert was for Gibbs SR toothpaste – BBC Radio kills off Grace Archer in retaliation', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (85, N'Radiotelephony spelling alphabet introduced', CAST(0x0000502100000000 AS DateTime), N'Radiotelephony spelling alphabet introduced (Alpha, Bravo, etc)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (86, N'Premium Bonds first launched', CAST(0x0000505000000000 AS DateTime), N'Premium Bonds first launched – first prizes drawn on 1 Jun 1957', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (87, N'Eurovision Song Contest launched', CAST(0x0000507500000000 AS DateTime), N'The first Eurovision Song Contest is held in Lugano, Switzerland – won by the host nation', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (88, N'3rd class travel abolished on BR', CAST(0x0000507F00000000 AS DateTime), N'3rd class travel abolished on British Railways (renamed ''Third Class'' as ''Second Class'', which had been abolished in 1875 leaving just First and Third Class)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (89, N'Submarine telephone cable across the Atlantic opened', CAST(0x000050F100000000 AS DateTime), N'Submarine telephone cable across the Atlantic opened', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (90, N'Hungarians protest against Soviet occupation', CAST(0x0000510D00000000 AS DateTime), N'Hungarians protest against Soviet occupation (protest crushed on 4 Nov)', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (91, N'Britain and France invade Suez', CAST(0x0000511500000000 AS DateTime), N'Britain and France invade Suez', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (92, N'Suez canal blocked for a few months', CAST(0x0000512500000000 AS DateTime), N'Suez canal blocked for a few months (see also 1957 & 1967)', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (93, N'Harold Macmillan becomes Prime Minister', CAST(0x0000515D00000000 AS DateTime), N'Harold Macmillan becomes Prime Minister', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (94, N'BBC TV broadcasts Six-Five Special', CAST(0x0000518100000000 AS DateTime), N'BBC TV started to broadcast Six-Five Special, breaking the ''Toddlers'' Truce'' of no broadcasting 6-7pm', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (95, N'Suez canal reopened by the Egyptians', CAST(0x0000519500000000 AS DateTime), N'Suez canal reopened by the Egyptians (see 1956)', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (96, N'EEC founded', CAST(0x000051A600000000 AS DateTime), N'Treaty of Rome to create European Economic Community (EEC) of six countries: France, West Germany, Italy, Belgium, Holland and Luxembourg – became operational Jan 1958', 5)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (97, N'Post-Suez petrol rationing ends', CAST(0x000051D800000000 AS DateTime), N'Post-Suez petrol rationing ends', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (98, N'Britain explodes her first H bomb', CAST(0x000051D900000000 AS DateTime), N'Britain explodes her first hydrogen bomb, at Christmas Island', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (99, N'Premium Bonds first prizes drawn', CAST(0x000051EA00000000 AS DateTime), N'Premium Bonds first prizes drawn', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (100, N'West Side Story opens in New York', CAST(0x0000525F00000000 AS DateTime), N'West Side Story opens in New York', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (101, N'Sputnik I launched by Soviet Union', CAST(0x0000526700000000 AS DateTime), N'Sputnik I launched by Soviet Union – first artificial satellite', 13)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (102, N'Sputnik 2 launched by Soviet Union', CAST(0x0000528500000000 AS DateTime), N'Sputnik 2 launched by Soviet Union – carried a dog (''Laika'')', 13)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (103, N'Lewisham rail disaster', CAST(0x000052A400000000 AS DateTime), N'Lewisham rail disaster – 90 killed as two trains collide in thick fog and a viaduct collapses on top of them', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (104, N'Launch of Explorer 1', CAST(0x000052DE00000000 AS DateTime), N'Launch of Explorer 1 – first American satellite', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (105, N'Munich air disaster', CAST(0x000052E400000000 AS DateTime), N'Munich air disaster – Manchester United team members killed', 7)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (106, N'CND launched', CAST(0x000052F700000000 AS DateTime), N'CND launched', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (107, N'USA launches its first satellite', CAST(0x0000530B00000000 AS DateTime), N'USA launches its first satellite (Vanguard 1) – space race with the USSR begins', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (108, N'Velcro trade mark registered', CAST(0x0000534400000000 AS DateTime), N'Velcro trade mark registered', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (109, N'Charles created Prince of Wales', CAST(0x0000538E00000000 AS DateTime), N'Charles created Prince of Wales', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (110, N'USS Nautilus travels under the polar ice cap', CAST(0x0000539600000000 AS DateTime), N'USS Nautilus travels under the polar ice cap', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (111, N'Charles de Gaulle establishes Fifth Republic', CAST(0x000053D500000000 AS DateTime), N'Charles de Gaulle establishes Fifth Republic in France – and is elected President on 21 Dec', 6)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (112, N'First commercial flight of Boeing 707', CAST(0x000053EA00000000 AS DateTime), N'First commercial flight of Boeing 707 (NY to Paris)', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (113, N'Inauguration of Subscriber Trunk Dialling (STD) in Britain', CAST(0x0000541200000000 AS DateTime), N'Inauguration of Subscriber Trunk Dialling (STD) in Britain (completed in 1979)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (114, N'Preston by-pass opens', CAST(0x0000541200000000 AS DateTime), N'Preston by-pass opens – UK''s first stretch of motorway', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (115, N'Pane crash kills Buddy Holly, Ritchie Valens, and The Big Bopper', CAST(0x0000544E00000000 AS DateTime), N'''The Day The Music Died'' – plane crash kills Buddy Holly, Ritchie Valens, and The Big Bopper', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (116, N'Vanguard 2 satellite launched', CAST(0x0000545C00000000 AS DateTime), N'Vanguard 2 satellite launched – first to measure cloud-cover distribution', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (117, N'St Lawrence Seaway opens', CAST(0x0000549F00000000 AS DateTime), N'St Lawrence Seaway opens', 3)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (118, N'Empire Day becomes Commonwealth Day', CAST(0x000054BC00000000 AS DateTime), N'Empire Day becomes Commonwealth Day', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (119, N'Hawaii becomes 50th State of the USA', CAST(0x0000551500000000 AS DateTime), N'Hawaii becomes 50th State of the USA', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (120, N'USSR crash-lands unmanned Lunik on the moon', CAST(0x0000552D00000000 AS DateTime), N'USSR crash-lands unmanned Lunik on the moon', 13)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (121, N'Postcodes introduced in Britain', CAST(0x0000554000000000 AS DateTime), N'Postcodes introduced in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (122, N'First section of M1 motorway opened', CAST(0x0000555D00000000 AS DateTime), N'First section of M1 motorway opened', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (123, N'Macmillan ''wind of change'' speech in South Africa', CAST(0x000055BB00000000 AS DateTime), N'Macmillan ''wind of change'' speech in South Africa', 14)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (124, N'New £1 notes issued', CAST(0x000055E600000000 AS DateTime), N'New £1 notes issued by Bank of England', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (125, N'Last steam locomotive of BR named', CAST(0x000055E700000000 AS DateTime), N'Last steam locomotive of British Railways named', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (126, N'Francis Chichester arrives in New York', CAST(0x0000566400000000 AS DateTime), N'Francis Chichester arrives in New York aboard Gypsy Moth II (took 40 days), winning the first single-handed transatlantic yacht race which he co-founded (see 1967)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (127, N'Echo I launched', CAST(0x0000567A00000000 AS DateTime), N'Echo I, the first (passive) communications satellite, launched', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (128, N'MoT tests on motor vehicles introduced', CAST(0x0000569900000000 AS DateTime), N'MoT tests on motor vehicles introduced', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (129, N'Nikita Khrushchev disrupts the UN', CAST(0x000056AA00000000 AS DateTime), N'Nikita Khrushchev disrupts the United Nations General Assembly with a number of angry outbursts', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (130, N'HMS Dreadnought nuclear submarine launched', CAST(0x000056AC00000000 AS DateTime), N'HMS Dreadnought nuclear submarine launched', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (131, N'Lady Chatterley''s Lover case', CAST(0x000056CC00000000 AS DateTime), N'Penguin Books found not guilty of obscenity in the Lady Chatterley''s Lover case', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (132, N'Farthing ceases to be legal tender in UK', CAST(0x0000570800000000 AS DateTime), N'Farthing ceases to be legal tender in UK', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (133, N'John F Kennedy becomes US President', CAST(0x0000571B00000000 AS DateTime), N'John F Kennedy becomes US President', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (134, N'First US Polaris submarines', CAST(0x0000574A00000000 AS DateTime), N'First US Polaris submarines arrive at Holy Loch', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (135, N'Black & White £5 notes cease to be legal tender', CAST(0x0000574F00000000 AS DateTime), N'Black & White £5 notes cease to be legal tender', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (136, N'New English Bible (New Testament) published', CAST(0x0000575000000000 AS DateTime), N'New English Bible (New Testament) published', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (137, N'Yuri Gagarin first man in space', CAST(0x0000576D00000000 AS DateTime), N'Yuri Gagarin first man in space – followed shortly afterwards by Alan Shepard on 5th May', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (138, N'Census: Pop. E&W 46M, Scot 5.1M, NI 1.4M', CAST(0x0000577800000000 AS DateTime), N'Census: Pop. E&W 46M, Scot 5.1M, NI 1.4M', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (139, N'Betting shops legal in Britain', CAST(0x0000578000000000 AS DateTime), N'Betting shops legal in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (140, N'John F Kennedy announces space goal', CAST(0x0000579800000000 AS DateTime), N'John F Kennedy announces his goal to put a "man on the moon" before the end of the decade', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (141, N'Volcanic eruption on Tristan da Cunha', CAST(0x0000582200000000 AS DateTime), N'Volcanic eruption on Tristan da Cunha – whole population evacuated to Britain', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (142, N'Consecration of new Coventry Cathedral', CAST(0x0000590500000000 AS DateTime), N'Consecration of new Coventry Cathedral (old destroyed in WW2 blitz) – Britten War Requiem', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (143, N'First nuclear generated electricity', CAST(0x0000591A00000000 AS DateTime), N'First nuclear generated electricity to supplied National Grid (from Berkeley, Glos)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (144, N'Telstar launched', CAST(0x0000593300000000 AS DateTime), N'First TV transmission between US and Europe (Telstar) – first live broadcast on 23 Jul', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (145, N'Marilyn Monroe found dead', CAST(0x0000594D00000000 AS DateTime), N'Marilyn Monroe found dead', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (146, N'Cuba missile crisis', CAST(0x0000599D00000000 AS DateTime), N'Cuba missile crisis – brink of nuclear war', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (147, N'No frost-free nights in Britain till 5 Mar 1963', CAST(0x000059D800000000 AS DateTime), N'No frost-free nights in Britain till 5 Mar 1963', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (148, N'Beeching Report on British Railways', CAST(0x00005A3700000000 AS DateTime), N'Beeching Report on British Railways (the ''Beeching Axe'')', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (149, N'John Profumo resigns', CAST(0x00005A7D00000000 AS DateTime), N'Secretary of State for War John Profumo resigns in a sex scandal', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (150, N'The "red telephone" link established', CAST(0x00005A8C00000000 AS DateTime), N'The "red telephone" link established between Soviet Union and United States following the Cuban Missile Crisis', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (151, N'Minimum prison age raised to 17', CAST(0x00005AB600000000 AS DateTime), N'Minimum prison age raised to 17', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (152, N'Great Train Robbery', CAST(0x00005ABD00000000 AS DateTime), N'''Great Train Robbery'' on Glasgow to London mail train', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (153, N'Martin Luther King speech', CAST(0x00005AD100000000 AS DateTime), N'Martin Luther King gives his I have a dream speech', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (154, N'Fylingdales operational', CAST(0x00005AE500000000 AS DateTime), N'Fylingdales (Yorks) early warning system operational', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (155, N'Denning Report on Profumo affair', CAST(0x00005AED00000000 AS DateTime), N'Denning Report on Profumo affair', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (156, N'Dartford Tunnel opens', CAST(0x00005B2300000000 AS DateTime), N'Dartford Tunnel opens', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (157, N'President Kennedy assassinated', CAST(0x00005B2700000000 AS DateTime), N'President Kennedy assassinated in Dallas, Texas; Aldous Huxley died the same day', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (158, N'First episode of Dr Who', CAST(0x00005B2800000000 AS DateTime), N'First episode of Dr Who on BBC TV', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (159, N'First ''Top of the Pops''', CAST(0x00005B4F00000000 AS DateTime), N'First ''Top of the Pops'' on BBC TV', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (160, N'The Beatles arrive in the US', CAST(0x00005B7400000000 AS DateTime), N'The Beatles arrive on their first visit to the United States', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (161, N'Cassius Clay beats Sonny Liston', CAST(0x00005B8600000000 AS DateTime), N'Cassius Clay (Muhammad Ali) beats Sonny Liston', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (162, N'First Greater London Council (GLC) election', CAST(0x00005BB200000000 AS DateTime), N'First Greater London Council (GLC) election', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (163, N'BBC2 TV starts', CAST(0x00005BBE00000000 AS DateTime), N'BBC2 TV starts', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (164, N'Match of the Day starts on BBC2', CAST(0x00005C3900000000 AS DateTime), N'Match of the Day starts on BBC2', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (165, N'Forth road bridge opens', CAST(0x00005C4600000000 AS DateTime), N'Forth road bridge opens', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (166, N'The Sun newspaper founded in Britain', CAST(0x00005C5100000000 AS DateTime), N'The Sun newspaper founded in Britain, replacing the Daily Herald', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (167, N'First US raids against North Vietnam', CAST(0x00005CE200000000 AS DateTime), N'First US raids against North Vietnam', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (168, N'First walk in space', CAST(0x00005D0900000000 AS DateTime), N'Cosmonaut Aleksei Leonov becomes the first man to ''walk'' in space', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (169, N'Launch of Early Bird satellite', CAST(0x00005D1C00000000 AS DateTime), N'Launch of Early Bird commercial communications satellite', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (170, N'Winston Churchill dies', CAST(0x00005D1D00000000 AS DateTime), N'Winston Churchill dies', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (171, N'Mont Blanc road tunnel opens', CAST(0x00005D8100000000 AS DateTime), N'Mont Blanc road tunnel opens (begun in 1957)', 11)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (172, N'TV ban on cigarette advertising in Britain', CAST(0x00005D9100000000 AS DateTime), N'TV ban on cigarette advertising in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (173, N'The Beatles play at Shea Stadium', CAST(0x00005D9F00000000 AS DateTime), N'The Beatles play at Shea Stadium in New York City', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (174, N'Oil strike by BP in North Sea', CAST(0x00005DC400000000 AS DateTime), N'Oil strike by BP in North Sea (or natural gas?)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (175, N'Post Office Tower operational in London', CAST(0x00005DD500000000 AS DateTime), N'Post Office Tower operational in London', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (176, N'Death penalty for murder suspended', CAST(0x00005DE900000000 AS DateTime), N'Death penalty for murder suspended in Britain for five-year trial period, then abolished 18 Dec 1969', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (177, N'Declaration of UDI in Rhodesia', CAST(0x00005DF700000000 AS DateTime), N'Declaration of UDI in Rhodesia', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (178, N'70mph speed limit on British roads', CAST(0x00005E2000000000 AS DateTime), N'70mph speed limit on British roads', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (179, N'Soft landing on moon by unmanned Luna 9', CAST(0x00005E4B00000000 AS DateTime), N'Soft landing on moon by unmanned Luna 9 – followed by Surveyor 1', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (180, N'Australia converts from £ to $', CAST(0x00005E5600000000 AS DateTime), N'Australia converts from £ to $', 1)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (181, N'Archbishop of Canterbury meets Pope in Rome', CAST(0x00005E7B00000000 AS DateTime), N'Archbishop of Canterbury meets Pope in Rome', 11)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (182, N'The Times prints news on front page', CAST(0x00005EA400000000 AS DateTime), N'The Times begins to print news on its front page in place of classified advertisements', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (183, N'Seamen''s strike begins', CAST(0x00005EB100000000 AS DateTime), N'Seamen''s strike begins (ended 1 Jul)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (184, N'World Cup won by England at Wembley', CAST(0x00005EFC00000000 AS DateTime), N'World Cup won by England at Wembley (4-2 in extra time v West Germany)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (185, N'First Severn road bridge opens', CAST(0x00005F2400000000 AS DateTime), N'First Severn road bridge opens', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (186, N'Aberfan disaster', CAST(0x00005F4F00000000 AS DateTime), N'Aberfan disaster – slag heap slip kills 144, incl. 116 children', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (187, N'First Christmas stamps issued in Britain', CAST(0x00005F7800000000 AS DateTime), N'First Christmas stamps issued in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (188, N'Donald Campbell dies', CAST(0x00005F9A00000000 AS DateTime), N'Donald Campbell dies attempting to break his world water speed record on Conniston Water – his body and Bluebird recovered in 2002', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (189, N'Apollo launch pad test fire', CAST(0x00005FB100000000 AS DateTime), N'Three US astronauts killed in fire during Apollo launch pad test', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (190, N'Torrey Canyon oil tanker disaster', CAST(0x00005FE300000000 AS DateTime), N'Torrey Canyon oil tanker runs aground off Lands End – first major oil spill', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (191, N'Celtic win the European Cup', CAST(0x0000602700000000 AS DateTime), N'Celtic become the first British team to win the European Cup', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (192, N'Francis Chichester arrives in Plymouth', CAST(0x0000602A00000000 AS DateTime), N'Francis Chichester arrives in Plymouth after solo circumnavigation in Gipsy Moth IV (he was knighted 7th July at Greenwich by the queen using the sword with which Elizabeth I had knighted Sir Francis Drake four centuries earlier – see 1581)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (193, N'First withdrawal from a cash dispenser (ATM)', CAST(0x0000604800000000 AS DateTime), N'First withdrawal from a cash dispenser (ATM) in Britain – at Enfield branch of Barclays', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (194, N'First colour TV in Britain', CAST(0x0000604C00000000 AS DateTime), N'First colour TV in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (195, N'Public Record Act', CAST(0x0000605800000000 AS DateTime), N'Public Record Act – records now closed for only 30 years (but the census is still closed for 100 years)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (196, N'Withdrawal from East of Suez announced', CAST(0x0000605D00000000 AS DateTime), N'Withdrawal from East of Suez by mid-70s announced', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (197, N'Offshore pirate radio stations declared illegal', CAST(0x0000607800000000 AS DateTime), N'Offshore pirate radio stations declared illegal by the UK', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (198, N'Sweden changes rule of road to drive on right', CAST(0x0000608C00000000 AS DateTime), N'Sweden changes rule of road to drive on right', 16)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (199, N'QE2 launched on Clydebank', CAST(0x0000609D00000000 AS DateTime), N'QE2 launched on Clydebank', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (200, N'Queen Mary last transatlantic voyage', CAST(0x000060A400000000 AS DateTime), N'Queen Mary arrives Southampton at end of her last transatlantic voyage', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (201, N'BBC Radios 1, 2, 3 & 4 open', CAST(0x000060A700000000 AS DateTime), N'BBC Radios 1, 2, 3 & 4 open – first record played on Radio 1 was the controversial Flowers in the Rain by ''The Move''', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (202, N'Introduction of majority verdicts', CAST(0x000060AC00000000 AS DateTime), N'Introduction of majority verdicts in English courts', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (203, N'Che Guevara killed in Bolivia', CAST(0x000060B000000000 AS DateTime), N'Che Guevara killed in Bolivia – becomes a cult hero', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (204, N'Russian spacecraft Venus IV', CAST(0x000060B900000000 AS DateTime), N'Russian spacecraft Venus IV became first successful probe to perform in-place analysis of the environment of another planet', 13)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (205, N'First human heart transplant', CAST(0x000060E700000000 AS DateTime), N'First human heart transplant (in South Africa by Christiaan Barnard)', 14)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (206, N'British Standard Time introduced', CAST(0x0000613400000000 AS DateTime), N'British Standard Time introduced – Summer Time became permanent - the UK reverted to GMT in October 1971', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (207, N'London Bridge sold', CAST(0x0000617000000000 AS DateTime), N'London Bridge sold (and eventually moved to Arizona) – modern London Bridge, built around it as it was demolished, was opened in Mar 1973', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (208, N'Enoch Powell ''Rivers of Blood'' speech', CAST(0x0000617200000000 AS DateTime), N'Enoch Powell ''Rivers of Blood'' speech on immigration', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (209, N'Issue of 5p and 10p decimal coins in Britain', CAST(0x0000617500000000 AS DateTime), N'Issue of 5p and 10p decimal coins in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (210, N'Student riots in Paris', CAST(0x0000618600000000 AS DateTime), N'Student riots in Paris', 6)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (211, N'Manchester United win the European Cup', CAST(0x0000619900000000 AS DateTime), N'Manchester United first English club to win the European Cup', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (212, N'Robert F Kennedy shot', CAST(0x000061A000000000 AS DateTime), N'Robert F Kennedy shot – dies next day', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (213, N'Pope condemns birth control', CAST(0x000061D600000000 AS DateTime), N'Pope encyclical condemns all artificial forms of birth control', 11)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (214, N'Last steam passenger train service', CAST(0x000061E300000000 AS DateTime), N'Last steam passenger train service ran in Britain (Carlisle–Liverpool)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (215, N'Severe flooding in England', CAST(0x0000620600000000 AS DateTime), N'Severe flooding in England', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (216, N'Two-tier postal rate starts in Britain', CAST(0x0000620700000000 AS DateTime), N'Two-tier postal rate starts in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (217, N'Hair opens in London', CAST(0x0000621200000000 AS DateTime), N'Hair opens in London', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (218, N'Beginning of disturbances in N Ireland', CAST(0x0000621A00000000 AS DateTime), N'Beginning of disturbances in N Ireland', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (219, N'The Beatles'' last public performance', CAST(0x0000628F00000000 AS DateTime), N'The Beatles'' last public performance, on the roof of Apple Records in London', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (220, N'Maiden flight of Concorde', CAST(0x000062AE00000000 AS DateTime), N'Maiden flight of Concorde, at Toulouse', 6)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (221, N'Victoria Line tube opens in London', CAST(0x000062B300000000 AS DateTime), N'Victoria Line tube opens in London', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (222, N'Voting age lowered from 21 to 18', CAST(0x000062DC00000000 AS DateTime), N'Voting age lowered from 21 to 18', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (223, N'Maiden voyage of liner Queen Elizabeth 2 (QE2)', CAST(0x000062EB00000000 AS DateTime), N'Maiden voyage of liner Queen Elizabeth 2 (QE2)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (224, N'Investiture of Prince Charles', CAST(0x0000632700000000 AS DateTime), N'Investiture of Prince Charles as Prince of Wales at Caernarfon Castle', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (225, N'First men land on the moon', CAST(0x0000633A00000000 AS DateTime), N'Apollo 11 – First men land on the moon (Neil Armstrong & Buzz Aldrin)', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (226, N'Halfpenny ceases to be legal tender in Britain', CAST(0x0000634500000000 AS DateTime), N'Halfpenny ceases to be legal tender in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (227, N'Civil disturbances in Ulster', CAST(0x0000635300000000 AS DateTime), N'Civil disturbances in Ulster – Britain sends troops to support civil authorities', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (228, N'Woodstock Music Festival', CAST(0x0000635400000000 AS DateTime), N'Woodstock Music Festival in NY State attracts 300,000 fans', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (229, N'First episode of Monty Python'' recorded', CAST(0x0000636B00000000 AS DateTime), N'First episode of Monty Python''s Flying Circus recorded', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (230, N'50p coin introduced in Britain', CAST(0x0000639000000000 AS DateTime), N'50p coin introduced in Britain (reduced in size 1998)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (231, N'Apollo 12 – second manned landing on the moon', CAST(0x000063B400000000 AS DateTime), N'Apollo 12 – second manned landing on the moon (Charles Conrad & Alan Bean)', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (232, N'Death penalty for murder abolished in Britain', CAST(0x000063D100000000 AS DateTime), N'Death penalty for murder abolished in Britain (had already been suspended since Oct 1965)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (233, N'Publication of complete New English Bible', CAST(0x0000642900000000 AS DateTime), N'Publication of complete New English Bible', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (234, N'Apollo 13 launched', CAST(0x0000644300000000 AS DateTime), N'Apollo 13 launched – oxygen tank explosion aborted the moon landing mission two days later – successfully returned to Earth on 17 Apr', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (235, N'Decimal postage stamps first issued for sale in Britain', CAST(0x0000648600000000 AS DateTime), N'Decimal postage stamps first issued for sale in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (236, N'Edward Heath becomes Prime Minister', CAST(0x0000648800000000 AS DateTime), N'Edward Heath becomes Prime Minister', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (237, N'Damages awarded to Thalidomide victims', CAST(0x000064B100000000 AS DateTime), N'Damages awarded to Thalidomide victims', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (238, N'First Glastonbury Festival held', CAST(0x000064E400000000 AS DateTime), N'First Glastonbury Festival held', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (239, N'Ten shilling note goes out of circulation', CAST(0x0000652200000000 AS DateTime), N'Ten shilling note (50p after decimalisation) goes out of circulation in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (240, N'Divorce Reform Act (1969) comes into force', CAST(0x0000654C00000000 AS DateTime), N'Divorce Reform Act (1969) comes into force', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (241, N'Open University starts', CAST(0x0000654E00000000 AS DateTime), N'Open University starts', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (242, N'Decimalisation of coinage', CAST(0x0000657900000000 AS DateTime), N'Decimalisation of coinage in UK and Republic of Ireland', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (243, N'Internment without trial introduced in N Ireland', CAST(0x0000662800000000 AS DateTime), N'Internment without trial introduced in N Ireland', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (244, N'UK launches its first (and only) satellite, Prospero', CAST(0x0000667800000000 AS DateTime), N'UK launches its first (and only) satellite, Prospero', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (245, N'Parliament votes to join Common Market', CAST(0x0000667800000000 AS DateTime), N'Parliament votes to join Common Market (joined 1973)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (246, N'Mariner 9, becomes the first spacecraft to orbit another planet (Mars)', CAST(0x0000668800000000 AS DateTime), N'Mariner 9, becomes the first spacecraft to orbit another planet (Mars)', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (247, N'''Bloody Sunday'' in Derry, Northern Ireland', CAST(0x000066D600000000 AS DateTime), N'''Bloody Sunday'' in Derry, Northern Ireland', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (248, N'Power workers crisis', CAST(0x000066E000000000 AS DateTime), N'Power workers crisis', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (249, N'Ceylon changes its name to Sri Lanka', CAST(0x0000674700000000 AS DateTime), N'Ceylon changes its name to Sri Lanka', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (250, N'Duke of Windsor (ex-King Edward VIII) dies', CAST(0x0000674D00000000 AS DateTime), N'Duke of Windsor (ex-King Edward VIII) dies in Paris', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (251, N'United Reformed Church founded', CAST(0x000067CF00000000 AS DateTime), N'United Reformed Church founded out of Congregational and Presbyterian Churches in E&W', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (252, N'John Betjeman becomes Poet Laureate', CAST(0x000067D400000000 AS DateTime), N'John Betjeman becomes Poet Laureate', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (253, N'Last manned moon mission, Apollo 17, launched', CAST(0x0000680E00000000 AS DateTime), N'Last manned moon mission, Apollo 17, launched – crew take the ''Blue marble'' photograph of earth', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (254, N'Britain enters EEC Common Market', CAST(0x0000682700000000 AS DateTime), N'Britain enters EEC Common Market (with Ireland and Denmark)', 5)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (255, N'Vietnam ceasefire agreement signed', CAST(0x0000684100000000 AS DateTime), N'Vietnam ceasefire agreement signed', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (256, N'Modern London Bridge opened by the Queen', CAST(0x0000687200000000 AS DateTime), N'Modern London Bridge opened by the Queen', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (257, N'VAT introduced in Britain', CAST(0x0000688100000000 AS DateTime), N'VAT introduced in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (258, N'First call made (in New York) on mobile', CAST(0x0000688300000000 AS DateTime), N'First call made (in New York) on a portable cellular phone', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (259, N'Skylab launched', CAST(0x000068AC00000000 AS DateTime), N'Skylab launched', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (260, N'Concorde crosses Atlantic', CAST(0x0000693300000000 AS DateTime), N'Concorde makes its first non-stop crossing of the Atlantic in record-breaking time', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (261, N'Yom Kippur War', CAST(0x0000693D00000000 AS DateTime), N'Yom Kippur War precipitates world oil crisis', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (262, N'Marriage of Princess Anne', CAST(0x0000694500000000 AS DateTime), N'Marriage of Princess Anne and Captain Mark Phillips in Westminster Abbey', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (263, N'Sydney Opera House opens', CAST(0x0000694D00000000 AS DateTime), N'Sydney Opera House opens', 1)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (264, N'Miners strike and three-day week', CAST(0x0000699300000000 AS DateTime), N'Miners strike and oil crisis precipitate ''three-day week'' (till 9 Mar 1974) to conserve power', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (265, N'President Nixon resigns over Watergate', CAST(0x00006A6F00000000 AS DateTime), N'President Nixon resigns over Watergate scandal', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (266, N'Lord Lucan disappears', CAST(0x00006ACA00000000 AS DateTime), N'Lord Lucan disappears', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (267, N'Birmingham pub bombings by the IRA', CAST(0x00006AD800000000 AS DateTime), N'Birmingham pub bombings by the IRA', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (268, N'Margaret Thatcher becomes leader of Conservative party', CAST(0x00006B2A00000000 AS DateTime), N'Margaret Thatcher becomes leader of Conservative party (in opposition)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (269, N'Moorgate tube crash in London', CAST(0x00006B3B00000000 AS DateTime), N'Moorgate tube crash in London – over 43 deaths, greatest loss of life on the Underground in peacetime. The cause of the incident was never conclusively determined', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (270, N'Charlie Chaplin knighted', CAST(0x00006B3F00000000 AS DateTime), N'Charlie Chaplin knighted', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (271, N'End of Vietnam war', CAST(0x00006B7800000000 AS DateTime), N'End of Vietnam war', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (272, N'UK votes to stay in EEC', CAST(0x00006B9C00000000 AS DateTime), N'UK votes in a referendum to stay in the European Community', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (273, N'Suez canal reopens', CAST(0x00006B9C00000000 AS DateTime), N'Suez canal reopens (after 8 years closure)', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (274, N'Arthur Ashe wins Wimbledon', CAST(0x00006BBA00000000 AS DateTime), N'Arthur Ashe wins Wimbledon singles title', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (275, N'American Apollo and Soviet Soyuz spacecraft dock in orbit', CAST(0x00006BC600000000 AS DateTime), N'American Apollo and Soviet Soyuz spacecraft dock in orbit', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (276, N'''Yorkshire Ripper'' commits his first murder', CAST(0x00006C2E00000000 AS DateTime), N'''Yorkshire Ripper'' commits his first murder', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (277, N'First North Sea oil comes ashore', CAST(0x00006C3300000000 AS DateTime), N'First North Sea oil comes ashore', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (278, N'General Franco dies in Spain', CAST(0x00006C4400000000 AS DateTime), N'General Franco dies in Spain; Juan Carlos declared King', 15)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (279, N'Microsoft launched', CAST(0x00006C4D00000000 AS DateTime), N'The name ''Micro-soft'' coined by Bill Gates (Microsoft'' became a Trademark the following year)', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (280, N'Equal Pay Act and Sex Discrimination Act', CAST(0x00006C6900000000 AS DateTime), N'Equal Pay Act and Sex Discrimination Act come into force', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (281, N'Concorde enters supersonic passenger service', CAST(0x00006C8200000000 AS DateTime), N'Concorde enters supersonic passenger service [see 2000]', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (282, N'Apple Computer formed', CAST(0x00006CC900000000 AS DateTime), N'Apple Computer formed by Steve Jobs and Steve Wozniak', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (283, N'Drought Act 1976 comes into force', CAST(0x00006D4800000000 AS DateTime), N'Drought Act 1976 comes into force — the long, hot summer', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (284, N'Lib-Lab pact', CAST(0x00006E2D00000000 AS DateTime), N'Lib-Lab pact', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (285, N'Red Rum wins a third Grand National', CAST(0x00006E3700000000 AS DateTime), N'Red Rum wins a third Grand National', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (286, N'George Lucas'' film Star Wars released', CAST(0x00006E6C00000000 AS DateTime), N'George Lucas'' film Star Wars released', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (287, N'New road speed limits', CAST(0x00006E7300000000 AS DateTime), N'Road speed limits: 70mph dual roads; 60mph single', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (288, N'Apple II goes on sale', CAST(0x00006E7700000000 AS DateTime), N'Apple II, the first practical personal computer, goes on sale', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (289, N'Queen''s Silver Jubilee celebrations', CAST(0x00006E7900000000 AS DateTime), N'Queen''s Silver Jubilee celebrations in London', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (290, N'Virginia Wade wins Wimbledon', CAST(0x00006E9000000000 AS DateTime), N'Virginia Wade wins the Ladies Singles title at Wimbledon', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (291, N'Elvis Presley dies', CAST(0x00006EBF00000000 AS DateTime), N'Elvis Presley dies', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (292, N'Eradication of smallpox declared', CAST(0x00006F0600000000 AS DateTime), N'Eradication of smallpox world-wide declared by WHO (certified in 1979)', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (293, N'Regular supersonic Concorde service inaugurated', CAST(0x00006F2100000000 AS DateTime), N'Regular supersonic Concorde service betweeen London and NY inaugurated', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (294, N'Broadcast of proceedings in Parliament starts', CAST(0x00006FAA00000000 AS DateTime), N'Regular broadcast of proceedings in Parliament starts', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (295, N'First May Day holiday in Britain', CAST(0x00006FC100000000 AS DateTime), N'First May Day holiday in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (296, N'World''s first ''test tube'' baby', CAST(0x0000701600000000 AS DateTime), N'World''s first ''test tube'' baby, Louise Browne born in Oldham', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (297, N'Pope John Paul II elected', CAST(0x0000706800000000 AS DateTime), N'Pope John Paul II elected – a Pole, and first non-Italian for 450 years – died 2 Apr 2005', 11)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (298, N'Publication of The Times suspended', CAST(0x0000709600000000 AS DateTime), N'Publication of The Times suspended – industrial relations problems (until 13 Nov 1979)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (299, N'Ayatollah Khomeini returns to Iran', CAST(0x000070D500000000 AS DateTime), N'Ayatollah Khomeini returns to Iran', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (300, N'Devolution votes', CAST(0x000070F100000000 AS DateTime), N'32.5% of Scots vote in favour of devolution (40% needed) – Welsh vote overwhelmingly against', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (301, N'Airey Neave killed', CAST(0x0000710E00000000 AS DateTime), N'Airey Neave killed by a car bomb at Westminster', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (302, N'Withdrawal of Royal Navy from Malta', CAST(0x0000710F00000000 AS DateTime), N'Withdrawal of Royal Navy from Malta', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (303, N'Margaret Thatcher becomes Prime Minister', CAST(0x0000713100000000 AS DateTime), N'Margaret Thatcher becomes first woman UK Prime Minister', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (304, N'Sony introduces the Walkman', CAST(0x0000716B00000000 AS DateTime), N'Sony introduces the Walkman', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (305, N'Lord Mountbatten killed', CAST(0x000071A400000000 AS DateTime), N'Lord Mountbatten and 3 others killed in bomb blast off coast of Sligo, Ireland', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (306, N'ILEA votes to abolish corporal punishment', CAST(0x000071BA00000000 AS DateTime), N'ILEA votes to abolish corporal punishment in its schools', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (307, N'The Times returns to circulation', CAST(0x000071F200000000 AS DateTime), N'The Times returns to circulation', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (308, N'Lancaster House agreement', CAST(0x0000721800000000 AS DateTime), N'Lancaster House agreement to give Southern Rhodesia independence (became Zimbabwe on 18 Apr 1980)', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (309, N'Death of President Tito of Yugoslavia', CAST(0x0000729F00000000 AS DateTime), N'Death of President Tito of Yugoslavia', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (310, N'SAS storm Iranian Embassy', CAST(0x000072A000000000 AS DateTime), N'SAS storm Iranian Embassy in London to free hostages', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (311, N'John Lennon assassinated', CAST(0x0000737900000000 AS DateTime), N'John Lennon assassinated in New York', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (312, N'Launch of SDP by ''Gang of Four'' in Britain', CAST(0x000073A900000000 AS DateTime), N'Launch of SDP by ''Gang of Four'' in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (313, N'First London marathon run', CAST(0x000073E800000000 AS DateTime), N'First London marathon run', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (314, N'Census day in Britain', CAST(0x000073EF00000000 AS DateTime), N'Census day in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (315, N'Brixton riots in South London', CAST(0x000073F500000000 AS DateTime), N'Brixton riots in South London – 30 other British cities also experience riots', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (316, N'First US Space Shuttle (Columbia) launched', CAST(0x000073F600000000 AS DateTime), N'First US Space Shuttle (Columbia) launched', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (317, N'Worst April blizzards this century in Britain', CAST(0x0000740300000000 AS DateTime), N'Worst April blizzards this century in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (318, N'First use of computer mouse', CAST(0x0000740500000000 AS DateTime), N'First use of computer mouse (by Xerox PARC system)', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (319, N'Wedding of Prince Charles', CAST(0x0000746200000000 AS DateTime), N'Wedding of Prince Charles and Lady Diana Spencer (divorced 28 Aug 1996)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (320, N'IBM launches its PC', CAST(0x0000747000000000 AS DateTime), N'IBM launches its PC — starts the general use of personal computers', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (321, N'Unemployment reached 3 million', CAST(0x0000751700000000 AS DateTime), N'Unemployment reached 3 million in Britain (1 in 8 of working population)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (322, N'Laker Airways collapses', CAST(0x0000752100000000 AS DateTime), N'Laker Airways collapses', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (323, N'DeLorean collapses', CAST(0x0000752F00000000 AS DateTime), N'DeLorean Car factory in Belfast goes into receivership', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (324, N'Argentinians raised flag in South Georgia', CAST(0x0000754A00000000 AS DateTime), N'Argentinians raised flag in South Georgia', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (325, N'Argentina invades Falkland (Malvinas) Islands', CAST(0x0000755900000000 AS DateTime), N'Argentina invades Falkland (Malvinas) Islands', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (326, N'Royal Navy fleet sails from Portsmouth', CAST(0x0000755C00000000 AS DateTime), N'Royal Navy fleet sails from Portsmouth for Falklands', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (327, N'General Belgrano sunk', CAST(0x0000757700000000 AS DateTime), N'British nuclear submarine HMS Conqueror sinks Argentine cruiser General Belgrano', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (328, N'Goose Green battle', CAST(0x0000759100000000 AS DateTime), N'First land battle in Falklands (Goose Green)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (329, N'Ceasefire in Falklands', CAST(0x000075A200000000 AS DateTime), N'Ceasefire in Falklands', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (330, N'Birth of Prince Willia', CAST(0x000075A900000000 AS DateTime), N'Birth of Prince William of Wales', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (331, N'IRA bombings in London', CAST(0x000075C600000000 AS DateTime), N'IRA bombings in London (Hyde Park and Regents Park)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (332, N'Smiley emoticon first used', CAST(0x0000760300000000 AS DateTime), N'Smiley emoticon :-) said to have been used for the first time', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (333, N'Mary Rose raised in the Solent', CAST(0x0000761900000000 AS DateTime), N'Mary Rose raised in the Solent (sank in 1545)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (334, N'Thames Barrier raised for first time', CAST(0x0000762D00000000 AS DateTime), N'Thames Barrier raised for first time (some say first public demonstration Nov 7)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (335, N'Channel 4 TV station launched', CAST(0x0000762F00000000 AS DateTime), N'Channel 4 TV station launched – first programme ''Countdown''', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (336, N'Lorries up to 38 tonnes allowed', CAST(0x0000763100000000 AS DateTime), N'Lorries up to 38 tonnes allowed on Britain''s roads', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (337, N'Greenham Common protests', CAST(0x0000765700000000 AS DateTime), N'Women''s peace protest at Greenham Common (Cruise missiles arrived 14 Nov 1983)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (338, N'Start of breakfast TV in Britain', CAST(0x0000767B00000000 AS DateTime), N'Start of breakfast TV in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (339, N'Spreadsheet Lotus 1-2-3 released', CAST(0x0000768300000000 AS DateTime), N'Spreadsheet Lotus 1-2-3 released', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (340, N'Seat belt law comes into force', CAST(0x0000768900000000 AS DateTime), N'Seat belt law comes into force', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (341, N'£1 coin into circulation in Britain', CAST(0x000076D900000000 AS DateTime), N'£1 coin into circulation in Britain', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (342, N'Plans to abolish GLC announced', CAST(0x0000778200000000 AS DateTime), N'Plans to abolish GLC announced', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (343, N'Brinks Mat robbert', CAST(0x000077B400000000 AS DateTime), N'Brinks Mat robbery: 6,800 gold bars worth nearly £26 million are stolen from a vault at Heathrow Airport', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (344, N'FTSE index exceeded 800', CAST(0x000077E000000000 AS DateTime), N'FTSE index exceeded 800', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (345, N'Miners strike begins', CAST(0x0000781900000000 AS DateTime), N'Miners strike begins', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (346, N'Police Constable Yvonne Fletcher killed', CAST(0x0000784300000000 AS DateTime), N'Police Constable Yvonne Fletcher killed by gunfire from the Libyan Embassy in London', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (347, N'Inaugural flight of Virgin Atlantic', CAST(0x0000788500000000 AS DateTime), N'Inaugural flight of Virgin Atlantic', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (348, N'York Minster struck by lightning', CAST(0x0000789600000000 AS DateTime), N'York Minster struck by lightning – the resulting fire damaged much of the building but the "Rose Window" not affected', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (349, N'IRA bomb explodes at Brighton', CAST(0x000078F500000000 AS DateTime), N'IRA bomb explodes at Tory conference hotel in Brighton – 4 killed', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (350, N'Miners'' strike', CAST(0x0000790100000000 AS DateTime), N'Miners'' strike — High Court orders sequestration of NUM assets', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (351, N'Indira Gandhi assassinated', CAST(0x0000790800000000 AS DateTime), N'Indira Gandhi assassinated', 8)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (352, N'British Telecom privatised', CAST(0x0000792900000000 AS DateTime), N'British Telecom privatised – shares make massive gains on first day''s trading', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (353, N'Bhopal disaster in India', CAST(0x0000792900000000 AS DateTime), N'Bhopal disaster in India', 8)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (354, N'Summit Tunnel Fire near Todmorton', CAST(0x0000793A00000000 AS DateTime), N'Summit Tunnel Fire near Todmorton', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (355, N'Miners agree to call off strike', CAST(0x0000798300000000 AS DateTime), N'Miners agree to call off strike', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (356, N'Al Fayed buys Harrods', CAST(0x0000798B00000000 AS DateTime), N'Al Fayed buys Harrods', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (357, N'First episode of Neighbours', CAST(0x0000799200000000 AS DateTime), N'First episode of Neighbours in Australia', 1)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (358, N'Heysel Stadium disaster', CAST(0x000079DA00000000 AS DateTime), N'Heysel Stadium disaster in Brussels', 2)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (359, N'Schengen Agreement', CAST(0x000079EA00000000 AS DateTime), N'Schengen Agreement on abolition of border controls agreed between Belgium, France, West Germany, Luxembourg, and The Netherlands – not implemented until 26 Mar 1995 when it also included Spain & Portugal – by 2007 there are 30 states included', 5)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (360, N'Live Aid pop concert', CAST(0x00007A0700000000 AS DateTime), N'Live Aid pop concert raises over £50M for famine relief', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (361, N'Wreck of Titanic found', CAST(0x00007A3900000000 AS DateTime), N'Wreck of Titanic found (sank 1912)', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (362, N'GLC abolished', CAST(0x00007B0C00000000 AS DateTime), N'GLC and 6 metropolitan councils abolished', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (363, N'Chernobyl nuclear accident', CAST(0x00007B2600000000 AS DateTime), N'Chernobyl nuclear accident – radiation reached Britain on 2 May', 13)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (364, N'Mannie Shinwel dies', CAST(0x00007B3100000000 AS DateTime), N'Mannie Shinwell, veteran politician, dies aged 101', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (365, N'The European Community adopts the European flag', CAST(0x00007B4400000000 AS DateTime), N'The European Community adopts the European flag', 5)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (366, N'Prince Andrew marries', CAST(0x00007B7E00000000 AS DateTime), N'Prince Andrew, Duke of York marries Sarah Ferguson at Westminster Abbey', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (367, N'''Big Bang'' (deregulation) of the London Stock Market', CAST(0x00007BDE00000000 AS DateTime), N'''Big Bang'' (deregulation) of the London Stock Market', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (368, N'M25 ring round London completed', CAST(0x00007BE000000000 AS DateTime), N'M25 ring round London completed', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (369, N'Terry Waite kidnapped', CAST(0x00007C4000000000 AS DateTime), N'Terry Waite kidnapped in Beirut (released 17 Nov 1991)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (370, N'Herald of Free Enterprise capsizes', CAST(0x00007C6000000000 AS DateTime), N'Car ferry Herald of Free Enterprise capsizes off Zeebrugge – 188 die', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (371, N'Channel Tunnel excavation starts', CAST(0x00007CD500000000 AS DateTime), N'Excavation begins on the Channel Tunnel (see 1990 & 1994)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (372, N'Hungerford Massacre', CAST(0x00007D0600000000 AS DateTime), N'Hungerford Massacre – Michael Ryan kills sixteen people with a rifle', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (373, N'The ''Hurricane'' sweeps southern England', CAST(0x00007D4000000000 AS DateTime), N'The ''Hurricane'' sweeps southern England', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (374, N'Black Monday'' in the City of London', CAST(0x00007D4300000000 AS DateTime), N'''Black Monday'' in the City of London – Stock Market crash', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (375, N'Enniskillen bombing', CAST(0x00007D5700000000 AS DateTime), N'Enniskillen bombing at a Remembrance Day ceremony', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (376, N'King''s Cross fire', CAST(0x00007D6100000000 AS DateTime), N'King''s Cross fire in London – 31 people die', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (377, N'First ''Red Nose Day'' in UK', CAST(0x00007DB000000000 AS DateTime), N'First ''Red Nose Day'' in UK, raising money for charity', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (378, N'Copyright, Designs and Patents Act', CAST(0x00007ECC00000000 AS DateTime), N'Copyright, Designs and Patents Act – reformulated the statutory basis of copyright law (including performing rights) in the UK', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (379, N'Clapham Junction rail crash', CAST(0x00007EE700000000 AS DateTime), N'Clapham Junction rail crash kills 35 and injures hundreds after two collisions of three commuter trains', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (380, N'Lockerbie disaster', CAST(0x00007EF000000000 AS DateTime), N'Lockerbie disaster – Pan Am flight 103 explodes over Scotland', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (381, N'Global Positioning System launched', CAST(0x00007F2700000000 AS DateTime), N'The first of 24 satellites of the Global Positioning System is placed into orbit', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (382, N'Fatwa issued against Salman Rushdie', CAST(0x00007F2700000000 AS DateTime), N'Fatwa issued against Salman Rushdie for The Satanic Verses', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (383, N'EU decision to ban CFCs', CAST(0x00007F3700000000 AS DateTime), N'EU decision to ban production of all chlorofluorocarbons (CFCs) by the end of the century', 5)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (384, N'Tiananmen Square massacre', CAST(0x00007F9600000000 AS DateTime), N'Tanks stopped in Tiananmen Square, Peking by unknown protester', 4)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (385, N'Berlin Wall torn down', CAST(0x0000803300000000 AS DateTime), N'Berlin Wall torn down', 7)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (386, N'Proceedings of House of Commons first televised live', CAST(0x0000803F00000000 AS DateTime), N'Proceedings of House of Commons first televised live', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (387, N'Nelson Mandela released in South Africa', CAST(0x0000809100000000 AS DateTime), N'Nelson Mandela released in South Africa', 14)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (388, N'Riots in London against Poll Tax', CAST(0x000080C100000000 AS DateTime), N'Riots in London against Poll Tax which had been implemented in England & Wales', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (389, N'Hubble space telescope launched', CAST(0x000080DA00000000 AS DateTime), N'Hubble space telescope launched', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (390, N'Iraq invades Kuwait', CAST(0x0000813D00000000 AS DateTime), N'Iraq invades Kuwait', 9)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (391, N'German reunification', CAST(0x0000817B00000000 AS DateTime), N'German reunification', 7)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (392, N'Margaret Thatcher resigns', CAST(0x000081AD00000000 AS DateTime), N'Margaret Thatcher resigns as Conservative party leader (and Prime Minister) — John Major elected', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (393, N'Channel Tunnel excavation teams meet', CAST(0x000081B600000000 AS DateTime), N'Channel Tunnel excavation teams meet in the middle', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (394, N'Helen Sharman is first British Astronaut in Space', CAST(0x0000825E00000000 AS DateTime), N'Helen Sharman is first British Astronaut in Space', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (395, N'Leningrad renamed St Petersburg', CAST(0x000082CD00000000 AS DateTime), N'Leningrad renamed St Petersburg', 13)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (396, N'Robert Maxwell drowns at sea', CAST(0x0000830900000000 AS DateTime), N'Robert Maxwell drowns at sea', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (397, N'European Union formed by The Maastricht Treaty', CAST(0x0000836700000000 AS DateTime), N'European Union formed by The Maastricht Treaty [see 1993]', 5)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (398, N'Betty Boothroyd elected as first female Speaker', CAST(0x000083B200000000 AS DateTime), N'Betty Boothroyd elected as first female Speaker of the House of Commons', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (399, N'Football Premier League kicks off in England', CAST(0x0000842500000000 AS DateTime), N'Football Premier League kicks off in England', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (400, N'''Black Wednesday'' as Pound leaves the ERM', CAST(0x0000844500000000 AS DateTime), N'''Black Wednesday'' as Pound leaves the ERM', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (401, N'Fire breaks out in Windsor Castle', CAST(0x0000848600000000 AS DateTime), N'Fire breaks out in Windsor Castle causing over £50 million worth of damage', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (402, N'Church of England ordains its first female priests', CAST(0x0000866300000000 AS DateTime), N'Church of England ordains its first female priests', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (403, N'Channel Tunnel open to traffic', CAST(0x0000869A00000000 AS DateTime), N'Channel Tunnel open to traffic', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (404, N'National Lottery starts', CAST(0x0000875F00000000 AS DateTime), N'National Lottery starts', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (405, N'Nick Leeson brings down Barings', CAST(0x000087C200000000 AS DateTime), N'Nick Leeson brings down Barings', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (406, N'First item sold on Amazon.com', CAST(0x0000884D00000000 AS DateTime), N'First item sold on Amazon.com', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (407, N'The Queen Mother has a hip replacement', CAST(0x000088C900000000 AS DateTime), N'The Queen Mother has a hip replacement operation at 95 years old', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (408, N'Toy Story released', CAST(0x000088CF00000000 AS DateTime), N'Toy Story released – first feature-length film created completely using computer-generated imagery', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (409, N'Galileo spacecraft arrives at Jupiter', CAST(0x000088DE00000000 AS DateTime), N'Galileo spacecraft arrives at Jupiter (launched from shuttle 18 Oct 1989)', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (410, N'IRA bomb explodes in London Docklands', CAST(0x0000891E00000000 AS DateTime), N'IRA bomb explodes in London Docklands – ends 17 month ceasefire', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (411, N'Dunblane massacre', CAST(0x0000893F00000000 AS DateTime), N'Dunblane massacre', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (412, N'IRA bomb explodes in Manchester', CAST(0x0000899D00000000 AS DateTime), N'IRA bomb explodes in Manchester', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (413, N'Scientists in Scotland clone a sheep (Dolly)', CAST(0x000089B100000000 AS DateTime), N'Scientists in Scotland clone a sheep (Dolly)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (414, N'Princess of Wales divorced', CAST(0x000089E700000000 AS DateTime), N'Charles, Prince of Wales and Diana, Princess of Wales are divorced', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (415, N'Channel 5 TV begins in UK', CAST(0x00008ABD00000000 AS DateTime), N'Channel 5 TV begins in UK (launched by the Spice Girls)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (416, N'Hale-Bopp comet at its brightest', CAST(0x00008ABF00000000 AS DateTime), N'Hale-Bopp comet at its brightest', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (417, N'New'' Labour landslide victory in Britain', CAST(0x00008ADD00000000 AS DateTime), N'''New'' Labour landslide victory in Britain (Tony Blair replaces John Major as Prime Minister)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (418, N'Announcement that Bank of England to be made independent', CAST(0x00008AE200000000 AS DateTime), N'Announcement that Bank of England to be made independent of Government control', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (419, N'A computer beats a master at chess', CAST(0x00008AE700000000 AS DateTime), N'First time a computer beats a master at chess (IBM''s Deep Blue v Garry Kasparov)', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (420, N'Publication of first Harry Potter novel', CAST(0x00008B1900000000 AS DateTime), N'Publication of first Harry Potter novel Harry Potter and the Philosopher''s Stone', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (421, N'Hong Kong returned to China', CAST(0x00008B1A00000000 AS DateTime), N'Hong Kong returned to China', 4)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (422, N'Landing by American ''Pathfinder Rover'' on Mars', CAST(0x00008B1D00000000 AS DateTime), N'Landing by American ''Pathfinder Rover'' on Mars', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (423, N'IRA declares a ceasefire', CAST(0x00008B2C00000000 AS DateTime), N'IRA declares a ceasefire', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (424, N'Diana, Princess of Wales killed', CAST(0x00008B5700000000 AS DateTime), N'Diana, Princess of Wales killed in car crash in Paris', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (425, N'Land speed record breaks sound barrier for first time', CAST(0x00008B7000000000 AS DateTime), N'Land speed record breaks sound barrier for first time – Wing Commander Andy Green in Thrust SSC at Black Rock Desert, USA', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (426, N'Good Friday peace agreement in Northern Ireland', CAST(0x00008C3500000000 AS DateTime), N'Good Friday peace agreement in Northern Ireland – effectively implemented in May 2007', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (427, N'Car bomb explodes in Omagh', CAST(0x00008CB300000000 AS DateTime), N'Car bomb explodes in Omagh killing 29 people', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (428, N'Google search engine founded', CAST(0x00008CDF00000000 AS DateTime), N'Google search engine founded', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (429, N'First module of the International Space Station launched', CAST(0x00008D1500000000 AS DateTime), N'First module of the International Space Station launched', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (430, N'US President Bill Clinton is impeached', CAST(0x00008D3200000000 AS DateTime), N'US President Bill Clinton is impeached over Monica Lewinsky scandal', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (431, N'European Monetary Union begins', CAST(0x00008D3F00000000 AS DateTime), N'European Monetary Union begins – UK opts out – by the end of the year the Euro has approximately the same value as the US Dollar', 5)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (432, N'The Scottish Parliament is opened', CAST(0x00008DF400000000 AS DateTime), N'The Scottish Parliament is officially opened by Queen Elizabeth – powers are officially transferred from the Scottish Office in London to the new devolved Scottish Executive in Edinburgh', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (433, N'Total eclipse of the sun', CAST(0x00008E1D00000000 AS DateTime), N'Total eclipse of the sun visible in Devon and Cornwall', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (434, N'Hereditary Peers no longer have right to sit in House of Lords', CAST(0x00008E7900000000 AS DateTime), N'Hereditary Peers no longer have right to sit in House of Lords', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (435, N'A new millennium starts', CAST(0x00008EAC00000000 AS DateTime), N'A new millennium starts', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (436, N'The Big Number Change', CAST(0x00008F1C00000000 AS DateTime), N'The Big Number Change takes place in the UK – affected telephone dialling codes assigned to Cardiff, Coventry, London, Northern Ireland, Portsmouth and Southampton', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (437, N'Ken Livingstone elected first Mayor of London', CAST(0x00008F2800000000 AS DateTime), N'Ken Livingstone elected first Mayor of London (not to be confused with Lord Mayor of London!)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (438, N'Millennium footbridge opens for first time', CAST(0x00008F4D00000000 AS DateTime), N'Millennium footbridge over the Thames opens, but wobbles and is quickly declared dangerous and closed – finally reopened Feb 2002', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (439, N'A chartered Air France Concorde crashes', CAST(0x00008F7A00000000 AS DateTime), N'A chartered Air France Concorde crashes on take-off at Paris with loss of all lives – debris on the runway blamed for causing fuel to escape and catch fire, and all Concordes grounded until 7 November 2001', 6)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (440, N'Derailment at Hatfield', CAST(0x00008FCE00000000 AS DateTime), N'Derailment at speed on the main London-North eastern line at Hatfield caused by a broken rail – Railtrack put restrictions on the rest of the network while all other suspect locations were checked', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (441, N'First crew arrive at the International Space Station', CAST(0x00008FDE00000000 AS DateTime), N'First crew arrive at the International Space Station.', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (442, N'New Prayer Book introduced in Anglican Church', CAST(0x00008FEA00000000 AS DateTime), N'New Prayer Book introduced in Anglican Church', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (443, N'Mir space station successfully ditched in the Pacific', CAST(0x0000906B00000000 AS DateTime), N'Mir space station successfully ditched in the Pacific', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (444, N'UK Census Day', CAST(0x0000909000000000 AS DateTime), N'UK Census Day', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (445, N'FA Cup Final played at the Millennium Stadium in Cardiff', CAST(0x0000909D00000000 AS DateTime), N'FA Cup Final played at the Millennium Stadium in Cardiff – first time away from Wembley since 1922', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (446, N'New-style number plates on road vehicles in UK', CAST(0x0000910D00000000 AS DateTime), N'New-style number plates on road vehicles in UK [eg. AB 51 ABC]', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (447, N'Massive terrorist attack on the United States', CAST(0x0000911700000000 AS DateTime), N'Massive terrorist attack on the United States – commercial planes hi-jacked and crashed into the twin towers of the World Trade Centre (destroying it) and one section of the Pentagon', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (448, N'Concorde flights resume', CAST(0x0000915000000000 AS DateTime), N'Concorde flights resume after modifications to tyres and fuel tanks (see 2003)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (449, N'The Leaning Tower of Pisa reopens', CAST(0x0000917600000000 AS DateTime), N'The Leaning Tower of Pisa reopens after 11 years, still leaning', 11)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (450, N'Euro launched', CAST(0x0000918700000000 AS DateTime), N'Twelve major countries in Europe (Austria, Belgium, Holland, Irish Republic, Italy, Luxembourg, Finland, France, Germany, Greece, Spain, Portugal) and their dependents start using the Euro instead of their old national currencies', 5)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (451, N'UK 1901 census details available', CAST(0x0000918800000000 AS DateTime), N'UK 1901 census details available', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (452, N'Millennium Bridge over the Thames in London finally opens', CAST(0x000091BB00000000 AS DateTime), N'Millennium Bridge over the Thames in London finally opens', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (453, N'The Queen Mother dies, aged 101 years', CAST(0x000091DF00000000 AS DateTime), N'The Queen Mother dies, aged 101 years', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (454, N'Two Bank Holidays declared in UK', CAST(0x0000922000000000 AS DateTime), N'Two Bank Holidays declared in UK to celebrate the Queen''s Golden Jubilee', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (455, N'Steve Fossett flies nonstop round world in balloon', CAST(0x0000923D00000000 AS DateTime), N'Steve Fossett becomes the first person to fly solo around the world nonstop in a balloon', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (456, N'Space Shuttle Columbia disintegrates', CAST(0x0000931300000000 AS DateTime), N'Space Shuttle Columbia disintegrates during re-entry, killing all seven astronauts aboard', 18)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (457, N'Start of Congestion Charge for London', CAST(0x0000932300000000 AS DateTime), N'Start of Congestion Charge for traffic entering central London', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (458, N'Temperatures reach record high', CAST(0x000093D100000000 AS DateTime), N'Temperatures reach record high of 101 F (38.3 C) in Kent', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (459, N'Last commercial flight of Concorde', CAST(0x0000941C00000000 AS DateTime), N'Last commercial flight of Concorde', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (460, N'England wins Rugby World Cup', CAST(0x0000943900000000 AS DateTime), N'England wins Rugby World Cup in nail-biting final in Australia – first northern hemisphere team to do this', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (461, N'Saddam Hussein captured', CAST(0x0000944E00000000 AS DateTime), N'Saddam Hussein captured near his home town of Tikrit (executed 30 Dec 2006)', 9)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (462, N'Queen Mary 2 arrives in Southampton', CAST(0x0000945B00000000 AS DateTime), N'Queen Mary 2 arrives in Southampton from the builder''s yard in France', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (463, N'Alistair Cooke dies', CAST(0x000094B900000000 AS DateTime), N'Alistair Cooke dies at the age of 95 – until four weeks previously, and since 1946, he had broadcast his regular ''Letter from America'' on BBC radio', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (464, N'Ireland bans smoking', CAST(0x000094B900000000 AS DateTime), N'Ireland becomes first country in the world to ban smoking in public places', 10)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (465, N'Enlargement of the European Union', CAST(0x000094DA00000000 AS DateTime), N'Enlargement of the European Union to include 25 members by the entry of 10 new states: Estonia, Latvia, Lithuania, Poland, Czech Republic, Slovakia, Hungary, Slovenia, Malta, Cyprus.', 5)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (466, N'Kyoto Protocol starts', CAST(0x000095FD00000000 AS DateTime), N'Kyoto Protocol on climate change came into force', 12)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (467, N'Ban on hunting with dogs', CAST(0x000095FF00000000 AS DateTime), N'Ban on hunting with dogs came into force in England & Wales (had already been a similar law for about two years in Scotland)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (468, N'Death of Pope John Paul II', CAST(0x0000962A00000000 AS DateTime), N'Death of Pope John Paul II, first non-Italian Pope for 450 years when elected in 1978', 11)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (469, N'Pope Benedict XVI elected', CAST(0x0000963B00000000 AS DateTime), N'Pope Benedict XVI elected – first German Pope for about 1,000 years', 11)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (470, N'London chosen as venue for the 2012 Olympic Games', CAST(0x0000968900000000 AS DateTime), N'London chosen as venue for the 2012 Olympic Games', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (471, N'Suicide bombers attack London for the first time', CAST(0x0000968A00000000 AS DateTime), N'Suicide bombers attack London for the first time', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (472, N'IRA declare an end to their ''armed struggle''', CAST(0x0000969F00000000 AS DateTime), N'IRA declare an end to their ''armed struggle''', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (473, N'England regain the ''Ashes''', CAST(0x000096CD00000000 AS DateTime), N'England regain the ''Ashes'' after a gripping Test series (but are whitewashed 5-0 in the return series in Australia 2007)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (474, N'Angela Merkel becomes first female Chancellor of Germany', CAST(0x0000971400000000 AS DateTime), N'Angela Merkel becomes first female Chancellor of Germany', 7)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (475, N'John Sentamu becomes Archbishop of York', CAST(0x0000971C00000000 AS DateTime), N'John Sentamu becomes Archbishop of York; the first black archbishop in the Church of England', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (476, N'Last Routemaster bus runs', CAST(0x0000972500000000 AS DateTime), N'Last Routemaster bus runs on regular service in London (see 1954)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (477, N'Explosions at the Buncefield Oil Depot', CAST(0x0000972700000000 AS DateTime), N'Explosions at the Buncefield Oil Depot in Hemel Hempstead', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (478, N'Same-sex civil partnerships begin', CAST(0x0000973100000000 AS DateTime), N'Same-sex civil partnerships begin – famously, on this day, between Elton John and David Furnish', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (479, N'Welsh Assembly Building opened', CAST(0x0000977700000000 AS DateTime), N'Welsh Assembly Building opened by the Queen', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (480, N'Prohibition of smoking in Scotland', CAST(0x0000979000000000 AS DateTime), N'Prohibition of smoking in enclosed public places in Scotland', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (481, N'80th birthday of Queen Elizabeth II', CAST(0x000097AA00000000 AS DateTime), N'80th birthday of Queen Elizabeth II', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (482, N'UK postage rates start to be measured by size as well as by weight', CAST(0x0000982400000000 AS DateTime), N'UK postage rates start to be measured by size as well as by weight', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (483, N'Saddam Hussein executed', CAST(0x000098A700000000 AS DateTime), N'Saddam Hussein executed', 9)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (484, N'Further enlargement of the European Union', CAST(0x000098A900000000 AS DateTime), N'Further enlargement of the European Union to include Bulgaria and Romania', 5)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (485, N'Extension of Congestion Charge zone for London, westwards', CAST(0x000098DA00000000 AS DateTime), N'Extension of Congestion Charge zone for London, westwards', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (486, N'A Northern Ireland Executive formed', CAST(0x0000992800000000 AS DateTime), N'A Northern Ireland Executive formed under the leadership of Ian Paisley (DUP) and Martin McGuinness (Sinn Fein)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (487, N'Tony Blair resigns as Prime Minister', CAST(0x0000995A00000000 AS DateTime), N'Tony Blair resigns as Prime Minister after 10 years – replaced by Gordon Brown', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (488, N'Prohibition of smoking in England', CAST(0x0000995E00000000 AS DateTime), N'Prohibition of smoking in enclosed public places in England (thus completing cover of the entire UK)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (489, N'Seventh and final Harry Potter book released', CAST(0x0000997200000000 AS DateTime), N'Seventh and final Harry Potter book released', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (490, N'First commercial flight of Airbus A380', CAST(0x000099D200000000 AS DateTime), N'First commercial flight of Airbus A380 (Singapore to Sydney)', 19)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (491, N'First rail service direct from St Pancras to France', CAST(0x000099E600000000 AS DateTime), N'First rail service direct from St Pancras to France (replacing that from Waterloo)', 17)
insert into tblEvent (EventId, EventName, EventDate, Description, CountryId) values (492, N'The great author was born', '1980-04-20', N'The great author, Rajat Dutta, who took time to insert all these 492 records, was born.', 77)
set identity_insert tblEvent off
go
select * from tblCountry
select * from tblEvent

/*Create a view using the view designer which will be a repeat of one we did in an earlier exercise. The view should show for each country the number of events occurring since 1990,
but exclude countries with less than 5 events. Save this view as vw_EventsByCountry. Amend the view by scripting it to a new window so that it is a bit easier to read, then execute it*/
use HistoricalEvents
go
create or alter view vw_EventsByCountry
as
select		tblCountry.CountryName
			, count(tblEvent.EventId) as NumberEvents
from		tblCountry
			INNER JOIN tblEvent on
			tblCountry.CountryId = tblEvent.CountryId
where		year(tblEvent.EventDate) >= 1990
group by	tblCountry.CountryName
having		count(tblEvent.EventId) >=5
go
select * from vw_EventsByCountry

/*The aim of this exercise is to display all of the actors who have appeared in films directed by Spielberg, but we'll do it in two passes, using a CTE: To accomplish this:
Create a CTE which shows all of the films directed by Spielberg; then link the results of this CTE to the tblCast and tblActor tables*/
use Movies
;with cte_SpielbergFilms as (select FilmName from tblFilm join tblDirector on tblFilm.FilmDirectorID=tblDirector.DirectorID where DirectorName like '%Spielberg%')
select ActorName, cte_SpielbergFilms.FilmName, CastCharacterName from cte_SpielbergFilms join tblFilm on cte_SpielbergFilms.FilmName=tblFilm.FilmName join tblCast on
tblFilm.FilmID=tblCast.CastFilmID join tblActor on tblCast.CastActorID=tblActor.ActorID order by ActorName

/*Write a query which:
Begins a transaction
Within this transaction, deletes all rows from the above table where the Category column is Betting or Adult
Stores how many rows are left in the table in an integer variable
Rolls back the transaction
Stores how many rows are in the table after this roll back (in a second integer variable)
Displays the final figures*/
use Websites

set nocount on

begin tran
	declare @AD int, @AR int
	delete Data_at_14_Jan_2010 where Category in ('Adult','Betting')
	select @AD=count(*) from Data_at_14_Jan_2010
	print 'After Deletion: '+cast(@AD as varchar)

rollback tran
	select @AR=count(*) from Data_at_14_Jan_2010
	print 'After RollBack: '+cast(@AR as varchar)

--Choose your favourite method to export the main event columns to an Excel workbook
--use HistoricalEvents
--select * from tblEvent
--
--
--

/*Create a function called ufn_CountIds to count how many trainers there are assigned to each course (note that exactly the same function could also count
how many resources are assigned).*/
use Training
go

create or alter function ufn_CountIds
	(
		@IDs varchar(50)
	)
returns int
as
	begin
		declare @LengthWithCommas tinyint, @LengthWithoutCommas tinyint
		set @LengthWithCommas=len(@IDs)
		set @LengthWithoutCommas=len(replace(@IDs,',',''))
		return @LengthWithCommas-@LengthWithoutCommas+1
	end
go

select		CourseName
			, convert(varchar,StartDate,103) 'Start Date'
			, TrainerIds
			, dbo.ufn_CountIds(TrainerIds) 'Trainers'' Count'
from		tblSchedule
			join tblCourse on tblSchedule.CourseId=tblCourse.CourseId
order by	StartDate

--Create a multi-statement table-valued function called ufn_CoursesForResources which - given a particular resource name - will return a table of courses which use that resource.
use Training
go

create or alter function ufn_CoursesForResources
	(
		@ResourceName varchar(100)
	)
returns 
table as
return
select	tblSchedule.ScheduleId, CourseName, StartDate, ResourceIds
from	tblSchedule 
		join tblCourse on tblSchedule.CourseId=tblCourse.CourseId
		join (select ScheduleId, value from tblSchedule cross apply string_split(ResourceIds,',')) as cca on tblSchedule.ScheduleId=cca.ScheduleId
		join tblResource on cca.value=tblResource.ResourceId
where ResourceName=@ResourceName
go

select * from ufn_CoursesForResources('Whiteboard')
select * from ufn_CoursesForResources('Projector')
select * from ufn_CoursesForResources('Laptops')
select * from ufn_CoursesForResources('Special equipment')
select * from ufn_CoursesForResources('Flip chart')

/*Create a function using a CASE statement to return the punk era for any given date, using these dubious statistics:
Punk is defined to have begun on 1st January 1975
Punk finished on 31st December 1979
Write a query using your function to test it works
Amend your query so that it shows how many events there were for each era, with the busiest era first.*/
use HistoricalEvents
go
create or alter function ufn_Punk_Details () returns table as return
select case when EventDate<'1975-01-01' then 'Pre-Punk' when EventDate>'1979-12-31' then 'Post-Punk' else 'Punk' end 'Punk_Era', EventName from tblEvent
go
create or alter function ufn_Punk_Count () returns table as return
select top 100 percent Punk_Era, count(*) 'Number of Events' from (select case when EventDate<'1975-01-01' then 'Pre-Punk' when EventDate>'1979-12-31' then 'Post-Punk' else 'Punk' end
'Punk_Era', EventName from tblEvent) Punk_Table group by Punk_Era order by 'Number of Events' desc
go
select * from dbo.ufn_Punk_Count()
select * from dbo.ufn_Punk_Details()

/*Create as many of the following queries as you have time for:
A query called Null Countries to show that the only two countries where the ContinentId field is blank are Iraq and World
A query called TV but not BBC which shows that there are 7 events in the tblEvent table whose names contain the letters TV but not BBC
A query called Birth month events.sql which shows all the events which took place in your month of birth (ie whose date was on or after the first date of your birth month,
and before or on the last day of your birth month)
A query called Ecumenical query which shows that there are 6 events where the Description field includes either the word Pope or the word Islam*/
use HistoricalEvents
go
select * from tblCountry where ContinentId is null
select * from tblEvent where EventName like '%TV%' and EventName not like '%BBC%'
select * from tblEvent where month(EventDate)=4
select * from tblEvent where Description like '%Pope%' or Description like '%Islam%'

/*Create a stored procedure called usp_ListDelegates which displays, for a given company name and course name extract, the people who are attending courses.
If you leave either of the two parameters out, your stored procedure should show all rows for that parameter.*/
use Training
go
create or alter proc usp_ListDelegates (@OrgName varchar(25)='', @CourseName varchar(50)='', @CourseContains varchar(50)='') as
select	FirstName, LastName, OrgName, CourseName
from	tblPerson	join tblOrg on tblPerson.OrgId=tblOrg.OrgId
					join tblDelegate on tblPerson.Personid=tblDelegate.PersonId
					join tblSchedule on tblDelegate.ScheduleId=tblSchedule.ScheduleId
					join tblCourse on tblSchedule.CourseId=tblCourse.CourseId
where OrgName=@OrgName and CourseName='@CourseName' and CourseName like '%'+@CourseContains+'%'
go
exec usp_ListDelegates 'Lloyds', 'ASP.NET'

select top 1 CourseId, CourseName, NumberDays from tblCourse 
select top 1 DelegateId, ScheduleId, PersonId from tblDelegate
select top 1 OrgId, OrgName, OrgStatusId, SectorId, DateAdded from tblOrg
select top 1 OrgStatusId, OrgStatusName from tblOrgStatus
select top 1 Personid, OrgId, FirstName, LastName, Department, PersonStatusId from tblPerson
select top 1 PersonStatusId, PersonStatusName from tblPersonStatus
select top 1 ResourceId, ResourceName from tblResource
select top 1 ScheduleId, CourseId, StartDate, TrainerIds, ResourceIds from tblSchedule
select top 1 SectorId, SectorName from tblSector
select top 1 TrainerId, TrainerName from tblTrainer

select * from tblOrg where OrgName='Lloyds'