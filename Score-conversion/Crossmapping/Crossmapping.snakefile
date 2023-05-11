configfile: "/home/sspeak/projects/joint/ss_lpa_shared/scripts/reads-2-CADD-snakemake/Score-conversion/Crossmapping/Crossmapping_config.yaml"

rule all:
    input:
        "merged_chr/all_chr_btpCADD_1_based.bed"

def get_input_chr(wildcards):
    return config["Chromosomes"][wildcards.sample]

rule split_chCADD:
    input:
        chCADD_raw=config["chCADD_raw"]
    params:
        real_out="/home/sspeak/projects/joint/ss_lpa_shared/chCADD_raw/split_CADD/chCADD_chr'$1'.tsv"
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/chCADD_raw/split_CADD/chCADD_chr{sample}.tsv"
    shell:
        "zcat {input.chCADD_raw} | awk -F '\t' '{print > ({params.real-out})}'"

rule Crossmap_CADD:
    input:
        config["chain_file"],
        get_input_chr
    output:
        "crossmapped/{sample}_GruAmeCADD.tsv"
    log:
        "logs/crossmapping/{sample}.log"
    conda:
        "cross_mapping"
    params:
        "bed"
    shell:
        "CrossMap.py {params} {input} {output}"

rule filter_mapped:
    input:
        "crossmapped/{sample}_GruAmeCADD.tsv"
    output:
        "filtered/{sample}_GruAmeCADD.tsv"
    params:
        "'Fail' -v"
    shell:
        "grep {params} {input} | cut -f 8,9,10,11,12,13 > {output}"

rule convergence:
    input:
        tsvs=expand("filtered/{sample}_GruAmeCADD.tsv", sample=config["Chromosomes"])
    output:
        "merged_chr/all_chr_GruAmeCADD.tsv"
    shell:
        "cat ${input} >> ${output} "

rule tsv2bed_conversion:
    input:
        "merged_chr/all_chr_GruAmeCADD.tsv"
    output:
        "merged_chr/all_chr_GruAmeCADD_1_based.bed"
    params:
        remove_1=config["bed_conversion"]
    shell:
        "zcat ${input} | awk {params.remove_1} | bgzip > ${output}"
