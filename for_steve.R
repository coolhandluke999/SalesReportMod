#Chevron Sales Report
#provide functionality for subtotaling by product type

#Load packages
library(tidyverse)
library(ggrepel)
library(ggthemes)
library(dslabs)

#Read data
data <- read.csv("Sales Report.csv", header = TRUE, skip = 5)
backup_data <- data

#data <- backup_data

#Clean Data
#remove unwanted rows and columnns

data <- data[-(1902:1909),]

#set columns to proper data types

data$Item <- as.character(data$Item)
data$Items.Sold <- as.numeric(as.character(data$Items.Sold))
data$Price <- as.numeric(gsub("\\$", "", data$Price))


##add product type, product subtype, product class columns

data <- data %>% mutate(Product.Type = "None",
                        Product.Subtype = "None",
                        Product.Class = "None")

#find subtotal lines-- all lines with "Subtotal" in data$Item
#subtotallines is the end of the product class group by row number
subtotalLines = grep("Subtotal", data$Item)
subtotalLines

#find subtotal names- properly formatted character string of all subtotal names
subtotals <- as.character(data$Item[subtotalLines])
subtotalnames = strsplit(subtotals, split = "\\Subtotal")
subtotalnames = str_trim(subtotalnames)

#calculate how many items per class
#find start row of class group
#startline is the first line of the product class group
startline <- match(subtotalnames, data$Item)

#calculate items per product class -- subtotalLines - startline
totalitems <- subtotalLines - startline
finaltotalitems <- totalitems + 1  #adding 1 for footer of each group--REMOVE LATER
finaltotalitems  #how many times to reprint subtotal name
subtotalnames

#Adjust product subtype and type lines to say uptotal (subtype) and toptotal (type) instead of subtotal
data$Item[156] <- "ALCOHOLIC BEVERAGES UPTOTAL"
data$Item[174] <- "DAIRY BEVERAGES UPTOTAL"
data$Item[199] <- "CARBONATED WATER UPTOTAL"
data$Item[517] <- "PKGD NON-ALCOHOLIC BEVERAGES UPTOTAL"
data$Item[518] <- "BEVERAGES UPTOTAL"
data$Item[569] <- "FRESH DELIVERED FOOD SERVICE UPTOTAL"
data$Item[570] <- "FOOD SERVICE UPTOTAL"
#remove 10th item(row 156) from total items calculation vector--IS THIS NECESSARY?????
finaltotalitems[-10]

#test--writing product class to items in Alcohol Beverages group
#using elements 1:9 for alcoholic beverages test
testvector <- rep("none", 1901)
testvector <- rep(subtotalnames[1:9], finaltotalitems[1:9])
data$Product.Class[2:155] <- testvector  #offset by one on header itemes--FIX LATER

#Dairy Beverages
testvector <- rep("none", 16)
testvector <- rep(subtotalnames[11:13], finaltotalitems[11:13])
data$Product.Class[158:173] <- testvector

#Dispensed Beverages
testvector <- rep("none", 19)
testvector <- rep(subtotalnames[15:17], finaltotalitems[15:17])
data$Product.Class[176:194] <- testvector

#Carbonated Water
testvector <- rep("none", 3)
testvector <- rep(subtotalnames[19], finaltotalitems[19])
data$Product.Class[197:199] <- testvector

#PKGD NON-ALCOHOLIC BEVERAGES
testvector <- rep("none", 317)
testvector <- rep(subtotalnames[20:35], finaltotalitems[20:35])
data$Product.Class[200:516] <- testvector

#FRESH DELIVERED FOOD SERVICE
testvector <- rep("none", 49)
testvector <- rep(subtotalnames[38:44], finaltotalitems[38:44])
data$Product.Class[521:568] <- testvector

#DIESEL--did not need to separate out
#testvector <- rep("none", 49)
#testvector <- rep(subtotalnames[38:44], finaltotalitems[38:44])
data$Product.Class[573:575] <- rep("DIESEL", 3)

#MOTOR FUEL
testvector <- rep("none", 25)
testvector <- rep(subtotalnames[48:50], finaltotalitems[48:50])
data$Product.Class[573:600] <- testvector

#AUTO PRODUCTS
testvector <- rep("none", 48)
testvector <- rep(subtotalnames[53:62], finaltotalitems[53:62])
data$Product.Class[605:652] <- testvector

#GENERAL MERCHANDISE
testvector <- rep("none", 39)
testvector <- rep(subtotalnames[71:80], finaltotalitems[71:80])
data$Product.Class[655:693] <- testvector

#HEALTH AND BEAUTY
testvector <- NULL#rep("none", 39) 
testvector <- rep(subtotalnames[71:80], finaltotalitems[71:80])
data$Product.Class[696:740] <- testvector

#HOUSEHOLD SUPPLIES
testvector <- NULL#rep("none", 39) 
testvector <- rep(subtotalnames[82], finaltotalitems[82])
data$Product.Class[743:745] <- testvector

#PUBLICATIONS
testvector <- NULL#rep("none", 39) 
testvector <- rep(subtotalnames[84], finaltotalitems[84])
data$Product.Class[748:752] <- testvector

#CHARITY SALES
testvector <- NULL#rep("none", 39) 
testvector <- rep(subtotalnames[87], finaltotalitems[87])
data$Product.Class[757:764] <- testvector

#CANDY/CONFECTION
testvector <- NULL#rep("none", 39) 
testvector <- rep(subtotalnames[90:97], finaltotalitems[90:97])
data$Product.Class[769:913] <- testvector

#FROZEN GROCERY
testvector <- NULL#rep("none", 39) 
testvector <- rep(subtotalnames[99], finaltotalitems[99])
data$Product.Class[916:918] <- testvector

#PERISHABLE GROCERY
testvector <- NULL#rep("none", 39) 
testvector <- rep(subtotalnames[101:102], finaltotalitems[101:102])
data$Product.Class[921:928] <- testvector

#SHELF STABLE GROCERY
testvector <- NULL#rep("none", 39) 
testvector <- rep(subtotalnames[104:113], finaltotalitems[104:113])
data$Product.Class[931:992] <- testvector

#SNACKS
testvector <- NULL#rep("none", 39) 
testvector <- rep(subtotalnames[115:142], finaltotalitems[115:142])
data$Product.Class[996:1458] <- testvector

#LOTTERY AND GAMING
testvector <- NULL#rep("none", 39) 
testvector <- rep(subtotalnames[145:146], finaltotalitems[145:146])
data$Product.Class[1462:1516] <- testvector

#SMOKELESS TOBACCO
testvector <- NULL#rep("none", 39) 
testvector <- rep(subtotalnames[149:150], finaltotalitems[149:150])
data$Product.Class[1521:1594] <- testvector

#CIGARETTES
testvector <- NULL#rep("none", 39) 
testvector <- rep(subtotalnames[152:156], finaltotalitems[152:156])
data$Product.Class[1597:1899] <- testvector

#add product type and subtype to rows
data$Product.Subtype[2:155] <- "ALCOHOLIC BEVERAGES"
data$Product.Type[2:155] <- "BEVERAGES"

data$Product.Subtype[156:173] <- "DAIRY BEVERAGES"
data$Product.Type[156:173] <- "BEVERAGES"

data$Product.Subtype[176:194] <- "DISPENSED BEVERAGES"
data$Product.Type[176:194] <- "BEVERAGES"

data$Product.Subtype[197:199] <- "CARBONATED WATER"
data$Product.Type[197:199] <- "BEVERAGES"

data$Product.Subtype[200:516] <- "PKGD NON-ALCOHOLIC BEVERAGES"
data$Product.Type[200:516] <- "BEVERAGES"

data$Product.Subtype[517:569] <- "FRESH DELIVERED FOOD SERVICE"
data$Product.Type[517:569] <- "FOOD SERVICE"

data$Product.Subtype[573:575] <- "MOTOR FUEL"
data$Product.Type[573:575] <- "FUEL PRODUCTS"

data$Product.Subtype[576:599] <- "MOTOR FUEL"
data$Product.Type[576:599] <- "FUEL PRODUCTS"

data$Product.Subtype[605:652] <- "AUTO PRODUCTS"
data$Product.Type[605:652] <- "NON-FOOD PRODUCTS"

data$Product.Subtype[654:694] <- "GENERAL MERCHANDISE"
data$Product.Type[654:694] <- "NON-FOOD PRODUCTS"

data$Product.Subtype[695:741] <- "HEALTH AND BEAUTY"
data$Product.Type[695:741] <- "NON-FOOD PRODUCTS"

data$Product.Subtype[742:746] <- "HOUSEHOLD SUPPLIES"
data$Product.Type[742:746] <- "NON-FOOD PRODUCTS"

data$Product.Subtype[748:753] <- "PUBLICATIONS"
data$Product.Type[748:753] <- "NON-FOOD PRODUCTS"

data$Product.Subtype[756:764] <- "NON C-STORE REVENUE"
data$Product.Type[756:764] <- "OTHER C-STORE REVENUE"

data$Product.Subtype[769:913] <- "CANDY AND CONFECTION"
data$Product.Type[769:913] <- "PKGD FOOD PRODUCTS"

data$Product.Subtype[915:919] <- "FROZEN GROCERY"
data$Product.Type[915:919] <- "PKGD FOOD PRODUCTS"

data$Product.Subtype[920:929] <- "PERISHABLE GROCERY"
data$Product.Type[920:929] <- "PKGD FOOD PRODUCTS"

data$Product.Subtype[931:993] <- "SHELF STABLE GROCERY"
data$Product.Type[931:993] <- "PKGD FOOD PRODUCTS"

data$Product.Subtype[995:1458] <- "SNACKS"
data$Product.Type[995:1458] <- "PKGD FOOD PRODUCTS"

data$Product.Subtype[1461:1517] <- "LOTTERY AND GAMING"
data$Product.Type[1461:1517] <- "SERVICE PRODUCTS"

data$Product.Subtype[1520:1594] <- "SMOKELESS TOBACCO"
data$Product.Type[1520:1594] <- "TOBACCO AND RELATED PRODUCTS"

data$Product.Subtype[1597:1807] <- "CIGARETTES"
data$Product.Type[1597:1807] <- "TOBACCO AND RELATED PRODUCTS"

#Remove non-items

keep <- !is.na(data$Price)
data <- data[keep,]

str(data)

#Complete Column Removal
remove <- c(4, 5)
data <- data[,-(remove)]

#Add Sold.Amount column back as function of Price and Items.Sold
data <- data %>% mutate(
                  Sold.Amount = Price * Items.Sold,
                  Percent.of.Sales = format((Sold.Amount/sum(Sold.Amount, na.rm = TRUE)), digits = 4, nsmall = 6 )
)

#Reorder columns
data <- data[,c(1:3, 10:11, 4:9)]

#Generate reports and export files
by_class <- data %>% group_by(Product.Type, Product.Subtype, Product.Class)

grouped_sales_class <- by_class %>% summarize(
                                 Sales = sum(Sold.Amount)
                        )
by_subtype <- data %>% group_by(Product.Type, Product.Subtype)

grouped_sales_subtype <- by_subtype %>% summarize(
        Sales = sum(Sold.Amount)
)

by_type <- data %>% group_by(Product.Type)

grouped_sales_type <- by_type %>% summarize(
        Sales = sum(Sold.Amount)
)


write.csv(grouped_sales_class, "sales_062020_byclass.csv")
write.csv(grouped_sales_subtype, "sales_062020_bysubtype.csv")
write.csv(grouped_sales_type, "sales_062020_bytype.csv")
