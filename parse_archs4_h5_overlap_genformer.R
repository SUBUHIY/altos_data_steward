library("rhdf5")

UPDATED_df <- read.csv("UPDATED_add_series.csv")

destination_file_human = "human_gene_v2.2.h5"
destination_file_mouse = "mouse_gene_v2.2.h5"

# #extracted_expression_file = "GSM2679484_expression_matrix.tsv"
# url = "https://altos-lab-data-external.s3.us-west-2.amazonaws.com/ARCHS4_20235301630/human_gene_v2.2.h5"
# 
# # Check if gene expression file was already downloaded, if not in current directory download file form repository
# if(!file.exists(destination_file)){
#   print("Downloading compressed gene expression matrix.")
#   download.file(url, destination_file, quiet = FALSE, mode = 'wb')
# }

# Selected samples to be extracted
UPDATED_gse = UPDATED_df$accession


len_series <- 1:length(UPDATED_gse)
# test_col = c()
# 
# for (ind in len_series)
#   test_col <-append(test_col,"ok")

# Retrieve information from compressed data
human_gse = h5read(destination_file_human, "meta/samples/series_id")
mouse_gse = h5read(destination_file_mouse, "meta/samples/series_id")

pass= function(){
  
}

overlap= c()

for (ind in len_series)
  if ((UPDATED_gse[ind] != "") && (UPDATED_gse[ind] %in% human_gse)){
    overlap <- append(overlap,"Y")
  } else if ((UPDATED_gse[ind] != "") && (UPDATED_gse[ind] %in% mouse_gse)) {
    overlap <- append(overlap,"Y")
  } else {
    overlap <- append(overlap,"")
  }



UPDATED_df$overlap_with_archs4 = overlap

write.csv(UPDATED_df,"UPDATED_overlap.csv")
