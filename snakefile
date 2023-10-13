subworkflow UCE:
    workdir:
        "{sample}/"
    snakefile:
        "LoadLift/1.Phyluce/Phyluce.snakefile"

subworkflow Read_mapping:
    workdir:
        "{sample}/"
    snakefile:
        "LoadLift/2.Read-mapping/bwa-new-readmapping.snakefile"

subworkflow Chain_creation:
    workdir:
        "{sample}/chain_file_creation/"
    snakefile:
        "LoadLift/4.Chainfile-creation/4.Chain-creation.snakefile"

subworkflow Score_conversion:
    workdir:
        "{sample}"
    snakefile:
        "LoadLift/5.Score-conversion/Crossmapping.snakefile"

subworkflow Format_conversion:
    workdir:
        "{sample}/"
    snakefile:
        "LoadLift/6.Score-intersect/format-conversion.snakefile"

subworkflow Score_intersect:
    workdir:
        "{sample}/"
    snakefile:
        "LoadLift/6.Score-intersect/Score-intersect.snakefile"