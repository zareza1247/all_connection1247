select * from ecom_d_uk;

select count(distinct(description)) from ecom_d_uk2; -- 4206 - after filtering now down to 3969

select distinct(description) from ecom_d_uk; -- 