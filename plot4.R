#loading partial data

#install.packages("sqldf")
#install.packages("downloader")
#install.packages("tidyverse")
library(sqldf)
library(downloader)
library(tidyverse)

#downloading the zip file and unzipping to the working directory
url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download(url, dest="dataset.zip", mode="wb") 
unzip ("dataset.zip",exdir=".")


#using sqldf to select only two days from the dataset
fi <- file("household_power_consumption.txt")  
df <- sqldf("select * from fi where Date in ('1/2/2007','2/2/2007')",file.format = list(header = TRUE, sep = ";"))#treating Date as characters
close(fi)


#pre-processing data
class(df$Date)
#converting date variable to date format
df<-df%>%mutate(date=as.Date(Date,format="%d/%m/%Y"))
df$datetime<-strptime(paste(df$Date,df$Time),"%d/%m/%Y %H:%M:%S")

#plotting

windows()
par(mfrow=c(2,2))

plot(df$Global_active_power~as.POSIXct(df$datetime),type="l",ylab = "Global Active Power",xlab="")

plot(df$Voltage~as.POSIXct(df$datetime),type="l",ylab = "Voltage",xlab="datetime")


plot(df$Sub_metering_1~as.POSIXct(df$datetime),type="l",xlab="",ylab="Energy sub metering")
lines(as.POSIXct(df$datetime),df$Sub_metering_2,col="red")
lines(as.POSIXct(df$datetime),df$Sub_metering_3,col="blue")
legend("topright", legend=c("Sub_metering 1", "Sub_metering 2","Sub_metering 3"),
       col=c("black","red", "blue"), lty=1, cex=0.5,bty = "n")

plot(df$Global_reactive_power~as.POSIXct(df$datetime),type="l",xlab="datetime",ylab="Global_reactive_power")

dev.copy(png,file="plot4.png")
dev.off
