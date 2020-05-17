# Importing libraries
# Reticulate - needed to import numpy arrays
library(reticulate)

# CA - needed for Correspondence Analysis 
library(ca)

# PSY - needed for Chronbach's alpha
library(psy)

# IRR - needed for Kendall's W
library(irr)


# Loading np
use_python("/usr/local/bin/python3")
np <- import("numpy")

# files path 
base_path = "/Users/almo/Development/WCMetrics/SurveyAnalysis/"

answers_path= paste(base_path,"answers.npy",sep="")
metrics_path= paste(base_path,"metrics.npy",sep="")

answers_mean_path = paste(base_path,"answers_mean.npy",sep="")
answers_median_path = paste(base_path,"answers_median.npy",sep="")
answers_std_path = paste(base_path,"answers_std.npy",sep="")

answers_agree_path = paste(base_path,"answers_agree.npy",sep="")
answers_disagree_path = paste(base_path,"answers_disagree.npy",sep="")

answers <- np$load(answers_path)
metrics <- np$load(metrics_path)

answers_mean <- np$load(answers_mean_path)
answers_median <- np$load(answers_median_path)
answers_std <- np$load(answers_std_path)

answers_agree <- np$load(answers_agree_path)
answers_disagree <- np$load(answers_disagree_path)

# Chronbach's Alpah
cronbach(answers)

# Corresponde Analysis
ca(answers)
plot(ca(answers))

# Kendall's W
kendall(metrics)