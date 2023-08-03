import pandas as pd

merged_df = pd.read_csv("archs4_recount3_geneformer.csv")
archs4_df = merged_df[merged_df['dataset'] == 'archs4']
archs4_df_dropna_st = merged_df[merged_df['dataset'] == 'archs4'].dropna(subset=['study_title'])
overlap_dict = {"Geneformer": 0, "recount3": 0}
for index, row in merged_df.iterrows():
   dataset = row['dataset']
   if dataset not in ['Geneformer','recount3']:
      break
   gse =  row['repository_id']
   title = row['study_title']
   
   if str(gse) != 'nan':
      gse_count = merged_df['repository_id'].value_counts()[gse]

      if  gse_count > 1:
         if (dataset in ['Geneformer','recount3']) and (gse in list(archs4_df['repository_id'])):
            overlap_dict[dataset] +=1
            merged_df.drop([index], inplace=True)
   else:
     if (dataset in ['Geneformer', 'recount3']):
        for archs4_title in archs4_df_dropna_st['study_title']:
           if str(title) != 'nan':
              if title in archs4_title:
                 print(index)
                 if index in merged_df.index:
                  overlap_dict[dataset] += 1
                  merged_df.drop([index], inplace=True)

print(overlap_dict)
merged_df.to_csv("archs4_recount3_geneformer_sp.csv")
