if(!file.exists("./c4")){dir.create("./c4")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="./c4/power.zip",method="curl")
unzip(zipfile = "./c4/power.zip", exdir = "./c4")
fpath <- file.path("./c4" , "Power data")
files<-list.files(fpath, recursive=TRUE)

dataFile <- "./c4/household_power_consumption.txt"
data <- read.table(dataFile, header=TRUE, sep=";", stringsAsFactors=FALSE, dec=".")
subSetData <- data[data$Date %in% c("1/2/2007","2/2/2007") ,]

datewithtime <- strptime(paste(subSetData$Date, subSetData$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
subMetering1 <- as.numeric(subSetData$Sub_metering_1)
subMetering2 <- as.numeric(subSetData$Sub_metering_2)
subMetering3 <- as.numeric(subSetData$Sub_metering_3)

png("./c4/plot3.png", width=480, height=480)
plot(datewithtime, subMetering1, type="l", ylab="Energy sub metering", xlab="")
lines(datewithtime, subMetering2, type="l", col="red")
lines(datewithtime, subMetering3, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, lwd=2.5, col=c("black", "red", "blue"))
dev.off()
