--
--This Query returns all stocks by Market Cap in the United States
--This the QAI DataStream2 database, which contains all public information
--2016-06-30
--
DECLARE @start_dt AS DATETIME
DECLARE @end_dt AS DATETIME
DECLARE @no_qtr AS int
DECLARE @mv_rank AS int
--SET @start_dt = '20160331'
--SET @end_dt= DATEADD(week,12,@start_dt)
--SET @no_qtr = 4
--SET @mv_rank= 1000
SET @start_dt = '%s'
SET @end_dt= '%s'
SET @no_qtr = %s
SET @mv_rank= %s
--print @start_dt
--print @end_dt
select * from (
select 
mv.ValDate,
m.Id,
m.sedol,
m.name, 
mv.ConsolMktVal,
p1.RI as prc_st,
p2.RI as prc_end,
p2.RI/p1.RI-1 as ret,
row_number() OVER (ORDER BY mv.ConsolMktVal desc) AS Rank_
from		secmstrx m			--North America - Security Master
inner join	secmapx ds			-- Join to the datastream map
	on			m.seccode = ds.seccode --Join to datastream
	and			ds.ventype = 33        -- Datastream is vent type of 33
	and			ds.rank = 1				--Rank for multiple issues.  Use the first.
	and			m.Type_ = 1				--North America Securities
join ds2ctryqtinfo di
	on			di.infocode = ds.vencode
	and di.TypeCode='EQ'				--Equities only
join DS2ExchQtInfo ex
	on di.InfoCode=ex.InfoCode
	and ex.IsPrimExchQt='Y'
	and di.CovergCode='F'
join ds2mktval mv	
	on di.infocode = mv.infocode
	and mv.ValDate = @start_dt
join ds2primqtri p1
	on di.infocode = p1.infocode
	and p1.MarketDate = @start_dt
left join ds2primqtri p2
	on di.infocode = p2.infocode
	and p2.MarketDate = @end_dt
where di.Region='US'
and m.country='USA'
) b
where b.Rank_<=@mv_rank
--
--EOF
--