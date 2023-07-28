library("rhdf5")
library(GEOquery)

suppressWarnings({
recounts_df <- read.csv("recount_overlap.csv")
len_recounts <-1:length(recounts_df$organism)
updated_df <- read.csv("UPDATED_overlap.csv")
len_updated <-1:length(updated_df$Dataset_ID)

destination_file_human = "human_gene_v2.2.h5"
destination_file_mouse = "mouse_gene_v2.2.h5"

gse <- c()
organism <- c()
tissue_type <- c()
study_title <- c()
dataset <- c()
overlap_gse <-c()


for (ind in len_updated)
  if (updated_df$overlap_with_archs4[ind] != "Y"){ 
    print(ind)
    title_organisms <- c()
    if (grepl("human", updated_df$Source[ind], ignore.case=TRUE)){
      title_organisms <- append(title_organisms, "human")
    }
    if (grepl("mouse", updated_df$Source[ind], ignore.case=TRUE)){
      title_organisms <- append(title_organisms, "mouse")
    }

    str_organisms = paste(title_organisms, sep=", \n")
    
    if (length(str_organisms) == 1){
      organism <- append(organism,str_organisms[1])
    }else if (length(str_organisms) == 2){
      organism <- append(organism, paste(title_organisms[1], title_organisms[2], sep = ", \n"))
    }else{
      organism <- append(organism,"")
    }

    if (grepl("No results found", updated_df$Source[ind], ignore.case=TRUE)){
      gse <-append(gse, "")
    }else {
      gse <-append(gse, updated_df$accession[ind])
    }
    tissue_type <-append(tissue_type, updated_df$Organ_specific[ind])
    study_title <-append(study_title, updated_df$Source[ind])
    dataset <- append(dataset, "Geneformer")
  }

for (ind in len_recounts)
  if (recounts_df$overlap_with_archs4[ind] != "Y"){
    
    if (grepl("No results found", recounts_df$series_id[ind], ignore.case=TRUE)){
      gse <-append(gse, "")
    }else {
      gse <-append(gse, recounts_df$series_id[ind])
    }
    organism <-append(organism, recounts_df$organism[ind])
    tissue_type <- append(tissue_type,"")
    study_title <-append(study_title, recounts_df$study_title[ind])
    dataset <- append(dataset, "recount3")
  }
  
    

non_overlap_recount_updated_df  <- data.frame("repository_id"=gse,
                                   "organism" = organism,
                                   "tissue_type" = tissue_type,
                                   "study title" = study_title,
                                   "dataset" = dataset)

write.csv(non_overlap_recount_updated_df,"recount3_geneformer.csv")

recount3_genformer_df <- read.csv("recount3_geneformer.csv")
  
# Retrieve information from compressed data
human_gse = h5read(destination_file_human, "meta/samples/series_id")
human_source = h5read(destination_file_human, "meta/samples/source_name_ch1")
mouse_gse = h5read(destination_file_mouse, "meta/samples/series_id")
mouse_source = h5read(destination_file_mouse, "meta/samples/source_name_ch1")

archs_gse <- c()
archs_organism <-c()
archs_sample <- c()
archs_title <- c()
archs_dataset <- c()

find_title <- function(i) {
  tryCatch(
    {
      gse_ind <- getGEO(GEO = i, destdir = "./", GSEMatrix = FALSE)
      return(Meta(gse_ind)[c("title")]$title)
    },
    error=function(e) {
      message('An Error Occurred')
      return("")
    },
    warning=function(w) {
      message('A Warning Occurred')
      return("")
    }
  )
}



for (ind in 1:length(human_gse)){
  if (grepl(",", human_gse[ind], ignore.case=TRUE)){
    gse_list <- strsplit(human_gse[ind], split = ",")
    human_gse[ind] = gse_list[[1]]
  }
  if (!(human_gse[ind] %in% archs_gse)){
    archs_gse <- append(archs_gse, human_gse[ind])
    archs_organism <- append(archs_organism, "human")
    archs_sample <- append(archs_sample,human_source[ind])
    archs_title <-append(archs_title,  find_title(human_gse[ind]))
    archs_dataset <-append(archs_dataset, "archs4")
  }}

  
for (ind in 1:length(mouse_gse)){
  if (grepl(",", mouse_gse[ind], ignore.case=TRUE)){
    gse_list <- strsplit(mouse_gse[ind], split = ",")
    mouse_gse[ind] = gse_list[[1]]
  }
  if (!(mouse_gse[ind] %in% archs_gse)){
    archs_gse <- append(archs_gse, mouse_gse[ind])
    archs_organism <- append(archs_organism, "mouse")
    archs_sample <- append(archs_sample,mouse_source[ind])
    archs_title <-append(archs_title,  find_title(mouse_gse[ind]))
    archs_dataset <-append(archs_dataset, "archs4")
    
  }}


  
final_df <-  data.frame("repository_id"=c(recount3_genformer_df$repository_id, archs_gse),
                        "organism" = c(recount3_genformer_df$organism, archs_organism),
                        "tissue_type" = c(recount3_genformer_df$tissue_type, archs_sample),
                        "study_title" = c(recount3_genformer_df$study_title, archs_title),
                        "dataset" = c(recount3_genformer_df$dataset, archs_dataset))

write.csv(final_df,"archs4_recount3_geneformer.csv")

})
