--housing data preview
SELECT TOP (10) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [Portifolio].[dbo].[Nashvillehousing]
  
Select SaleDate, CONVERT(dATE, SaleDate)
From [Portifolio].[dbo].[Nashvillehousing]

Update Nashvillehousing
Set SaleDate = CONVERT(dATE, SaleDate)

Alter Table Nashvillehousing
Add SaleDateonv Date;


Update Nashvillehousing
Set SaleDateonv = CONVERT(dATE, SaleDate)


Select SaleDateonv, CONVERT(dATE, SaleDate)
From [Portifolio].[dbo].[Nashvillehousing]

Select PropertyAddress
From [Portifolio].[dbo].[Nashvillehousing]
where PropertyAddress  is null

Select *
From [Portifolio].[dbo].[Nashvillehousing]
where PropertyAddress  is null

Select *
From [Portifolio].[dbo].[Nashvillehousing]
--where PropertyAddress  is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress,B.ParcelID, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portifolio].[dbo].[Nashvillehousing] a
JOIN [Portifolio].[dbo].[Nashvillehousing] B
	ON A.ParcelID = B.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ] 
where a.PropertyAddress is null

----Removing the blank address specified as NULL
Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portifolio].[dbo].[Nashvillehousing] a
JOIN [Portifolio].[dbo].[Nashvillehousing] B
	ON A.ParcelID = B.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ] 

---CHECKING TO SEE IF THERE ARE AY NULLS LEFT
Select a.ParcelID, a.PropertyAddress,B.ParcelID, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portifolio].[dbo].[Nashvillehousing] a
JOIN [Portifolio].[dbo].[Nashvillehousing] B
	ON A.ParcelID = B.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ] 
where a.PropertyAddress is null

Select PropertyAddress
From [Portifolio].[dbo].[Nashvillehousing]

--EXTRACT A SUBSTRING
Select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) AS Adress,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS Adress
From [Portifolio].[dbo].[Nashvillehousing]

---CREATING AND EXRACTING SUBSTRINGS INTO TWO COLUMNS
Alter Table [Portifolio].[dbo].[Nashvillehousing]
Add ProAddress1 nvarchar(255);

Update [Portifolio].[dbo].[Nashvillehousing]
Set ProAddress1 = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)


Alter Table [Portifolio].[dbo].[Nashvillehousing]
Add ProAddressCity nvarchar(255);


Update [Portifolio].[dbo].[Nashvillehousing]
Set ProAddressCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


---looking into the OwnerADRESS USING PARSE
Select OwnerAddress
From [Portifolio].[dbo].[Nashvillehousing]

Select 
Parsename(replace(OwnerAddress,',','.'),3),
Parsename(replace(OwnerAddress,',','.'),2),
Parsename(replace(OwnerAddress,',','.'),1)
From [Portifolio].[dbo].[Nashvillehousing]

---CREATING AND EXRACTING SUBSTRINGS INTO TWO COLUMNS USING PARSE
Alter Table [Portifolio].[dbo].[Nashvillehousing]
Add OwnerAddress1 nvarchar(255);

Update [Portifolio].[dbo].[Nashvillehousing]
Set OwnerAddress1 = Parsename(replace(OwnerAddress,',','.'),3)


Alter Table [Portifolio].[dbo].[Nashvillehousing]
Add OwnerAddressCity nvarchar(255);


Update [Portifolio].[dbo].[Nashvillehousing]
Set OwnerAddressCity = Parsename(replace(OwnerAddress,',','.'),2)

Alter Table [Portifolio].[dbo].[Nashvillehousing]
Add OwnerAddressState nvarchar(255);


Update [Portifolio].[dbo].[Nashvillehousing]
Set OwnerAddressState = Parsename(replace(OwnerAddress,',','.'),1)

Select *
From [Portifolio].[dbo].[Nashvillehousing]

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From [Portifolio].[dbo].[Nashvillehousing]
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, case when SoldAsVacant = 'Y' THEN 'YES'
	   when SoldAsVacant = 'N' THEN 'NO' 	
	   ELSE SoldAsVacant
	   END
From [Portifolio].[dbo].[Nashvillehousing]

--cleaning the sales status
Update [Portifolio].[dbo].[Nashvillehousing]
set SoldAsVacant = case when SoldAsVacant = 'Y' THEN 'YES'
	   when SoldAsVacant = 'N' THEN 'NO' 	
	   ELSE SoldAsVacant
	   END

Select SoldAsVacant
From [Portifolio].[dbo].[Nashvillehousing]

--REMOVE DUPLICATES
With RowNum AS (
Select *,
 ROW_NUMBER() OVER (
 PARTITION BY ParcelID,
			  PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  Order by
				UNIQUEID
				) row_num
				
From [Portifolio].[dbo].[Nashvillehousing]
--order by ParcelID
)

Select*
From RowNum
Where row_num >1
order by PropertyAddress

Delete
From RowNum
Where row_num >1
--order by PropertyAddress

----delete unused columns
Select *
From [Portifolio].[dbo].[Nashvillehousing]

Alter table [Portifolio].[dbo].[Nashvillehousing]
Drop column OwnerAddress, PropertyAddress

Alter table [Portifolio].[dbo].[Nashvillehousing]
Drop column SaleDate
--



