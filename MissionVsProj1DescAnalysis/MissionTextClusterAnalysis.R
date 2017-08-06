#===================================================================================
# File:        MissionTextClusterAnalysis.R
# Author:      Dave Langer
# Date:        Aug 6, 2017
# Description: This file performs a cluster analysis of the text MISSION field of
#              the Form 990 sample file. Specifically, the file performs a unigram
#              text analysis of the textual descriptions of organizations and then
#              attempts to find an optimal number of clusters using k-means. The
#              found clusters are then visualized as word clouds for analysis.
#===================================================================================
library(quanteda)
library(dplyr)
library(ggplot2)

# Load data
tax.data <- read.csv("Sample_Program_Service_Data.csv", stringsAsFactors = FALSE)

# Tokenize words
mission.tokens <- tokens(tax.data$MISSION, what = "word", 
                       remove_numbers = TRUE, remove_punct = TRUE,
                       remove_symbols = TRUE, remove_hyphens = TRUE)

# Make all words lower case
mission.tokens <- tokens_tolower(mission.tokens)

# Remove stop words, adding custom words common in the text that are deemed
# to not add analytical value
mission.stopwords <- c(stopwords(), "services", "program", "programs",
                     "provide", "provided", "support", "provides",
                     "also", "year", "new", "providing", "help",
                     "approximately", "including", "one", "well",
                     "people", "area", "service", "based", "served",
                     "projects", "include", "will", "persons", "promote",
                     "related", "various", "staff", "staffers", "include",
                     "includes", "project", "supports", "community",
                     "communities", "organization", "organizations",
                     "org", "design", "help", "helping", "helps", "designs",
                     "mission", "missions", "helper", "establish", "establishes",
                     "purpose", "purposes", "develop", "development", "develops",
                     "connect", "connects", "connecting", "connector", 
                     "connection", "connections", "resource", "resources") 
mission.tokens <- tokens_select(mission.tokens, mission.stopwords, selection = "remove")

# Perform stemming. This will mangle words, but will also standardize multiple
# word forms into single representations
mission.tokens <- tokens_wordstem(mission.tokens, language = "english")

# Create n-grams - NOTE that this line of code is present to illustrate how
# to additional n-grams easily to the analysis by changing n = 1 to n = 1:2 
# for unigrams and bigrams
mission.tokens <- tokens_ngrams(mission.tokens, n = 1)

# Create document feature matrix
mission.tokens.dfm <- dfm(mission.tokens, tolower = FALSE)

# Only keep words that are present in at least 10 observations
mission.tokens.dfm <- dfm_trim(mission.tokens.dfm, min_count = 1, min_docfreq = 10)
mission.tokens.dfm

# Examine the top 50 words by count
missionDesc.topfeatures <- topfeatures(mission.tokens.dfm, n = 50)
missionDesc.topfeatures

# Apply the TF-IDF calcaulation to the matrix
missionDesc.tokens.tfidf <- tfidf(mission.tokens.dfm, normalize = TRUE)

# Convert quanteda object type to standard R matrix
missionDesc.tfidf.matrix <- as.matrix(convert(mission.tokens.dfm, to = "tm"))


# Perform singular value composition on the TF-IDF matrix. Specifically, 
# reduce dimensionality down to 300 columns for our latent semantic 
# analysis (LSA). Research has shown that 300 singular vectors is a 
# reasonable starting point.
library(irlba)

# Time the code execution
start.time <- Sys.time()

train.irlba <- irlba(t(missionDesc.tfidf.matrix), nv = 300, maxit = 600)

# Total time of execution
total.time <- Sys.time() - start.time
total.time

# Calculating SVD takes a long time, save off results as R binary
save(train.irlba, file = "mission.svd.RData")


# Leverage the "elbow-method" with a scree plot for determining an
# optimal number of clusters for k-means.

# First, establish a vector to hold all values.
clusters.sum.squares <- rep(0.0, 19)

# Repeat K-means clustering with K equal to 2, 3, 4,...15.
cluster.params <- 2:20

set.seed(59846)
for (i in cluster.params) {
  # Cluster data using K-means with the current value of i
  kmeans.temp <- kmeans(train.irlba$v, centers = i)
  
  # Get the total sum of squared distances for all points
  # in the cluster and store it for plotting later.
  clusters.sum.squares[i - 1] <- sum(kmeans.temp$withinss)
}   

# Create screen plot. Look for points of diminishing returns 
# (i.e., "elbows" in the plot) for potenial optimal numbers
# of clusters
ggplot(NULL, aes(x = cluster.params, y = clusters.sum.squares)) +
  theme_bw() +
  geom_point() +
  geom_line() +
  labs(x = "Number of Clusters",
       y = "Cluster Sum of Squared Distances",
       title = "Form 990 Mission Clusters Scree Plot")


# The scree plot illustrates that k = 12 might be the optimal
# numbers of clusters, take a look at all three values.
set.seed(86245)
kmeans.twelve <- kmeans(train.irlba$v, centers = 12)

# Add cluster assignments to the data frame
tax.data$TwelveCluster <- kmeans.twelve$cluster

# Examine cluster assignment distributions
table(tax.data$TwelveCluster)


# Visualize clusters as wordcloud of top 50 terms for each cluster
library(wordcloud)

for(i in 1:12) {
  top.features <- topfeatures(mission.tokens.dfm[tax.data$TwelveCluster == i],
                              n = 50)
  wordcloud(names(top.features), top.features)
}


# Save off EIN to Mission cluster assignments as R binary
mission.df <- tax.data[, c("EIN", "TwelveCluster")]
save(mission.df, file = "mission.df.RData")

