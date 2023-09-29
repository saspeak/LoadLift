configfile: "{path_to_working_dir}scripts/LoadLift/5.Score-conversion/Crossmapping_config.yaml"

subject_species= config["species"]

rule all:
    input:
        "merged_chr/all_chr_1_based_"+subject_species+"CADD.bed.gz"

def get_input_chr(wildcards):
    return config["Chromosomes"][wildcards.sample]

rule split_chCADD:
    input:
        chCADD_file=config["chCADD_raw"]
    params:
        real_out="{path_to_working_dir}chCADD_raw/split_CADD/chCADD_chr'$1'.tsv"
    output:
        "{path_to_working_dir}chCADD_raw/split_CADD/chCADD_{sample}.tsv"
    shell:
        "zcat {input.chCADD_file} | awk -F '\t' '{print > ({params.real-out})}'"

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

rule Crossmap_CADD:
    input:
        config["chain_file"],
        "{path_to_working_dir}chCADD_raw/split_CADD/bed_files/chCADD_{sample}_1_based.bed"
    output:
        "crossmapped/{sample}_"+subject_species+"CADD.bed"
    log:
        "logs/crossmapping/{sample}.log"
    conda:
        "cross_mapping"
    params:
        "bed"
    shell:
        "CrossMap.py {params} {input} > {output}"

rule filter_mapped:
    input:
        "crossmapped/{sample}_"+subject_species+"CADD.bed"
    output:
        "filtered/{sample}_"+subject_species+"CADD.bed"
    params:
        "'Unmap' -v"
    shell:
        "grep {params} {input} | cut -f 8,9,10,11,12,13 > {output}"

rule convergence:
    input:
        tsvs=expand("filtered/{sample}_"+subject_species+"CADD.bed", sample=config["Chromosomes"])
    output:
        "merged_chr/all_chr_1_based_"+subject_species+"CADD.bed.gz"
    shell:
        "cat {input} | bgzip > {output} "

