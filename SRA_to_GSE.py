#import pysradb
import subprocess

import pandas as pd
import pandas as ps



updated = pd.read_excel("UPDATED_41586_2023_6139_MOESM4_ESM.xlsx", "Sheet1")
acessions = updated['accession']
GSEs = []



for project in acessions:
    if "SRP" not in str(project):
        GSEs.append("")
    elif "GSE" in str(project):
        GSEs.append(str(project))
    else:
        p = subprocess.Popen("pysradb srp-to-gse {}".format(project), shell=True, stdout=subprocess.PIPE)
        stdout, stderr = p.communicate()
        out_list =str(stdout).split("\\t")
        GSE = out_list[-1][:-3]
        GSEs.append(GSE)

GSEs = pd.Series(GSEs)

updated['accession'] = GSEs

#updated = updated[['organism', 'project_home', 'project', 'series id', 'n_samples', 'study_title', 'study_abstract']]

updated.to_csv("UPDATED_add_series.csv")




# p = subprocess.Popen("pysradb sra-to-gse ERP107748", shell=True, stdout=subprocess.PIPE)
# stdout, stderr = p.communicate()
# pass