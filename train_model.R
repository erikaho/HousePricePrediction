rm(list = ls())
library(caret)
library(data.table)
library(Metrics)

set.seed(77)

#read data into environment
train<-fread('./project/volume/data/interim/train.csv')
test<-fread('./project/volume/data/interim/test.csv')
submit<-fread('./project/volume/data/raw/example_sub.csv')


#master is unused here, but helpful to look back on
master<-rbind(train,test)

#class dummies model
#dummies<-dummyVars(SalePrice~.,data = master)
#train<-predict(dummies,newdata=train)
#test<-predict(dummies,newdata=test)

#reformat from matrix back into data table
#train<-data.table(train)
#train$SalePrice<-train_y
#test<-data.table(test)

#model using train data
lm_model<-lm(SalePrice~ LotArea+BldgType+Qual+Cond+ FullBath+ HalfBath+ YearBuilt+ TotalBsmtSF+BedroomAbvGr+CentralAir+GrLivArea+YrSold, data=train)

summary(lm_model)


#saveRDS(dummies,'./project/volume/models/SalePrice_lm.dummies')
saveRDS(lm_model,'./project/volume/models/SalePrice_lm.model')


#predicting SalePrice using lm_model with test data
test$SalePrice<-predict(lm_model, newdata=test)

submit$SalePrice<-test$SalePrice

fwrite(submit,'./project/volume/data/processed/submit_lm4.csv')

