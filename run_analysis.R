#=====================STEP 0: PREPARATION DATA ========================
rm(list=ls())
# Create data folder 
if (!file.exists('data')){
  dir.create('data')
}

# Download and unzip dataset 
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,destfile = 'data/human_activity.zip')
unzip('data/human_activity.zip',exdir = 'data/')
date_of_download <- date()

# read data
data_path <- 'data/UCI HAR Dataset/'

features <- read.table(paste(data_path, 'features.txt', sep=""), col.names = c('ID', 'Features'))
activity_label <- read.table(paste(data_path, 'activity_labels.txt', sep=""), col.names = c('ID', 'Activity'))

# variable name description 
col_train <- features$Features

# Read train dataset
X_train <- read.table(paste(data_path, 'train/X_train.txt', sep=""), col.names = col_train, check.names = FALSE)
y_train <- read.table(paste(data_path, 'train/y_train.txt', sep=""))
subject_train <- read.table(paste(data_path, 'train/subject_train.txt', sep=""))

# Read test dataset
X_test <- read.table(paste(data_path, 'test/X_test.txt', sep=""), col.names = col_train, check.names = FALSE)
y_test <- read.table(paste(data_path, 'test/y_test.txt', sep=""))
subject_test <- read.table(paste(data_path, 'test/subject_test.txt', sep=""))
#===================== END STEP 0 =================================

#===================== STEP 1: MERGE THE DATASET ================================
# merge columns subject_train and subject_test into X train and X_test respectively
X_train_p = cbind(y_train, subject_train,X_train)
X_test_p = cbind(y_test, subject_test,X_test)

# rename first 2 columns of X_train
names(X_train_p)[1] <- "Activity"
names(X_train_p)[2] <- "Subject"

# rename first 2 columns of X_test
names(X_test_p)[1] <- "Activity"
names(X_test_p)[2] <- "Subject"

# Merge train and test file
X_data <- rbind(X_train,X_test)
y_data <- rbind(y_train,y_test)
subject_data <- rbind(subject_train,subject_test)
#=====================END STEP 1 ================================

#===================== STEP 2: EXTRACT MEASUREMENT VARIABLES ==============
# extract measurement on mean and standard variable by variables name
col_names <- colnames(X_data)
col_mean  <- grep('mean\\(\\)',col_names)
col_std   <- grep('std\\(\\)',col_names)
X_mean_std <- X_data[,c(col_mean,col_std)]
#===================== END STEP 2 =====================


# =================== STEP 3: USE DESCRIPTY ACTIVITY NAMES ============
X_data_clean <- cbind(subject_data, y_data, X_mean_std)
names(X_data_clean)[1] <- "Subject"
names(X_data_clean)[2] <- "ID_Activity"

# Merge activity name with activity label by IDs
X_clean <- merge(X_data_clean, activity_label, by.x = 'ID_Activity', by.y = 'ID')

# Just get the Activity for the names of activities, remove the ID columns
X_clean[,"ID_Activity"] <- NULL

#===================== END STEP 3 =========================

#===================== STEP 4: APPRORIATELY DATA VARIABLES NAMES ==============================
# Replace the short name meaning by full meaning as described in features_info.txt
col_X_cleans <- colnames(X_clean)
col_X_cleans <- sub(x=col_X_cleans, pattern = "^t", replacement = "Time domain: ")
col_X_cleans <- sub(x=col_X_cleans, pattern = "^f", replacement = "Frequency domain: ")
col_X_cleans <- sub(x = col_X_cleans, pattern = '-', replacement = ', ')
col_X_cleans <- sub(x = col_X_cleans, pattern = 'mean\\(\\)',replacement = ' mean value ')
col_X_cleans <- sub(x = col_X_cleans, pattern = 'std\\(\\)',replacement = ' standard deviration value ')
col_X_cleans <- sub(x = col_X_cleans, pattern = '-X',replacement = 'on X axis')
col_X_cleans <- sub(x = col_X_cleans, pattern = '-Y',replacement = 'on Y axis')
col_X_cleans <- sub(x = col_X_cleans, pattern = '-Z',replacement = 'on Z axis')
col_X_cleans <- sub(x = col_X_cleans, pattern = 'AccJerk',replacement = ' acceleration jerk')
col_X_cleans <- sub(x = col_X_cleans, pattern = 'Acc',replacement = ' acceleration')
col_X_cleans <- sub(x = col_X_cleans, pattern = 'GyroJerk',replacement = ' angular velocity jerk')
col_X_cleans <- sub(x = col_X_cleans, pattern = 'Gyro',replacement = ' angular velocity')
col_X_cleans <- sub(x = col_X_cleans, pattern = 'Mag',replacement = ' magnitude')

# Assign new columns name to X_clean
names(X_clean) <- col_X_cleans

#================================ END STEP 4 =============================
# count mean of each variable by activity and subject
X_tidy <- aggregate(X_clean[,3:68],by=list(X_clean$Activity,X_clean$Subject),FUN=mean)
names(X_tidy)[1] <- "Activity"
names(X_tidy)[2] <- "Subject"

# Save the X_tidy data as tidy_data_set.txt
write.table(X_tidy, file = 'tidy_data_set.txt', row.names = F)
