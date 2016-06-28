
select 
    ref.Ticker as Ticker,
    mst.name as name,
	mst.Sedol as sedol,
    val.CalPerEndDt as qtr_end,
	val.StmtDt as stmtdt,
    val.value_ as EPS,
	case 
		when val2.value_ is null 
		then val3.value_ 
		else val2.value_ 
	end as REVENUE,
	rank() OVER (partition by mst.Sedol order by val.stmtdt desc) as rank_
    --ite.desc_
    ,* -- you may pick the fields that you would like to display and comment this line
from secmstrx mst
join secmapx map
    on mst.seccode=map.seccode
    --and mst.sedol in ('B44WZD','BYVY8G','264910')
	--and mst.sedol in (%s) 
    and map.rank=1 --- rank 1 gives the current valid mapping
    and map.ventype=26 -- ventype for Reuters Fundamental - RKD
    and mst.Sedol is not null
join RKDFndcmpRefIssue ref -- this table allows us to join the master tables to the RKD schema
    on ref.issuecode=map.vencode
    --and ref.IssueID=1 --issue 1 only to mitigate Brown Forman problem
join RKDFndStdFinVal val -- here we are pulling the data from the standard financial values
    on val.code=ref.code
    and val.item=150 --10: EPS; 150: revenue
	and val.CalPerEndDt = val.CalStmtDt --unrestated
	and val.PerTypeCode = 2 -- only quarterly
left join RKDFndStdFinVal val2 -- here we are pulling the data from the standard financial values
    on val2.code=ref.code
    and val2.item=10 --10: EPS; 150: revenue
	and val2.CalPerEndDt = val2.CalStmtDt --unrestated
	and val2.PerTypeCode = 2 -- only quarterly
	and val.CalPerEndDt = val2.CalPerEndDt
left join RKDFndStdFinVal val3 -- here we are pulling the data from the standard financial values
    on val3.code=ref.code
    and val3.item=25 --10: EPS; 150: revenue
	and val3.CalPerEndDt = val3.CalStmtDt --unrestated
	and val3.PerTypeCode = 2 -- only quarterly
	and val.CalPerEndDt = val3.CalPerEndDt
join RKDFndStdItem ite -- we join this table to have the text definition of the item we are pulling the value for
    on val.item = ite.item
	and val.PerTypeCode = 2 -- only quarterly
where mst.SecCode in (
10641,
10642,
30902,
11131355
)



SELECT * 
from secmstrx mst
join secmapx map
    on mst.seccode=map.seccode
    --and mst.sedol in ('B44WZD','BYVY8G','264910')
	--and mst.sedol in (%s) 
    and map.rank=1 --- rank 1 gives the current valid mapping
    and map.ventype=26 -- ventype for Reuters Fundamental - RKD
    and mst.sedol  is not null
join RKDFndcmpRefIssue ref -- this table allows us to join the master tables to the RKD schema
    on ref.issuecode=map.vencode
join RKDFndStdFinVal val -- here we are pulling the data from the standard financial values
    on val.code=ref.code
    and val.item=150 --10: EPS; 150: revenue
	and val.CalPerEndDt = val.CalStmtDt --unrestated
	and val.PerTypeCode = 2 -- only quarterly
where mst.SecCode in (
10641,
10642,
30902,
11131355
)
and val.CalPerEndDt>='2015-12-31'


select * from RKDFndcmpRefIssue


select * from RKDFndInfo where code = 10641
select * from RKDFndInfo where code = 10642

select
*
from secmstrx mst
join secmapx map
on mst.seccode=map.seccode
and map.rank = 1
and map.ventype=26
join RKDFndcmpRefIssue ref
on ref.issuecode=map.vencode
join RKDFndStdFinVal val
on val.code = ref.code
and val.item in (10, 150,25)
and val.PerEndDt > '20160101'
--where mst.id in ('38259P70','WFC','BF.B','BF.A')\
where mst.id in ('38259P70','WFC','BF.B','BF.A')

select * from secmstrx where Name like 'ALPHABET%'

30902
11131355


select * from RKDFndStdFinVal 
select * from RKDFndStdItem 

select * from RKDFndInfo

select
mst.id,
val.*
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
where ref.Ticker in 
('IBM')


select
mst.id,
val.*
from (select *,1 as typ from secmstrx union select *,6 as typ from gsecmstrx) mst
join (select *,1 as typ from secmapx union select *,6 as typ from gsecmapx) map
on mst.seccode=map.seccode
and mst.typ = map.typ
and mst.type_ in (1,10)
and map.rank = 1
and map.ventype=26
join RKDFndcmpRefIssue ref
on ref.issuecode=map.vencode
join RKDFndStdFinVal val
on val.code = ref.code
and val.item in (10,25)
--and val.PerEndDt > '20160101'
where ref.Ticker in 
(
'AET',
'AFG',
'AFL',
'AIG',
'ALL',
'CI',
'CINF',
'CMS',
'CNA',
'DTE',
'HIG',
'HUM',
'L',
'LNC',
'MET',
'MKL',
'OKE',
'PGR',
'PPL',
'RGA',
'SRE',
'TMK',
'TRV',
'UGI',
'UNH',
'UNM',
'WEC',
'WR',
'WRB',
'Y')

