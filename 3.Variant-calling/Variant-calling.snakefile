configfile: "bwa_alignment.config.yaml"

rule all:
    input:
        "plots/quals.svg"

####### We take the sorted and duplicate removed bam files we can do variant calling
####### first we need to index the BAMs
rule samtools_index:
    input:
        "/sorted_reads/duplicate_rmv/{sample}_picard_dup_removed.bam"
    output:
        "/sorted_reads/duplicate_rmv/{sample}_picard_dup_removed.bam.bai"
    conda:
        "env/aligning_env.yml"
    shell:
        "samtools index {input}"


######### we can now do the SNP calling 
rule bcftools_forward_call:
    input:
        fa=config["ref_genome"],
        bam=expand("/sorted_reads/duplicate_rmv/{sample}_picard_dup_removed.bam", sample=config["samples"]),
        bai=expand("/sorted_reads/duplicate_rmv/{sample}_picard_dup_removed.bam.bai", sample=config["samples"]),
        #UCE_forward=phyluce_workflow("UCE_regions/forward/UCE_forward_orient_regions.txt")
    output:
        "variant_calls/forward/all_{species}_forward_orient.bcf"
    params:
        calling="-Ou -q 10 -C 50 -a AD,DP ",
        UCE_forward_path="UCE_regions/forward/",
        individual=config["UCE_individual"],
        UCE_file="_UCE_forward_orient_regions.txt"
    threads: 4
    log:
        "logs/bcftools_call/all_{species}_forward.log"
    conda:
        "envs/bcftools_env.yaml"
    shell:
        "(bcftools mpileup --threads {threads} {params.calling} -f {params.UCE_forward_path}{params.individual}{params.UCE_file} {input.bam} | "
        #"(bcftools mpileup --threads {threads} {params} -f {input.UCE_forward} {input.bam} | "
        "bcftools call --threads {threads} -c -Ob > {output}) 2> {log}"

rule bcftools_reverse_call:
    input:
        fa=config["ref_genome"],
        bam=expand("/sorted_reads/duplicate_rmv/{sample}_picard_dup_removed.bam", sample=config["samples"]),
        bai=expand("/sorted_reads/duplicate_rmv/{sample}_picard_dup_removed.bam.bai", sample=config["samples"]),
        #UCE_reverse = phyluce_workflow("UCE_regions/reverse/UCE_reverse_orient_regions.txt")
    output:
        "variant_calls/reverse/all_{species}_reverse_orient.bcf"
    params:
        calling="-Ou -q 10 -C 50 -a AD,DP ",
        UCE_reverse_path="UCE_regions/reverse/",
        individual=config["UCE_individual"],
        UCE_file="_UCE_reverse_orient_regions.txt"
    threads: 4
    log:
        "logs/bcftools_call/all_{species}_reverse.log"
    conda:
        "envs/bcftools_env.yaml"
    shell:
        #"(bcftools mpileup --threads {threads} {params} -f {input.UCE_reverse} {input.bam} | "
        "(bcftools mpileup --threads {threads} {params.calling} -f {params.UCE_reverse_path}{params.individual}{params.UCE_file} {input.bam} | "
        "bcftools call --threads {threads} -c -Ob > {output}) 2> {log}"

####### some post duplicate removal stats using a little python code in a tutorial for snakemake - can remove but is nice to see.

rule plot_quals:
    input:
        "variant_calls/forward/all_{species}_forward_orient.bcf",
        "variant_calls/reverse/all_{species}_reverse_orient.bcf"
    output:
        "plots/quals.svg"
    log:
        "logs/plot_quals/all.log"
    script:
        "scripts/plot-quals.py"


######## once you have the VCF files for the forward and reverse within the UCEs you can move onto scoring.
