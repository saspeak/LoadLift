configfile: "{path_to_working_dir}scripts/reads-2-CADD-snakemake/2.Read-mapping/bwa_alignment.config.yaml"

species = config["species"]

rule all:
	input: 
		"bed_calls/forward/all_"+ species +"_forward_orient_INDEL_rmv.bed"
#		"bed_calls/reverse/all_"+ species +"_reverse_orient_INDEL_rmv.bed"

rule indel_rmv:
    input:
        "variant_calls/{sample}/all_{species}_{sample}_orient.bcf"
    output:
        "variant_calls/{sample}/all_{species}_{sample}_orient_snps_only.recode.vcf"
    params:
        flags = "--remove-indels --recode --recode-INFO-all",
        real_out = "variant_calls/{sample}/all_{species}_{sample}_orient_snps_only"
    log:
        "logs/INDEL_rmv/mark_all_{species}_{sample}log"
    conda:
        "bcftools_env"
    shell:
        "(vcftools --bcf {input} {params.flags} --out {params.real_out}) 2> {log}"

rule format_conversion:
    input:
        "variant_calls/{sample}/all_{species}_{sample}_orient_snps_only.recode.vcf"
    output:
        "bed_calls/{sample}/all_{species}_{sample}_orient.bed"
    params:
        "-O v"
    log:
        "logs/bed_con/all_{species}_{sample}log"
    conda:
        "bcftools_env"
    shell:
        "(vcf2bed < {input} > {output}) 2> {log}"

rule filter_indel:
    input:
        "bed_calls/{sample}/all_{species}_{sample}_orient.bed"
    output:
        "bed_calls/{sample}/all_{species}_{sample}_orient_INDEL_rmv.bed"
    params:
        "-v 'INDEL'"
    log:
        "logs/INDEL_rmv/all_{species}_{sample}.log"
    conda:
        "bcftools_env"
    shell:
        "(grep {params} {input} > {output}) 2> {log}"

