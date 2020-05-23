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
ca_values <- ca(answers)
ca_values$rownames <- c("E01","E02","E03","E04","E05","E06","E07","E08","E09","Ex10","Ex11","Ex12")
ca_values$colnames <- c("Q01","Q02","Q03","Q04","Q05","Q06","Q07","Q08","Q09","Q10",
                        "Q11","Q12","Q13","Q14","Q15","Q16","Q17","Q18","Q19","Q20",
                        "Q21","Q22","Q23","Q24","Q25","Q26","Q27","Q28","Q29","Q30",
                        "Q31","Q32","Q33","Q34","Q35","Q36","Q37","Q38","Q39","Q40",
                        "Q41","Q42","Q43","Q44","Q45")

plot(ca(answers))

# Kendall's W
# Note: Fixing ties
kendall(metrics, TRUE)