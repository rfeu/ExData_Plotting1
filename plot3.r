## Read data
## Use fread because the file contains many lines
require(data.table)
require(reshape2)
data <- fread("household_power_consumption.txt", na.string="?")

## Keep only rows with date = February 1st,2007 or February 2nd, 2007
data<- subset(data, Date=="1/2/2007" | Date =="2/2/2007")
table(data$Date)
str(data)

## Convert columns into numeric
data <-as.data.frame(data)
cols = 3:ncol(data); data[cols] <- lapply(data[,cols], function (x) as.numeric(x))
str(data)

## Create a new variable combining date and time
data$completedate <- with(data, paste (Date, Time))
data$completedate <- strptime(data$completedate, "%d/%m/%Y %H:%M:%S")
Sys.setlocale("LC_TIME", "English")


## Melt the columns "Sub_metering_1", "Sub_metering_2" and "Sub_metering_3" into one column
data2 <- data[,7:10]
data2$completedate <- as.character(data2$completedate)
data2 <- melt(data2, id = "completedate", variable.name = "Sub_metering_type", value.name = "Sub_metering_value")
data2$completedate <- as.POSIXlt(data2$completedate)
str(data2)

## Plot 3
png("plot3.png")
with(data2, plot(completedate,Sub_metering_value,xlab="",ylab="Energy sub metering", type="n"))
with(subset(data2, Sub_metering_type =="Sub_metering_1"), lines(completedate, Sub_metering_value, col="black"))
with(subset(data2, Sub_metering_type =="Sub_metering_2"), lines(completedate, Sub_metering_value, col="red"))
with(subset(data2, Sub_metering_type =="Sub_metering_3"), lines(completedate, Sub_metering_value, col="blue"))
legend("topright",lty=1, col=c("black","red","blue"), legend = unique(data2$Sub_metering_type))
dev.off()