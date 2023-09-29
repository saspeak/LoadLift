#!/bin/bash
#SBATCH --job-name=Snakemake_submission    # Job name
#SBATCH --mail-type=NONE          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=hgg16hgu@uea.ac.uk   # Where to send mail
#SBATCH --partition=medium            #the partition that it is submitted to
#SBATCH --ntasks=2                   # Run on a single CPU
#SBATCH --mem=12G                     # Job memory request
#SBATCH --time=1-00:00:00               # Time limit hrs:min:sec
#SBATCH --output=Snakemake_%j.log   # Standard output and error log
#SBATCH --error=Snakemake_%j.err

source activate snakemake

### defult run with n jobs to run at once given by the second alue you input ######
snakemake --slurm --default-resources slurm_account=cropdiv-acc slurm_partition=short -s ${1} ${3} -j ${2} --use-conda --rerun-incomplete 

###### altered ro run for bed intersection requires high mem
#snakemake --slurm --default-resources slurm_account=cropdiv-acc slurm_partition=short -s ${1} ${3} -j ${2} --use-conda --rerun-incomplete --set-resources intersection:slurm_partition=himem intersection:mem_mb=75000 intersection:runtime=1-00:00:00

#### altered for Crossmapping sometimes takes over 6 hour run time for some chr so needs to be run on medium partition 
#snakemake --slurm --default-resources slurm_account=cropdiv-acc slurm_partition=medium -s ${1} ${3} -j ${2} --use-conda --rerun-incomplete --set-resources Crossmap_CADD:mem_mb=64000 Crossmap_CADD:runtime=1-00:00:00

##### altered for phyluce to give higher memory for lastz jobs 
# snakemake --slurm --default-resources slurm_account=cropdiv-acc slurm_partition=short -s ${1} ${3} -j ${2} --use-conda --rerun-incomplete phyluce_probe_run_multiple_lastzs_sqlite:mem_mb=32000 phyluce_probe_run_multiple_lastzs_sqlite:runtime=06:00:00 


#prefix=`basename ${1}`

####### if you want to get the svg of the dag that was run 

#snakemake --slurm --default-resources slurm_account=cropdiv-acc slurm_partition=short --dag -s ${1} ${2} -j 2 --use-conda --rerun-incomplete | dot -Tsvg > ${prefix%.snakemake}_dag.svg

source deactivate
