configfile: "{path_to_LoadLift}reads-2-CADD-snakemake/Variant-calling/2.Read-mapping/bwa_alignment.config.yaml"

species = config["species"]
genome = config["ref_genome"]

individual = config["UCE_individual"]

rule all:
    input:
        "plots/plot-quals.svg"

subworkflow phyluce_workflow:
    workdir:
        "{path_to_working_dir}passenger_pigeon/"
    snakefile:
        "../1.Phyluce/snakefile"
    configfile:
        "../1.Phyluce/UCE-config.yaml"

def get_input_fastqs(wildcards):
    return config["samples"][wildcards.sample]

####### When working with illmina/ non-10X reads we need to trim them and align them separately. 
rule fastq_trimming:
    input:
        get_input_fastqs
    output:
        "trimmed_reads/{sample}_trimmed.fq.gz"
    params:
        '-M 0.05 -N 0.75 -m 0.8 -n 0.02 -X 0.25 -Z 26'
    log:
        "logs/seq_prep/{sample}.log"
    shell:
        "(SeqPrep {params} -f {input} -r {input} -1 {output} -2 2_{output}) 2> {log}"

####### Once the reads have been trimmed we can align them to the reference genome using bwa mem 

rule bwa_index: 
    input:
        genome=config["ref_genome"]
    output:
        config["ref_genome_index"]
    conda:
        "env/aligning_env.yml"
    shell:
        "bwa index {input.genome}"

rule bwa_map:
    input:
        genome=config["ref_genome"],
        index_ref=config["ref_genome_index"],
        forward="trimmed_reads/{sample}_trimmed.fq.gz"
    output:
        temp("mapped_reads/{sample}.bam")
    params:
        rg=r"@RG\tID:{sample}\tSM:{sample}"
    conda:
        "env/aligning_env.yml"
    log:
        "logs/bwa_mem/{sample}.log"
    threads: 8
    shell:
        "(bwa mem -R '{params.rg}' -t {threads} {input.genome} {input.forward} | "
        "samtools view -Sb - > {output}) 2> {log}"

##### Once we have the aligned bam files we need to do duplicate and indel removal 
##### start by sorting the bam files (again this is automatic for the 10X long ranger tool)

rule samtools_sort:
    input:
        "mapped_reads/{sample}.bam"
    output:
        protected("sorted_reads/{sample}.bam")
    conda:
        "env/aligning_env.yml"
    shell:
        "samtools sort -T sorted_reads/{wildcards.sample} "
        "-O bam {input} > {output}"

####### now we need to remove the optical duplicates

rule duplicate_removal:
    input:
        "sorted_reads/{sample}.bam"
    output:
        "/sorted_reads/duplicate_rmv/{sample}_picard_dup_removed.bam"
    log:
        "logs/dup_rmv/{sample}.log"
    params:
        "-M  mapped_reads/outs/{sample}_marked_dup_metrics.txt"
    conda:
        "env/aligning_env.yml"
    shell:
        "(picard MarkDuplicates -REMOVE_DUPLICATES true -REMOVE_SEQUENCING_DUPLICATES true -AS true -I {input} -O {output} {params}) 2> {log}"

###### Will I need the variant calling in the same pipeline or it will it work okay as a sperate snakefile?
###### there is no harm to putting it in here just won't need to run the variant calling step ......

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


######### we can now do the actual snp calling 
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
