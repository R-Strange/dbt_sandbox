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
        payments.payment_amount
    from orders
    left join payments on orders.order_id = payments.order_id

),

total_amount_per_customer as (

    select
        customer_id,
        sum(payment_amount) as amount

    from order_payments

    group by customer_id

),

final as (

    select
        orders.order_id,
        orders.customer_id,
        total_amount_per_customer.amount
    
    from orders
    left join total_amount_per_customer on orders.customer_id = total_amount_per_customer.customer_id

)

select * from final