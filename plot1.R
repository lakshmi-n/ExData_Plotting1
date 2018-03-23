
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

dirdata <- "."

zDataFile <- paste(dirdata, "\\power_consumption.zip", sep = "")

if (!file.exists(dirdata)) {
    dir.create(dirdata)
}

download.file(fileURL, zDataFile)
unzip(zDataFile, exdir = dirdata)

fileName <- paste(dirdata, "\\household_power_consumption.txt", sep = "")

dates <- c('1/2/2007', '2/2/2007') 
vector <- paste0("'", dates, "'", collapse = ",")
selectstatement <- paste("select * from file where Date in (",
                         vector,
                         ")")

consumptiondata <- read.csv.sql(fileName, sql = selectstatement, sep = ";")

consumptiondata$newdate <- as.Date(consumptiondata$Date, '%d/%m/%Y')
consumptiondata$newdate <- as.POSIXct(paste(consumptiondata$Date, consumptiondata$Time), format="%d/%m/%Y %H:%M:%S")

png("plot1.png", width=480, height=480, units="px")
hist(consumptiondata$Global_active_power, 
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)", 
     col = "red")
dev.off()

