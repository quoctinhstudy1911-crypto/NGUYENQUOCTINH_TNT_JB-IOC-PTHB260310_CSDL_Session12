-- Dữ liệu mẫu
create database session12_db;

alter table products
add column price numeric;

create table orders (
    order_id serial primary key,
    product_id int references products(product_id),
    quantity int,
    total_amount numeric
);

update products
set price = 1500
where name = 'laptop';

update products
set price = 20
where name = 'mouse';

select * from products;

create or replace function calc_total_amount()
returns trigger
language plpgsql
as $$
declare
    v_price numeric;
begin
    -- lấy giá sản phẩm
    select price into v_price
    from products
    where product_id = new.product_id;

    -- tính total_amount
    new.total_amount := new.quantity * v_price;

    return new;
end;
$$;

create trigger trg_calc_total
before insert on orders
for each row
execute function calc_total_amount();

insert into orders (product_id, quantity)
values (1, 2);