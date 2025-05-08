-- investigate how much records do not have customer id

select count(*)
from ecom_d_uk
where customerid is null;