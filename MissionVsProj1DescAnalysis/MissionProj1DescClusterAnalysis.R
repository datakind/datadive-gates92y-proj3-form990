#===================================================================================
# File:        MissionProj1DescClusterAnalysis.R
# Author:      Dave Langer
# Date:        Aug 6, 2017
# Description: This file performs a combined analysis of the Mission and Proj1Desc
#              clusters. Specifically, this analysis focuses on the distribution of
#              which Proj1Desc clusters by Mission clusters.
#===================================================================================
library(dplyr)
library(ggplot2)

# Load data
tax.data <- read.csv("Sample_Program_Service_Data.csv", stringsAsFactors = FALSE)
load("mission.df.RData")
load("proj1.df.RData")


# Add cluster assigments to sample Form 990 data
tax.data$MissionCluster <- mission.df$TwelveCluster
tax.data$Proj1DescCluster <- proj1.df$NineCluster

mission.cluster.totals <- tax.data %>%
  group_by(MissionCluster, Proj1DescCluster) %>%
  summarize(ClusterMappingCount = n()) %>%
  arrange(MissionCluster, Proj1DescCluster)


# Mission cluster #1 to Proj1Desc Mappings
cluster.total <- mission.cluster.totals %>%
  filter(MissionCluster == 1)

ggplot(cluster.total, aes(x = as.factor(Proj1DescCluster), y = ClusterMappingCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  labs(x = "Proj1Desc Cluster #",
       y = "Organization Count",
       title = "Mission Cluster #1 to Proj1Desc Cluster Distribution")


# Mission cluster #2 to Proj1Desc Mappings
cluster.total <- mission.cluster.totals %>%
  filter(MissionCluster == 2)

ggplot(cluster.total, aes(x = as.factor(Proj1DescCluster), y = ClusterMappingCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  labs(x = "Proj1Desc Cluster #",
       y = "Organization Count",
       title = "Mission Cluster #2 to Proj1Desc Cluster Distribution")


# Mission cluster #3 to Proj1Desc Mappings
cluster.total <- mission.cluster.totals %>%
  filter(MissionCluster == 3)

ggplot(cluster.total, aes(x = as.factor(Proj1DescCluster), y = ClusterMappingCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  labs(x = "Proj1Desc Cluster #",
       y = "Organization Count",
       title = "Mission Cluster #3 to Proj1Desc Cluster Distribution")


# Mission cluster #4 to Proj1Desc Mappings
cluster.total <- mission.cluster.totals %>%
  filter(MissionCluster == 4)

ggplot(cluster.total, aes(x = as.factor(Proj1DescCluster), y = ClusterMappingCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  labs(x = "Proj1Desc Cluster #",
       y = "Organization Count",
       title = "Mission Cluster #4 to Proj1Desc Cluster Distribution")


# Mission cluster #5 to Proj1Desc Mappings
cluster.total <- mission.cluster.totals %>%
  filter(MissionCluster == 5)

ggplot(cluster.total, aes(x = as.factor(Proj1DescCluster), y = ClusterMappingCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  labs(x = "Proj1Desc Cluster #",
       y = "Organization Count",
       title = "Mission Cluster #5 to Proj1Desc Cluster Distribution")


# Mission cluster #6 to Proj1Desc Mappings
cluster.total <- mission.cluster.totals %>%
  filter(MissionCluster == 6)

ggplot(cluster.total, aes(x = as.factor(Proj1DescCluster), y = ClusterMappingCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  labs(x = "Proj1Desc Cluster #",
       y = "Organization Count",
       title = "Mission Cluster #6 to Proj1Desc Cluster Distribution")


# Mission cluster #7 to Proj1Desc Mappings
cluster.total <- mission.cluster.totals %>%
  filter(MissionCluster == 7)

ggplot(cluster.total, aes(x = as.factor(Proj1DescCluster), y = ClusterMappingCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  labs(x = "Proj1Desc Cluster #",
       y = "Organization Count",
       title = "Mission Cluster #7 to Proj1Desc Cluster Distribution")


# Mission cluster #8 to Proj1Desc Mappings
cluster.total <- mission.cluster.totals %>%
  filter(MissionCluster == 8)

ggplot(cluster.total, aes(x = as.factor(Proj1DescCluster), y = ClusterMappingCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  labs(x = "Proj1Desc Cluster #",
       y = "Organization Count",
       title = "Mission Cluster #8 to Proj1Desc Cluster Distribution")


# Mission cluster #9 to Proj1Desc Mappings
cluster.total <- mission.cluster.totals %>%
  filter(MissionCluster == 9)

ggplot(cluster.total, aes(x = as.factor(Proj1DescCluster), y = ClusterMappingCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  labs(x = "Proj1Desc Cluster #",
       y = "Organization Count",
       title = "Mission Cluster #9 to Proj1Desc Cluster Distribution")


# Mission cluster #10 to Proj1Desc Mappings
cluster.total <- mission.cluster.totals %>%
  filter(MissionCluster == 10)

ggplot(cluster.total, aes(x = as.factor(Proj1DescCluster), y = ClusterMappingCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  labs(x = "Proj1Desc Cluster #",
       y = "Organization Count",
       title = "Mission Cluster #10 to Proj1Desc Cluster Distribution")


# Mission cluster #11 to Proj1Desc Mappings
cluster.total <- mission.cluster.totals %>%
  filter(MissionCluster == 11)

ggplot(cluster.total, aes(x = as.factor(Proj1DescCluster), y = ClusterMappingCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  labs(x = "Proj1Desc Cluster #",
       y = "Organization Count",
       title = "Mission Cluster #11 to Proj1Desc Cluster Distribution")


# Mission cluster #12 to Proj1Desc Mappings
cluster.total <- mission.cluster.totals %>%
  filter(MissionCluster == 12)

ggplot(cluster.total, aes(x = as.factor(Proj1DescCluster), y = ClusterMappingCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  labs(x = "Proj1Desc Cluster #",
       y = "Organization Count",
       title = "Mission Cluster #12 to Proj1Desc Cluster Distribution")


# Great grand totals of Mission clusters to Ntee codes
ntee.totals <- tax.data %>%
  group_by(MissionCluster, NteeFinal) %>%
  summarize(NteeCount = n()) %>%
  arrange(MissionCluster, NteeFinal)


# Mission cluster #1 to Ntee Codes
cluster.total <- ntee.totals %>%
  filter(MissionCluster == 1)

ggplot(cluster.total, aes(x = as.factor(NteeFinal), y = NteeCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(x = "Ntee Code",
       y = "Organization Count",
       title = "Mapping of Mission Cluster #1 to Ntee Code")


# Mission cluster #2 to Ntee Codes
cluster.total <- ntee.totals %>%
  filter(MissionCluster == 2)

ggplot(cluster.total, aes(x = as.factor(NteeFinal), y = NteeCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(x = "Ntee Code",
       y = "Organization Count",
       title = "Mapping of Mission Cluster #2 to Ntee Code")


# Mission cluster #3 to Ntee Codes
cluster.total <- ntee.totals %>%
  filter(MissionCluster == 3)

ggplot(cluster.total, aes(x = as.factor(NteeFinal), y = NteeCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(x = "Ntee Code",
       y = "Organization Count",
       title = "Mapping of Mission Cluster #3 to Ntee Code")


# Mission cluster #4 to Ntee Codes
cluster.total <- ntee.totals %>%
  filter(MissionCluster == 4)

ggplot(cluster.total, aes(x = as.factor(NteeFinal), y = NteeCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(x = "Ntee Code",
       y = "Organization Count",
       title = "Mapping of Mission Cluster #4 to Ntee Code")


# Mission cluster #5 to Ntee Codes
cluster.total <- ntee.totals %>%
  filter(MissionCluster == 5)

ggplot(cluster.total, aes(x = as.factor(NteeFinal), y = NteeCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(x = "Ntee Code",
       y = "Organization Count",
       title = "Mapping of Mission Cluster #5 to Ntee Code")


# Mission cluster #6 to Ntee Codes
cluster.total <- ntee.totals %>%
  filter(MissionCluster == 6)

ggplot(cluster.total, aes(x = as.factor(NteeFinal), y = NteeCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(x = "Ntee Code",
       y = "Organization Count",
       title = "Mapping of Mission Cluster #6 to Ntee Code")


# Mission cluster #7 to Ntee Codes
cluster.total <- ntee.totals %>%
  filter(MissionCluster == 7)

ggplot(cluster.total, aes(x = as.factor(NteeFinal), y = NteeCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(x = "Ntee Code",
       y = "Organization Count",
       title = "Mapping of Mission Cluster #7 to Ntee Code")


# Mission cluster #8 to Ntee Codes
cluster.total <- ntee.totals %>%
  filter(MissionCluster == 8)

ggplot(cluster.total, aes(x = as.factor(NteeFinal), y = NteeCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(x = "Ntee Code",
       y = "Organization Count",
       title = "Mapping of Mission Cluster #8 to Ntee Code")


# Mission cluster #9 to Ntee Codes
cluster.total <- ntee.totals %>%
  filter(MissionCluster == 9)

ggplot(cluster.total, aes(x = as.factor(NteeFinal), y = NteeCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(x = "Ntee Code",
       y = "Organization Count",
       title = "Mapping of Mission Cluster #9 to Ntee Code")


# Mission cluster #10 to Ntee Codes
cluster.total <- ntee.totals %>%
  filter(MissionCluster == 10)

ggplot(cluster.total, aes(x = as.factor(NteeFinal), y = NteeCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(x = "Ntee Code",
       y = "Organization Count",
       title = "Mapping of Mission Cluster #10 to Ntee Code")


# Mission cluster #11 to Ntee Codes
cluster.total <- nteeltotals %>%
  filter(MissionCluster == 11)

ggplot(cluster.total, aes(x = as.factor(NteeFinal), y = NteeCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(x = "Ntee Code",
       y = "Organization Count",
       title = "Mapping of Mission Cluster #11 to Ntee Code")


# Mission cluster #12 to Ntee Codes
cluster.total <- ntee.totals %>%
  filter(MissionCluster == 12)

ggplot(cluster.total, aes(x = as.factor(NteeFinal), y = NteeCount)) +
  theme_bw() +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(x = "Ntee Code",
       y = "Organization Count",
       title = "Mapping of Mission Cluster #12 to Ntee Code")

