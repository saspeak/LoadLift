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
    shell:
        "samtools index {input}"


######### we can now do the actual snp calling 
rule bcftools_forward_call:
    input:
        fa=config["ref_genome"],
        bam=expand("/sorted_reads/duplicate_rmv/{sample}_picard_dup_removed.bam", sample=config["samples"]),
        bai=expand("/sorted_reads/duplicate_rmv/{sample}_picard_dup_removed.bam.bai", sample=config["samples"])
    output:
        forward="variant_calls/forward/all_forward_orient.vcf"
    params:
        ""
    log:
        "logs/bcftools_call/all.log"
    shell:
        "(bcftools mpileup -f {input.fa} {input.bam} | "
        "bcftools call -mv -P {params.rate} - > {output.forward}) 2> {log}"

rule bcftools_reverse_call:
    input:
        fa=config["ref_genome"],
        bam=expand("/sorted_reads/duplicate_rmv/{sample}_picard_dup_removed.bam", sample=config["samples"]),
        bai=expand("/sorted_reads/duplicate_rmv/{sample}_picard_dup_removed.bam.bai", sample=config["samples"])
    output:
        reverse="variant_calls/reverse/all_reverse_orient.vcf"
    params:
        ""
    log:
        "logs/bcftools_call/all.log"
    shell:
        "(bcftools mpileup -f {input.fa} {input.bam} | "
        "bcftools call -mv -P {params.rate} - > {output.reverse}) 2> {log}"

reverse="variant_calls/reverse/all_reverse_orient.vcf"
####### some post duplicate removal stats using a little python code in a tutorial for snakemake - can remove but is nice to see.

rule plot_quals:
    input:
        "variant_calls/forward/all_forward_orient.vcf",
        "variant_calls/reverse/all_reverse_orient.vcf"
    output:
        "plots/quals.svg"
    log:
        "logs/plot_quals/all.log"
    script:
        "scripts/plot-quals.py"

######## once you have the VCF files for the forward and reverse within the UCEs you can move onto scoring.