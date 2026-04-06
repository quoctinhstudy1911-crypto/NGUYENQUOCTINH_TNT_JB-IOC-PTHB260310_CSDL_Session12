-- Dữ liệu mẫu
create database session12_db;

create table products (
    product_id serial primary key,
    name varchar(50),
    stock int
);

create table sales (
    sale_id serial primary key,
    product_id int references products(product_id),
    quantity int
);

insert into products (name, stock)
values
('laptop', 5),
('mouse', 10);

create or replace function check_stock_before_insert()
returns trigger
language plpgsql
as $$
declare
    v_stock int;
begin
    -- lấy tồn kho hiện tại
    select stock into v_stock
    from products
    where product_id = new.product_id;

    -- kiểm tra xem hàng đủ không
    if v_stock < new.quantity then
        raise exception 'Không đủ hàng trong kho';
    end if;

    -- Trừ kho
    update products
    set stock = stock - new.quantity
    where product_id = new.product_id;

    return new;
end;
$$;

create trigger trg_check_stock
before insert on sales
for each row
execute function check_stock_before_insert();

insert into sales (product_id, quantity)
values (1, 2);

select * from sales;
select * from products;