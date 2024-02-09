library(tidyverse)
library(ggplot2)
library(data.table)
library(plyr)
library(dplyr)
library(regioneR)
library(GenomicRanges)

setwd("{subject_species_dir}/bed_calls/R_filtering/re-called-zygosity/")

subject_load <- read.csv("orient_converted_subject_CADD_post_filtering.csv")

subject_load

######### 

UCE_full_info <- read.delim("{subject_species_dir}/UCE_regions/niatt_arizona_UCE_regions_full_info.txt")

colnames(UCE_full_info) <-c("CHROM","start","end","UCE_ID","UCE_start","UCE_end","Orient")

print(c("overlapping ranges"))

#UCE_full_info %>% filter((end - start) < 0)

colnames(subject_load)[2] <- c("start")
colnames(subject_load)[3] <- c("end")

UCE_ranges <-makeGRangesFromDataFrame(df=UCE_full_info, seqnames.field = "CHROM", keep.extra.columns = TRUE)

subject_CADD_bed_sep_ranges <-makeGRangesFromDataFrame(df=subject_load, seqnames.field = "CHROM", keep.extra.columns = TRUE)

overlaps_raw <- overlapRegions(UCE_ranges,subject_CADD_bed_sep_ranges,Type = "any")

print(c("joining UCE data"))

UCE_info_overlaps <- full_join(UCE_full_info,overlaps_raw, by = c("CHROM" = "chr" ,"start" = "startA", "end" ="endA"))
subject_CADD_bed_UCE_info <- full_join(UCE_info_overlaps,subject_load,by = c("CHROM", "startB" ="start", "endB"= "end"))

setwd("{subject_species_dir}/bed_calls/R_filtering/re-called-zygosity/")

print("saving passenger_pigeon_CADD_bed_UCE_info")
write.csv(file = "raw_subject_CADD_bed_UCE_info.csv", subject_CADD_bed_UCE_info)

