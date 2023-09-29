configfile: "{path_to_LoadLift}LoadLift/1.Phyluce/UCE-config.yaml"

def get_input_genome(wildcards):
    return config["individuals"][wildcards.individual]

rule make_2bit:
    input:
        genome=get_input_genome
    output:
        "{individual}/{individual}.2bit"
    params:
        genome_path=config["genome_path"]
        #species="{individual}"
    conda:
        "phyluce-1.7.1"
    shell:
        "faToTwoBit {input.genome} {params.genome_path}/{output}"

rule make_conf_file:
    input:
        "{individual}/{individual}.2bit"
    output:
        "phyluce_{individual}_config.txt"
    params:
        species="{individual}",
        genome_path=config["genome_path"]
    shell:
        "echo -e [scaffolds] '\n'{params.species}:{params.genome_path}/{input} > {output}"

rule phyluce_probe_run_multiple_lastzs_sqlite:
    input:
        genome="{individual}/{individual}.2bit",
        genome_path=config["genome_path"],
        probes=config["probe_file"]
    output:
        "{individual}-genome-lastz/uce-5k-probes.fasta_v_{individual}.lastz.clean"
    params:
        cores="4",
        species="{individual}"
    conda:
        "phyluce-1.7.1"
    shell:
        "phyluce_probe_run_multiple_lastzs_sqlite --db {params.species}.sqlite --output {params.species}-genome-lastz --scaffoldlist {params.species} --genome-base-path {input.genome_path} --probefile {input.probes} --cores  {params.cores}"

def individual_lower(wildcards):
    species_name = wildcards.individual
    species_name_lower = species_name.lower()
    lower_fasta = "UCE/" + species_name_lower + ".fasta"
    return species_name_lower

rule phyluce_probe_slice_sequence_from_genomes:
    input:
        lastz="{individual}-genome-lastz/",
        conf="phyluce_{individual}_config.txt"
    output:
        "UCE/{individual}.fasta"
    conda:
        "phyluce-1.7.1"
    params:
        name="uce-5k-probes.fasta_v_{individual}.lastz.clean",
        dir=config["out_dir"],
        flank=config["flank-size"]
    shell:
        "phyluce_probe_slice_sequence_from_genomes --lastz {input.lastz} --conf {input.conf} --flank {params.flank} --name-pattern {params.name} --output {params.dir}"

rule orientation_lables:
    input:
       "UCE/{individual).fasta"
    output:
        "UCE_regions/{individual}_UCE_regions.txt"
    params:
        columns="-f 2,3,4,6",
        orient=config["params_orientation"]
    conda:
        "phyluce-1.7.1"
    shell:
        "grep 'uce' {input} | cut -d '|' {params.columns} | sed -e 's/|/\t/g' | sed -e 's/contig://g' | sed -e 's/slice://g'| sed -e 's/uce://g' | sed -e 's/orient://g' | sed -e 's/uce-/uce_/g' | {params.orient}| sed -e 's/-/\t/g'  > {output}"

rule orientation_separation_forward:
    input:
        "UCE_regions/{individual}_UCE_regions.txt"
    output:
        "UCE_regions/forward/{individual}_UCE_forward_orient_regions.txt"
    params:
        "-f 1,2,3"
    conda:
        "phyluce-1.7.1"
    shell:
        "grep 'forward' {input}| cut {params} > {output}"

rule orientation_separation_reverse:
    input:
        "UCE_regions/{individual}_UCE_regions.txt"
    output:
        "UCE_regions/reverse/{individual}_UCE_reverse_orient_regions.txt"
    params:
        "-f 1,2,3"
    conda:
        "phyluce-1.7.1"
    shell:
        "grep 'reverse' {input}| cut {params} > {output}"

rule run_all:
    input:
        "UCE_regions/forward/{individual}_UCE_forward_orient_regions.txt",
        "UCE_regions/reverse/{individual}_UCE_reverse_orient_regions.txt",
        "UCE/{individual}.fasta"
    output:
        "{individual}_paths_to_UCEs.txt"
    shell:
        "ls {input} > {output}"
