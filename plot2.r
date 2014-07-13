## Read data
## Use fread because the file contains many lines
require(data.table)
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

##Plot 2
png("plot2.png")
with(data, plot(completedate, Global_active_power, type ="l", xlab="", ylab="Global Active Power (kilowatts)"))
dev.off()
