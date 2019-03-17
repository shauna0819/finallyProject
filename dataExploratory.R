#Data Exploratory 
sgim_original <- read.csv("/Users/Shauna/workplace/finallyProject/Smart_Green_Infrastructure_Monitoring_Sensors_-_Historical.csv")
head(sgim_original)
str(sgim_original)
table(sgim_original$Measurement.Title)
table(sgim_original$Measurement.Description)
table(sgim_original$Measurement.Type)
table(sgim_original$Measurement.Medium)
table(sgim_original$Location)

#Seperate data by 3 locations
library(sqldf)
sgim_original_langley <- sqldf("select * from sgim_original where Latitude = '41.753112'")
sgim_original_uiLabs <- sqldf("select * from sgim_original where Latitude = '41.90715'")
sgim_original_argyle <- sqldf("select * from sgim_original where Latitude = '41.973086'")
table(sgim_original_langley$Measurement.Title)
table(sgim_original_uiLabs$Measurement.Title)
table(sgim_original_argyle$Measurement.Title)

#Focus on the Langley site only based on cost and avaliable resource
head(sgim_original_langley)
str(sgim_original_langley)
table(sgim_original_langley$Measurement.Type)
head(sgim_original_langley)
summary(sgim_original_langley)
table(sgim_original_langley$Measurement.Title)

#Based on data interpretation
sgim_langley <- sqldf('select * from sgim_original_langley 
                             where [Measurement.Title] like "Langley - Cumulus%" 
                             or [Measurement.Title] = "Langley - Thunder 1: MK-III Weather Station RH"') 
table(sgim_langley$Measurement.Title)
write.csv(sgim_langley, "/Users/Shauna/workplace/finallyProject/sgim_langley.csv")
