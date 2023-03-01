--View Schema of all Wise Owl SQL Server Exercises' DBs
use Books
select AuthorId, FirstName, LastName from tblAuthor
select BookId, BookName, AuthorId from tblBook
select GenreID, GenreName, Rating from tblGenre

use Carnival
select MenuId, MenuName, ParentMenuId, SortOrder, Tooltip, VisibleText, WebPage, FolderName from tblMenu

use DoctorWho
select top 1 AuthorId, AuthorName from tblAuthor
select top 1 CompanionId, CompanionName, WhoPlayed from tblCompanion
select top 1 DoctorId, DoctorNumber, DoctorName, BirthDate, FirstEpisodeDate, LastEpisodeDate from tblDoctor
select top 1 EnemyId, EnemyName, Description from tblEnemy
select top 1 EpisodeId, SeriesNumber, EpisodeNumber, EpisodeType, Title, EpisodeDate, AuthorId, DoctorId, Notes from tblEpisode
select top 1 EpisodeCompanionId, EpisodeId, CompanionId from tblEpisodeCompanion
select top 1 EpisodeEnemyId, EpisodeId, EnemyId from tblEpisodeEnemy
select top 1 ProductionCompanyId, ProductionCompanyName, Abbreviation from tblProductionCompany

use HistoricalEvents
select top 4 ContinentId, ContinentName from tblContinent
select top 4 CountryId, CountryName, ContinentId from tblCountry
select top 4 EventId, EventName, EventDate, Description, CountryId from tblEvent

use Historical_Events
select top 5 CountryId, CountryName from tblCountry
select top 5 EventId, EventName, EventDate, Description, CountryId from tblEvent

use Movies
select top 1 ActorID, ActorName, ActorDOB, ActorGender from tblActor
select top 1 CastID, CastFilmID, CastActorID, CastCharacterName from tblCast
select top 1 CertificateID, CertificateName from tblCertificate
select top 1 CountryID, CountryName from tblCountry
select top 1 DirectorID, DirectorName, DirectorDOB, DirectorGender from tblDirector
select top 1 FilmID, FilmName, FilmReleaseDate, FilmDirectorID, FilmLanguageID, FilmCountryID, FilmStudioID, FilmSynopsis, FilmRunTimeMinutes, FilmCertificateID, FilmBudgetDollars,
FilmBoxOfficeDollars, FilmOscarNominations, FilmOscarWins from tblFilm
select top 1 LanguageID, LanguageName from tblLanguage
select top 1 StudioID, StudioName from tblStudio

use Training
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

use Websites
select top 1 id, AlexaRank, Name, Company, Url, LinkingSites, DateOnline, Domain, Country, Category, AlexaUKRank, CompanyId, DomainSuffixId, CountryId,
CategoryId from Data_at_14_Jan_2010
select top 1 Id, RankingId, Proportion, Country, upsize_ts from Rankings
select top 1 CategoryId, CategoryName from tblCategory
select top 1 CompanyId, CompanyName from tblCompany
select top 1 CountryId, CountryName from tblCountry
select top 1 DomainId, DomainName from tblDomain
select top 1 UsageId, CountryId, WebsiteId, Proportion from tblUsage
select top 1 WebsiteId, AlexaRankWorld, AlexaRankUk, WebsiteName, CompanyId, WebsiteUrl, NumberLinks, DateOnline, DomainId, CategoryId from tblWebsite

use WorldEvents
select top 1 CategoryID, CategoryName from tblCategory
select top 1 ContinentID, ContinentName, Summary from tblContinent
select top 1 CountryID, CountryName, ContinentID from tblCountry
select top 1 EventID, EventName, EventDetails, EventDate, CountryID, CategoryID from tblEvent
select top 1 SummaryItem, CountEvents from tblEventSummary
select top 1 ContinentName,[Countries in Continent],[Events in Continent],[Earliest Continent Event],[Latest Continent Event] from tblContinentSummary
select top 1 FamilyID, FamilyName, ParentFamilyId from tblFamily