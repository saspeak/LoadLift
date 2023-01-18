subworkflow Chainfile_creation:
    workdir:
        "/home/sspeak/projects/joint/ss_lpa_shared/passenger_pigeon/btp_CADD_scores/"
    snakefile:
        "/home/sspeak/projects/joint/ss_lpa_shared/scripts/CADD_Snakemake/Score-conversion/chainfile-creation/Chain-creation.snakefile"
    configfile:
        "/home/sspeak/projects/joint/ss_lpa_shared/scripts/CADD_Snakemake/Score-conversion/chainfile-creation/Chain-creation_config.yaml"
        

subworkflow Cross_mapping:
    workdir:
        "/home/sspeak/projects/joint/ss_lpa_shared/passenger_pigeon/btp_CADD_scores/"
    snakefile:
        "/home/sspeak/projects/joint/ss_lpa_shared/scripts/CADD_Snakemake/Score-conversion/Crossmapping/Crossmapping.snakefile"
    configfile:
        "/home/sspeak/projects/joint/ss_lpa_shared/scripts/CADD_Snakemake/Score-conversion/Crossmapping/Crossmapping_config.yaml"