
-- using standardized data column

alter table nashvillehousing add saledateconverted date;
update nashvillehousing set saledateconverted = str_to_date(saledate,'%Y-%m-%');
select saledateconverted from nashvillehousing;


select * from nashvillehousing where propertyaddress is null;
select a.parcelID,b.parcelid,a.propertyaddress,b.propertyaddress, ifnull(a.propertyaddress,b.propertyaddress)
from nashvillehousing a join nashvillehousing b
on a.parcelID=b.parcelId
where a.propertyaddress is null;

update nashvillehousing  
inner join nashvillehousing a join nashvillehousing b on a.parcelID=b.parcelId
set a.propertyaddress=ifnull(a.propertyaddress,b.propertyaddress) 
where a.propertyaddress is null;


-- breaking address into individual columns(city,state)

select propertyaddress from nashvillehousing;
select SUBSTRING_INDEX(propertyaddress,',',1) as 'address', SUBSTRING_INDEX(propertyaddress,',',-1) as 'city' from nashvillehousing;

alter table nashvillehousing add PropertySplitAddress varchar(255);
update nashvillehousing set PropertySplitAddress = SUBSTRING_INDEX(propertyaddress,',',1);

alter table nashvillehousing add PropertySplitCity varchar(255);
update nashvillehousing set PropertySplitCity = SUBSTRING_INDEX(propertyaddress,',',-1);

 select PropertySplitAddress,PropertySplitCity from nashvillehousing;
 select owneraddress from nashvillehousing;-- where owneraddress ='';
 
 select substring_index(owneraddress,',',1)as 'street', substring_index(substring_index(owneraddress,',',2),',',-1) as 'city', SUBSTRING_INDEX(owneraddress,',',-1) as 'state' from nashvillehousing;
 alter table nashvillehousing add OwnerSplitCity varchar(255);
 alter table nashvillehousing add OwnerSplitStreet varchar(255);
 alter table nashvillehousing add OwnerSplitState varchar(255);
update nashvillehousing set OwnerSplitCity = substring_index(substring_index(owneraddress,',',2),',',-1);
update nashvillehousing set OwnerSplitStreet= substring_index(owneraddress,',',1);
update nashvillehousing set OwnerSplitState=SUBSTRING_INDEX(owneraddress,',',-1);

-- change 'Y' , 'N' to 'YES' and 'NO' respectively

select distinct(soldasvacant),count(*) from nashvillehousing group by soldasvacant order by 2;

select distinct(soldasvacant) , case when soldasvacant='Y' then 'Yes' when soldasvacant='N' then 'No' else soldasvacant end from nashvillehousing;

update nashvillehousing set  soldasvacant=case when soldasvacant='Y' then 'Yes' when soldasvacant='N' then 'No' else soldasvacant end;

-- delete duplicate vaues
select * from nashvillehousing order by parcelid;
with RowNumCTE as(
select *, row_number() over (partition by parcelid, propertyaddress,saledate,saleprice,Legalreference) as 'row_num' from nashvillehousing)
delete  from RowNumCTE where row_num>1;

