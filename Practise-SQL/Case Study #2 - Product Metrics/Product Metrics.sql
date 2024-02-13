-- 1. Paid Users, Churned Users, Churn Rate
with monthly_activity as (
	select 
		distinct date_trunc('month', payment_date) as month,
		user_id
	from project.games_payments
),
churn_count_users as ( 
select 
	cast(current_month.month + interval '1 month' as date) as month, 
	sum(case when next_month.month is null then 1 else 0 end) as churned_users
from monthly_activity current_month
	left join monthly_activity next_month
		on current_month.month + interval '1 month' = next_month.month
			and current_month.user_id = next_month.user_id
group by 1
order by 1
)
select 
	ma.month::date,
	count(distinct ma.user_id) as paid_users,
	cu.churned_users,
	round(cu.churned_users * 1.00 / count(distinct ma.user_id) * 100.00, 2) as churne_rate
from monthly_activity ma
	left join churn_count_users cu
		on ma.month = cu.month
group by 1,3
;

-- 2. ARPPU (monthly)
select 
	payment_month,
	round(sum(monthly_revenue) / count(distinct user_id),2) as arppu
from (
	select 
		user_id,
		(date_trunc('month', payment_date))::date as payment_month,
		(sum(revenue_amount_usd)) as monthly_revenue
	from project.games_payments
	group by 1,2
	order by 1,2
	) as monthly_payments
group by 1
order by 1
;

-- 3. New Paid Users  
select 
	cast(first_payment_month as date),
	count(distinct user_id) as new_paid_users
from (
    select 
        user_id,
        min(date_trunc('month', payment_date)) as first_payment_month
    from project.games_payments
    group by 1) as first_payment_per_user
group by 1

-- 4. MRR, Churned Revenue (Churned MRR), Revenue Churn Rate
with user_payments as (
    select 
        user_id,
        date_trunc('month', payment_date) as payment_month,
        sum(revenue_amount_usd) as monthly_revenue
    from project.games_payments
    group by 1, 2
    order by 1,2
),
payment_months as (
    select
        user_id,
        monthly_revenue,
        payment_month,
        lead(payment_month) over (partition by user_id order by payment_month) as next_payment_month
    from user_payments
),
churned_revenue as(
  	select 
  	    (payment_month + INTERVAL '1 month')::date as month,
    		round(SUM(monthly_revenue),0) as churned_revenue
  	from payment_months
  	where next_payment_month is null or next_payment_month > payment_month + interval '1 month'
  	group by 1
  	order by 1
),
mrr as(
  	select 
  		(payment_month)::date as month,
  		round(SUM(monthly_revenue),0) as MRR
  	from payment_months
  	group by 1
  	order by 1
),
previous_month_mrr as (
    select 
        (month + interval '1 month')::date as month,
        mrr as previous_mrr
    from mrr
)
select 
    mrr.month,
    cr.churned_revenue,
    mrr.mrr,
    round(coalesce(cr.churned_revenue*1.00 / nullif(pm.previous_mrr, 0)*100.00, 0),2) AS revenue_churn_rate
from mrr
  left join churned_revenue cr 
    on mrr.month = cr.month 
  left join previous_month_mrr pm 
    on mrr.month = pm.month
order by mrr.month
;

-- 5. New MRR
with user_payments as (
    select 
        user_id,
        date_trunc('month', payment_date) as payment_month,
        SUM(revenue_amount_usd) as monthly_revenue
    from project.games_payments
    group by 1, 2
    order by 1,2
),
payment_months as (
    select
        user_id,
        monthly_revenue,
        payment_month,
        row_number() over(partition by user_id order by payment_month) as num_payment_month
    from user_payments
)
select 
	(payment_month)::date as month,
	round(SUM(monthly_revenue),0) as new_mrr
from payment_months
where num_payment_month = '1'
group by 1
order by 1
;

-- 6. Expansion MRR, Contraction MRR
with user_payments AS (
    select 
        user_id,
        cast(date_trunc('month', payment_date) as date) as month,
        sum(revenue_amount_usd) as mrr
    from project.games_payments
    group by 1,2
    order by 1,2
),
previous_month_payment as(
    select
    	  user_id,
        (month + interval '1 month')::date as month,
        mrr as previous_mrr
    from user_payments
),
expansion_mrr as(
  	select 
    		mrr.month,
    		sum(mrr.mrr - pmrr.previous_mrr) as expansion_mrr
  	from user_payments mrr
  		left join previous_month_payment pmrr
  			on mrr.user_id = pmrr.user_id 
          and mrr.month = pmrr.month
  	where mrr.mrr > pmrr.previous_mrr
  	group by 1
  	order by 1
),
contraction_mrr as(
  	select 
    		mrr.month,
    		sum(mrr.mrr - pmrr.previous_mrr) as contraction_mrr
  	from user_payments mrr
  		left join previous_month_payment pmrr
  			on mrr.user_id = pmrr.user_id 
          and mrr.month = pmrr.month
  	where mrr.mrr < pmrr.previous_mrr
  	group by 1
  	order by 1
)
select 
  	emrr.month,
  	emrr.expansion_mrr,
  	cmrr.contraction_mrr
from expansion_mrr emrr
  left join contraction_mrr cmrr
    on emrr.month = cmrr.month
;

-- 7. LT (LIFE TIME)
select 
	avg(payment_month) as life_time
from (
	select 
		user_id,
		count(distinct DATE_TRUNC('month', payment_date)) as payment_month
	from project.games_payments
	group by 1
	) as months_count
;
