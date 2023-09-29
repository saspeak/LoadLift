subworkflow Chainfile_creation:
    workdir:
        "{path_to_working_dir}passenger_pigeon/btp_CADD_scores/"
    snakefile:
        "4.Chainfile-creation/Chain-creation.snakefile"
    configfile:
        "4.Chainfile-creation/Chain-creation_config.yaml"
        

subworkflow Cross_mapping:
    workdir:
        "{path_to_working_dir}passenger_pigeon/btp_CADD_scores/"
    snakefile:
        "5.Score-conversion/Crossmapping.snakefile"
    configfile:
        "5.Score-conversion/Crossmapping_config.yaml"
