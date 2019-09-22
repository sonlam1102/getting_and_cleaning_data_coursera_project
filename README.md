# Getting and Cleaning Course Final submission project Coursera    
This is my final submission on Coursera    

# Submission content    
This project contains only the scipt run_analysis.R. 
The data is downloaded from the link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip   

# How to run    
- I had try to wrap all tasks in one script file thus you just simply run the command: **Rscript run_analysis.R** (please install R on your machine before)
- The script run_analysis.R will do these following tasks:   
  - Download and unzip the file from the data resources link.   
  - Read thoses downloaded file (include train set and test set).   
  - Merging training set and test set.    
  - Extract only measurement on mean and standard deviation.   
  - Use meaningful names for the activity values.    
  - Change the header to approriately values.   
  - Find the average vof each value for each activity name and subject.
  - Save the final data as tidy data.
- The results after executing the script is an tidy data file called: **tidy_data.txt**
