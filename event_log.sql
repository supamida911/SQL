select count(*)
from event.log;

select *
from event.log;

# DAU
select substr(event_time, 1, 10) as 'date',
	count(distinct user_id) as DAU
from event.log
group by 1
order by 1;

# WAU
select week(event_time) as 'week',
	count(distinct user_id) as WAU
from event.log
group by 1
order by 1;

# MAU
select substr(event_time, 1, 7) as YM,
	count(distinct user_id) as MAU
from event.log
group by 1
order by 1;

# ARPPU
-- event_type= purchase
-- Daily
select substr(event_time, 1, 10) as 'date',
	count(distinct user_id) as PU,
	sum(price) as rev,
    sum(price)/ count(distinct user_id) as ARPPU
from event.log
where event_type= 'purchase'
group by 1
order by 1;
-- Weekly
select week(event_time) as 'week',
	count(distinct user_id) as PU,
	sum(price) as rev,
    sum(price)/ count(distinct user_id) as ARPPU
from event.log
where event_type= 'purchase'
group by 1
order by 1;
-- Monthly
select substr(event_time, 1, 7) as YM,
	count(distinct user_id) as PU,
	sum(price) as rev,
    sum(price)/ count(distinct user_id) as ARPPU
from event.log
where event_type= 'purchase'
group by 1
order by 1;

# ARPU
-- total revenue / active users
-- Daily
select substr(event_time, 1, 10) as 'date',
	count(distinct user_id) as DAU,
    sum(price) as rev,
    sum(price)/ count(distinct user_id) as ARPU
from event.log
group by 1
order by 1;
-- Weekly
select week(event_time) as 'week',
	count(distinct user_id) as WAU,
    sum(price) as rev,
    sum(price)/ count(distinct user_id) as ARPU
from event.log
group by 1
order by 1;
-- Monthly
select substr(event_time, 1, 7) as YM,
	count(distinct user_id) as MAU,
    sum(price) as rev,
    sum(price)/ count(distinct user_id) as ARPU
from event.log
group by 1
order by 1;

# Conversion Rate
-- view-> cart-> purchase
-- view user
with view_user as
(select substr(event_time, 1, 10) as event_date,
	user_id
from event.log
where event_type= 'view'),
-- cart user
cart_user as
(select substr(event_time, 1, 10) as event_date,
	user_id
from event.log
where event_type= 'cart'),
-- purchse user
paid_user as
(select substr(event_time, 1, 10) as event_date,
	user_id
from event.log
where event_type= 'purchase')

select a.event_date,
	count(distinct a.user_id) as view_cnt,
    count(distinct b.user_id) as cart_cnt,
    count(distinct c.user_id) as purchase_cnt
from view_user as a
	left join cart_user as b
		on a.user_id= b.user_id
	left join paid_user as c
		on a.user_id= c.user_id
			and b.user_id= c.user_id
group by 1
order by 1;

select count(*)
from event.log;