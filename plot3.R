
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

## A function to plot the submetering graphs since we need to do this twice.
plot_submetering <- function(btyvalue = "o") {
    plotcolors <- c("black", "red", "blue")
    
    ## Initialize the scatter data graph without any points     
    plot(consumptiondata$newdate, 
         consumptiondata$Sub_metering_1,
         xlab = "",
         ylab = "Energy sub metering",
         type = "n")
    axis(side = 2, lwd = 2)
    
    legend_labels <- c()
    
    ## Add data for each of the sub_metering columns to the graph
    for (temploopvar in 1:length(plotcolors)){
        legend_labels[temploopvar] <- paste0("Sub_metering_", temploopvar)
        points(consumptiondata$newdate, 
               consumptiondata[[legend_labels[temploopvar]]],
               type = "l",
               col = plotcolors[temploopvar])
    }
    
    legend("topright", legend_labels, col = plotcolors, lty = "solid", bty = btyvalue)
}

png("plot3.png", width=480, height=480, units="px")
plot_submetering()
dev.off()
