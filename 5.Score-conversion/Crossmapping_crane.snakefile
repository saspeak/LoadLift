configfile: "/home/sspeak/projects/joint/ss_lpa_shared/scripts/reads-2-CADD-snakemake/Score-conversion/Crossmapping/Crossmapping_config.yaml"

rule all:
    input:
        "merged_chr/all_chr_GruAmeCADD_CADD_1_based.bed"

def get_input_chr(wildcards):
    return config["Chromosomes"][wildcards.sample]

rule split_chCADD:
    input:
        chCADD_raw=config["chCADD_raw"]
    params:
        real_out="/home/sspeak/projects/joint/ss_lpa_shared/chCADD_raw/split_CADD/chCADD_chr'$1'.tsv"
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/chCADD_raw/split_CADD/chCADD_{sample}.tsv"
    shell:
        "zcat {input.chCADD_raw} | awk -F '\t' '{print > ({params.real-out})}'"

rule tsv2bed_conversion:
    input:
        get_input_chr
    output:
        "bed_files/chCADD_{sample}_1_based.bed"
    params:
        remove_1='OFS="\t"',
        open="{",
        close="}"
    shell:
        "cat {input} | awk '{params.open} {params.remove_1}; print $1,$2-1,$2,$3,$4,$5{params.close}' > {output}"

rule Crossmap_CADD:
    input:
        config["chain_file"],
        "bed_files/chCADD_{sample}_1_based.bed"
    output:
        "crossmapped/{sample}_GruAmeCADD.bed"
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
        "crossmapped/{sample}_GruAmeCADD.bed"
    output:
        "filtered/{sample}_GruAmeCADD.bed"
    params:
        "'Unmap' -v"
    shell:
        "grep {params} {input} | cut -f 8,9,10,11,12,13 > {output}"

rule convergence:
    input:
        tsvs=expand("filtered/{sample}_GruAmeCADD.bed", sample=config["Chromosomes"])
    output:
        "merged_chr/all_chr_1_based_GruAmeCADD.bed.gz"
    shell:
        "cat {input} | bgzip > {output} "

