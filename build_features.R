rm(list = ls())
library(dplyr)
library(data.table)

#read raw data into environment
housedata_table <- fread('./project/volume/data/raw/Stat_380_housedata.csv')
qc_table<- fread('./project/volume/data/raw/Stat_380_QC_table.csv')

#merged data frame of house data and qc table
merged_df <- merge(housedata_table, qc_table, by= 'qc_code', all = FALSE)

test<-merged_df[grepl("^test",Id)]
train<-merged_df[grepl("^train",Id)]

#sort test ID in ascending order
test$Id <- as.character(test$Id)
numeric_part <- as.numeric(sub("test_", "", test$Id))
test <- test[order(numeric_part), ]

test$SalePrice<-0

#write train and test tables into interim
fwrite(train,'./project/volume/data/interim/train.csv')
fwrite(test,'./project/volume/data/interim/test.csv')

