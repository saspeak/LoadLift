subworkflow Phyluce:
    workdir:
        "{path_to_working_dir}passenger_pigeon/UCE_outputs/"
    snakefile:
        "{path_to_working_dir}scripts/reads-2-CADD-snakemake/Variant-calling/1.Phyluce/snakfile"
    configfile:
        "{path_to_working_dir}scripts/reads-2-CADD-snakemake/Variant-calling/1.Phyluce/UCE-config.yaml"
        

subworkflow Longranger:
    workdir:
        "{path_to_working_dir}passenger_pigeon/alignment/"
    snakefile:
        "{path_to_working_dir}scripts/reads-2-CADD-snakemake/Variant-calling/2.Readmapping/longranger-snakefile"
    configfile:
        "{path_to_working_dir}scripts/reads-2-CADD-snakemake/Variant-calling/2.Readmapping/longranger_config.yaml"

subworkflow Longranger:
    workdir:
        "{path_to_working_dir}passenger_pigeon/alignment/"
    snakefile:
        "{path_to_working_dir}scripts/reads-2-CADD-snakemake/Variant-calling/3.Variant-calling/Variant-calling-snakefile"
    configfile:
        "{path_to_working_dir}scripts/reads-2-CADD-snakemake/Variant-calling/3.Variant-calling/Variant-calling_config.yaml"

subworkflow Score_intersect:
    workdir:
        "{path_to_working_dir}passenger_pigeon/alignment/"
    snakefile:
        "{path_to_working_dir}scripts/reads-2-CADD-snakemake/Variant-calling/4.Score-intersect/4.Score-intersect-snakefile"
    configfile:
        "{path_to_working_dir}scripts/reads-2-CADD-snakemake/Variant-calling/4.Score-intersect/4.Score-intersect-config.yaml"
