import pandas as pd
import json

#get lists of various cellxgene columns
cellx = pd.read_csv("CellXGene.csv")
cellx_ds_title = list(cellx["dataset_title"])
cellx_study_title = list(cellx["study_title"])
cellx_sample_names = list(cellx["file_name_rds"].apply(lambda x: str(x).split("/processed/")[-1]))
cellx_shorthand = list(cellx["preferred_name"].apply(lambda x: str(x).lower()))


#load labrador json
f = open('labrador_export_06062023.json')
data_labr = json.load(f)

#check for overlap with sample names
print("matches in sample names")
for record in data_labr:
    for sample in record["Altos Requested Datasets"]:
        if str(sample["name"]).lower() in [str(x).lower() for x in cellx_ds_title]:
            print(sample["name"])

#check for overlap with study titles
print("matches in study title")
for labr_record in data_labr:
    #print(str(labr_record["Altos Publication Ontology"]["title"]).split(".")[0])
    if str(labr_record["Altos Publication Ontology"]["title"]).split(".")[0] in cellx_study_title:
        print(labr_record["Altos Publication Ontology"]["title"])

#check with overlap of shorthand titles
print("matches in study shorthand/preferred name")
for labr_record in data_labr:
    lbr_shorthand = "".join(str(labr_record["Submitter study design"]["title"]).split("_")).lower()
    if lbr_shorthand in cellx_study_title:
        print(lbr_shorthand)


# Closing file
f.close()