# Sales Report Upgrade

Modifies original sales report to add product class, type, and subtype by item and allow for higher level sales reporting.

In the original Sales Report the products were not directly assigned the product class, product type, and product subtype information. Reporting on product groups was limited to what the default report presented. This information was insufficient for the store manager. 

![alt text](https://github.com/coolhandluke999/SalesReportMod/blob/output/before.PNG)

The R code solves this reporting problem for all sales reports of the format displayed in "Sales Report.csv." Minor updates would be required to adjust for new product classes, types or subtypes. No adjustment is necessary for new products.

![alt text](https://github.com/coolhandluke999/SalesReportMod/blob/output/after.PNG)

The code provides dynamic reporting by product class, type, subtype. All items are individually assigned these variables and then the amounts are calculated and displayed. The high level summaries provide for much easier consumption of the data while maintaining all of the information from the original report. 

![alt text](https://github.com/coolhandluke999/SalesReportMod/blob/output/summary.PNG)


