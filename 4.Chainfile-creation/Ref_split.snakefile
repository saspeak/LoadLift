configfile: "{path_to_working_dir}scripts/LoadLift/4.Chainfile-creation/Chain_file_creation_config_seqs.yaml"

species=config["species"]

rule all:
    input:
        "{path_to_working_dir}"+species+"/chain_file_creation/faSplit/b"+species+"/b"+species,
        "{path_to_working_dir}"+species+"/chain_file_creation/faSplit/bGalGal/bGalGal",
        "{path_to_working_dir}"+species+"/chain_file_creation/bGalGal/bGalGal.2bit",
        "{path_to_working_dir}"+species+"/chain_file_creation/b"+species+"/b"+species+".2bit"

def get_input_chr(wildcards):
    return config["Chromosomes"][wildcards.sample]

rule two_bit_chicken:
    input:
    	GalGal_ref=config["chicken_ref"]
    output:
        "{sample}/chain_file_creation/bGalGal/bGalGal.2bit"
    conda:
        "chainfile_creation_env"
    shell:
        "faToTwoBit {input.GalGal_ref} {output}"

rule two_bit_species:
    input:
        species_ref=config["species_ref"]
    output:
        "{path_to_working_dir}{sample}/chain_file_creation/b{sample}/b{sample}.2bit"
    conda:
        "chainfile_creation_env"
    shell:
    	"faToTwoBit {input.species_ref} {output}"

rule split_chicken:
    input:
        GalGal_ref=config["chicken_ref"]
    params:
        "byname"
    output:
        "{path_to_working_dir}{sample}/chain_file_creation/faSplit/bGalGal/bGalGal_{chromosome}.fa"
    conda:
        "chainfile_creation_env"
    shell:
        "faSplit {params} {input.GalGal_ref} {output}"

rule split_species:
    input:
        species_ref=config["species_ref"]
    params:
        "sequence"
    output:
        "{path_to_working_dir}{sample}/chain_file_creation/faSplit/b{sample}/b{sample}_{sequence}.fa"
    conda:
        "chainfile_creation_env"
    shell:
        "faSplit {params} {input.species_ref} 100 {output}"

