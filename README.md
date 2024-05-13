# Nashville Housing Data Cleaning

This repository contains SQL queries for cleaning and preprocessing Nashville housing data.

## Overview

- **Data Source**: `nashville_housing` table containing information about housing sales in Nashville.
- **Cleaning Steps**:
  1. Standardize Date Format
  2. Fill Missing Property Addresses
  3. Split Address into Address, City, and State
  4. Split Owner Address into Address, City, and State
  5. Normalize "Y" and "N" in SoldAsVacant Column
  6. Detect and Handle Duplicates
  7. Delete Unused Columns

## Instructions

1. Execute each SQL query sequentially in your database system.
2. Review the cleaned data after each step to ensure accuracy.
3. Modify the queries as needed to fit your specific data and requirements.

## Note

- Make sure you have necessary permissions to modify the database schema.
- Carefully review the data before and after each cleaning step to avoid unintended changes.
