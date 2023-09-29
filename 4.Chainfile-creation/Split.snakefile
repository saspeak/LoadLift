rule two_bit_chicken:
    input:
	GalGal_ref=config["chicken_ref"]
    output:
	"{path_to_working_dir}{sample}/chain_file_creation/bGalGal/bGalGal.2bit"
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
	method="byname",
        output="{path_to_working_dir}{sample}/chain_file_creation/faSplit/bGalGal/bGalGal"
    output:
	directory("{path_to_working_dir}{sample}/chain_file_creation/faSplit/bGalGal/")
    conda:
	"chainfile_creation_env"
    shell:
	"faSplit {params.method} {input.GalGal_ref} {params.output}"

rule split_species:
    input:
	species_ref=config["species_ref"]
    params:
	method="sequence",
        output="{path_to_working_dir}{sample}/chain_file_creation/faSplit/b{sample}/b{sample}"
    output:
	directory("{path_to_working_dir}{sample}/chain_file_creation/faSplit/b{sample}/")
    conda:
	"chainfile_creation_env"
    shell:
	"faSplit {params.method} {input.species_ref} 100 {params.output}"
