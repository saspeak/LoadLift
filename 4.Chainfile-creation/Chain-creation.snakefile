configfile: "Chain_file_creation_config_seqs.yaml"

rule all:
    input:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/galGal6To{sample}.over.chain.gz"

def get_input_chr(wildcards):
    return config["Chromosomes"][wildcards.sample]

rule two_bit_chicken:
    input:
    	GalGal_ref=config["chicken_ref"]
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/bGalGal/bGalGal.2bit"
    shell:
        "faToTwoBit {input.GalGal_ref} {output}"

rule two_bit_species:
    input:
        species_ref=config["species_ref"]
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/b{sample}/b{sample}.2bit"
    shell:
    	"faToTwoBit {input.species_ref} {output}"

rule split_chicken:
    input:
        GalGal_ref=config["chicken_ref"]
    params:
        "byname"
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/faSplit/bGalGal/"
    shell:
        "faSplit {params} {input.GalGal_ref} {output}"

rule split_species:
    input:
        species_ref=config["species_ref"]
    params:
        "byname"
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/faSplit/b{sample}"
    shell:
        "faSplit {params} {input.species_ref} {output}"

rule lastz_alignments:
    input:
        chicken_split= "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/faSplit/bGalGal/",
        #chr= "bGalGal_{chromosome}",
        subject_split= "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/faSplit/b{sample}/"
        #seq= "b{sample}_{sequence}"
    params:
        chr= "bGalGal_{chromosome}",
        seq= "b{sample}_{sequence}",
        flags= "--hspthresh=2200 --inner=2000 --ydrop=3400 --gappedthresh=10000 --scores=HoxD55 --chain --format=axt"
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/1.lastz/chr_{chromosome}/bgalgal_{chromosome}_{sequence}.axt"
    shell:
        "lastz {input.chicken_split}{params.chr} {input.subject_split}{params.seq} {params.flags} > {output}"

rule Chain_alignments:
    input:
        alignment= "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/1.lastz/chr_{chromosome}/bgalgal_{chromosome}_{sequence}.axt",
        ch_2bit= "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/bGalGal/bGalGal.2bit",
        species_2bit= "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/b{sample}/b{sample}.2bit"
    params:
        "-minscore=5000 -linearGap=loose"
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/2.chain/bgalgal_{chromosome}_b{sample}_{sequence}.chain"
    shell:
        "axtChain {params} {input.alignment} {input.ch_2bit} {input.species_2bit} {output}"

rule Merge_chains:
    input:
        expand("/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/2.chain/bgalgal_{chromosome}_b{sample}_{sequence}.chain",sample=config["species"],chromosome=config["chrs"],sequence=config["number"])
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/3.chain/all.chain"
    shell:
        "chainMergeSort {input} {output}"

rule Sort_chains:
    input:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/3.chain/all.chain"
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/3.chain/all.sorted.chain"
    shell:
        "chainSort {input} {output}"

rule link_galgal:
    input:
        GalGal_ref=config["chicken_ref"]
    params:
        ""
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/bGalGal/bGalGal.fa"
    shell:
        "ln {input} {output}"

rule faindex_galgal:
    input:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/bGalGal/bGalGal.fa"
    params:
	""
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/bGalGal/bGalGal.fa.fai"
    conda:
        "samtools_env"
    shell:
        "samtools faidx {input} > {output}"

rule genome_size_galgal:
    input:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/bGalGal/bGalGal.fa.fai"
    params:
	""
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/bGalGal/bGalGal.chrom.size"
    shell:
        "cut -f 1,2 {input} > {output}"

rule link_subject:
    input:
        species_ref=config["species_ref"]
    params:
	""
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/b{sample}/b{sample}.fa"
    conda:
        "samtools_env"
    shell:
        "ln {input} > {output}"

rule faindex_subject:
    input:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/b{sample}/b{sample}.fa"
    params:
	""
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/b{sample}/b{sample}.fa.fai"
    conda:
        "samtools_env"
    shell:
        "samtools faidx {input} > {output}"

rule genome_size_subject:
    input:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/b{sample}/b{sample}.fa.fai"
    params:
	""
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/b{sample}/b{sample}.chrom.size"
    shell:
        "cut -f 1,2 {input} > {output}"

rule net_chains:
    input:
        chain="/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/3.chain/all.sorted.chain",
        subject_chr="/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/b{sample}/b{sample}.chrom.size",
        galgal_chr="/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/bGalGal/bGalGal.chrom.size"
    params:
	""
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/4.net/all.net"
    shell:
        "chainNet {input.chain} {input.galgal_chr} {input.subject_chr} {output}"

rule net_Chain_Subset:
    input:
        net="/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/4.net/all.net",
        chain="/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/3.chain/all.sorted.chain"
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/galGal6To{sample}.over.chain"
    shell:
        "netChainSubset {input.net} {input.chain} {output}"

rule gzip_chain:
    input:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/galGal6To{sample}.over.chain"
    output:
        "/home/sspeak/projects/joint/ss_lpa_shared/{sample}/chain_file_creation/galGal6To{sample}.over.chain.gz"
    shell:
        "gzip {input} > {output}"
