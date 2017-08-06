#===================================================================================
# File:        Proj1TextClusterAnalysis.R
# Author:      Dave Langer
# Date:        Aug 6, 2017
# Description: This file performs a cluster analysis of the text Proj1Desc field of
#              the Form 990 sample file. Specifically, the file performs a unigram
#              text analysis of the textual descriptions of organizations and then
#              attempts to find an optimal number of clusters using k-means. The
#              found clusters are then visualized as word clouds for analysis.
#===================================================================================
library(quanteda)
library(ggplot2)

# Load data
tax.data <- read.csv("Sample_Program_Service_Data.csv", stringsAsFactors = FALSE)

# Tokenize words
proj1.tokens <- tokens(tax.data$proj1Desc, what = "word", 
                       remove_numbers = TRUE, remove_punct = TRUE,
                       remove_symbols = TRUE, remove_hyphens = TRUE)

# Make all words lower case
proj1.tokens <- tokens_tolower(proj1.tokens)

# Remove stop words, adding custom words common in the text that are deemed
# to not add analytical value
proj1.stopwords <- c(stopwords(), "services", "program", "programs",
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
                     "connection", "connections", "resource", "resources",
                     "culture", "cultures", "cultured", "support", "supports",
                     "supported") 
proj1.tokens <- tokens_select(proj1.tokens, proj1.stopwords, selection = "remove")

# Perform stemming. This will mangle words, but will also standardize multiple
# word forms into single representations
proj1.tokens <- tokens_wordstem(proj1.tokens, language = "english")

# Create n-grams - NOTE that this line of code is present to illustrate how
# to additional n-grams easily to the analysis by changing n = 1 to n = 1:2 
# for unigrams and bigrams
proj1.tokens <- tokens_ngrams(proj1.tokens, n = 1)

# Create document feature matrix
proj1.tokens.dfm <- dfm(proj1.tokens, tolower = FALSE)

# Only keep words that are present in at least 10 observations
proj1.tokens.dfm <- dfm_trim(proj1.tokens.dfm, min_count = 1, min_docfreq = 10)
proj1.tokens.dfm

# Examine the top 50 words by count
proj1Desc.topfeatures <- topfeatures(proj1.tokens.dfm, n = 75)
proj1Desc.topfeatures

# Apply the TF-IDF calcaulation to the matrix
proj1Desc.tokens.tfidf <- tfidf(proj1.tokens.dfm, normalize = TRUE)

# Convert quanteda object type to standard R matrix
proj1Desc.tfidf.matrix <- as.matrix(convert(proj1.tokens.dfm, to = "tm"))



# Perform singular value composition on the TF-IDF matrix. Specifically, 
# reduce dimensionality down to 300 columns for our latent semantic 
# analysis (LSA). Research has shown that 300 singular vectors is a 
# reasonable starting point.
library(irlba)

# Time the code execution
start.time <- Sys.time()

train.irlba <- irlba(t(proj1Desc.tfidf.matrix), nv = 300, maxit = 600)

# Total time of execution on workstation was 
total.time <- Sys.time() - start.time
total.time

# Calculating SVD takes a long time, save off results as R binary
save(train.irlba, file = "proj1desc.svd.RData")


# Leverage the "elbow-method" with a scree plot for determining an
# optimal number of clusters for k-means.

# First, establish a vector to hold all values.
clusters.sum.squares <- rep(0.0, 19)

# Repeat K-means clustering with K equal to 2, 3, 4,...15.
cluster.params <- 2:20

set.seed(893247)
for (i in cluster.params) {
  # Cluster data using K-means with the current value of i.
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
       title = "Form 990 Proj1Desc Clusters Scree Plot")


# The scree plot illustrates that k = 6, 9 and 11 might be optimal
# numbers of clusters, take a look at all three values.
set.seed(95834)
kmeans.six <- kmeans(train.irlba$v, centers = 6, iter.max = 50)
kmeans.nine <- kmeans(train.irlba$v, centers = 9, iter.max = 50)
kmeans.eleven <- kmeans(train.irlba$v, centers = 11, iter.max = 50)

# Add cluster assignments to the data frame
tax.data$SixCluster <- kmeans.six$cluster
tax.data$NineCluster <- kmeans.nine$cluster
tax.data$ElevenCluster <- kmeans.eleven$cluster

# Examine cluster assignment distributions
table(tax.data$SixCluster)
table(tax.data$NineCluster)
table(tax.data$ElevenCluster)


# Looking at the distributions above, seems like k = 9 is a 
# reasonable starting point for analysis


# Visualize clusters as wordcloud of top 50 terms for each cluster
library(wordcloud)

for(i in 1:9) {
  top.features <- topfeatures(proj1.tokens.dfm[tax.data$NineCluster == i],
                              n = 50)
  wordcloud(names(top.features), top.features)
}



# Save off EIN to Mission cluster assignments as R binary
proj1.df <- tax.data[, c("EIN", "NineCluster")]
save(proj1.df, file = "proj1.df.RData")
