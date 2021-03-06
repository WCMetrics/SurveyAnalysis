# Importing libraries
# Reticulate - needed to import numpy arrays
library(reticulate)

# CA - needed for Correspondence Analysis 
library(ca)

# PSY - needed for Chronbach's alpha
library(psy)

# IRR - needed for Kendall's W
library(irr)

# RcppAlgos - needed for Kendall's Clusterization
library(RcppAlgos)

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
#R1 ca_values$rownames <- c("E014","E024","E034","E043","E055","E064","E072","E084","E095","E105","E114","E124","E135","E144","E154","E164","E174","E185","E194","E205")
ca_values$rownames <- c("E064","E024","E095","E185","E105","E034","E124","E114","E043","E164","E154","E144","E055","E014","E072","E194","E174","E084","E135","E205")
ca_values$colnames <- c("Q01","Q02","Q03","Q04","Q05","Q06","Q07","Q08","Q09","Q10",
                        "Q11","Q12","Q13","Q14","Q15","Q16","Q17","Q18","Q19","Q20",
                        "Q21","Q22","Q23","Q24","Q25","Q26","Q27","Q28","Q29","Q30",
                        "Q31","Q32","Q33","Q34","Q35","Q36","Q37","Q38","Q39","Q40",
                        "Q41","Q42","Q43","Q44","Q45")

plot(ca_values)

# Kendall's W Intra Iteraciones
# Note: Fixing ties
kendall(metrics, TRUE)

# Kendall's W Inter #1 #2
# Note: Fixing ties
rounds_avg <- cbind(answers_mean,c(2.80, 3.40, 1.95, 2.35, 2.50, 2.00, 4.15, 3.20, 3.05, 4.10, 2.55, 3.25, 3.15, 2.75, 4.65, 3.50, 2.50, 4.05, 2.65, 2.35, 3.35, 3.00, 4.15, 4.20, 4.15, 3.20, 4.20, 3.25, 4.30, 3.95, 3.30, 3.70, 4.55, 3.80, 3.80, 4.55, 3.80, 3.45, 4.25, 3.40, 4.40, 3.55, 4.55, 4.25, 3.65))
kendall(rounds_avg, TRUE)

# Kendall's W Clustering
# Cluster 2 Experts
eval_num <- c(1:comboCount(20,2))
eval<-comboGeneral(20,2)

StatsClusters <- data.frame()
W2Cluster <- data.frame()

for (i in eval_num){
    answers_slice <- cbind(answers[eval[i,1],],answers[eval[i,2],])
    k_output <- kendall(answers_slice,TRUE)
    
    new_eval <- data.frame(eval[i,1],eval[i,2],k_output["value"])
    names(new_eval) <- c("Exp1","Exp2","W")
    
    W2Cluster <- rbind(W2Cluster,new_eval)
}

W2ClusterMin <- W2Cluster[which.min(W2Cluster$W),]
W2ClusterMax <- W2Cluster[which.max(W2Cluster$W),]

new_stats <- data.frame("WMC.02",W2ClusterMax$W, W2ClusterMin$W, mean(W2Cluster$W), var(W2Cluster$W) ,sd(W2Cluster$W))
names(new_stats) <- c("Cluster","Max","Min","Mean","Var", "StdDev")

StatsClusters <- rbind(StatsClusters,new_stats)

hist(W2Cluster$W,seq(W2ClusterMin$W,W2ClusterMax$W,(W2ClusterMax$W-W2ClusterMin$W)/100))


# Cluster 3 Experts
eval_num <- c(1:comboCount(20,3))
eval<-comboGeneral(20,3)

W3Cluster <- data.frame()

for (i in eval_num){
    answers_slice <- cbind(answers[eval[i,1],],answers[eval[i,2],],answers[eval[i,3],])
    k_output <- kendall(answers_slice,TRUE)
    
    new_eval <- data.frame(eval[i,1],eval[i,2],eval[i,3],k_output["value"])
    names(new_eval) <- c("Exp1","Exp2","Exp3","W")
    
    W3Cluster <- rbind(W3Cluster,new_eval)
}

W3ClusterMin <- W3Cluster[which.min(W3Cluster$W),]
W3ClusterMax <- W3Cluster[which.max(W3Cluster$W),]

new_stats <- data.frame("WMC.03",W3ClusterMax$W, W3ClusterMin$W, mean(W3Cluster$W), var(W3Cluster$W), sd(W3Cluster$W))
names(new_stats) <- c("Cluster","Max","Min","Mean","Var", "StdDev")

StatsClusters <- rbind(StatsClusters,new_stats)

hist(W3Cluster$W,seq(W3ClusterMin$W,W3ClusterMax$W,(W3ClusterMax$W-W3ClusterMin$W)/100))

# Cluster 4 Experts
eval_num <- c(1:comboCount(20,4))
eval<-comboGeneral(20,4)

W4Cluster <- data.frame()

for (i in eval_num){
    answers_slice <- cbind(answers[eval[i,1],],answers[eval[i,2],],answers[eval[i,3],],answers[eval[i,4],])
    k_output <- kendall(answers_slice,TRUE)
    
    new_eval <- data.frame(eval[i,1],eval[i,2],eval[i,3],eval[i,4],k_output["value"])
    names(new_eval) <- c("Exp1","Exp2","Exp3","Exp4","W")
    
    W4Cluster <- rbind(W4Cluster,new_eval)
}

W4ClusterMin <- W4Cluster[which.min(W4Cluster$W),]
W4ClusterMax <- W4Cluster[which.max(W4Cluster$W),]

new_stats <- data.frame("WMC.04",W4ClusterMax$W, W4ClusterMin$W, mean(W4Cluster$W), var(W4Cluster$W), sd(W4Cluster$W))
names(new_stats) <- c("Cluster","Max","Min","Mean","Var", "StdDev")

StatsClusters <- rbind(StatsClusters,new_stats)

hist(W4Cluster$W,seq(W4ClusterMin$W,W4ClusterMax$W,(W4ClusterMax$W-W4ClusterMin$W)/100))

# Cluster 5 Experts
eval_num <- c(1:comboCount(20,5))
eval<-comboGeneral(20,5)

W5Cluster <- data.frame()

for (i in eval_num){
    answers_slice <- cbind(answers[eval[i,1],],answers[eval[i,2],],answers[eval[i,3],],answers[eval[i,4],],answers[eval[i,5],])
    k_output <- kendall(answers_slice,TRUE)
    
    new_eval <- data.frame(eval[i,1],eval[i,2],eval[i,3],eval[i,4],eval[i,5],k_output["value"])
    names(new_eval) <- c("Exp1","Exp2","Exp3","Exp4","Exp5","W")
    
    W5Cluster <- rbind(W5Cluster,new_eval)
}

W5ClusterMin <- W5Cluster[which.min(W5Cluster$W),]
W5ClusterMax <- W5Cluster[which.max(W5Cluster$W),]

new_stats <- data.frame("WMC.05",W5ClusterMax$W, W5ClusterMin$W, mean(W5Cluster$W), var(W5Cluster$W), sd(W5Cluster$W))
names(new_stats) <- c("Cluster","Max","Min","Mean","Var", "StdDev")

StatsClusters <- rbind(StatsClusters,new_stats)

hist(W5Cluster$W,seq(W5ClusterMin$W,W5ClusterMax$W,(W5ClusterMax$W-W5ClusterMin$W)/100))

# Cluster 6 Experts
eval_num <- c(1:comboCount(20,6))
eval<-comboGeneral(20,6)

W6Cluster <- data.frame()

for (i in eval_num){
    answers_slice <- cbind(answers[eval[i,1],],answers[eval[i,2],],answers[eval[i,3],],answers[eval[i,4],],answers[eval[i,5],],answers[eval[i,6],])
    k_output <- kendall(answers_slice,TRUE)
    
    new_eval <- data.frame(eval[i,1],eval[i,2],eval[i,3],eval[i,4],eval[i,5],eval[i,6],k_output["value"])
    names(new_eval) <- c("Exp1","Exp2","Exp3","Exp4","Exp5","Exp6","W")
    
    W6Cluster <- rbind(W6Cluster,new_eval)
}

W6ClusterMin <- W6Cluster[which.min(W6Cluster$W),]
W6ClusterMax <- W6Cluster[which.max(W6Cluster$W),]

new_stats <- data.frame("WMC.06",W6ClusterMax$W, W6ClusterMin$W, mean(W6Cluster$W), var(W6Cluster$W), sd(W6Cluster$W))
names(new_stats) <- c("Cluster","Max","Min","Mean","Var", "StdDev")

StatsClusters <- rbind(StatsClusters,new_stats)

hist(W6Cluster$W,seq(W6ClusterMin$W,W6ClusterMax$W,(W6ClusterMax$W-W6ClusterMin$W)/100))

# Cluster 7 Experts
eval_num <- c(1:comboCount(20,7))
eval<-comboGeneral(20,7)

W7Cluster <- data.frame()

for (i in eval_num){
    answers_slice <- cbind(answers[eval[i,1],],answers[eval[i,2],],answers[eval[i,3],],answers[eval[i,4],],answers[eval[i,5],],answers[eval[i,6],],answers[eval[i,7],])
    k_output <- kendall(answers_slice,TRUE)
    
    new_eval <- data.frame(eval[i,1],eval[i,2],eval[i,3],eval[i,4],eval[i,5],eval[i,6],eval[i,7],k_output["value"])
    names(new_eval) <- c("Exp1","Exp2","Exp3","Exp4","Exp5","Exp6","Exp7","W")
    
    W7Cluster <- rbind(W7Cluster,new_eval)
}

W7ClusterMin <- W7Cluster[which.min(W7Cluster$W),]
W7ClusterMax <- W7Cluster[which.max(W7Cluster$W),]

new_stats <- data.frame("WMC.07",W7ClusterMax$W, W7ClusterMin$W, mean(W7Cluster$W), var(W7Cluster$W), sd(W7Cluster$W))
names(new_stats) <- c("Cluster","Max","Min","Mean","Var", "StdDev")

StatsClusters <- rbind(StatsClusters,new_stats)

hist(W7Cluster$W,seq(W7ClusterMin$W,W7ClusterMax$W,(W7ClusterMax$W-W7ClusterMin$W)/100))

# Cluster 8 Experts
eval_num <- c(1:comboCount(20,8))
eval<-comboGeneral(20,8)

W8Cluster <- data.frame()

for (i in eval_num){
    answers_slice <- cbind(answers[eval[i,1],],answers[eval[i,2],],answers[eval[i,3],],answers[eval[i,4],],answers[eval[i,5],],answers[eval[i,6],],answers[eval[i,7],],answers[eval[i,8],])
    k_output <- kendall(answers_slice,TRUE)
    
    new_eval <- data.frame(eval[i,1],eval[i,2],eval[i,3],eval[i,4],eval[i,5],eval[i,6],eval[i,7],eval[i,8],k_output["value"])
    names(new_eval) <- c("Exp1","Exp2","Exp3","Exp4","Exp5","Exp6","Exp7","Exp8","W")
    
    W8Cluster <- rbind(W8Cluster,new_eval)
}

W8ClusterMin <- W8Cluster[which.min(W8Cluster$W),]
W8ClusterMax <- W8Cluster[which.max(W8Cluster$W),]

new_stats <- data.frame("WMC.08",W8ClusterMax$W, W8ClusterMin$W, mean(W8Cluster$W), var(W8Cluster$W), sd(W8Cluster$W))
names(new_stats) <- c("Cluster","Max","Min","Mean","Var", "StdDev")

StatsClusters <- rbind(StatsClusters,new_stats)

hist(W8Cluster$W,seq(W8ClusterMin$W,W8ClusterMax$W,(W8ClusterMax$W-W8ClusterMin$W)/100))


# Cluster 9 Experts
eval_num <- c(1:comboCount(20,9))
eval<-comboGeneral(20,9)

W9Cluster <- data.frame()

for (i in eval_num){
    answers_slice <- cbind(answers[eval[i,1],],answers[eval[i,2],],answers[eval[i,3],],answers[eval[i,4],],answers[eval[i,5],],answers[eval[i,6],],answers[eval[i,7],],answers[eval[i,8],],answers[eval[i,9],])
    k_output <- kendall(answers_slice,TRUE)
    
    new_eval <- data.frame(eval[i,1],eval[i,2],eval[i,3],eval[i,4],eval[i,5],eval[i,6],eval[i,7],eval[i,8],eval[i,9],k_output["value"])
    names(new_eval) <- c("Exp1","Exp2","Exp3","Exp4","Exp5","Exp6","Exp7","Exp8","Exp9","W")
    
    W9Cluster <- rbind(W9Cluster,new_eval)
}

W9ClusterMin <- W9Cluster[which.min(W9Cluster$W),]
W9ClusterMax <- W9Cluster[which.max(W9Cluster$W),]

new_stats <- data.frame("WMC.09",W9ClusterMax$W, W9ClusterMin$W, mean(W9Cluster$W), var(W9Cluster$W), sd(W9Cluster$W))
names(new_stats) <- c("Cluster","Max","Min","Mean","Var", "StdDev")

StatsClusters <- rbind(StatsClusters,new_stats)

hist(W9Cluster$W,seq(W9ClusterMin$W,W9ClusterMax$W,(W9ClusterMax$W-W9ClusterMin$W)/100))

# Cluster 10 Experts
eval_num <- c(1:comboCount(20,10))
eval<-comboGeneral(20,10)

W10Cluster <- data.frame()

for (i in eval_num){
    answers_slice <- cbind(answers[eval[i,1],],answers[eval[i,2],],answers[eval[i,3],],answers[eval[i,4],],
    answers[eval[i,5],],answers[eval[i,6],],answers[eval[i,7],],answers[eval[i,8],],answers[eval[i,9],],
    answers[eval[i,10],])
    
    k_output <- kendall(answers_slice,TRUE)
    
    new_eval <- data.frame(eval[i,1],eval[i,2],eval[i,3],eval[i,4],eval[i,5],eval[i,6],eval[i,7],eval[i,8],eval[i,9],eval[i,10],k_output["value"])
    names(new_eval) <- c("Exp1","Exp2","Exp3","Exp4","Exp5","Exp6","Exp7","Exp8","Exp9","Exp10","W")
    
    W10Cluster <- rbind(W10Cluster,new_eval)
}

W10ClusterMin <- W10Cluster[which.min(W10Cluster$W),]
W10ClusterMax <- W10Cluster[which.max(W10Cluster$W),]

new_stats <- data.frame("WMC.10",W10ClusterMax$W, W10ClusterMin$W, mean(W10Cluster$W), var(W10Cluster$W), sd(W10Cluster$W))
names(new_stats) <- c("Cluster","Max","Min","Mean","Var", "StdDev")

StatsClusters <- rbind(StatsClusters,new_stats)

hist(W10Cluster$W,seq(W10ClusterMin$W,W10ClusterMax$W,(W10ClusterMax$W-W10ClusterMin$W)/100))

# Cluster 11 Experts
eval_num <- c(1:comboCount(20,11))
eval<-comboGeneral(20,11)

W11Cluster <- data.frame()

for (i in eval_num){
    answers_slice <- cbind(answers[eval[i,1],],answers[eval[i,2],],answers[eval[i,3],],answers[eval[i,4],],
    answers[eval[i,5],],answers[eval[i,6],],answers[eval[i,7],],answers[eval[i,8],],answers[eval[i,9],],
    answers[eval[i,10],],answers[eval[i,11],])
    
    k_output <- kendall(answers_slice,TRUE)
    
    new_eval <- data.frame(eval[i,1],eval[i,2],eval[i,3],eval[i,4],eval[i,5],eval[i,6],eval[i,7],eval[i,8],eval[i,9],eval[i,10],
    eval[i,11],k_output["value"])
    
    names(new_eval) <- c("Exp1","Exp2","Exp3","Exp4","Exp5","Exp6","Exp7","Exp8","Exp9","Exp10","Exp11","W")
    
    W11Cluster <- rbind(W11Cluster,new_eval)
}

W11ClusterMin <- W11Cluster[which.min(W11Cluster$W),]
W11ClusterMax <- W11Cluster[which.max(W11Cluster$W),]

new_stats <- data.frame("WMC.11",W11ClusterMax$W, W11ClusterMin$W, mean(W11Cluster$W), var(W11Cluster$W), sd(W11Cluster$W))
names(new_stats) <- c("Cluster","Max","Min","Mean","Var", "StdDev")

StatsClusters <- rbind(StatsClusters,new_stats)

hist(W11Cluster$W,seq(W11ClusterMin$W,W11ClusterMax$W,(W11ClusterMax$W-W11ClusterMin$W)/100))

# Cluster 12 Experts
eval_num <- c(1:comboCount(20,12))
eval<-comboGeneral(20,12)

W12Cluster <- data.frame()

for (i in eval_num){
    answers_slice <- cbind(answers[eval[i,1],],answers[eval[i,2],],answers[eval[i,3],],answers[eval[i,4],],
    answers[eval[i,5],],answers[eval[i,6],],answers[eval[i,7],],answers[eval[i,8],],answers[eval[i,9],],
    answers[eval[i,10],],answers[eval[i,11],],answers[eval[i,12],])
    
    k_output <- kendall(answers_slice,TRUE)
    
    new_eval <- data.frame(eval[i,1],eval[i,2],eval[i,3],eval[i,4],eval[i,5],eval[i,6],eval[i,7],eval[i,8],eval[i,9],eval[i,10],
    eval[i,11],eval[i,12],k_output["value"])
    
    names(new_eval) <- c("Exp1","Exp2","Exp3","Exp4","Exp5","Exp6","Exp7","Exp8","Exp9","Exp10","Exp11","Exp12","W")
    
    W12Cluster <- rbind(W12Cluster,new_eval)
}

W12ClusterMin <- W12Cluster[which.min(W12Cluster$W),]
W12ClusterMax <- W12Cluster[which.max(W12Cluster$W),]

new_stats <- data.frame("WMC.12",W12ClusterMax$W, W12ClusterMin$W, mean(W12Cluster$W), var(W12Cluster$W), sd(W12Cluster$W))
names(new_stats) <- c("Cluster","Max","Min","Mean","Var","StdDev")

StatsClusters <- rbind(StatsClusters,new_stats)

hist(W12Cluster$W,seq(W12ClusterMin$W,W12ClusterMax$W,(W12ClusterMax$W-W12ClusterMin$W)/100))

# Cluster 13 Experts
eval_num <- c(1:comboCount(20,13))
eval<-comboGeneral(20,13)

W13Cluster <- data.frame()

for (i in eval_num){
    answers_slice <- cbind(answers[eval[i,1],],answers[eval[i,2],],answers[eval[i,3],],answers[eval[i,4],],
    answers[eval[i,5],],answers[eval[i,6],],answers[eval[i,7],],answers[eval[i,8],],answers[eval[i,9],],
    answers[eval[i,10],],answers[eval[i,11],],answers[eval[i,12],],answers[eval[i,13],])
    
    k_output <- kendall(answers_slice,TRUE)
    
    new_eval <- data.frame(eval[i,1],eval[i,2],eval[i,3],eval[i,4],eval[i,5],eval[i,6],eval[i,7],eval[i,8],eval[i,9],eval[i,10],
    eval[i,11],eval[i,12],eval[i,13],k_output["value"])
    
    names(new_eval) <- c("Exp1","Exp2","Exp3","Exp4","Exp5","Exp6","Exp7","Exp8","Exp9","Exp10","Exp11","Exp12","Exp13","W")
    
    W13Cluster <- rbind(W13Cluster,new_eval)
}

W13ClusterMin <- W13Cluster[which.min(W13Cluster$W),]
W13ClusterMax <- W13Cluster[which.max(W13Cluster$W),]

new_stats <- data.frame("WMC.13",W13ClusterMax$W, W13ClusterMin$W, mean(W13Cluster$W), var(W13Cluster$W), sd(W13Cluster$W))
names(new_stats) <- c("Cluster","Max","Min","Mean","Var", "StdDev")

StatsClusters <- rbind(StatsClusters,new_stats)

hist(W13Cluster$W,seq(W13ClusterMin$W,W13ClusterMax$W,(W13ClusterMax$W-W13ClusterMin$W)/100))

# Cluster 14 Experts
eval_num <- c(1:comboCount(20,14))
eval<-comboGeneral(20,14)

W14Cluster <- data.frame()

for (i in eval_num){
    answers_slice <- cbind(answers[eval[i,1],],answers[eval[i,2],],answers[eval[i,3],],answers[eval[i,4],],
    answers[eval[i,5],],answers[eval[i,6],],answers[eval[i,7],],answers[eval[i,8],],answers[eval[i,9],],
    answers[eval[i,10],],answers[eval[i,11],],answers[eval[i,12],],answers[eval[i,13],],answers[eval[i,14],])
    
    k_output <- kendall(answers_slice,TRUE)
    
    new_eval <- data.frame(eval[i,1],eval[i,2],eval[i,3],eval[i,4],eval[i,5],eval[i,6],eval[i,7],eval[i,8],eval[i,9],eval[i,10],
    eval[i,11],eval[i,12],eval[i,13],eval[i,14],k_output["value"])
    
    names(new_eval) <- c("Exp1","Exp2","Exp3","Exp4","Exp5","Exp6","Exp7","Exp8","Exp9","Exp10","Exp11","Exp12","Exp13","Exp14","W")
    
    W14Cluster <- rbind(W14Cluster,new_eval)
}

W14ClusterMin <- W14Cluster[which.min(W14Cluster$W),]
W14ClusterMax <- W14Cluster[which.max(W14Cluster$W),]

new_stats <- data.frame("WMC.14",W14ClusterMax$W, W14ClusterMin$W, mean(W14Cluster$W), var(W14Cluster$W), sd(W14Cluster$W))
names(new_stats) <- c("Cluster","Max","Min","Mean","Var", "StdDev")

StatsClusters <- rbind(StatsClusters,new_stats)

hist(W14Cluster$W,seq(W14ClusterMin$W,W14ClusterMax$W,(W14ClusterMax$W-W14ClusterMin$W)/100))

# Cluster 15 Experts
eval_num <- c(1:comboCount(20,15))
eval<-comboGeneral(20,15)

W15Cluster <- data.frame()

for (i in eval_num){
    answers_slice <- cbind(answers[eval[i,1],],answers[eval[i,2],],answers[eval[i,3],],answers[eval[i,4],],
    answers[eval[i,5],],answers[eval[i,6],],answers[eval[i,7],],answers[eval[i,8],],answers[eval[i,9],],
    answers[eval[i,10],],answers[eval[i,11],],answers[eval[i,12],],answers[eval[i,13],],answers[eval[i,14],],
    answers[eval[i,15],])
    
    k_output <- kendall(answers_slice,TRUE)
    
    new_eval <- data.frame(eval[i,1],eval[i,2],eval[i,3],eval[i,4],eval[i,5],eval[i,6],eval[i,7],eval[i,8],eval[i,9],eval[i,10],
    eval[i,11],eval[i,12],eval[i,13],eval[i,14],eval[i,15],k_output["value"])
    
    names(new_eval) <- c("Exp1","Exp2","Exp3","Exp4","Exp5","Exp6","Exp7","Exp8","Exp9","Exp10","Exp11","Exp12","Exp13","Exp14","Exp15","W")
    
    W15Cluster <- rbind(W15Cluster,new_eval)
}

W15ClusterMin <- W15Cluster[which.min(W15Cluster$W),]
W15ClusterMax <- W15Cluster[which.max(W15Cluster$W),]

new_stats <- data.frame("WMC.15",W15ClusterMax$W, W15ClusterMin$W, mean(W15Cluster$W), var(W15Cluster$W), sd(W15Cluster$W))
names(new_stats) <- c("Cluster","Max","Min","Mean","Var", "StdDev")

StatsClusters <- rbind(StatsClusters,new_stats)

hist(W15Cluster$W,seq(W15ClusterMin$W,W15ClusterMax$W,(W15ClusterMax$W-W15ClusterMin$W)/100))

# Cluster 16 Experts
eval_num <- c(1:comboCount(20,16))
eval<-comboGeneral(20,16)

W16Cluster <- data.frame()

for (i in eval_num){
    answers_slice <- cbind(answers[eval[i,1],],answers[eval[i,2],],answers[eval[i,3],],answers[eval[i,4],],
    answers[eval[i,5],],answers[eval[i,6],],answers[eval[i,7],],answers[eval[i,8],],answers[eval[i,9],],
    answers[eval[i,10],],answers[eval[i,11],],answers[eval[i,12],],answers[eval[i,13],],answers[eval[i,14],],
    answers[eval[i,15],],answers[eval[i,16],])
    
    k_output <- kendall(answers_slice,TRUE)
    
    new_eval <- data.frame(eval[i,1],eval[i,2],eval[i,3],eval[i,4],eval[i,5],eval[i,6],eval[i,7],eval[i,8],eval[i,9],eval[i,10],
    eval[i,11],eval[i,12],eval[i,13],eval[i,14],eval[i,15],eval[i,16],k_output["value"])
    
    names(new_eval) <- c("Exp1","Exp2","Exp3","Exp4","Exp5","Exp6","Exp7","Exp8","Exp9","Exp10","Exp11","Exp12","Exp13","Exp14","Exp15","Exp16","W")
    
    W16Cluster <- rbind(W16Cluster,new_eval)
}

W16ClusterMin <- W16Cluster[which.min(W16Cluster$W),]
W16ClusterMax <- W16Cluster[which.max(W16Cluster$W),]

new_stats <- data.frame("WMC.16",W16ClusterMax$W, W16ClusterMin$W, mean(W16Cluster$W), var(W16Cluster$W), sd(W16Cluster$W))
names(new_stats) <- c("Cluster","Max","Min","Mean","Var", "StdDev")

StatsClusters <- rbind(StatsClusters,new_stats)

hist(W16Cluster$W,seq(W16ClusterMin$W,W16ClusterMax$W,(W16ClusterMax$W-W16ClusterMin$W)/100))

# Cluster 17 Experts
eval_num <- c(1:comboCount(20,17))
eval<-comboGeneral(20,17)

W17Cluster <- data.frame()

for (i in eval_num){
    answers_slice <- cbind(answers[eval[i,1],],answers[eval[i,2],],answers[eval[i,3],],answers[eval[i,4],],
    answers[eval[i,5],],answers[eval[i,6],],answers[eval[i,7],],answers[eval[i,8],],answers[eval[i,9],],
    answers[eval[i,10],],answers[eval[i,11],],answers[eval[i,12],],answers[eval[i,13],],answers[eval[i,14],],
    answers[eval[i,15],],answers[eval[i,16],],answers[eval[i,17],])
    
    k_output <- kendall(answers_slice,TRUE)
    
    new_eval <- data.frame(eval[i,1],eval[i,2],eval[i,3],eval[i,4],eval[i,5],eval[i,6],eval[i,7],eval[i,8],eval[i,9],eval[i,10],
    eval[i,11],eval[i,12],eval[i,13],eval[i,14],eval[i,15],eval[i,16],eval[i,17],k_output["value"])
    
    names(new_eval) <- c("Exp1","Exp2","Exp3","Exp4","Exp5","Exp6","Exp7","Exp8","Exp9","Exp10","Exp11","Exp12","Exp13","Exp14","Exp15","Exp16","Exp17","W")
    
    W17Cluster <- rbind(W17Cluster,new_eval)
}

W17ClusterMin <- W17Cluster[which.min(W17Cluster$W),]
W17ClusterMax <- W17Cluster[which.max(W17Cluster$W),]

new_stats <- data.frame("WMC.17",W17ClusterMax$W, W17ClusterMin$W, mean(W17Cluster$W), var(W17Cluster$W), sd(W17Cluster$W))
names(new_stats) <- c("Cluster","Max","Min","Mean","Var", "StdDev")

StatsClusters <- rbind(StatsClusters,new_stats)

hist(W17Cluster$W,seq(W17ClusterMin$W,W17ClusterMax$W,(W17ClusterMax$W-W17ClusterMin$W)/100))

# Cluster 18 Experts
eval_num <- c(1:comboCount(20,18))
eval<-comboGeneral(20,18)

W18Cluster <- data.frame()

for (i in eval_num){
    answers_slice <- cbind(answers[eval[i,1],],answers[eval[i,2],],answers[eval[i,3],],answers[eval[i,4],],
    answers[eval[i,5],],answers[eval[i,6],],answers[eval[i,7],],answers[eval[i,8],],answers[eval[i,9],],
    answers[eval[i,10],],answers[eval[i,11],],answers[eval[i,12],],answers[eval[i,13],],answers[eval[i,14],],
    answers[eval[i,15],],answers[eval[i,16],],answers[eval[i,17],],answers[eval[i,18],])
    
    k_output <- kendall(answers_slice,TRUE)
    
    new_eval <- data.frame(eval[i,1],eval[i,2],eval[i,3],eval[i,4],eval[i,5],eval[i,6],eval[i,7],eval[i,8],eval[i,9],eval[i,10],
    eval[i,11],eval[i,12],eval[i,13],eval[i,14],eval[i,15],eval[i,16],eval[i,17],eval[i,18],k_output["value"])
    
    names(new_eval) <- c("Exp1","Exp2","Exp3","Exp4","Exp5","Exp6","Exp7","Exp8","Exp9","Exp10","Exp11","Exp12","Exp13","Exp14","Exp15","Exp16","Exp17","Exp18","W")
    
    W18Cluster <- rbind(W18Cluster,new_eval)
}

W18ClusterMin <- W18Cluster[which.min(W18Cluster$W),]
W18ClusterMax <- W18Cluster[which.max(W18Cluster$W),]

new_stats <- data.frame("WMC.18",W18ClusterMax$W, W18ClusterMin$W, mean(W18Cluster$W), var(W18Cluster$W), sd(W18Cluster$W))
names(new_stats) <- c("Cluster","Max","Min","Mean","Var", "StdDev")

StatsClusters <- rbind(StatsClusters,new_stats)

hist(W18Cluster$W,seq(W18ClusterMin$W,W18ClusterMax$W,(W18ClusterMax$W-W18ClusterMin$W)/100))

# Cluster 19 Experts
eval_num <- c(1:comboCount(20,19))
eval<-comboGeneral(20,19)

W19Cluster <- data.frame()

for (i in eval_num){
    answers_slice <- cbind(answers[eval[i,1],],answers[eval[i,2],],answers[eval[i,3],],answers[eval[i,4],],
    answers[eval[i,5],],answers[eval[i,6],],answers[eval[i,7],],answers[eval[i,8],],answers[eval[i,9],],
    answers[eval[i,10],],answers[eval[i,11],],answers[eval[i,12],],answers[eval[i,13],],answers[eval[i,14],],
    answers[eval[i,15],],answers[eval[i,16],],answers[eval[i,17],],answers[eval[i,18],],answers[eval[i,19],])
    
    k_output <- kendall(answers_slice,TRUE)
    
    new_eval <- data.frame(eval[i,1],eval[i,2],eval[i,3],eval[i,4],eval[i,5],eval[i,6],eval[i,7],eval[i,8],eval[i,9],eval[i,10],
    eval[i,11],eval[i,12],eval[i,13],eval[i,14],eval[i,15],eval[i,16],eval[i,17],eval[i,18],eval[i,19],k_output["value"])
    
    names(new_eval) <- c("Exp1","Exp2","Exp3","Exp4","Exp5","Exp6","Exp7","Exp8","Exp9","Exp10","Exp11","Exp12","Exp13","Exp14","Exp15","Exp16","Exp17","Exp18","Exp19","W")
    
    W19Cluster <- rbind(W19Cluster,new_eval)
}

W19ClusterMin <- W19Cluster[which.min(W19Cluster$W),]
W19ClusterMax <- W19Cluster[which.max(W19Cluster$W),]

new_stats <- data.frame("WMC.19",W19ClusterMax$W, W19ClusterMin$W, mean(W19Cluster$W), var(W19Cluster$W), sd(W19Cluster$W))
names(new_stats) <- c("Cluster","Max","Min","Mean","Var", "StdDev")

StatsClusters <- rbind(StatsClusters,new_stats)

hist(W19Cluster$W,seq(W19ClusterMin$W,W19ClusterMax$W,(W19ClusterMax$W-W19ClusterMin$W)/10))


## Plotting W Dynamics
plot(StatsClusters$Min, type="b")
text(StatsClusters$Min,labels=StatsClusters$Cluster,cex=0.7, pos=3)

plot(StatsClusters$Max, type="b")
text(StatsClusters$Max,labels=StatsClusters$Cluster,cex=0.7, pos=3)

plot(StatsClusters$Mean, type="b")
text(StatsClusters$Mean,labels=StatsClusters$Cluster,cex=0.7, pos=3)

plot(StatsClusters$Var, type="b")
text(StatsClusters$Var,labels=StatsClusters$Cluster,cex=0.7, pos=3)

plot(StatsClusters$StdDev, type="b")
text(StatsClusters$StdDev,labels=StatsClusters$Cluster,cex=0.7, pos=3)