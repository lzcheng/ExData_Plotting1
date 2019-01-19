#loading partial data

#install.packages("sqldf")
#install.packages("downloader")
library(sqldf)
library(downloader)

#downloading the zip file and unzipping to the working directory
url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download(url, dest="dataset.zip", mode="wb") 
unzip ("dataset.zip",exdir=".")


#using sqldf to select only two days from the dataset
fi <- file("household_power_consumption.txt")  
df <- sqldf("select * from fi where Date in ('1/2/2007','2/2/2007')",file.format = list(header = TRUE, sep = ";"))#treating Date as characters
close(fi)

#generating the plot
windows()
hist(df$Global_active_power,col="red",main="Global Active Power",xlab = "Global Active Power (kilowatts)")
dev.copy(png,file="plot1.png")
dev.off



