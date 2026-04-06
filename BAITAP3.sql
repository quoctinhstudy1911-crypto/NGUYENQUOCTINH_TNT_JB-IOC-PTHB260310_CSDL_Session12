-- Dữ liệu mẫu
create database session12_db;

create or replace function update_stock_after_insert()
returns trigger
language plpgsql
as $$
begin
    -- trừ tồn kho sau khi insert thành công
    update products
    set stock = stock - new.quantity
    where product_id = new.product_id;

    return new;
end;
$$;

create trigger trg_update_stock
after insert on sales
for each row
execute function update_stock_after_insert();

insert into sales (product_id, quantity)
values (1, 2);

select * from products;