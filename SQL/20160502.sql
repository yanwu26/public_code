DROP TABLE ##TMP


select 
p.marketdate,
m.Sedol,
e.DsExchCode,
m.Country,
m.name,
p.Close_,
p.Volume,
mv.ConsolNumShrs,
mv.ConsolMktVal
INTO ##TMP
from		secmstrx m			
inner join	secmapx ds			-- Join to the datastream map
	on			m.seccode = ds.seccode --Join to datastream
	and			m.Type_ = 1				--North America Securities is 1, 10 is global
	and			ds.ventype = 33        -- Datastream is vent type of 33
	--and			ds.rank = 1				--Rank for multiple issues.  Use the first.
join ds2ctryqtinfo di
	on			di.infocode = ds.vencode
join ds2primqtprc p
	on			p.infocode = di.infocode
join DS2Exchange e
	on			p.ExchIntCode = e.ExchIntCode
join ds2mktval mv	
	on			di.infocode = mv.infocode
and mv.valdate = p.marketdate
where 
--p.MarketDate = '20160429'
--and p.Volume is null
 di.Region = 'US'

