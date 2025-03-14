configfile: "{path_to_working_dir}scripts/LoadLift/5.Score-conversion/Crossmapping_config.yaml"

rule all:
    input:
	"merged_chr/all_chr_{species}CADD_CADD_1_based.bed"

def get_input_chr(wildcards):
    return config["Chromosomes"][wildcards.sample]

rule split_chCADD:
    input:
	chCADD_raw=config["chCADD_raw"]
    params:
	real_out="{path_to_working_dir}chCADD_raw/split_CADD/chCADD_chr'$1'.tsv"
    output:
	"{path_to_working_dir}chCADD_raw/split_CADD/chCADD_{sample}.tsv"
    shell:
	"zcat {input.chCADD_raw} | awk -F '\t' '{print > ({params.real-out})}'"

rule tsv2bed_conversion:
    input:
	get_input_chr
    output:
	"{path_to_working_dir}chCADD_raw/split_CADD/bed_files/chCADD_{sample}_1_based.bed"
    params:
	remove_1='OFS="\t"',
        open="{",
        close="}"
    shell:
	"cat {input} | awk '{params.open} {params.remove_1}; print $1,$2-1,$2,$3,$4,$5{params.close}' > {output}"


