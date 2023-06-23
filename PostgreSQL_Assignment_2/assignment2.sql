---------------ASSIGNMENT 2--------------------------------
 -- QUERY 1
 create or replace view member_data as
 SELECT
     m2.memberid,
	 m2.firstname,
	 m2.joindate,
	 m3.type,
	 m2.gender,
	 m2.coachname,
	 m1.teamname
 FROM
     members m2
 JOIN team m1 on m1.teamid = m2.teamid
 JOIN membertype m3 on m2.membertypeid = m3.id
 
 select * from member_data
 
 --QUERY 2
 SELECT
     m1.firstname,
	 t1.year,
	 count(*) AS numbers_of_tours
 FROM
     members m1
 JOIN tournament_entry t1 on m1.memberid = t1.memberid
 group by m1.memberid, t1.year
 order by m1.memberid
 
 -- according to my tables and their data, a particular
 -- member did only 1 tour in a year so the above query
 -- shows number_of_tours = 1 for every member
 
 --QUERY 3
 SELECT
     m1.firstname,
	 m2.type,
	 m1.coachname
 FROM
     members m1
 JOIN membertype m2 on m1.membertypeid = m2.id
 JOIN tournament_entry m3 on m1.memberid = m3.memberid
 where m3.tourid = null
 
  -- according to my tables and their data, there is no
  -- member who has never participated in the tournament
  -- so above queries will show empty table structure
 
 -- QUERY 4
 create or replace view tournament_data as
 SELECT
     t2.id,
	 t2.tour_name,
	 t2.country,
	 t1.year,
	 count(*)
 FROM
     tournament_entry t1
 JOIN tournament t2 on t1.tourid = t2.id
 group by t2.id, t1.year
 order by t2.id asc
 
 select * from tournament_data
 
 ALTER TABLE tournament_data RENAME COLUMN count TO number_of_participants;
 
 -- QUERY 5
 
  create or replace view team_data as
 SELECT
     t1.teamid,
	 t1.teamname,
	 count(t2.teamid), 
	 SUM (t3.fee) AS total_fee
 FROM
     team t1
 JOIN members t2 on t1.teamid = t2.teamid
 JOIN membertype t3 on t2.membertypeid = t3.id
 group by t1.teamid 
 order by t1.teamname asc
 
 ALTER TABLE team_data RENAME COLUMN count TO number_of_team_members;
 ALTER TABLE team_data RENAME COLUMN total_fee TO membership_fees;
 
 select * from team_data
 
  -- QUERY 6
 create or replace view open_tournament_data as
 SELECT
     t1.tour_name,
	 t1.country,
	 t1.tour_type,
	 t2.year,
	 count(*) AS number_of_participants
 FROM
     tournament t1
 JOIN tournament_entry t2 on t2.tourid = t1.id
 --JOIN tournament_data t3 on t1.tour_name = t3.tour_name
 where t2.year = (select max(year) from tournament_entry)
 and t1.is_open = true
 group by t1.id, t2.year
 order by t1.id asc
 
 select * from open_tournament_data
 
 -- According to the data of my tables, there is no open tournaments in current year,
 -- so above query will show nothing in my table. 
 -- To prove the validity, I am showing all the non-open tournaments in below query.
 
 create or replace view open_tournament_data as
 SELECT
     t1.tour_name,
	 t1.country,
	 t1.tour_type,
	 t2.year,
	 count(*) AS number_of_participants
 FROM
     tournament t1
 JOIN tournament_entry t2 on t2.tourid = t1.id
 --JOIN tournament_data t3 on t1.tour_name = t3.tour_name
 where t2.year = (select max(year) from tournament_entry)
 and t1.is_open = false
 group by t1.id, t2.year
 order by t1.id asc
 
 select * from open_tournament_data
 
 -----------------------------------------------------
 