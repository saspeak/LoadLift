#print("installing packages")

#install.packages("GenomicRanges")
#install.packages("regioneR")
#install.packages("plyr")
#install.packages("tidyverse")
#install.packages("dplyr")
#install.packages("data.table")

#### load in packages 
print("loading packages")

library(regioneR)
library(GenomicRanges)
library(plyr)
#library(ggplot2)
library(tidyverse)
library(dplyr)
library(data.table)
#library(magrittr)
#library(pivottabler)
#library(openxlsx)
#library(ggpubr)

print("loading in the data")

#setwd("{subject_species_dir}/bed_calls/R_filtering/")

#raw_subject_bed_no_UCE_info <- read.csv(file = "raw_merged_subject_INDEL_rmv_intersect_CADD_individuals.csv", header = TRUE)

#orient_cor_seperated_INFO_subject_CADD_raw <- raw_subject_bed_no_UCE_info

#orient_cor_seperated_INFO_subject_CADD_raw$Score <- as.numeric(orient_cor_seperated_INFO_subject_CADD_raw$Score)
#orient_cor_seperated_INFO_subject_CADD_raw$chCADD <- as.numeric(orient_cor_seperated_INFO_subject_CADD_raw$chCADD)
#orient_cor_seperated_INFO_subject_CADD_raw$GT <- as.character(orient_cor_seperated_INFO_subject_CADD_raw$GT)
#orient_cor_seperated_INFO_subject_CADD_raw$ch_REF <- as.character(orient_cor_seperated_INFO_subject_CADD_raw$ch_REF)
#orient_cor_seperated_INFO_subject_CADD_raw$ch_ALT <- as.character(orient_cor_seperated_INFO_subject_CADD_raw$ch_ALT)
#orient_cor_seperated_INFO_subject_CADD_raw$pp_REF <- as.character(orient_cor_seperated_INFO_subject_CADD_raw$pp_REF)
#orient_cor_seperated_INFO_subject_CADD_raw$pp_ALT <- as.character(orient_cor_seperated_INFO_subject_CADD_raw$pp_ALT)
#orient_cor_seperated_INFO_subject_CADD_raw$Type <- as.character(orient_cor_seperated_INFO_subject_CADD_raw$Type)

##### pp_REFormatting data 

#orient_cor_seperated_INFO_subject_CADD_DP <- separate(orient_cor_seperated_INFO_subject_CADD_raw, col = "DP", sep=",", into = c("DP_REF", "DP_ALT"))

#orient_cor_seperated_INFO_subject_CADD_DP$DP_REF <- as.numeric(orient_cor_seperated_INFO_subject_CADD_DP$DP_REF)

#orient_cor_seperated_INFO_subject_CADD_DP$AD <- as.numeric(orient_cor_seperated_INFO_subject_CADD_DP$AD)

#head(orient_cor_seperated_INFO_subject_CADD_DP)

#orient_cor_CADD_het_info_subject_DP_ratio_ref <- transform(orient_cor_seperated_INFO_subject_CADD_DP, Ratio_Ref = DP_REF / AD)

#head(orient_cor_CADD_het_info_subject_DP_ratio_ref)

#orient_cor_seperated_INFO_subject_CADD_DP_ratio <- transform(orient_cor_CADD_het_info_subject_DP_ratio_ref, Ratio_ALT = 1 - Ratio_Ref)

#head(orient_cor_seperated_INFO_subject_CADD_DP_ratio)

#orient_cor_seperated_INFO_subject_CADD_DP_ratio <- setDT(orient_cor_seperated_INFO_subject_CADD_DP_ratio)[GT == c("-1/-1") &
#                                                                                                                              CHROM == CHROM &
#                                                                                                                              POS == POS,
#                                                                                                                              GT :=  c("./.")]
#
#print("loaded_data made ratios and reformatted")
#orient_cor_seperated_INFO_subject_CADD_DP_ratio %>% dplyr::group_by(GT) %>% count() 
#
#orient_cor_seperated_INFO_subject_CADD_DP_ratio <- setDT(orient_cor_seperated_INFO_subject_CADD_DP_ratio)[GT == c(" 0/0"), GT := c("0/0")]
#orient_cor_seperated_INFO_subject_CADD_DP_ratio <- setDT(orient_cor_seperated_INFO_subject_CADD_DP_ratio)[GT == c(" 0/1"), GT := c("0/1")]
#orient_cor_seperated_INFO_subject_CADD_DP_ratio <- setDT(orient_cor_seperated_INFO_subject_CADD_DP_ratio)[GT == c(" 1/1"), GT := c("1/1")]
#
#######
#
###### The next section can be used to re-call the snps based on Ratio_ALT to get hetero/homozygotes the code below is for at a 5% threshold (can be edited as appropriate) #####

##### 0/0

#head(filter(orient_cor_seperated_INFO_subject_CADD_DP_ratio,GT == c("0/0"), Ratio_ALT > 0.05))

#orient_cor_seperated_INFO_subject_CADD_DP_ratio <- setDT(orient_cor_seperated_INFO_subject_CADD_DP_ratio)[GT == c("0/0") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & Ratio_ALT < args[1], GT :=  c("0/0")]
#orient_cor_seperated_INFO_subject_CADD_DP_ratio <- setDT(orient_cor_seperated_INFO_subject_CADD_DP_ratio)[GT == c("0/0") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & Ratio_ALT >= args[1] & Ratio_ALT <= uPassP_BTPer, GT :=  c("0/1")]
#orient_cor_seperated_INFO_subject_CADD_DP_ratio <- setDT(orient_cor_seperated_INFO_subject_CADD_DP_ratio)[GT == c("0/0") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & Ratio_ALT > uPassP_BTPer, GT :=  c("1/1")]

#head(filter(orient_cor_seperated_INFO_subject_CADD_DP_ratio,GT == c("0/0"), Ratio_ALT > 0.05))
##### 1/1

#print(head(filter(orient_cor_seperated_INFO_subject_CADD_DP_ratio, GT == c("1/1"), Ratio_ALT < 0.95)))

#orient_cor_seperated_INFO_subject_CADD_DP_ratio <- setDT(orient_cor_seperated_INFO_subject_CADD_DP_ratio)[GT == c("1/1") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & Ratio_ALT < args[1], GT :=  c("0/0")]
#orient_cor_seperated_INFO_subject_CADD_DP_ratio <- setDT(orient_cor_seperated_INFO_subject_CADD_DP_ratio)[GT == c("1/1") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & Ratio_ALT >= args[1]& Ratio_ALT <= uPassP_BTPer, GT :=  c("0/1")]
#orient_cor_seperated_INFO_subject_CADD_DP_ratio <- setDT(orient_cor_seperated_INFO_subject_CADD_DP_ratio)[GT == c("1/1") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & Ratio_ALT > uPassP_BTPer, GT :=  c("1/1")]

#print(head(filter(orient_cor_seperated_INFO_subject_CADD_DP_ratio, GT == c("1/1"), Ratio_ALT < 0.95)))

##### 0/1

#print(head(filter(orient_cor_seperated_INFO_subject_CADD_DP_ratio, GT == c("0/1"), Ratio_ALT > 0.95)))

#orient_cor_seperated_INFO_subject_CADD_DP_ratio <- setDT(orient_cor_seperated_INFO_subject_CADD_DP_ratio)[GT == c("0/1") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & Ratio_ALT < args[1], GT :=  c("0/0")]
#orient_cor_seperated_INFO_subject_CADD_DP_ratio <- setDT(orient_cor_seperated_INFO_subject_CADD_DP_ratio)[GT == c("0/1") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & Ratio_ALT >= args[1] & Ratio_ALT <= uPassP_BTPer, GT :=  c("0/1")]
#orient_cor_seperated_INFO_subject_CADD_DP_ratio <- setDT(orient_cor_seperated_INFO_subject_CADD_DP_ratio)[GT == c("0/1") & X.Chrom == X.Chrom & chCADD_Pos == chCADD_Pos & Ratio_ALT > uPassP_BTPer, GT :=  c("1/1")]

#print(head(filter(orient_cor_seperated_INFO_subject_CADD_DP_ratio, GT == c("0/1"), Ratio_ALT > 0.95)))

#wd <- ggplot(filter(orient_cor_seperated_INFO_subject_CADD_DP_ratio, GT == "0/1", Ratio_ALT > 0)) + geom_histogram(aes(x = Ratio_ALT)) + theme_classic()
#ww <- ggplot(filter(orient_cor_seperated_INFO_subject_CADD_DP_ratio, GT == "0/0", Ratio_ALT > 0)) + geom_histogram(aes(x = Ratio_ALT)) + theme_classic()
#dd <- ggplot(filter(orient_cor_seperated_INFO_subject_CADD_DP_ratio, GT == "1/1", Ratio_ALT > 0)) + geom_histogram(aes(x = Ratio_ALT)) + theme_classic()

###### plot out the distrobutions of this 
#main <- ggarrange(wd,ww,dd, nrow = 3,ncol = 1) 
#plot(main)
####### export the recalled snp zygosity

#setwd("{subject_species_dir}/bed_calls/R_filtering/re-called-zygosity/")
#merged_zygosity_re_call <- orient_cor_seperated_INFO_subject_CADD_DP_ratio

#write.csv(merged_zygosity_re_call,paste0("PassP_BTP_merged_zygosiyt_pre_filter.csv"), row.names = FALSE)
#####

#### now to re-Score the chCADD Scores ########
###### re Score the ppALT is chRef from 0 to the Score for 0/0 and 0/1 
#### modern

#orient_cor_seperated_INFO_subject_CADD <- setDT(orient_cor_seperated_INFO_subject_CADD_DP_ratio)[ Type == "ppALT_is_chREF" & GT == c("0/0") & CHROM == CHROM & POS == POS & pp_REF == ch_ALT, Score := chCADD]

#orient_cor_seperated_INFO_subject_CADD <- setDT(orient_cor_seperated_INFO_subject_CADD)[ Type == "ppALT_is_chREF" & GT == c("0/1") & CHROM == CHROM & POS == POS & pp_REF == ch_ALT, Score := chCADD]

#orient_cor_seperated_INFO_subject_CADD <- setDT(orient_cor_seperated_INFO_subject_CADD)[ Type == "ppALT_is_chREF" & GT == c("1/1") & CHROM == CHROM & POS == POS & pp_ALT == ch_REF, Score := 0]

##### hold fire on the SNP is pp_ALT the 0/0 don't have the correct Score as PassP_BTP pp_REF does not == the chRef 
##### modern
#orient_cor_seperated_INFO_subject_CADD <- setDT(orient_cor_seperated_INFO_subject_CADD)[ Type == "SNP_is_ALT" & GT == c("0/0") & CHROM == CHROM & POS == POS & pp_REF != ch_ALT, Score := 0 ]

#orient_cor_seperated_INFO_subject_CADD <- setDT(orient_cor_seperated_INFO_subject_CADD)[ Type == "SNP_is_ALT" & GT == c("0/0") & CHROM == CHROM & POS == POS & pp_REF == ch_ALT, Score := chCADD]

#orient_cor_seperated_INFO_subject_CADD <- setDT(orient_cor_seperated_INFO_subject_CADD)[ Type == "SNP_is_ALT" & GT == c("0/1") & CHROM == CHROM & POS == POS & pp_ALT == ch_ALT, Score := chCADD]

#orient_cor_seperated_INFO_subject_CADD <- setDT(orient_cor_seperated_INFO_subject_CADD)[ Type == "SNP_is_ALT" & GT == c("0/1") & CHROM == CHROM & POS == POS & pp_REF == ch_ALT, Score := chCADD]

#orient_cor_seperated_INFO_subject_CADD <- setDT(orient_cor_seperated_INFO_subject_CADD)[ Type == "SNP_is_ALT" & GT == c("1/1") & CHROM == CHROM & POS == POS & pp_ALT == ch_ALT, Score := chCADD]

#orient_cor_seperated_INFO_subject_CADD <- setDT(orient_cor_seperated_INFO_subject_CADD)[ Type == "SNP_is_ALT" & GT == c("1/1") & CHROM == CHROM & POS == POS & pp_ALT != ch_ALT, Score := 0]

###### SNP not match data contains the 0/0 Scores for the above 
## modern
#orient_cor_seperated_INFO_subject_CADD <- setDT(orient_cor_seperated_INFO_subject_CADD)[ Type == "SNP_not_match" & GT == c("0/0") & CHROM == CHROM & POS == POS & pp_REF == ch_ALT, Score := chCADD]

#orient_cor_seperated_INFO_subject_CADD <- setDT(orient_cor_seperated_INFO_subject_CADD)[ Type == "SNP_not_match" & GT == c("0/1") & CHROM == CHROM & POS == POS & pp_REF == ch_ALT, Score := chCADD]

#### SNP is the pp_ALTernate allele but the PassP_BTP pp_REFernce is the pp_REFerence allele 
##### modern
#orient_cor_seperated_INFO_subject_CADD <- setDT(orient_cor_seperated_INFO_subject_CADD)[ GT == c("0/0") & Type == c("SNP_is_ALT_pp=ref") & CHROM == CHROM & POS == POS & pp_REF == ch_REF, Score := 0]

#orient_cor_seperated_INFO_subject_CADD <- setDT(orient_cor_seperated_INFO_subject_CADD)[ GT == c("0/1") & Type == c("SNP_is_ALT_pp=ref") & CHROM == CHROM & POS == POS & pp_REF == ch_REF & pp_ALT == ch_ALT, Score := chCADD]

#orient_cor_seperated_INFO_subject_CADD <- setDT(orient_cor_seperated_INFO_subject_CADD)[ GT == c("1/1") & Type == c("SNP_is_ALT_pp=ref") & CHROM == CHROM & POS == POS & pp_ALT == ch_ALT, Score := chCADD]

#setwd("{subject_species_dir}/bed_calls/R_filtering/re-called-zygosity/")

#write.csv(orient_cor_seperated_INFO_subject_CADD,paste0("orient_converted_subject_CADD_re-Scored.csv"), row.names = FALSE)

#print("finished re-scoring")

#### fill all Na's with 0 for addittion step #
setwd("{subject_species_dir}/bed_calls/R_filtering/re-called-zygosity/")

#orient_cor_seperated_INFO_subject_CADD <- orient_cor_seperated_INFO_subject_CADD %>% mutate(Score,replace(., is.na(.), 0))

#write.csv(orient_cor_seperated_INFO_subject_CADD,paste0("orient_converted_subject_CADD_re-Scored.csv"), row.names = FALSE)

##### remove any duplicated rows #####

#orient_cor_seperated_INFO_subject_CADD_dup_rmv <- orient_cor_seperated_INFO_subject_CADD %>% distinct()

#write.csv(orient_cor_seperated_INFO_subject_CADD_dup_rmv, paste0("orient_converted_subject_CADD_dup_rmv_pre_merge.csv"),row.names = FALSE)

orient_cor_seperated_INFO_subject_CADD_dup_rmv <- read.csv(file = "orient_converted_subject_CADD_dup_rmv_pre_merge.csv", header = TRUE)

print("read in duplicate rmv file")
#print("removed duplicated lines")

###### now group the columns together so heterozygote Scores should add together ######

orient_cor_seperated_INFO_subject_CADD_dup_rmv_load <- orient_cor_seperated_INFO_subject_CADD_dup_rmv 
orient_cor_seperated_INFO_subject_CADD_dup_rmv_load <- 
  setDT(orient_cor_seperated_INFO_subject_CADD_dup_rmv_load)[GT == c("0/1"), RL := 0.1*Score]
orient_cor_seperated_INFO_subject_CADD_dup_rmv_load <- 
  setDT(orient_cor_seperated_INFO_subject_CADD_dup_rmv_load)[GT == c("0/0"), RL := Score]
orient_cor_seperated_INFO_subject_CADD_dup_rmv_load <- 
  setDT(orient_cor_seperated_INFO_subject_CADD_dup_rmv_load)[GT == c("1/1"), RL := Score]
orient_cor_seperated_INFO_subject_CADD_dup_rmv_load <- 
  setDT(orient_cor_seperated_INFO_subject_CADD_dup_rmv_load)[GT == c("0/1"), ML := 0.9*Score]
orient_cor_seperated_INFO_subject_CADD_dup_rmv_load <- 
  setDT(orient_cor_seperated_INFO_subject_CADD_dup_rmv_load)[GT == c("0/0"), ML := 0]
orient_cor_seperated_INFO_subject_CADD_dup_rmv_load <- 
  setDT(orient_cor_seperated_INFO_subject_CADD_dup_rmv_load)[GT == c("1/1"), ML := 0]

orient_cor_seperated_INFO_subject_CADD_dup_rmv_load <- 
  setDT(orient_cor_seperated_INFO_subject_CADD_dup_rmv_load)[GT == c("0/1"), GL := RL + ML]
orient_cor_seperated_INFO_subject_CADD_dup_rmv_load <- 
  setDT(orient_cor_seperated_INFO_subject_CADD_dup_rmv_load)[GT == c("0/0"), GL := RL + ML]
orient_cor_seperated_INFO_subject_CADD_dup_rmv_load <- 
  setDT(orient_cor_seperated_INFO_subject_CADD_dup_rmv_load)[GT == c("1/1"), GL := RL + ML]

orient_cor_seperated_INFO_subject_CADD_test_added_Scores <- orient_cor_seperated_INFO_subject_CADD_dup_rmv_load %>% 
  group_by(CHROM,POS,POS.1,ID,GT,ch_REF,pp_ALT,pp_REF,AD,Ratio_ALT,Ratio_Ref) %>% 
  summarise(Score = sum(Score), RL_sum=sum(RL),ML_sum=sum(ML),GL_sum=sum(GL))

write.csv(orient_cor_seperated_INFO_subject_CADD_test_added_Scores,paste0("orient_converted_subject_CADD_Scores_added.csv"), row.names = FALSE)

print("merged to add Scores togther")

##### visulising the data

head(orient_cor_seperated_INFO_subject_CADD_dup_rmv)

###### should have added together the values merging the rows

orient_cor_CADD_het_info_PassP_BTP <- setDT(orient_cor_seperated_INFO_subject_CADD_test_added_Scores)[CHROM == CHROM & POS == POS & AD < 5, GT := c("./.")]

orient_cor_CADD_het_info_PassP_BTP <- filter(orient_cor_CADD_het_info_PassP_BTP, GT != c("./."))

#### orient_cor_CADD_het_info_PassP_BTP <-  filter(orient_cor_CADD_het_info_PassP_BTP, Score > 0)

print("finished filtereing quick check")

print(head(filter(orient_cor_CADD_het_info_PassP_BTP, GT == c(" 0/0"))))

#### write out the csv

setwd("{subject_species_dir}/bed_calls/R_filtering/re-called-zygosity/")

write.csv(orient_cor_CADD_het_info_PassP_BTP,paste0("orient_converted_subject_CADD_post_filtering.csv"), row.names = FALSE)

#orient_cor_CADD_het_info_PassP_BTP <- read.csv("orient_converted_subject_CADD_post_filtering.csv")

#write.csv(orient_cor_seperated_INFO_subject_CADD_dup_rmv, paste0("orient_converted_subject_CADD_dup_rmv_pre_merge.csv"),row.names = FALSE)

