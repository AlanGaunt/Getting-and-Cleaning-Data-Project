## Install packages if needed

require("reshape2")

## Download and upzip data file

if(!file.exists("./data")){dir.create("./data")}
fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Accelerometers.zip")
dt = unzip(zipfile = "./data/Accelerometers.zip", exdir = "./data")

## Check to ensure files were downloaded

ifelse(length(dt) == 28, "Download & Unzip Succesful", "Download & Unzip Failed")

## Loading files in...

## Labels & Features

activity_labels = read.table('./data/UCI HAR Dataset/activity_labels.txt')
features <- read.table('./data/UCI HAR Dataset/features.txt')

##Testing

subject_test = read.table("./data/UCI HAR Dataset/test/subject_test.txt")
x_test = read.table("./data/UCI HAR Dataset/test/x_test.txt")
y_test = read.table("./data/UCI HAR Dataset/test/y_test.txt")

## Training

subject_train = read.table("./data/UCI HAR Dataset/train/subject_train.txt")
x_train = read.table("./data/UCI HAR Dataset/train/x_train.txt")
y_train = read.table("./data/UCI HAR Dataset/train/y_train.txt")

## Pull only features wanted (mean and std)...

featuresWanted = grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names = features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names = gsub('[-()]', '', featuresWanted.names)

x_test <- x_test[featuresWanted]
x_train <- x_train[featuresWanted]

## Merge datasets

test_data = cbind(y_test, subject_test, x_test)
train_data = cbind(y_train, subject_train, x_train)
all_data = rbind(test_data, train_data)

## Correcting column names

colnames(all_data) = c("Activity", "SubjectID", featuresWanted.names)

## Convert activites and subjects into factors

all_data$Activity = factor(all_data$Activity, levels = activity_labels[,1], labels = activity_labels[,2])
all_data$SubjectID = as.factor(all_data$SubjectID)

## Create tidy data frames

tidy_data = melt(all_data, id = c("Activity", "SubjectID"))
tidy_data.mean = dcast(tidy_data, Activity + SubjectID ~ variable, mean)

## Save tidy_data as txt file

write.table(tidy_data, "tidy.txt", row.names = FALSE, quote = FALSE)

## Save tidy_data.mean as txt file

write.table(tidy_data.mean, "tidy-mean.txt", row.names = FALSE, quote = FALSE)