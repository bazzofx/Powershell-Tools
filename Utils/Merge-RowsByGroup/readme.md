# Merge-RowsByGroup

This is a PowerShell script that can be used to combine and aggregate rows of data from a CSV file based on a specified group. It works by sorting the CSV file based on the group identifier, and then combining all rows with the same identifier into a single row, while summing up the specified mainNumber and bonusNumber columns.

## Usage

To use this script, simply call the `Merge-RowsByGroup` function and pass in the required parameters:

```powershell
Merge-RowsByGroup -identifier <string> -mainNumber <string> -bonusNumber <string>
```

Here's an example of how to use this script:

```powershell
Merge-RowsByGroup -identifier Name -mainNumber Salary -bonusNumber Bonus
```

This will combine all rows with the same name, while summing up their salaries and bonuses.

## Parameters

The `Merge-RowsByGroup` function takes in three parameters:

- `identifier`: This is the name of the column that contains the group identifier. The script will combine all rows with the same identifier into a single row.
- `mainNumber`: This is the name of the column that contains the main number that you want to sum up.
- `bonusNumber`: This is the name of the column that contains the bonus number that you want to sum up.

## How it works

The script first imports the CSV file and sorts it based on the group identifier column. It then loops through each row in the CSV file, and checks whether the current row has the same identifier as the next row. If it does, it adds the mainNumber and bonusNumber of the current row to a running total, until it reaches a row with a different identifier. Once it reaches a row with a different identifier, it creates a new row with the combined total and adds it to an array.

If the current row has the same identifier as the previous row, the script adds the bonusNumber of the current row to a global variable called `$global:adjustment`. Once it reaches a row with a different identifier, it adds the value of `$global:adjustment` to the running total. This allows the script to handle cases where there are multiple rows with the same identifier, and some of them have empty bonusNumber columns.

Finally, the script exports the array of combined rows to a new CSV file.

## Conclusion

The `Merge-RowsByGroup` script is a simple but powerful tool for aggregating and combining rows of data in a CSV file. By providing the group identifier, mainNumber, and bonusNumber columns, you can quickly and easily combine rows and sum up their values.