subworkflow Phyluce:
    workdir:
        "/home/sspeak/projects/joint/ss_lpa_shared/passenger_pigeon/UCE_outputs/"
    snakefile:
        "/home/sspeak/projects/joint/ss_lpa_shared/scripts/reads-2-CADD-snakemake/Variant-calling/1.Phyluce/snakfile"
    configfile:
        "/home/sspeak/projects/joint/ss_lpa_shared/scripts/reads-2-CADD-snakemake/Variant-calling/1.Phyluce/UCE-config.yaml"
        

subworkflow Longranger:
    workdir:
        "/home/sspeak/projects/joint/ss_lpa_shared/passenger_pigeon/alignment/"
    snakefile:
        "/home/sspeak/projects/joint/ss_lpa_shared/scripts/reads-2-CADD-snakemake/Variant-calling/2.Readmapping/longranger-snakefile"
    configfile:
        "/home/sspeak/projects/joint/ss_lpa_shared/scripts/reads-2-CADD-snakemake/Variant-calling/2.Readmapping/longranger_config.yaml"

subworkflow Longranger:
    workdir:
        "/home/sspeak/projects/joint/ss_lpa_shared/passenger_pigeon/alignment/"
    snakefile:
        "/home/sspeak/projects/joint/ss_lpa_shared/scripts/reads-2-CADD-snakemake/Variant-calling/3.Variant-calling/Variant-calling-snakefile"
    configfile:
        "/home/sspeak/projects/joint/ss_lpa_shared/scripts/reads-2-CADD-snakemake/Variant-calling/3.Variant-calling/Variant-calling_config.yaml"

subworkflow Score_intersect:
    workdir:
        "/home/sspeak/projects/joint/ss_lpa_shared/passenger_pigeon/alignment/"
    snakefile:
        "/home/sspeak/projects/joint/ss_lpa_shared/scripts/reads-2-CADD-snakemake/Variant-calling/4.Score-intersect/4.Score-intersect-snakefile"
    configfile:
        "/home/sspeak/projects/joint/ss_lpa_shared/scripts/reads-2-CADD-snakemake/Variant-calling/4.Score-intersect/4.Score-intersect-config.yaml"
