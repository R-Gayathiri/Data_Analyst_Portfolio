----1----

--What is the total number of parts per theme.

--create view dbo.analytics_main as

select s.set_num,s.theme_id,s.name as set_name,s.year,CAST(s.num_parts as numeric)num_parts,
	t.name as theme_name,t.parent_id,p.name as parent_theme_name
from dbo.sets as s
left join dbo.themes as t
	on s.theme_id=t.id 
left join dbo.themes as p
	on t.id=p.parent_id

select theme_name, sum(num_parts) as Total_numb_parts
from dbo.analytics_main
--where parent_theme_name is not null
group by theme_name
order by 2 desc


----2----
--What is the total number of parts per year.
--select * from dbo.analytics_main

select year, sum(num_parts) as Total_numb_parts
from dbo.analytics_main
--where parent_theme_name is not null
group by year
order by 2 desc		


----3----
--How many sets were created in each century

--select * from dbo.analytics_main
select Century, count(set_num) as Total_set_number
from dbo.analytics_main
--where parent_theme_name is not null
group by Century

----4----
--What percentage of sets were released in the 21st century where Trains themed 

--select * from dbo.analytics_main
with cte as
(
select Century, theme_name,count(set_num) as total_sum
from dbo.analytics_main
where  Century='21st Century'
group by Century,theme_name
)
select sum(total_sum),sum(percentage) 
from (
	select Century,theme_name,total_sum, sum(total_sum) over() as total, cast(total_sum * 1.00/ sum(total_sum) over() as decimal(5,4))*100 as percentage
	from cte
	--Order by 3 desc
	)m
where theme_name like '%train%'

----5----
-- What was the popular theme by year in the 21st Century
select year, theme_name, total
from(
	select year, theme_name, count(set_num) as total , ROW_NUMBER() over(partition by year order by count(set_num) desc) as r
	from dbo.analytics_main
	where Century='21st Century'
	and parent_theme_name is not null
	group by year, theme_name
)m
where r=1
order by year desc

----6----
--What is the most produced Color of LEGO

select color_name, sum(quantity) as quantity_of_parts
from  
(
select inv.color_id,inv.inventory_id,inv.part_num, cast(inv.quantity as numeric)quantity, c.name as color_name, p.name as part_name
from inventory_parts inv
inner join parts p
on inv.part_num=p.part_num
inner join colors c
on inv.color_id=c.id

)main
group by color_name
order by quantity_of_parts desc
