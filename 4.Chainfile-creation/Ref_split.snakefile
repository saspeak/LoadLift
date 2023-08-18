configfile: "Chain_file_creation_config_seqs.yaml"

rule all:
    input:
        "{sample}/chain_file_creation/galGal6To{sample}.over.chain.gz"

def get_input_chr(wildcards):
    return config["Chromosomes"][wildcards.sample]

rule two_bit_chicken:
    input:
    	GalGal_ref=config["chicken_ref"]
    output:
        "{sample}/chain_file_creation/bGalGal/bGalGal.2bit"
    shell:
        "faToTwoBit {input.GalGal_ref} {output}"

rule two_bit_species:
    input:
        species_ref=config["species_ref"]
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/b{sample}/b{sample}.2bit"
    shell:
    	"faToTwoBit {input.species_ref} {output}"

rule split_chicken:
    input:
        GalGal_ref=config["chicken_ref"]
    params:
        "byname"
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/faSplit/bGalGal/"
    shell:
        "faSplit {params} {input.GalGal_ref} {output}"

rule split_species:
    input:
        species_ref=config["species_ref"]
    params:
        "byname"
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/faSplit/b{sample}"
    shell:
        "faSplit {params} {input.species_ref} {output}"

