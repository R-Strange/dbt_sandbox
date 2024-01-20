with payments as (

    select * from {{ ref("stg_payments") }}

),

orders as (

select * from {{ ref("stg_orders") }}

),

order_payments as (

    select
        orders.order_id,
        orders.customer_id,
        payments.payment_amount as amount
    from orders
    left join payments on orders.order_id = payments.order_id

    where payments.payment_status = "success"

),

/* total_amount_per_customer as (

    select
        customer_id,
        sum(payment_amount) as amount

    from order_payments

    group by customer_id

), */


final as (

    select
        order_id,
        customer_id,
        amount
    
    from order_payments

)

select * from final