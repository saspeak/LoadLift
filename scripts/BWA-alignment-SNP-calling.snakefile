subworkflow Phyluce:
    workdir:
        "{path_to_working_dir}passenger_pigeon/UCE_outputs/"
    snakefile:
        "{path_to_working_dir}scripts/reads-2-CADD-snakemake/Variant-calling/1.Phyluce/snakfile"
    configfile:
        "{path_to_working_dir}scripts/reads-2-CADD-snakemake/Variant-calling/1.Phyluce/UCE-config.yaml"
        

subworkflow BWA_alignment:
    workdir:
        "{path_to_working_dir}passenger_pigeon/alignment/"
    snakefile:
        "{path_to_working_dir}scripts/reads-2-CADD-snakemake/Variant-calling/2.Readmapping/bwa-readmapping-snakefile"
    configfile:
        "{path_to_working_dir}scripts/reads-2-CADD-snakemake/Variant-calling/2.Readmapping/bwa_alignment_config.yaml"

subworkflow Score_intersect:
    workdir:
        "{path_to_working_dir}passenger_pigeon/alignment/"
    snakefile:
        "{path_to_working_dir}scripts/reads-2-CADD-snakemake/Variant-calling/4.Score-intersect/format-conversion-snakefile"
    configfile:
        "{path_to_working_dir}scripts/reads-2-CADD-snakemake/Variant-calling/2.Readmapping/bwa_alignment_config.yaml"
