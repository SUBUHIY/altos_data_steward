#import pysradb
import subprocess

import pandas as pd
import pandas as ps
import argparse

#add argments and descriptions
parser = argparse.ArgumentParser(add_help=False)
parser.add_argument('--file_in',help="input excel filepath")
parser.add_argument('--sheet_name',help="input excel sheetname. ignore if input is csv", default= "Sheet1")
parser.add_argument('--excel_out',help="output filepath", default="add_series.xlsx")
parser.add_argument('--SRA_col_name', help="column name that indicates SRA ID")
args = parser.parse_args()
f = args.file_in
sheetname = args.sheet_name
outfile = args.excel_out
sra_name = args.SRA_col_name


def add_series(filename, sheet_name, out, SRAcolname):
    if ".xl" in filename:
        in_df = pd.read_excel(filename, sheet_name)
    elif ".csv" in filename:
        in_df = pd.read_csv(filename)

    acessions = in_df[SRAcolname]
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
    
    in_df['accession'] = GSEs
    
    in_df.to_excel(out)
    
    return


if __name__ == "__main__":
   add_series(f, sheetname, outfile, sra_name)
