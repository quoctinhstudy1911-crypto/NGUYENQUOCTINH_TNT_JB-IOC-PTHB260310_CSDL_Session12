-- Dữ liệu mẫu
create database session12_db;

create table customers (
    customer_id serial primary key,
    name varchar(50),
    email varchar(50)
);

create table customer_log (
    log_id serial primary key,
    customer_name varchar(50),
    action_time timestamp
);

-- Tạo function
create or replace function log_customer_insert()
returns trigger
language plpgsql
as $$
begin
    insert into customer_log (customer_name, action_time)
    values (new.name, now());

    return new;
end;
$$;

create trigger trg_log_customer
after insert on customers
for each row
execute function log_customer_insert();


insert into customers (name, email)
values
('Kim Toa', 'kt@gmail.com'),
('Quoc Tinh', 'qt@gmail.com');

-- Sau khi insert kiểm tra log xem có chưa
select * from customer_log;