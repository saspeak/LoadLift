configfile: "{path_to_working_dir}scripts/LoadLift/4.Chainfile-creation/Chain_file_creation_config_seqs.yaml"

species=config["species"]

rule all:
    input:
        "{path_to_working_dir}"+species+"/chain_file_creation/galGal6To"+species+".over.chain.gz"

rule split_refs:
    input:
        "{path_to_working_dir}"+species+"/chain_file_creation/faSplit/b"+species+"/b"+species+"_099.fa",
        "{path_to_working_dir}"+species+"/chain_file_creation/faSplit/bGalGal/32.fa"
    output:
        "split_references_"+species


def get_input_chr(wildcards):
    return config["Chromosomes"][wildcards.sample]

rule two_bit_chicken:
    input:
        GalGal_ref=config["chicken_ref"]
    output:
        "{sample}/chain_file_creation/bGalGal/bGalGal.2bit"
    conda:
        "chainfile_creation_env"
    shell:
        "faToTwoBit {input.GalGal_ref} {output}"

rule two_bit_species:
    input:
        species_ref=config["species_ref"]
    output:
        "{path_to_working_dir}{sample}/chain_file_creation/b{sample}/b{sample}.2bit"
    conda:
        "chainfile_creation_env"
    shell:
        "faToTwoBit {input.species_ref} {output}"

rule split_chicken:
    input:
        GalGal_ref=config["chicken_ref"]
    params:
        method="byname",
        true_output="{path_to_working_dir}{sample}/chain_file_creation/faSplit/bGalGal/"
    output:
        "{path_to_working_dir}{sample}/chain_file_creation/faSplit/bGalGal/{chromosome}.fa"
    conda:
        "chainfile_creation_env"
    shell:
        "faSplit {params.method} {input.GalGal_ref} {params.true_output}"

rule split_species:
    input:
        species_ref=config["species_ref"]
    params:
        method="sequence",
        true_output="{path_to_working_dir}{sample}/chain_file_creation/faSplit/b{sample}/b{sample}_"
    output:
        "{path_to_working_dir}{sample}/chain_file_creation/faSplit/b{sample}/b{sample}_{sequence}.fa"
    conda:
        "chainfile_creation_env"
    shell:
        "faSplit {params.method} {input.species_ref} 100 {params.true_output}"

rule lastz_alignments:
    input:
        chicken_split= "{path_to_working_dir}{sample}/chain_file_creation/faSplit/bGalGal/{chromosome}.fa",
        #chr= "bGalGal_{chromosome}",
        subject_split= "{path_to_working_dir}{sample}/chain_file_creation/faSplit/b{sample}/b{sample}_{sequence}.fa"
        #seq= "b{sample}_{sequence}"
    params:
        chr= "/bGalGal_{chromosome}",
        seq= "/b{sample}_{sequence}",
        flags= "--hspthresh=2200 --inner=2000 --ydrop=3400 --gappedthresh=10000 --scores={path_to_working_dir}scripts/LoadLift/utilities/HoxD55 --chain --format=axt"
    output:
        "{path_to_working_dir}{sample}/chain_file_creation/1.lastz/chr_{chromosome}/bgalgal_{chromosome}_b{sample}_{sequence}.axt"
    conda:
        "chainfile_creation_env"
    shell:
        "lastz {input.chicken_split} {input.subject_split} {params.flags} > {output}"

rule Chain_alignments:
    input:
        alignment= "{path_to_working_dir}{sample}/chain_file_creation/1.lastz/chr_{chromosome}/bgalgal_{chromosome}_b{sample}_{sequence}.axt",
        ch_2bit= "{path_to_working_dir}{sample}/chain_file_creation/bGalGal/bGalGal.2bit",
        species_2bit= "{path_to_working_dir}{sample}/chain_file_creation/b{sample}/b{sample}.2bit"
    params:
        "-minscore=5000 -linearGap=loose"
    output:
        "{path_to_working_dir}{sample}/chain_file_creation/2.chain/bgalgal_{chromosome}_b{sample}_{sequence}.chain"
    conda:
        "chainfile_creation_env"
    shell:
        "axtChain {params} {input.alignment} {input.ch_2bit} {input.species_2bit} {output}"

rule Merge_chains:
    input:
        expand("{path_to_working_dir}{sample}/chain_file_creation/2.chain/bgalgal_{chromosome}_b{sample}_{sequence}.chain",sample=config["species"],chromosome=config["chrs"],sequence=config["number"])
    output:
        "{path_to_working_dir}{sample}/chain_file_creation/3.chain/all.chain"
    conda:
        "chainfile_creation_env"
    shell:
        "chainMergeSort {input} > {output}"

rule Sort_chains:
    input:
        "{path_to_working_dir}{sample}/chain_file_creation/3.chain/all.chain"
    output:
        "{path_to_working_dir}{sample}/chain_file_creation/3.chain/all.sorted.chain"
    conda:
        "chainfile_creation_env"
    shell:
        "chainSort {input} {output}"

rule link_galgal:
    input:
        GalGal_ref=config["chicken_ref"]
    params:
        ""
    output:
        "{path_to_working_dir}{sample}/chain_file_creation/bGalGal/bGalGal.fa"
    conda:
        "chainfile_creation_env"
    shell:
        "ln -s {input} {output}"

rule faindex_galgal:
    input:
        "{path_to_working_dir}{sample}/chain_file_creation/bGalGal/bGalGal.fa"
    params:
	""
    output:
        "{path_to_working_dir}{sample}/chain_file_creation/bGalGal/bGalGal.fa.fai"
    conda:
        "samtools_env"
    shell:
        "samtools faidx {input} > {output}"

rule genome_size_galgal:
    input:
        "{path_to_working_dir}{sample}/chain_file_creation/bGalGal/bGalGal.fa.fai"
    params:
	""
    output:
        "{path_to_working_dir}{sample}/chain_file_creation/bGalGal/bGalGal.chrom.size"
    conda:
        "chainfile_creation_env"
    shell:
        "cut -f 1,2 {input} > {output}"

rule link_subject:
    input:
        species_ref=config["species_ref"]
    params:
	""
    output:
        "{path_to_working_dir}{sample}/chain_file_creation/b{sample}/b{sample}.fa"
    conda:
        "samtools_env"
    shell:
        "ln -s {input} {output}"

rule faindex_subject:
    input:
        "{path_to_working_dir}{sample}/chain_file_creation/b{sample}/b{sample}.fa"
    params:
	""
    output:
        "{path_to_working_dir}{sample}/chain_file_creation/b{sample}/b{sample}.fa.fai"
    conda:
        "samtools_env"
    shell:
        "samtools faidx {input} > {output}"

rule genome_size_subject:
    input:
        "{path_to_working_dir}{sample}/chain_file_creation/b{sample}/b{sample}.fa.fai"
    params:
	""
    output:
        "{path_to_working_dir}{sample}/chain_file_creation/b{sample}/b{sample}.chrom.size"
    shell:
        "cut -f 1,2 {input} > {output}"

rule net_chains:
    input:
        chain="{path_to_working_dir}{sample}/chain_file_creation/3.chain/all.sorted.chain",
        subject_chr="{path_to_working_dir}{sample}/chain_file_creation/b{sample}/b{sample}.chrom.size",
        galgal_chr="{path_to_working_dir}{sample}/chain_file_creation/bGalGal/bGalGal.chrom.size"
    params:
	""
    output:
        "{path_to_working_dir}{sample}/chain_file_creation/4.net/all.net"
    conda:
        "chainfile_creation_env"
    shell:
        "chainNet {input.chain} {input.galgal_chr} {input.subject_chr} {output}"

rule net_Chain_Subset:
    input:
        net="{path_to_working_dir}{sample}/chain_file_creation/4.net/all.net",
        chain="{path_to_working_dir}{sample}/chain_file_creation/3.chain/all.sorted.chain"
    output:
        "{path_to_working_dir}{sample}/chain_file_creation/galGal6To{sample}.over.chain"
    conda:
        "chainfile_creation_env"
    shell:
        "netChainSubset {input.net} {input.chain} {output}"

rule gzip_chain:
    input:
        "{path_to_working_dir}{sample}/chain_file_creation/galGal6To{sample}.over.chain"
    output:
        "{path_to_working_dir}{sample}/chain_file_creation/galGal6To{sample}.over.chain.gz"
    conda:
        "chainfile_creation_env"
    shell:
        "gzip {input} > {output}"
