from google_auth_oauthlib import flow
from google.oauth2.credentials import Credentials
import gspread
import numpy as np
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt

def getUserCredetials():
    appflow = flow.InstalledAppFlow.from_client_secrets_file(
        '/Users/almo/Development/credentials/wcmetrics.json',
        scopes=['https://www.googleapis.com/auth/spreadsheets.readonly', 'https://www.googleapis.com/auth/drive.readonly'])

    appflow.run_local_server()

    credentials = appflow.credentials

    f = open("wcmetrics_user.json",'x')
    f.write(credentials.to_json())
    f.close()

    return credentials

def evaluateAgreement(a):
    agree = 0.0
    for i in a:
        if i > 3:
            agree+=1
    return agree/len(a)

def evaluateDisagreement(a):
    agree = 0.0    
    for i in a:
        if i < 3:
            agree+=1
    return agree/len(a)

try:
    credentials = Credentials.from_authorized_user_file("wcmetrics_user.json")
except FileNotFoundError:
    credentials= getUserCredetials()

gc = gspread.authorize(credentials)

worksheet = gc.open('Analisis de Calidad de Componentes Web (respuestas)').worksheet('Results Round #2')

# get_all_values gives a list of rows.
answers= np.array(worksheet.get('D2:AV21'),int)
metrics = np.transpose(answers)

# Statistics
answers_mean = np.mean(answers,axis=0)
answers_median = np.median(answers,axis=0)
answers_std = np.std(answers,axis=0)

answers_agree = np.apply_along_axis(evaluateAgreement,0,answers)
answers_disagree = np.apply_along_axis(evaluateDisagreement,0,answers)

## Saving Data for R Scripts
np.save("answers.npy",answers)
np.save("metrics.npy",metrics)
np.save("answers_mean.npy",answers_mean)
np.save("answers_median.npy",answers_median)
np.save("answers_std.npy",answers_std)
np.save("answers_agree.npy",answers_agree)
np.save("answers_disagree.npy",answers_disagree)

baseline=0
size_plots, ax1 = plt.subplots()
ax1.set_title('Code Size Product Quality Coverage')
ax1.boxplot([metrics[baseline+0],metrics[baseline+1],metrics[baseline+2],metrics[baseline+3],metrics[baseline+4],metrics[baseline+5],metrics[baseline+6],metrics[baseline+7]], 
    labels=["Q1","Q2","Q3","Q4","Q5","Q6","Q7","Q8"])

plt.show()

baseline=8
structure_plots, ax2 = plt.subplots()
ax2.set_title('Code Structure Product Quality Coverage')
ax2.boxplot([metrics[baseline+0],metrics[baseline+1],metrics[baseline+2],metrics[baseline+3],metrics[baseline+4],metrics[baseline+5],metrics[baseline+6],metrics[baseline+7]],
    labels=["Q9","Q10","Q11","Q12","Q13","Q14","Q15","Q16"])

plt.show()

baseline=16
dependencies_plots, ax3 = plt.subplots()
ax3.set_title('Number of Dependencies Product Quality Coverage')
ax3.boxplot([metrics[baseline+0],metrics[baseline+1],metrics[baseline+2],metrics[baseline+3],metrics[baseline+4],metrics[baseline+5],metrics[baseline+6],metrics[baseline+7]],
    labels=["Q17","Q18","Q19","Q20","Q21","Q22","Q23","Q24"])

plt.show()

baseline=24
completeness_plots, ax4 = plt.subplots()
ax4.set_title('Completeness Quality in Use Coverage')
ax4.boxplot([metrics[baseline+0],metrics[baseline+1],metrics[baseline+2],metrics[baseline+3],metrics[baseline+4],metrics[baseline+5],metrics[baseline+6]],
    labels=["Q25","Q26","Q27","Q28","Q29","Q30","Q31"])

plt.show()

baseline=31
latency_plots, ax5 = plt.subplots()
ax5.set_title('Latency Quality in Use Coverage')
ax5.boxplot([metrics[baseline+0],metrics[baseline+1],metrics[baseline+2],metrics[baseline+3],metrics[baseline+4],metrics[baseline+5],metrics[baseline+6]],
    labels=["Q32","Q33","Q34","Q35","Q36","Q37","Q38"])

plt.show()

baseline=38
consistency_plots, ax6 = plt.subplots()
ax6.set_title('Consistency Quality in Use Coverage')
ax6.boxplot([metrics[baseline+0],metrics[baseline+1],metrics[baseline+2],metrics[baseline+3],metrics[baseline+4],metrics[baseline+5],metrics[baseline+6]],
    labels=["Q39","Q40","Q41","Q42","Q43","Q44","Q45"])

plt.show()