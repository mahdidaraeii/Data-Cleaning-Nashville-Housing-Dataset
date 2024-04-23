-- cleaning data

SELECT * 
FROM nashville_housing;

-- Standardize Date Format

UPDATE Nashville_Housing
SET SaleDate = STR_TO_DATE(SaleDate, '%M %e, %Y');

-- Address

SELECT * 
FROM nashville_housing
ORDER BY ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM nashville_housing AS a
INNER JOIN nashville_housing AS b
ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

UPDATE Nashville_Housing AS a
JOIN Nashville_Housing AS b ON a.ParcelID = b.ParcelID
                           AND a.`UniqueID` <> b.`UniqueID`
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;

-- Split the address to Address, City and State

-- property address
SELECT PropertyAddress
FROM nashville_housing;

SELECT SUBSTRING_INDEX(PropertyAddress, ',', 1) AS Address,
SUBSTRING_INDEX(PropertyAddress, ',', -1) AS Address
FROM nashville_housing;

ALTER TABLE nashville_housing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE nashville_housing
SET PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1);

ALTER TABLE nashville_housing
ADD PropertySplitCity NVARCHAR(255);

UPDATE nashville_housing
SET PropertySplitCity = SUBSTRING_INDEX(PropertyAddress, ',', -1);

-- Owner Address

SELECT OwnerAddress 
FROM nashville_housing;

SELECT SUBSTRING_INDEX(OwnerAddress, ',', 1) AS Adress, 
SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -2),',',1) AS City,
SUBSTRING_INDEX(OwnerAddress, ',', -1) AS State
FROM nashville_housing;

ALTER TABLE nashville_housing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE nashville_housing
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1);

ALTER TABLE nashville_housing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE nashville_housing
SET OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -2),',',1);


ALTER TABLE nashville_housing
ADD OwnerSplitState NVARCHAR(255);

UPDATE nashville_housing
SET OwnerSplitState = SUBSTRING_INDEX(OwnerAddress, ',', -1);

-- "Y" and "N" in SoldAsVacant column

SELECT SoldAsVacant, COUNT(SoldAsVacant)
FROM nashville_housing
GROUP BY SoldAsVacant;

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END AS EditedSoldAsVacant
FROM nashville_housing;

UPDATE nashville_housing 
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END;

-- Detect Duplicates

WITH nashvilleCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From Nashville_Housing)
SELECT *
FROM nashvilleCTE
WHERE row_num > 1;

-- Delete Unused Columns

SELECT * 
FROM nashville_housing;

ALTER TABLE Nashville_Housing
DROP COLUMN OwnerAddress, 
DROP COLUMN TaxDistrict, 
DROP COLUMN PropertyAddress, 
DROP COLUMN SaleDate;






















