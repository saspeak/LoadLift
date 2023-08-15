subworkflow Phyluce:
    workdir:
        "/home/sspeak/projects/joint/ss_lpa_shared/passenger_pigeon/UCE_outputs/"
    snakefile:
        "/home/sspeak/projects/joint/ss_lpa_shared/scripts/reads-2-CADD-snakemake/Variant-calling/1.Phyluce/snakfile"
    configfile:
        "/home/sspeak/projects/joint/ss_lpa_shared/scripts/reads-2-CADD-snakemake/Variant-calling/1.Phyluce/UCE-config.yaml"
        

subworkflow BWA_alignment:
    workdir:
        "/home/sspeak/projects/joint/ss_lpa_shared/passenger_pigeon/alignment/"
    snakefile:
        "/home/sspeak/projects/joint/ss_lpa_shared/scripts/reads-2-CADD-snakemake/Variant-calling/2.Readmapping/bwa-readmapping-snakefile"
    configfile:
        "/home/sspeak/projects/joint/ss_lpa_shared/scripts/reads-2-CADD-snakemake/Variant-calling/2.Readmapping/bwa_alignment_config.yaml"

subworkflow Score_intersect:
    workdir:
        "/home/sspeak/projects/joint/ss_lpa_shared/passenger_pigeon/alignment/"
    snakefile:
        "/home/sspeak/projects/joint/ss_lpa_shared/scripts/reads-2-CADD-snakemake/Variant-calling/4.Score-intersect/format-conversion-snakefile"
    configfile:
        "/home/sspeak/projects/joint/ss_lpa_shared/scripts/reads-2-CADD-snakemake/Variant-calling/2.Readmapping/bwa_alignment_config.yaml"
