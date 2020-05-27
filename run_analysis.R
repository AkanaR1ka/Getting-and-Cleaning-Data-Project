library(reshape2)

# Download the dataset with given URL and unzip it
rawDataUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if(!file.exists('./rawDataDir')){dir.create('./rawDataDir')}
download.file(rawDataUrl,destfile = './rawDataDir/rawData.zip',method='curl')
if(!file.exists('./dataDir')){dir.create('./dataDir')}
unzip(zipfile = './rawDataDir/rawData.zip', exdir = './dataDir')

# Load activity labels and measurements
activityLabels <- read.table('./dataDir/UCI HAR Dataset/activity_labels.txt')
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table('./dataDir/UCI HAR Dataset/features.txt')
features[,2] <- as.character(features[,2])
head(features[,2])

# Extracts only the measurements on the mean and standard deviation for each measurement 
featuresNeeded <- grep(".*mean.*|.*std.*",features[,2])
# features[featuresNeeded,], check if all features with mean and sd have been extracted

# Load three files from training dataset and combine them by columns
train <- read.table('./dataDir/UCI HAR Dataset/train/X_train.txt')[featuresNeeded]
trainLabels <- read.table('./dataDir/UCI HAR Dataset/train/y_train.txt')
trainSubjects <- read.table('./dataDir/UCI HAR Dataset/train/subject_train.txt')
trainTotal <- cbind(trainSubjects,trainLabels,train) 
# head(trainTotal), have a look at the combined training dataset

# Load three files from test dataset and combine the by columns
test <- read.table('./dataDir/UCI HAR Dataset/test/X_test.txt')[featuresNeeded]
testLabels <- read.table('./dataDir/UCI HAR Dataset/test/y_test.txt')
testSubjects <- read.table('./dataDir/UCI HAR Dataset/test/subject_test.txt')
testTotal <- cbind(testSubjects,testLabels,test)

# Merge the training and the test sets to create one data set
Totaldata <- rbind(trainTotal,testTotal)
# head(Totaldata), have a look at the combined new dataset
# Label the data set with descriptive variable names
colnames(Totaldata) <- c('Subject','Activity',features[featuresNeeded,2])

# Turn activity and subject values into factors to give descriptive activity names
Totaldata$Activity <- factor(Totaldata$Activity,levels = activityLabels[,1], labels = activityLabels[,2])
Totaldata$Subject <- factor(Totaldata$Subject)
# head(Totaldata$Activity) to check if the activities value have been changed

# Create a second independent tidy data set with the average of each variable for each activity and each subject 
TotaldataMelt <- melt(Totaldata, id=c('Subject','Activity'))
TotaldataMean <- dcast(TotaldataMelt,Activity+Subject~variable,mean)
write.table(TotaldataMean,'tidy.txt', row.names = FALSE, quote = FALSE)









