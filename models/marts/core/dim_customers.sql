with customers as (

    select * from {{ ref("stg_customers") }}

),

orders as (

    select * from {{ ref("stg_orders") }}
),

order_payments as (

    select * from {{ ref("fct_orders") }}

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),

total_amount_per_customer as (

    select
        customer_id,
        sum(amount) as lifetime_value
    
    from order_payments 

    group by customer_id

),

customer_and_number_of_orders as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders

    from customers

    left join customer_orders using (customer_id)

),

final as (

    select
        t1.customer_id,
        t1.first_name,
        t1.last_name,
        t1.first_order_date,
        t1.most_recent_order_date,
        t1.number_of_orders,
        coalesce(t2.lifetime_value, 0) as lifetime_value

    from customer_and_number_of_orders as t1
    left join total_amount_per_customer as t2
    on t1.customer_id = t2.customer_id

)

select * from final