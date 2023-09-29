# LoadLift
The pipeline uses as input the sequencing reads of the target individuals, the target species reference genome, and the CADD scores and reference genome of a model species (i.e., chicken, chCADD scores  (Groß, Bortoluzzi, et al., 2020) and the Galgal6 reference genome (Warren et al., 2017). 

![Slide1](https://github.com/saspeak/LoadLift/assets/77833659/fff7176b-ea77-489b-98d5-8ba8f0e1dde0)


1) (Yellow) Extraction of UCEs from the reference genome using Phyluce.
2) (Dark Blue) Mapping the sequencing reads for individuals to the reference genome indicating two parallel approaches i) for 10X chromium read data and ii) for illumina read data.
3) (Light Blue) Variant calling for SNPs within the UCEs.
4) (Light grey) Creation of a chain file for the liftover of annotation from the chicken genome.
5) (Dark Grey) chCADD scores conversion to pink pigeon (subject species) annotation.
6) (Green) Intersection of BED files and UCE sites to output per site ppCADD (subject species) scores (Red). 

**Setting paths**

When you are setting up the pipeline you must input the PATHS to your data and working directories.
To help with this you edit the file: scripts/add_paths_to_snakefiles.sh. (designed for a slurm system) 
Then execute scripts/add_paths_to_snakefiles.sh. 
You should then also edit and check the confiuration .yaml files along with the snakemake files to ensure PATHS are correct.

**Publication:**

Preprint of analysis for original pipeline release DOI: 10.22541/au.169566325.52568264/v1




