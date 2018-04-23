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
globalActivePower <- as.numeric(subSetData$Global_active_power)
png("./c4/plot2.png", width = 480, height = 480)
plot(datewithtime, globalActivePower, type = "l", ylab="Global Active Power (kilowatts)", xlab = "")
dev.off()

