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
####### set directory and load the CADD score files ####
args = commandArgs(trailingOnly=TRUE)

#setwd("{subject_speices_dir}/")

###### load in the data ######
#ro_subject_CADD_bed <- read.delim(args[1], header = FALSE )

#fo_subject_CADD_bed <- read.delim(args[2], header = FALSE)

#fo_subject_CADD_bed[17:22] <- NULL
#ro_subject_CADD_bed[17:22] <- NULL

#head(fo_subject_CADD_bed) 
#head(ro_subject_CADD_bed) 

#subject_CADD_bed <- rbind(ro_subject_CADD_bed,fo_subject_CADD_bed)

#### save to reload 
#print("saving data")

setwd("{subject_speices_dir}/bed_calls/")

#write.csv(file= "raw_merged_subject_INDEL_rmv_intersect_CADD.csv", subject_CADD_bed)

print("loading in saved	data") 

subject_CADD_bed <- read.csv("raw_merged_subject_INDEL_rmv_intersect_CADD.csv", header = TRUE)

#### now gather and seperate 
print(colnames(subject_CADD_bed))

subject_CADD_bed_gatered <- gather(subject_CADD_bed,key = ID, value = INFO, c("BTP2012","BTP500","BTP700","QAT021","QAT024"))

write.csv(file= "raw_merged_subject_INDEL_rmv_intersect_CADD_gathered.csv", subject_CADD_bed_gatered)

#subject_CADD_bed_gatered <- read.csv("raw_merged_subject_INDEL_rmv_intersect_CADD_gathered.csv") 

subject_CADD_bed_gatered_variants <- subject_CADD_bed_gatered %>% filter(Type != c("ppREF_is_REF")) 

write.csv(file= "raw_merged_subject_INDEL_rmv_intersect_CADD_variants_gathered.csv", subject_CADD_bed_gatered_variants)

print(c("gathered"))

#subject_CADD_bed_sep <- separate(subject_CADD_bed_gatered, col= "INFO", sep=":", into = c("GT","PL","AD","DP"))
subject_CADD_bed_sep <- separate(subject_CADD_bed_gatered_variants, col= "INFO", sep=":", into = c("GT","PL","AD","DP"))
print(c("seperated"))

write.csv(file=	"raw_merged_subject_INDEL_rmv_intersect_CADD_individuals.csv", subject_CADD_bed_sep)

#subject_CADD_bed_sep <- read.csv("raw_merged_subject_INDEL_rmv_intersect_CADD_individuals.csv", header = TRUE)

print("done")
