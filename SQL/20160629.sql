select * from (
select 
    ref.Ticker as Ticker,
    mst.name as name,
	mst.Sedol as sedol,
    val.CalPerEndDt as qtr_end,
	val.StmtDt as stmtdt,
    val.value_ as EPS,
	case 
        when val2.value_ is null and val3.value_ is null then val4.Value_
		when val2.value_ is null then val3.value_ 
		else val2.value_ 
	end as REVENUE,
	val.perenddt,
	f.origanncdt,
	rank() OVER (partition by mst.Sedol order by val.stmtdt desc) as rank_
    --ite.desc_
    --,* 
from secmstrx mst
join secmapx map
    on mst.seccode=map.seccode
    --and mst.sedol in (%s)  --input sedols
    and map.rank=1 --- rank 1 gives the current valid mapping
    and map.ventype=26 -- ventype for Reuters Fundamental - RKD
    and mst.Sedol is not null
join RKDFndcmpRefIssue ref 
    on ref.issuecode=map.vencode
join RKDFndStdFinVal val 
    on val.code=ref.code
    and val.item=150 --10: EPS; 150: revenue
	and val.CalPerEndDt = val.CalStmtDt --unrestated
	and val.PerTypeCode = 2 -- only quarterly
left join RKDFndStdFinVal val2 
    on val2.code=ref.code
    and val2.item=10 --revenue
	and val2.CalPerEndDt = val2.CalStmtDt --unrestated
	and val2.PerTypeCode = 2 -- only quarterly
	and val.CalPerEndDt = val2.CalPerEndDt
left join RKDFndStdFinVal val3 
    on val3.code=ref.code
    and val3.item=25 --interest income for banks
	and val3.CalPerEndDt = val3.CalStmtDt --unrestated
	and val3.PerTypeCode = 2 -- only quarterly
	and val.CalPerEndDt = val3.CalPerEndDt
left join RKDFndStdFinVal val4 
    on val4.code=ref.code
    and val4.item=31 --31 
	and val4.CalPerEndDt = val4.CalStmtDt --unrestated
	and val4.PerTypeCode = 2 -- only quarterly
	and val.CalPerEndDt = val4.CalPerEndDt
join RKDFndStdItem ite -- we join this table to have the text definition of the item we are pulling the value for
    on val.item = ite.item
	and val.PerTypeCode = 2 -- only quarterly
join rkdfndstdperfiling f
    on f.code=val.code
    and f.perenddt=val.perenddt
    and f.pertypecode=val.pertypecode
    and f.stmtdt=val.stmtdt
where ref.Ticker IN ('WFC','STT')
) b
where b.rank_<=4



select
mst.id,
val.*
, f.origanncdt 
, s.SourceDt
from secmstrx mst
join secmapx map
on mst.seccode=map.seccode
and map.rank = 1
and map.ventype=26
join RKDFndcmpRefIssue ref
on ref.issuecode=map.vencode
join RKDFndStdFinVal val
on val.code = ref.code
and val.item in (10,25)
and val.PerEndDt > '20160101'
join rkdfndstdperfiling f
    on f.code=val.code
    and f.perenddt=val.perenddt
    and f.pertypecode=val.pertypecode
    and f.stmtdt=val.stmtdt

join rkdfndstdstmt  s
    on s.code=val.code
    and s.perenddt=val.perenddt
    and s.pertypecode=val.pertypecode
    and s.stmtdt=val.stmtdt
    and s.stmttypecode=val.stmttypecode
where ref.Ticker in
('IBM')


select 
    ref.Ticker as Ticker,
    mst.name as name,
	mst.Sedol as sedol,
    val.CalPerEndDt as qtr_end,
	val.StmtDt as stmtdt,
    val.value_ as EPS,
	case 
        when val2.value_ is null and val3.value_ is null then val4.Value_
		when val2.value_ is null then val3.value_ 
		else val2.value_ 
	end as REVENUE,
	val.perenddt,
	f.origanncdt,
	rank() OVER (partition by mst.Sedol order by val.stmtdt desc) as rank_
    --ite.desc_
    ,* 
from secmstrx mst
join secmapx map
    on mst.seccode=map.seccode
    --and mst.sedol in (%s)  --input sedols
    and map.rank=1 --- rank 1 gives the current valid mapping
    and map.ventype=26 -- ventype for Reuters Fundamental - RKD
    and mst.Sedol is not null
join RKDFndcmpRefIssue ref 
    on ref.issuecode=map.vencode
join RKDFndStdFinVal val 
    on val.code=ref.code
    and val.item=150 --10: EPS; 150: revenue
	and val.CalPerEndDt = val.CalStmtDt --unrestated
	and val.PerTypeCode = 2 -- only quarterly
left join RKDFndStdFinVal val2 
    on val2.code=ref.code
    and val2.item=10 --revenue
	and val2.CalPerEndDt = val2.CalStmtDt --unrestated
	and val2.PerTypeCode = 2 -- only quarterly
	and val.CalPerEndDt = val2.CalPerEndDt
left join RKDFndStdFinVal val3 
    on val3.code=ref.code
    and val3.item=25 --interest income for banks
	and val3.CalPerEndDt = val3.CalStmtDt --unrestated
	and val3.PerTypeCode = 2 -- only quarterly
	and val.CalPerEndDt = val3.CalPerEndDt
left join RKDFndStdFinVal val4 
    on val4.code=ref.code
    and val4.item=31 --31 
	and val4.CalPerEndDt = val4.CalStmtDt --unrestated
	and val4.PerTypeCode = 2 -- only quarterly
	and val.CalPerEndDt = val4.CalPerEndDt
join RKDFndStdItem ite -- we join this table to have the text definition of the item we are pulling the value for
    on val.item = ite.item
	and val.PerTypeCode = 2 -- only quarterly
join rkdfndstdperfiling f
    on f.code=val.code
    and f.perenddt=val.perenddt
    and f.pertypecode=val.pertypecode
    and f.stmtdt=val.stmtdt
	and f.FinalFiling=1
where ref.Ticker IN ('TGNA')
and f.OrigAnncDt = '20150421'
--where f.origanncdt<='%s' 


select * from SecMapx where seccode =  9132
select * from secmstrx where seccode =  9132

select * 
from secmstrx mst
join secmapx map
    on mst.seccode=map.seccode
    --and mst.sedol in (%s)  --input sedols
    and map.rank=1 --- rank 1 gives the current valid mapping
    and map.ventype=26 -- ventype for Reuters Fundamental - RKD
    and mst.Sedol is not null
join RKDFndcmpRefIssue ref 
    on ref.issuecode=map.vencode
join RKDFndStdFinVal val 
    on val.code=ref.code
    and val.item=150 --10: EPS; 150: revenue
	and val.CalPerEndDt = val.CalStmtDt --unrestated
	and val.PerTypeCode = 2 -- only quarterly
where map.seccode = 9132


select * 
from secmstrx mst
join secmapx map
    on mst.seccode=map.seccode
    --and mst.sedol in (%s)  --input sedols
    and map.rank=1 --- rank 1 gives the current valid mapping
    and map.ventype=26 -- ventype for Reuters Fundamental - RKD
    and mst.Sedol is not null
join RKDFndcmpRefIssue ref 
    on ref.issuecode=map.vencode
join RKDFndStdFinVal val 
    on val.code=ref.code
    and val.item=150 --10: EPS; 150: revenue
	and val.CalPerEndDt = val.CalStmtDt --unrestated
	and val.PerTypeCode = 2 -- only quarterly
left join RKDFndStdFinVal val2 
    on val2.code=ref.code
   and val2.item=10 --revenue
	and val2.CalPerEndDt = val2.CalStmtDt --unrestated
	and val2.PerTypeCode = 2 -- only quarterly
	and val.CalPerEndDt = val2.CalPerEndDt
left join RKDFndStdFinVal val3 
    on val3.code=ref.code
    and val3.item=25 --interest income for banks
	and val3.CalPerEndDt = val3.CalStmtDt --unrestated
	and val3.PerTypeCode = 2 -- only quarterly
	and val.CalPerEndDt = val3.CalPerEndDt
--left join RKDFndStdFinVal val4 
--    on val4.code=ref.code
--    and val4.item=31 --31 
--	and val4.CalPerEndDt = val4.CalStmtDt --unrestated
--	and val4.PerTypeCode = 2 -- only quarterly
--	and val.CalPerEndDt = val4.CalPerEndDt
join RKDFndStdItem ite -- we join this table to have the text definition of the item we are pulling the value for
    on val.item = ite.item
	and val.PerTypeCode = 2 -- only quarterly
join rkdfndstdperfiling f
    on f.code=val.code
    and f.perenddt=val.perenddt
    and f.pertypecode=val.pertypecode
    and f.stmtdt=val.stmtdt
	and f.FinalFiling=1
where ref.Ticker IN ('TGNA')
and val.perenddt = '20150329'




select * 
from secmstrx mst
join secmapx map
    on mst.seccode=map.seccode
    --and mst.sedol in (%s)  --input sedols
    and map.rank=1 --- rank 1 gives the current valid mapping
    and map.ventype=26 -- ventype for Reuters Fundamental - RKD
    and mst.Sedol is not null
join RKDFndcmpRefIssue ref 
    on ref.issuecode=map.vencode
join RKDFndStdFinVal val 
    on val.code=ref.code
    and val.item=10 --10: EPS; 150: revenue
	and val.CalPerEndDt = val.CalStmtDt --unrestated
	and val.PerTypeCode = 2 -- only quarterly
where map.seccode=29132
and val.perenddt = '20150329'
