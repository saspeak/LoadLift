configfile: "/home/sspeak/projects/joint/ss_lpa_shared/scripts/reads-2-CADD-snakemake/Score-conversion/Crossmapping/Crossmapping_config.yaml"

rule all:
    input:
        "merged_chr/all_chr_btpCADD_1_based.bed"

def get_input_chr(wildcards):
    return config["Chromosomes"][wildcards.sample]

rule split_chCADD:
    input:
        chCADD_raw=config["chCADD_raw"],
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/chCADD_raw/split_CADD/chCADD_chr'$1'.tsv"
    shell:
        "zcat {input.chCADD_raw} | awk -F '\t' '{print > ({output})}'"

rule Crossmap_CADD:
    input:
        config["chain_file"],
        get_input_chr
    output:
        "crossmapped/{sample}_btpCADD.tsv"
    log:
        "logs/crossmapping/{sample}.log"
    params:
        "bed"
    shell:
        "CrossMap.py {params} {input} {output}"

rule filter_mapped:
    input:
        "crossmapped/{sample}_btpCADD.tsv"
    output:
        "filtered/{sample}_btpCADD.tsv"
    params:
        "'Fail' -v"
    shell:
        "grep {params} {input} | cut -f 8,9,10,11,12,13 > {output}"

rule convergence:
    input:
        tsvs=expand("filtered/{sample}_btpCADD.tsv", sample=config["Chromosomes"])
    output:
        "merged_chr/all_chr_btpCADD.tsv"
    shell:
        "cat ${input} >> ${output} "

rule tsv2bed_conversion:
    input:
        "merged_chr/all_chr_btpCADD.tsv"
    output:
        "merged_chr/all_chr_btpCADD_1_based.bed"
    params:
        remove_1=config["bed_conversion"]
    shell:
        "zcat ${input} | awk {params.remove_1} | bgzip > ${output}"
