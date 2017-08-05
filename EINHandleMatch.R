#################################################
##              DATAKIND DATADIVE              ##
##         KIVAN POLIMIS & BRETT BEJCEK        ##
#################################################

#' DESCRIPTION: This script takes in the giving_tuesday_tweets.csv file and the 
#' Sample_Program_Service_Data.csv file to output a list of non-profits in the
#' sample file with their associated twitter handle based on if their bio contained
#' the link found in the tweets.csv file. 

# Clear List
rm(list=ls())

# Install Packages
install.packages(c("dplyr", "RecordLinkage", "stringi", "stringr"))

# Required Packages
require(dplyr)
require(RecordLinkage)
require(stringr)
require(stringr)

# Read in the tweets file
tweets <- read.csv("giving_tuesday_tweets.csv", comment.char="#")

# Read in the sample file
sample <- read.csv("Sample_Program_Service_Data.csv")

# Replace the N/A's in the WEBSITE column in the sample dataframe
sample$WEBSITE[sample$WEBSITE=='N/A' | sample$WEBSITE=='NONE' | sample$WEBSITE=='n/a'] = NA

# Function to just get the domain name given a url string
domainname <- function(x) strsplit(gsub("http://|https://|www\\.", "", x), "/")[[c(1, 1)]]

# This is a dataframe with no missing user_urls and domain names attached
tweets_no_missing = tweets %>% filter(user_urls != "") %>% 
  mutate(user_urls=str_to_lower(user_urls)) %>%
  mutate(domain = sapply(user_urls, domainname))

# This is a dataframe wiht no missing website urls and domain names attached
sample_no_missing = sample %>% filter(WEBSITE != "") %>%
  mutate(WEBSITE=str_to_lower(WEBSITE)) %>%
  mutate(domain = sapply(WEBSITE, domainname))

# We only need the twitter handle and the domain columns
reduced_tweets = tweets_no_missing[,c('user_screen_name','domain')]

# We only need EIN, NAME, and domain columns
reduced_sample = sample_no_missing[,c('EIN', 'NAME', 'domain')]

# Left join of the sample file on the tweets file
combined = merge(x = reduced_sample, y = reduced_tweets, by = "domain", all.x = TRUE)

# Sort list so no missing data
combined_no_missing = combined %>% filter(user_screen_name != "")

# Transform from factor variables to character
combined_no_missing$user_screen_name = as.character(combined_no_missing$user_screen_name)
combined_no_missing$NAME = as.character(combined_no_missing$NAME)

# Get a list of unique EINs
EINS = unique(combined_no_missing$EIN)

# Create new matrix to eventually write it out
matrix <- matrix(0, length(EINS), 4)

# Set up counter variable for the for loop
count = 1

# For each EIN, group by all the possible twitter handles (both individuals and 
# organizations with their bio containing the URL link of the non-profit) and match based 
# on Levenshtein distance
for(ein in EINS)
{
subset = combined_no_missing %>% filter(EIN == ein)
user_name = unique(subset$user_screen_name)
name = str_to_lower(unique(subset$NAME))
user_name = user_name[which.max(levenshteinSim(user_name, name))]
matrix[count,] = c(subset$domain[1],subset$EIN[1],subset$NAME[1],user_name) 
count = count + 1
}

# Rename columns
colnames(matrix) = c("Domain", "EIN", "Name","TwitterHandle")

# Convert to dataframe
df = as.data.frame(matrix)

# Write CSV
write.csv(df, "EINS_AND_HANDLES.csv")
