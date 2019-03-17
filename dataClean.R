#Load the Langley location data
sgim_langley <- read.csv("/Users/Shauna/workplace/finallyProject/sgim_langley.csv")
sgim_langley <- sgim_langley[,2:10]

#Format the time data
sgim_langley$Measurement.Time <- as.POSIXct(sgim_langley$Measurement.Time, format = "%m/%d/%Y %I:%M:%S %p")
table(sgim_langley$Measurement.Title)

#Aggregate the data hourly
sgim_langley_hourBase <- sgim_langley
sgim_langley_hourBase$Measurement.Time <- cut(sgim_langley_hourBase$Measurement.Time, "h")
library(sqldf)
sgim_langley_hourlyAgg <- sqldf('select [Measurement.Type],  [Measurement.Time], avg([Measurement.Value])as [avg.Measurement.Value], [Units.Abbreviation]
                                from sgim_langley_hourBase group by [Measurement.Time], [Measurement.Title]') 

SoilMoisture <- sqldf('select [Measurement.Time], [avg.Measurement.Value] 
                       from sgim_langley_hourlyAgg
                       where [Measurement.Type] = "SoilMoisture"')

Temperature <- sqldf('select [Measurement.Time], [avg.Measurement.Value] 
                      from sgim_langley_hourlyAgg
                      where [Measurement.Type] = "Temperature"')

DifferentialPressure <- sqldf('select [Measurement.Time], [avg.Measurement.Value] 
                               from sgim_langley_hourlyAgg
                               where [Measurement.Type] = "DifferentialPressure"')

CumulativePrecipitation <- sqldf('select [Measurement.Time], [avg.Measurement.Value] 
                                  from sgim_langley_hourlyAgg
                                  where [Measurement.Type] = "CumulativePrecipitation"')

WindSpeed <- sqldf('select [Measurement.Time], [avg.Measurement.Value] 
                    from sgim_langley_hourlyAgg
                    where [Measurement.Type] = "WindSpeed"')

RelativeHumidity <- sqldf('select [Measurement.Time], [avg.Measurement.Value] 
                           from sgim_langley_hourlyAgg
                           where [Measurement.Type] = "RelativeHumidity"')

#Aggregate the data to be mutivalue time series and remove the empty data
metricsAgg <- sqldf('select a.[Measurement.Time], a.[avg.Measurement.Value] as RelativeHumidity, b.[avg.Measurement.Value] as WindSpeed,
                    c.[avg.Measurement.Value] as CumulativePrecipitation, d.[avg.Measurement.Value] as DifferentialPressure,
                    e.[avg.Measurement.Value] as Temperature, f.[avg.Measurement.Value] as SoilMoisture
                    from ((((RelativeHumidity a inner join WindSpeed b on a.[Measurement.Time] = b.[Measurement.Time])
                    inner join CumulativePrecipitation c on a.[Measurement.Time] = c.[Measurement.Time])
                    inner join DifferentialPressure d on a.[Measurement.Time] = d.[Measurement.Time])
                    inner join Temperature e on a.[Measurement.Time] = e.[Measurement.Time])
                    inner join SoilMoisture f on a.[Measurement.Time] = f.[Measurement.Time]
                    where a.[Measurement.Time] > "2017-11-07 11:00:00"
                    ')
#Standat the time
temp <- metricsAgg
temp$Measurement.Time = as.integer(temp$Measurement.Time)
temp$Measurement.Time = temp$Measurement.Time - temp$Measurement.Time[1] + 1

#Add missing data based on liner since the time frame is short
insertData = rbind((temp[974,]-temp[973,])/3+temp[973,], (temp[974,]-temp[973,])/3*2+temp[973,])
metricsAgg_c <- rbind(temp[1:973,],insertData, temp[974:nrow(temp),])

#Convert CumulativePrecipitation to Precipitation
temp_cp <- metricsAgg_c$CumulativePrecipitation
temp_cp <- c(temp_cp[1],temp_cp[1:1381])
metricsAgg_p <- metricsAgg_c
metricsAgg_p$CumulativePrecipitation <- metricsAgg_c$CumulativePrecipitation - temp_cp
names(metricsAgg_p)[4] <- "Precipitation"
write.csv(metricsAgg_p, "/Users/Shauna/workplace/finallyProject/metricsAgg_p.csv")