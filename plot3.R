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
plot(df$Sub_metering_1~as.POSIXct(df$datetime),type="l",xlab="",ylab="Energy sub metering")
lines(as.POSIXct(df$datetime),df$Sub_metering_2,col="red")
lines(as.POSIXct(df$datetime),df$Sub_metering_3,col="blue")
legend("topright", legend=c("Sub_metering 1", "Sub_metering 2","Sub_metering 3"),
       col=c("black","red", "blue"), lty=1, cex=0.8)
#lty specifies the type of lines
#cex specifies the size of the legend
dev.copy(png,file="plot3.png")
dev.off
