
select top 1000
    fi.Ticker as Ticker,
    mst.name as name,
	mst.Sedol as sedol,
    val.CalPerEndDt as qtr_end,
	val.StmtDt as stmtdt,
    val.value_ as EPS,
	val2.value_ as REVENUE,
	rank() OVER (partition by mst.Sedol order by val.stmtdt desc) as rank_
    --ite.desc_
    ,* -- you may pick the fields that you would like to display and comment this line
from secmstrx mst
join secmapx map
    on mst.seccode=map.seccode
    --and mst.sedol in ('BYY88Y')
	--and mst.sedol in ('BYY88Y','264910')
	--and mst.sedol in (%s) 
    and map.rank=1 --- rank 1 gives the current valid mapping
    and map.ventype=26 -- ventype for Reuters Fundamental - RKD
    --and mst.Sedol is not null
join RKDFndcmpRefIssue ref -- this table allows us to join the master tables to the RKD schema
    on ref.issuecode=map.vencode
    --and ref.IssueID=1 --issue 1 only to mitigate Brown Forman problem
join RKDFndStdFinVal val -- here we are pulling the data from the standard financial values
    on val.code=ref.code
    and val.item=150 --10: EPS; 150: revenue
	and val.CalPerEndDt = val.CalStmtDt --unrestated
	and val.PerTypeCode = 2 -- only quarterly
join RKDFndStdFinVal val2 -- here we are pulling the data from the standard financial values
    on val2.code=ref.code
    and val2.item=10 --10: EPS; 150: revenue
	and val2.CalPerEndDt = val2.CalStmtDt --unrestated
	and val2.PerTypeCode = 2 -- only quarterly
	and val.CalPerEndDt = val2.CalPerEndDt
join RKDFndStdItem ite -- we join this table to have the text definition of the item we are pulling the value for
    on val.item = ite.item
	and val.PerTypeCode = 2 -- only quarterly
join RKDFndInfo fi
	on fi.code = val.code
--where val.code = 81183



select top 1000
    fi.Ticker as Ticker,
    mst.name as name,
	mst.Sedol as sedol,
    val.CalPerEndDt as qtr_end,
	val.StmtDt as stmtdt,
    val.value_ as EPS,
	val2.value_ as REVENUE
	--,rank() OVER (partition by mst.Sedol order by val.stmtdt desc) as rank_
    --ite.desc_
    ,* -- you may pick the fields that you would like to display and comment this line
from secmstrx mst
join secmapx map
    on mst.seccode=map.seccode
    --and mst.sedol in ('BYY88Y')
	--and mst.sedol in ('BYY88Y','264910')
	--and mst.sedol in (%s) 
    and map.rank=1 --- rank 1 gives the current valid mapping
    and map.ventype=26 -- ventype for Reuters Fundamental - RKD
    --and mst.Sedol is not null
join RKDFndcmpRefIssue ref -- this table allows us to join the master tables to the RKD schema
    on ref.issuecode=map.vencode
    --and ref.IssueID=1 --issue 1 only to mitigate Brown Forman problem
join RKDFndStdFinVal val -- here we are pulling the data from the standard financial values
    on val.code=ref.code
    and val.item=150 --10: EPS; 150: revenue
	and val.CalPerEndDt = val.CalStmtDt --unrestated
	and val.PerTypeCode = 2 -- only quarterly
join RKDFndStdFinVal val2 -- here we are pulling the data from the standard financial values
    on val2.code=ref.code
    and val2.item=10 --10: EPS; 150: revenue
	and val2.CalPerEndDt = val2.CalStmtDt --unrestated
	and val2.PerTypeCode = 2 -- only quarterly
	and val.CalPerEndDt = val2.CalPerEndDt
join RKDFndStdItem ite -- we join this table to have the text definition of the item we are pulling the value for
    on val.item = ite.item
	and val.PerTypeCode = 2 -- only quarterly
join RKDFndInfo fi
	on fi.code = val.code
where mst.Sedol = '264910'


select * from secmstrx where Sedol = '264910'

select * 
from secmstrx mst
join secmapx map
    on mst.seccode=map.seccode
and map.rank=1 --- rank 1 gives the current valid mapping
    and map.ventype=26 -- ventype for Reuters Fundamental - RKD
join RKDFndcmpRefIssue ref -- this table allows us to join the master tables to the RKD schema
    on ref.issuecode=map.vencode
    --and ref.IssueID=1 --issue 1 only to mitigate Brown Forman problem
join RKDFndStdFinVal val -- here we are pulling the data from the standard financial values
    on val.code=ref.code
    and val.item=150 --10: EPS; 150: revenue
	and val.CalPerEndDt = val.CalStmtDt --unrestated
	and val.PerTypeCode = 2 -- only quarterly
join RKDFndStdFinVal val2 -- here we are pulling the data from the standard financial values
   on val2.code=ref.code
   and val2.item=10 --10: EPS; 150: revenue
--	and val2.CalPerEndDt = val2.CalStmtDt --unrestated
--	and val2.PerTypeCode = 2 -- only quarterly
--	and val.CalPerEndDt = val2.CalPerEndDt
--join RKDFndStdItem ite -- we join this table to have the text definition of the item we are pulling the value for
--    on val.item = ite.item
--	and val.PerTypeCode = 2 -- only quarterly
--join RKDFndInfo fi
--	on fi.code = val.code
where mst.sedol in ('BYY88Y','264910')



select * 
from RKDFndStdFinVal
where code in (3438)
and item in (10,150)
and PerTypeCode = 2
order by code, PerEndDt desc

select * 
from RKDFndStdFinVal
where code in (3438)
and item in (10,150)
and PerTypeCode = 2
order by code, PerEndDt desc


select * 
from secmstrx mst
join secmapx map
    on mst.seccode=map.seccode
and map.rank=1 --- rank 1 gives the current valid mapping
    and map.ventype=26 -- ventype for Reuters Fundamental - RKD
join RKDFndcmpRefIssue ref -- this table allows us to join the master tables to the RKD schema
    on ref.issuecode=map.vencode
    --and ref.IssueID=1 --issue 1 only to mitigate Brown Forman problem
join RKDFndStdFinVal val -- here we are pulling the data from the standard financial values
    on val.code=ref.code
    and val.item in (150,10)--: EPS; 150: revenue
	and val.CalPerEndDt = val.CalStmtDt --unrestated
	and val.PerTypeCode = 2 -- only quarterly
where mst.sedol  in ('BYY88Y','264910')
and val.PerEndDt = '20160331'
order by mst.sedol, val.CalPerEndDt desc
