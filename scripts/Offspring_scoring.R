######## load in packages ######
library(GGally)
library(corrplot)
library(plyr)
library(ggplot2)
library(ggpubr)
library(tidyverse)
library(dplyr)
library(data.table)
library(ggpattern)
library(ggVennDiagram)
library(arsenal)
library(ggpubr)
library(cowplot)
library(see)
library(reshape)
library(rlang)

####### Loading in filtered CADD data ######
setwd("/CADD_orient_bed/csv_in/Scores_out/INDEL_rmv/")

orient_cor_CADD_het_info <- read.csv("orient_converted_pp_CADD_post_filtering_0.175.csv")

##### if PP_ALT == "." it cant be anything other than "0/0" I need to either re do all the scoring or I jsut filter them all out as something is wrong 

##### filter out the odd cases as it is safer than re scoring at this point 

hets_orient_cor_CADD_het_info <- orient_cor_CADD_het_info %>% filter(GT == c("0/1") & PP_ALT != c(".")) 

homo_orient_cor_CADD_het_info <- orient_cor_CADD_het_info %>% filter(GT != c("0/1"))

het_and_homo_orient_cor_CADD_het_info <- rbind(homo_orient_cor_CADD_het_info,hets_orient_cor_CADD_het_info)

##### scoring homozygotes as double ####
orient_cor_CADD_het_info_double_homo <- het_and_homo_orient_cor_CADD_het_info

orient_cor_CADD_het_info_double_homo <- setDT(orient_cor_CADD_het_info_double_homo)[ GT == c("0/0") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos, Score := Score * 2]
orient_cor_CADD_het_info_double_homo <- setDT(orient_cor_CADD_het_info_double_homo)[ GT == c("1/1") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos, Score := Score * 2]
orient_cor_CADD_het_info_double_homo <- setDT(orient_cor_CADD_het_info_double_homo)[ GT == c("0/1") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos, Score := Score ]

##### add in collumn that tells you how many differences from the chicken that allele means ######

orient_cor_CADD_het_info_double_homo[,"chicken_dif"] <- paste0("0")

orient_cor_CADD_het_info_double_homo <- setDT(orient_cor_CADD_het_info_double_homo)[ GT == c("0/0") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & PP_REF == GAL_Ref, chicken_dif := 0]
orient_cor_CADD_het_info_double_homo <- setDT(orient_cor_CADD_het_info_double_homo)[ GT == c("0/0") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & PP_REF != GAL_Ref, chicken_dif := c("2_H0")]
orient_cor_CADD_het_info_double_homo <- setDT(orient_cor_CADD_het_info_double_homo)[ GT == c("1/1") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & PP_ALT == GAL_Ref, chicken_dif := 0]
orient_cor_CADD_het_info_double_homo <- setDT(orient_cor_CADD_het_info_double_homo)[ GT == c("1/1") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & PP_ALT != GAL_Ref, chicken_dif := c("2_HO")]
orient_cor_CADD_het_info_double_homo <- setDT(orient_cor_CADD_het_info_double_homo)[ GT == c("0/1") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & PP_REF == GAL_Ref & PP_ALT != GAL_Ref, chicken_dif := 1]
orient_cor_CADD_het_info_double_homo <- setDT(orient_cor_CADD_het_info_double_homo)[ GT == c("0/1") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & PP_REF != GAL_Ref & PP_ALT == GAL_Ref, chicken_dif := 1]
orient_cor_CADD_het_info_double_homo <- setDT(orient_cor_CADD_het_info_double_homo)[ GT == c("0/1") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & PP_REF != GAL_Ref & PP_ALT != GAL_Ref, chicken_dif := c("2_HE")]

orient_cor_CADD_het_info_double_homo[,"chicken_dif_numeric"] <- paste0("0")

orient_cor_CADD_het_info_double_homo <- setDT(orient_cor_CADD_het_info_double_homo)[ GT == c("0/0") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & PP_REF == GAL_Ref, chicken_dif_numeric := 0]
orient_cor_CADD_het_info_double_homo <- setDT(orient_cor_CADD_het_info_double_homo)[ GT == c("0/0") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & PP_REF != GAL_Ref, chicken_dif_numeric := 2]
orient_cor_CADD_het_info_double_homo <- setDT(orient_cor_CADD_het_info_double_homo)[ GT == c("1/1") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & PP_ALT == GAL_Ref, chicken_dif_numeric := 0]
orient_cor_CADD_het_info_double_homo <- setDT(orient_cor_CADD_het_info_double_homo)[ GT == c("1/1") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & PP_ALT != GAL_Ref, chicken_dif_numeric := 2]
orient_cor_CADD_het_info_double_homo <- setDT(orient_cor_CADD_het_info_double_homo)[ GT == c("0/1") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & PP_REF == GAL_Ref & PP_ALT != GAL_Ref, chicken_dif_numeric := 1]
orient_cor_CADD_het_info_double_homo <- setDT(orient_cor_CADD_het_info_double_homo)[ GT == c("0/1") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & PP_REF != GAL_Ref & PP_ALT == GAL_Ref, chicken_dif_numeric := 1]
orient_cor_CADD_het_info_double_homo <- setDT(orient_cor_CADD_het_info_double_homo)[ GT == c("0/1") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & PP_REF != GAL_Ref & PP_ALT != GAL_Ref, chicken_dif_numeric := 2]

setwd("/CADD_orient_bed/csv_in/Scores_out/")

write.csv(orient_cor_CADD_het_info_double_homo, "orient_converted_pp_CADD_post_filtering_double_homozygosity+chicken_dif_0.175.csv", row.names = FALSE)

########################################
########## Offspring Load #############
########################################

########## once the CADD scores have been filtered and checked and scores added we can proceed with the offspring calculations 

orient_cor_CADD_het_info_double_homo_raw <- orient_cor_CADD_het_info_double_homo

#### select the key columns that we need and merge into Score_GT and Chrom_pos

selectkey_columns <- select(orient_cor_CADD_het_info_double_homo_raw, ID, UCE_ID,X.Chrom,chCADD_Pos,GAL_Ref,PP_REF,PP_ALT,Score,GT,chicken_dif_numeric)

create_ID_GT <- mutate(selectkey_columns, Score_GT = paste0(selectkey_columns$Score,":",selectkey_columns$GT,":",selectkey_columns$chicken_dif_numeric), Chrom_pos =  paste0(selectkey_columns$UCE_ID,":",selectkey_columns$X.Chrom,":",selectkey_columns$chCADD_Pos,":",selectkey_columns$GAL_Ref,":",selectkey_columns$PP_REF,":",selectkey_columns$PP_ALT))

#### remove the merged columns components
create_ID_GT$chicken_dif_numeric <- NULL
create_ID_GT$Score <- NULL
create_ID_GT$GT <- NULL
create_ID_GT$X.Chrom <- NULL
create_ID_GT$chCADD_Pos <- NULL
create_ID_GT$PP_ALT <- NULL
create_ID_GT$PP_REF <- NULL
create_ID_GT$GAL_Ref<- NULL

##### remove duplicated lines
create_ID_GT_dup_rmv <-  create_ID_GT %>% distinct() 

#### filter before spreading the df 
filtered_spread_the_df <- create_ID_GT_dup_rmv %>% group_by(UCE_ID,Chrom_pos,Score_GT) %>% filter(n() < 6)
filtered_spread_the_df$Score_GT <- as.numeric(filtered_spread_the_df$Score_GT),

spread_the_df <- tidyr::spread(filtered_spread_the_df, ID, Score_GT)


##### calculating offspring scores #######

pb = txtProgressBar(min = 0, max = length((ncol(spread_the_df)*ncol(spread_the_df))), initial = 0) 
stepi = 0 
combind <- data.frame()
self_mating <- data.frame()

for(i in 3:ncol(spread_the_df)){
  for(a in 3:ncol(spread_the_df)){
    if(a != i){ 
      print("different individuals")
      
      temp <- data.frame(spread_the_df[,2],spread_the_df[,i],spread_the_df[,a])
      
      colnames(temp) <- c("Site",colnames(spread_the_df)[i],colnames(spread_the_df)[a])
      
      split_df  <- separate(temp, col= c(paste0(colnames(spread_the_df)[i])), sep= ":", into = c("Indi_1_Score", "Indi_1_GT","Indi_1_DA"))
      
      temp <- split_df
      
      split_df  <- separate(temp, col= c(paste0(colnames(spread_the_df)[a])), sep= ":", into = c("Indi_2_Score", "Indi_2_GT","Indi_2_DA"))
      
      temp <- split_df
      
      ##### attempting to do the matrix within the loop as files too large for excel##
      
      temp <- mutate(temp, Homo_ww_CADD = paste("-"), Hetero_wd_CADD = paste("-"), Homo_dd_CADD = paste("-"), w_1 = paste("-"), w_2 = paste("-"), d_1 = paste("-"), d_2 = paste("-"), "w/w" = paste("-"), "w/d" = paste("-"), "d/d" = paste("-"), Homo_load = paste("-"), Hetero_load = paste("-"))
      
      ####
      temp$Indi_1_Score <- as.numeric(temp$Indi_1_Score)
      temp$Indi_2_Score <- as.numeric(temp$Indi_2_Score)
      
      #### define the homo w/w score
      ## simple ones 
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/0") & Indi_1_DA == c(2), Homo_ww_CADD := Indi_1_Score]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/0"), Homo_ww_CADD := Indi_2_Score]
      temp_w <- setDT(temp)[ Indi_1_GT == c("1/1") & Indi_2_GT == c("0/0"), Homo_ww_CADD := Indi_2_Score]
      ### more thinking 
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("1/1") & Indi_1_DA == c(1) & Indi_2_DA == c(2), Homo_ww_CADD := 0]
      temp_w <- setDT(temp)[ Indi_1_GT == c("1/1") & Indi_2_GT == c("0/1") & Indi_1_DA == c(2) & Indi_2_DA == c(1), Homo_ww_CADD := 0]
      
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("1/1") & Indi_2_DA == c(0), Homo_ww_CADD := (Indi_1_Score)*2]
      temp_w <- setDT(temp)[ Indi_1_GT == c("1/1") & Indi_2_GT == c("0/1") & Indi_1_DA == c(0), Homo_ww_CADD := (Indi_2_Score)*2]
      
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/1") & Indi_1_DA == c(1) & Indi_2_DA == c(1), Homo_ww_CADD := 0]
      
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/1") & Indi_1_DA == c(2) & Indi_2_DA == c(2), Homo_ww_CADD := ((Indi_1_Score + Indi_2_Score)/2)]
      
      #### define the homo d/d score
      ## simple ones 
      temp_w <- setDT(temp)[ Indi_1_GT == c("1/1"), Homo_dd_CADD := Indi_1_Score]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("1/1"), Homo_dd_CADD := Indi_2_Score]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/0") & Indi_2_GT == c("1/1"), Homo_dd_CADD := Indi_2_Score]
      ### more thinking 
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/0") & Indi_2_DA == c(0), Homo_dd_CADD := (Indi_1_Score)*2]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/0") & Indi_2_DA == c(2), Homo_dd_CADD := 0]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/0") & Indi_2_GT == c("0/1") & Indi_1_DA == c(0), Homo_dd_CADD := (Indi_2_Score)*2]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/0") & Indi_2_GT == c("0/1") & Indi_1_DA == c(2), Homo_dd_CADD := 0]
      
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/1") & Indi_1_DA == c(1) & Indi_2_DA == c(1), Homo_dd_CADD := (Indi_1_Score + Indi_2_Score)]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/1") & Indi_1_DA == c(2) & Indi_2_DA == c(2), Homo_dd_CADD := ((Indi_1_Score + Indi_2_Score)/2)]
      
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/1") & Indi_1_DA == c(1) & Indi_2_DA == c(2), Homo_dd_CADD := (Indi_1_Score + Indi_2_Score)]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/1") & Indi_1_DA == c(2) & Indi_2_DA == c(1), Homo_dd_CADD := ((Indi_1_Score + Indi_2_Score)/2)]
      
      #### define the hetero score
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("1/1"), Hetero_wd_CADD := Indi_1_Score]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/0"), Hetero_wd_CADD := Indi_1_Score]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/1"), Hetero_wd_CADD := ((Indi_1_Score + Indi_2_Score)/2)]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/0") & Indi_2_GT == c("0/1"), Hetero_wd_CADD := Indi_2_Score]
      temp_w <- setDT(temp)[ Indi_1_GT == c("1/1") & Indi_2_GT == c("0/1"), Hetero_wd_CADD := Indi_2_Score]
      temp_w <- setDT(temp)[ Indi_1_GT == c("1/1") & Indi_2_GT == c("0/0"), Hetero_wd_CADD := ((Indi_1_Score + Indi_2_Score)/2)]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/0") & Indi_2_GT == c("1/1"), Hetero_wd_CADD := ((Indi_1_Score + Indi_2_Score)/2)]
      
      #### set the ratio of alleles in gameets
      ### w_1
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/0"), w_1 := 1]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1"), w_1 := 0.5]
      temp_w <- setDT(temp)[ Indi_1_GT == c("1/1"), w_1 := 0]
      
      ### w_2
      temp_w <- setDT(temp)[ Indi_2_GT == c("0/0"), w_2 := 1]
      temp_w <- setDT(temp)[ Indi_2_GT == c("0/1"), w_2 := 0.5]
      temp_w <- setDT(temp)[ Indi_2_GT == c("1/1"), w_2 := 0]
      
      ### d_1
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/0"), d_1 := 0]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1"), d_1:= 0.5]
      temp_w <- setDT(temp)[ Indi_1_GT == c("1/1"), d_1 := 1]
      
      ### d_2
      temp_w <- setDT(temp)[ Indi_2_GT == c("0/0"), d_2 := 0]
      temp_w <- setDT(temp)[ Indi_2_GT == c("0/1"), d_2 := 0.5]
      temp_w <- setDT(temp)[ Indi_2_GT == c("1/1"), d_2 := 1]
      
      ##### make sure they are numeric
      temp_w$w_1 <- as.numeric(temp_w$w_1)
      temp_w$d_1 <- as.numeric(temp_w$d_1)
      temp_w$w_2 <- as.numeric(temp_w$w_2)
      temp_w$d_2 <- as.numeric(temp_w$d_2)
      
      #### offspring genotypes
      temp_w <- temp_w[,"w/w" := w_1 * w_2]
      temp_w <- temp_w[,"w/d" := ((w_1 * d_2)+(w_2 * d_1))]
      temp_w <- temp_w[,"d/d" := d_1 * d_2]
      
      #### set all the - values as 0 
      temp_w[temp_w == "-"] <- 0
      
      temp_w$Homo_ww_CADD <- as.numeric(temp_w$Homo_ww_CADD)
      temp_w$Homo_dd_CADD <- as.numeric(temp_w$Homo_dd_CADD)
      temp_w$Hetero_wd_CADD <- as.numeric(temp_w$Hetero_wd_CADD)
      
      temp_w$`w/w` <- as.numeric(temp_w$`w/w`)
      temp_w$`w/d` <- as.numeric(temp_w$`w/d`)
      temp_w$`d/d` <- as.numeric(temp_w$`d/d`)
      
      #### calculate the loads
      temp_w <- temp_w[,Homo_load := ((Homo_ww_CADD * `w/w`) + (Homo_dd_CADD * `d/d`))]
      temp_w <- temp_w[,Hetero_load := (Hetero_wd_CADD * `w/d`)]
      
      mean(temp_w)
      
      temp <-  temp_w
      
      #print(head(filter(temp, Indi_1_GT == c("0/1") & Indi_2_GT == c("0/1"))))
      temp[,"Indi_1_ID"] <- c(paste0(colnames(spread_the_df)[i]))
      temp[,"Indi_2_ID"] <- c(paste0(colnames(spread_the_df)[a]))
      
      #### make a new df to refer to in the future 
      assign(paste0(colnames(spread_the_df)[i],"_cross_",colnames(spread_the_df)[a]), temp)
      
      ### write out the df as a csv
      setwd("/CADD_orient_bed/csv_in/Scores_out/")
      write.csv(temp,paste0(colnames(spread_the_df)[i],"_cross_",colnames(spread_the_df)[a],"_for_input.csv"))
      
      #### combine the dfs together
      df <- paste0(colnames(spread_the_df)[i],"_cross_",colnames(spread_the_df)[a])
      data <- get(df)
      combind <- rbind(data,combind)
      
      rm(temp)
      rm(temp_w)
      
    }
    else{      print("same indi")
      temp <- data.frame(spread_the_df[,2],spread_the_df[,i],spread_the_df[,a])
      
      colnames(temp) <- c("Site",colnames(spread_the_df)[i],paste0(colnames(spread_the_df)[a],"_2"))
      
      split_df  <- separate(temp, col= c(paste0(colnames(spread_the_df)[i])), sep= ":", into = c("Indi_1_Score", "Indi_1_GT","Indi_1_DA"))
      
      temp <- split_df
      
      split_df  <- separate(temp, col= c(paste0(colnames(spread_the_df)[a],"_2")), sep= ":", into = c("Indi_2_Score", "Indi_2_GT","Indi_2_DA"))
      
      temp <- split_df
      
      ##### attempting to do the matrix within the loop as files too large for excel##
      
      temp <- mutate(temp, Homo_ww_CADD = paste("-"), Hetero_wd_CADD = paste("-"), Homo_dd_CADD = paste("-"), w_1 = paste("-"), w_2 = paste("-"), d_1 = paste("-"), d_2 = paste("-"), "w/w" = paste("-"), "w/d" = paste("-"), "d/d" = paste("-"), Homo_load = paste("-"), Hetero_load = paste("-"))
      
      ####
      temp$Indi_1_Score <- as.numeric(temp$Indi_1_Score)
      temp$Indi_2_Score <- as.numeric(temp$Indi_2_Score)
      
      #### define the homo w/w score
      ## simple ones 
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/0") & Indi_1_DA == c(2), Homo_ww_CADD := Indi_1_Score]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/0"), Homo_ww_CADD := Indi_2_Score]
      temp_w <- setDT(temp)[ Indi_1_GT == c("1/1") & Indi_2_GT == c("0/0"), Homo_ww_CADD := Indi_2_Score]
      ### more thinking 
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("1/1") & Indi_1_DA == c(1) & Indi_2_DA == c(2), Homo_ww_CADD := 0]
      temp_w <- setDT(temp)[ Indi_1_GT == c("1/1") & Indi_2_GT == c("0/1") & Indi_1_DA == c(2) & Indi_2_DA == c(1), Homo_ww_CADD := 0]
      
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("1/1") & Indi_2_DA == c(0), Homo_ww_CADD := (Indi_1_Score)*2]
      temp_w <- setDT(temp)[ Indi_1_GT == c("1/1") & Indi_2_GT == c("0/1") & Indi_1_DA == c(0), Homo_ww_CADD := (Indi_2_Score)*2]
      
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/1") & Indi_1_DA == c(1) & Indi_2_DA == c(1), Homo_ww_CADD := 0]
      
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/1") & Indi_1_DA == c(2) & Indi_2_DA == c(2), Homo_ww_CADD := ((Indi_1_Score + Indi_2_Score)/2)]
      
      #### define the homo d/d score
      ## simple ones 
      temp_w <- setDT(temp)[ Indi_1_GT == c("1/1"), Homo_dd_CADD := Indi_1_Score]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("1/1"), Homo_dd_CADD := Indi_2_Score]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/0") & Indi_2_GT == c("1/1"), Homo_dd_CADD := Indi_2_Score]
      ### more thinking 
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/0") & Indi_2_DA == c(0), Homo_dd_CADD := (Indi_1_Score)*2]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/0") & Indi_1_DA == c(1) & Indi_2_DA == c(2), Homo_dd_CADD := 0]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/0") & Indi_2_GT == c("0/1") & Indi_1_DA == c(0), Homo_dd_CADD := (Indi_2_Score)*2]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/0") & Indi_2_GT == c("0/1") & Indi_2_DA == c(1) & Indi_1_DA == c(2), Homo_dd_CADD := 0]
      
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/1") & Indi_1_DA == c(1) & Indi_2_DA == c(1), Homo_dd_CADD := (Indi_1_Score + Indi_2_Score)]
      
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/1") & Indi_1_DA == c(2) & Indi_2_DA == c(2), Homo_dd_CADD := ((Indi_1_Score + Indi_2_Score)/2)]
      
      #### define the hetero score
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("1/1"), Hetero_wd_CADD := Indi_1_Score]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/0"), Hetero_wd_CADD := Indi_1_Score]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1") & Indi_2_GT == c("0/1"), Hetero_wd_CADD := ((Indi_1_Score + Indi_2_Score)/2)]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/0") & Indi_2_GT == c("0/1"), Hetero_wd_CADD := Indi_2_Score]
      temp_w <- setDT(temp)[ Indi_1_GT == c("1/1") & Indi_2_GT == c("0/1"), Hetero_wd_CADD := Indi_2_Score]
      
      #### set the ratio of alleles in gameets
      ### w_1
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/0"), w_1 := 1]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1"), w_1 := 0.5]
      temp_w <- setDT(temp)[ Indi_1_GT == c("1/1"), w_1 := 0]
      
      ### w_2
      temp_w <- setDT(temp)[ Indi_2_GT == c("0/0"), w_2 := 1]
      temp_w <- setDT(temp)[ Indi_2_GT == c("0/1"), w_2 := 0.5]
      temp_w <- setDT(temp)[ Indi_2_GT == c("1/1"), w_2 := 0]
      
      ### d_1
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/0"), d_1 := 0]
      temp_w <- setDT(temp)[ Indi_1_GT == c("0/1"), d_1:= 0.5]
      temp_w <- setDT(temp)[ Indi_1_GT == c("1/1"), d_1 := 1]
      
      ### d_2
      temp_w <- setDT(temp)[ Indi_2_GT == c("0/0"), d_2 := 0]
      temp_w <- setDT(temp)[ Indi_2_GT == c("0/1"), d_2 := 0.5]
      temp_w <- setDT(temp)[ Indi_2_GT == c("1/1"), d_2 := 1]
      
      ##### make sure they are numeric
      temp_w$w_1 <- as.numeric(temp_w$w_1)
      temp_w$d_1 <- as.numeric(temp_w$d_1)
      temp_w$w_2 <- as.numeric(temp_w$w_2)
      temp_w$d_2 <- as.numeric(temp_w$d_2)
      
      #### offspring genotypes
      temp_w <- temp_w[,"w/w" := w_1 * w_2]
      temp_w <- temp_w[,"w/d" := ((w_1 * d_2)+(w_2 * d_1))]
      temp_w <- temp_w[,"d/d" := d_1 * d_2]
      
      #### set all the - values as 0 
      temp_w[temp_w == "-"] <- 0
      
      temp_w$Homo_ww_CADD <- as.numeric(temp_w$Homo_ww_CADD)
      temp_w$Homo_dd_CADD <- as.numeric(temp_w$Homo_dd_CADD)
      temp_w$Hetero_wd_CADD <- as.numeric(temp_w$Hetero_wd_CADD)
      
      temp_w$`w/w` <- as.numeric(temp_w$`w/w`)
      temp_w$`w/d` <- as.numeric(temp_w$`w/d`)
      temp_w$`d/d` <- as.numeric(temp_w$`d/d`)
      
      #### calculate the loads
      temp_w <- temp_w[,Homo_load := ((Homo_ww_CADD * `w/w`) + (Homo_dd_CADD * `d/d`))]
      temp_w <- temp_w[,Hetero_load := (Hetero_wd_CADD * `w/d`)]
      
      mean(temp_w)
      
      temp <-  temp_w
      
      #print(head(filter(temp, Indi_1_GT == c("0/1") & Indi_2_GT == c("0/1"))))
      temp[,"Indi_1_ID"] <- c(paste0(colnames(spread_the_df)[i]))
      temp[,"Indi_2_ID"] <- c(paste0(colnames(spread_the_df)[a]))
      
      #### make a new df to refer to in the future 
      assign(paste0(colnames(spread_the_df)[i],"_cross_",colnames(spread_the_df)[a]), temp)
      
      ### write out the df as a csv
      setwd("/CADD_orient_bed/csv_in/Scores_out/")
      write.csv(temp,paste0(colnames(spread_the_df)[i],"_cross_",colnames(spread_the_df)[a],"_for_input.csv"))
      
      #### combine the dfs together
      df <- paste0(colnames(spread_the_df)[i],"_cross_",colnames(spread_the_df)[a])
      data <- get(df)
      self_mating <- rbind(data,self_mating)
      rm(temp)
      rm(temp_w)}
    
    
  }
}

###### merge those two dfs together into one combind df ####

paste0(colnames(spread_the_df)[i],"_cross_",colnames(spread_the_df)[a])

combind <- rbind(self_mating,combind)
combind_na_rmv <- combind  %>% na.omit()

############ save the data frame ######
setwd("/CADD_orient_bed/csv_in/Scores_out/")
write.csv(combind_na_rmv,"Combined_offspring_load_calculated_0.175_all_scores.csv", row.names = FALSE)

###### Extracting scores for just the UCEs #####
raw_combined_scores <- combind_na_rmv
raw_combined_scores$X <- NULL

raw_combined_scores_site_id <- raw_combined_scores %>% separate(col = Site, sep = ":", 
                                                                into = c("UCE","Scaffold_ID","Pos","Gal_Ref","PP_Ref","PP_Alt"))


UCE_no_flank <- read.delim("pink_pigeon_UCE_loci_no_flank.txt")

colnames(UCE_no_flank) <- c("UCE_Scaffold_ID","UCE","UCE_START","UCE_END")

offspring_CADD_scored_UCE_coord <- join(UCE_no_flank,raw_combined_scores_site_id)

########## saving and then re-importing #####
setwd("CADD_Offspring_Load/")

#############################################

UCE_offspring <- offspring_CADD_scored_UCE_coord %>%
  filter(between(Pos, UCE_START, UCE_END)) 

write.csv(UCE_offspring, file = "UCE_only_offspring_CADD_load.csv")
###### reading it in if we need to load #####
setwd("CADD_Offspring_Load/")
UCE_offspring <- read.csv("UCE_only_offspring_CADD_load.csv")

##########################################################################################
####### uce only scores calculated for the potential offspring of all the individuals ####
##########################################################################################

UCE_offspring %>% group_by(Scaffold_ID) %>% count()
UCE_offspring %>% count(UCE)

################
head(UCE_offspring)
'%!in%' <- function(x,y)!('%in%'(x,y))

fixed_filtered_UCE <- UCE_offspring %>% dplyr::group_by(Scaffold_ID,Pos,Gal_Ref,PP_Ref,PP_Alt) %>% filter(n() == 36) %>% ungroup %>% dplyr::group_by(Scaffold_ID,Pos,Gal_Ref,PP_Ref,PP_Alt,Homo_load,Hetero_load) %>% filter(n() < 36) %>% ungroup

fixed_filtered_UCE_hr_rmv <- subset(fixed_filtered_UCE,fixed_filtered_UCE$UCE %!in% high_rate_baddly_aligjned_UCE$UCE_ID) 


####### calculate how many UCEs have a non fixed SNP 
UCEs_with_SNP <- as.data.frame(fixed_filtered_UCE$UCE) %>% distinct() %>% as.list() 
UCEs_with_SNP <- as.data.frame(UCEs_with_SNP) 
colnames(UCEs_with_SNP) <- c("UCE")

############ Finding SNP frequency within the UCEs and Flanking Regions ########

####### read in the original files 
UCE_no_flank <- read.delim(" pink_pigeon_UCE_loci_no_flank.txt")
orient_cor_CADD_het_info_double_homo <- read.delim("orient_converted_pp_CADD_post_filtering_double_homozygosity+chicken_dif_0.175.csv")
######## Join the UCE information onto the CADD scores
orient_cor_CADD_het_info_double_homo_UCE_coord <- join(UCE_no_flank,orient_cor_CADD_het_info_double_homo)

##### filter for UCEs with SNPs
parent_sites_within_filtered_UCE <- subset(orient_cor_CADD_het_info_double_homo_UCE_coord,  orient_cor_CADD_het_info_double_homo_UCE_coord$UCE_ID %in% UCEs_with_SNP$UCE)

UCE_orient_cor_CADD_het_info_double_homo_UCE_coord <- parent_sites_within_filtered_UCE %>%
  filter(between(chCADD_Pos, UCE_START, UCE_END)) 

flank_orient_cor_CADD_het_info_double_homo_UCE_coord <- parent_sites_within_filtered_UCE %>%
  filter(!between(chCADD_Pos, UCE_START, UCE_END)) 

UCE_orient_cor_CADD_het_info_double_homo_UCE_coord <- mutate(UCE_orient_cor_CADD_het_info_double_homo_UCE_coord, "Region" = c("UCE"))
flank_orient_cor_CADD_het_info_double_homo_UCE_coord <- mutate(flank_orient_cor_CADD_het_info_double_homo_UCE_coord, "Region" = c("Flank"))

##### join together 

UCE_flank_orient_cor_CADD_het_info_double_homo_UCE_coord <- rbind(UCE_orient_cor_CADD_het_info_double_homo_UCE_coord,flank_orient_cor_CADD_het_info_double_homo_UCE_coord)

##### filter to remove any that are duplicated 

UCE_flank_orient_cor_CADD_het_info_double_homo_UCE_coord_drmv <- UCE_flank_orient_cor_CADD_het_info_double_homo_UCE_coord %>% dplyr::group_by(X.Chrom,chCADD_Pos,ID,GT,GAL_Ref,PP_ALT,PP_REF,AD ,Ratio_ALT,Ratio_Ref,Score,chicken_dif,chicken_dif_numeric) %>% distinct()

UCE_mutations <- UCE_flank_orient_cor_CADD_het_info_double_homo_UCE_coord_drmv %>% dplyr::group_by(Region,ID) %>% count(UCE_ID,ID)

UCE_mutations$Region <- as.factor(UCE_mutations$Region)

UCE_mutations_flank <- mutate(filter(UCE_mutations, Region == c("Flank")), rate = n/2000)
UCE_mutations_UCE <- mutate(filter(UCE_mutations, Region == c("UCE")), rate = n/120)

UCE_mutations_join <- rbind(UCE_mutations_UCE,UCE_mutations_flank)

####### some of these point had very high rates #######
high_rate_UCE <- filter(UCE_mutations_UCE,rate > 0.35)

high_rate_UCE_check <- high_rate_UCE$UCE_ID %>% unique()

high_rate_UCE_check <- as.data.frame(high_rate_UCE_check)
colnames(high_rate_UCE_check) <-  c("UCE_ID")

high_rate_baddly_aligjned_UCE <- subset(high_rate_UCE_check, high_rate_UCE_check$UCE_ID %in% fixed_filtered_UCE$UCE)

######## removing the high rate scores from the fixed filtered offspring scores ######
fixed_filtered_UCE_hr_rmv <- subset(fixed_filtered_UCE,fixed_filtered_UCE$UCE %!in% high_rate_baddly_aligjned_UCE$UCE_ID) 
###### saving this data frame for the rest of the analysis. 
write.csv(fixed_filtered_UCE_hr_rmv,file = c("CADD_Offspring_Load/all_6_fixed_filtered_UCE_hr_rmv.csv"), col.names = TRUE)

fixed_filtered_UCE_hr_rmv <- read.csv("CADD_Offspring_Load/all_6_fixed_filtered_UCE_hr_rmv.csv")

############ plotting the SNP rates for the flank and UCEs for Figure 1. #######
UCE_mutations_join_for_plot <- subset(UCE_mutations_join, UCE_mutations_join$UCE_ID %!in% high_rate_baddly_aligjned_UCE$UCE_ID)

UCE_Flank_Rate_comp <- ggplot(UCE_mutations_join_for_plot) + geom_violin(aes(x = Region, y = rate, fill = Region)) + scale_x_discrete(name = c("Region"))+ scale_y_continuous(name = c("SNP frequency"))+ scale_fill_discrete(name = c("Region")) + theme_pubr()

UCE_Flank_comp <- ggarrange(UCE_Flank_Score_comp,UCE_Flank_Rate_comp, labels = c("D.","E."), ncol= 2, nrow = 1, common.legend = TRUE) 
UCE_Flank_comp

UCE_mutations_join_for_stats <- UCE_mutations_join_for_plot %>% pivot_wider(names_from = Region, values_from = rate)

UCE_mutations_join_for_stats$Flank <- as.numeric(UCE_mutations_join_for_stats$Flank)
UCE_mutations_join_for_stats$UCE <- as.numeric(UCE_mutations_join_for_stats$UCE)

wilcox.test(data = UCE_mutations_join_for_plot, rate ~ Region)

################