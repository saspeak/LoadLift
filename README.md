# LoadLift
The pipeline uses as input the sequencing reads of the target individuals, the target species reference genome, and the CADD scores and reference genome of a model species (i.e., chicken, chCADD scores  (Groß, Bortoluzzi, et al., 2020) and the Galgal6 reference genome (Warren et al., 2017). 

![Slide1](https://github.com/saspeak/reads-2-CADD-snakemake/assets/77833659/9e8d2d2c-1c54-40b0-8218-0b82e131b97c)

1) (Yellow) Extraction of UCEs from the reference genome using Phyluce.
2) (Dark Blue) Mapping the sequencing reads for individuals to the reference genome indicating two parallel approaches i) for 10X chromium read data and ii) for illumina read data.
3) (Light Blue) Variant calling for SNPs within the UCEs.
4) (Light grey) Creation of a chain file for the liftover of annotation from the chicken genome.
5) (Dark Grey) chCADD scores conversion to pink pigeon (subject species) annotation.
6) (Green) Intersection of BED files and UCE sites to output per site ppCADD (subject species) scores (Red). 
