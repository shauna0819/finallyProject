library(urca)
library(MASS)
library(sandwich)
library(strucchange)
library(vars)

metricsAgg_p <- read.csv("/Users/Shauna/workplace/finallyProject/metricsAgg_p.csv")
metricsAgg_ts <- metricsAgg_p[,3:8]
metricsAgg_ts <- ts(metricsAgg_ts)
#SGIM Data overview
plot(metricsAgg_ts,type="l",xlab="Date", ylab="metricsAgg_ts", cex.lab = 0.75, main = "Smart Green Infrastructure Monitor Data in Langley Site")  
plot(diff(metricsAgg_ts),type="l",xlab="Date", ylab="metricsAgg_ts", cex.lab = 0.75)
#Seperate each dataset
rh <- metricsAgg_ts[,1]
ws <- metricsAgg_ts[,2]
p <- metricsAgg_ts[,3]
dp <- metricsAgg_ts[,4]
t <- metricsAgg_ts[,5]
sm <- metricsAgg_ts[,6]
#Plot each dataset
plot(rh,type="l",xlab="Date", ylab="RelativeHumidity %", cex.lab = 0.75, main = "Smart Green Infrastructure Monitor Data in Langley Site_RelativeHumidity")  
plot(ws,type="l",xlab="Date", ylab="WindSpeed m/s", cex.lab = 0.75, main = "Smart Green Infrastructure Monitor Data in Langley Site_WindSpeed")  
plot(p,type="l",xlab="Date", ylab="Precipitation inch", cex.lab = 0.75, main = "Smart Green Infrastructure Monitor Data in Langley Site_Precipitation")  
plot(dp,type="l",xlab="Date", ylab="DifferentialPressure pa", cex.lab = 0.75, main = "Smart Green Infrastructure Monitor Data in Langley Site_DifferentialPressure")  
plot(t,type="l",xlab="Date", ylab="Temperature degreeC", cex.lab = 0.75, main = "Smart Green Infrastructure Monitor Data in Langley Site_Temperature")  
plot(sm,type="l",xlab="Date", ylab="SoilMoisture %", cex.lab = 0.75, main = "Smart Green Infrastructure Monitor Data in Langley Site_SoilMoisture")  
#Plot correlation
plot(sm,type="l",xlab="Date", ylab=" ", cex.lab = 0.75, main = "Smart Green Infrastructure Monitor Data in Langley Site_SoilMoisture VS Temperature", col = "blue")  
par(new=TRUE)
plot(t,type="l",xlab="Date", ylab=" ",cex.lab = 0.75, col = "red")  

plot(sm,type="l",xlab="Date", ylab=" ", cex.lab = 0.75, main = "Smart Green Infrastructure Monitor Data in Langley Site_SoilMoisture VS Precipitation", col = "blue")  
par(new=TRUE)
plot(p,type="l",xlab="Date", ylab=" ",cex.lab = 0.75, col = "green") 

plot(sm,type="l",xlab="Date", ylab=" ", cex.lab = 0.75, main = "Smart Green Infrastructure Monitor Data in Langley Site_SoilMoisture VS RelativeHumidity", col = "blue")  
par(new=TRUE)
plot(rh,type="l",xlab="Date", ylab=" ", cex.lab = 0.75, col = "darkorange2")  

plot(sm,type="l",xlab="Date", ylab=" ", cex.lab = 0.75, main = "Smart Green Infrastructure Monitor Data in Langley Site_SoilMoisture VS WindSpeed", col = "blue")  
par(new=TRUE)
plot(ws,type="l",xlab="Date", ylab=" ", cex.lab = 0.75, col = "coral")  

#Multivariate Time Series Analysis
VARselect(metricsAgg_ts,lag.max=10,type="const")
var<-VAR(metricsAgg_ts,p = 1,lag.max=6,ic="AIC")
var
summary(var)
