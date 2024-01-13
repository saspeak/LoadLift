configfile: "{path_to_LoadLift}/2.Read-mapping/bwa_alignment.config.yaml"

rule intersection_reverse:
    input:
        bed="bed_calls/{sample}_reverse/all_{species}_{sample}_reverse_orient_INDEL_rmv_or_cor.bed",
        CADD="merged_chr/all_chr_{species}CADD_1_based.bed.gz"
    output:
        "bed_calls/{sample}_reverse/intersect/all_{species}_{sample}_reverse_orient_INDEL_rmv_or_cor_intersect_CADD.bed"
    params:
        "-wa -wb"
    log:
        "logs/intersect/intersect_all_{species}_{sample}.log"
    conda:
        "bcftools_env"
    shell:
        "(bedtools intersect -a {input.CADD} -b {input.bed} {params} > {output}) 2> {log}"

rule SNP_orient_correction:
    input:
        "bed_calls/{sample}_reverse/all_{species}_{sample}_reverse_orient_INDEL_rmv.bed"
    output:
        "bed_calls/{sample}_reverse/all_{species}_{sample}_reverse_orient_INDEL_rmv_or_cor.bed"
    params:
        "-v b=6 -v e=100 -f {path_to_LoadLift}/scripts/Orient_conversion_reverse.awk"
    log:
        "logs/intersect/intersect_all_{species}_{sample}_reverse.log"
    conda:
        "bcftools_env"
    shell:
        "(awk {params} {input} > {output}) 2> {log}"

rule SNP_check_reverse:
    input:
        "bed_calls/{sample}_reverse/intersect/all_{species}_{sample}_reverse_orient_INDEL_rmv_or_cor_intersect_CADD.bed"
    output:
        "bed_calls/{sample}_reverse/intersect/all_{species}_{sample}_reverse_orient_INDEL_rmv_intersect_CADD_orient_cor_summary.bed"
    params:
        "-v b=6 -v e=100 -f {path_to_LoadLift}/scripts/SNP_check_reverse.awk"
    log:
        "logs/intersect/intersect_all_{species}_{sample}_reverse.log"
    conda:
        "bcftools_env"
    shell:
        "(awk {params} {input} > {output}) 2> {log}"

rule intersection_forward:
    input:
        bed="bed_calls/{sample}_forward/all_{species}_{sample}_forward_orient_INDEL_rmv.bed",
        CADD="merged_chr/all_chr_{species}CADD_1_based.bed.gz"
    output:
        "bed_calls/{sample}_forward/intersect/all_{species}_{sample}_forward_orient_INDEL_rmv_intersect_CADD.bed"
    params:
        "-wa -wb"
    log:
        "logs/intersect/intersect_all_{species}_{sample}_forward.log"
    conda:
        "bcftools_env"
    shell:
        "(bedtools intersect -a {input.CADD} -b {input.bed} {params} > {output}) 2> {log}"

rule SNP_check_forward:
    input:
        "bed_calls/{sample}_forward/intersect/all_{species}_{sample}_forward_orient_INDEL_rmv_intersect_CADD.bed"
    output:
        "bed_calls/{sample}_forward/intersect/all_{species}_{sample}_forward_orient_INDEL_rmv_intersect_CADD_summary.bed"
    params:
        "-v b=6 -v e=100 -f {path_to_LoadLift}/scripts/SNP_check_forward.awk"
    log:
        "logs/intersect/intersect_all_{species}_{sample}_forward.log"
    conda:
        "bcftools_env"
    shell:
        "(awk {params} {input} > {output}) 2> {log}"
