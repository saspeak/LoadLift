#!/bin/sh
#SBATCH --partition short
#SBATCH --job-name=seqprep_debug
#SBATCH --mem=2000
#SBATCH --time=01:00:00
#SBATCH --output=fq-seqprep-%J.out
#SBATCH --error=fq-seqpre-%J.err

. /etc/profile


# map the reads to the reference genome

#ref="/Band-tailed/GCA_002029285.1_NIATT_ARIZONA_genomic.fna"
#sra="/home/sspeak/projects/joint/ss_lpa_shared/passenger_pigeon/SRA_download/sra/"

#for i in ${sra}*.sra
#do
#		genome_folder="/home/sspeak/projects/joint/ss_lpa_shared/passenger_pigeon/trimmed_reads/"
		#mkdir ${genome_folder}
		#fastq-dump ${i}

#		#trim the fastq files to remove the forward and reverse primers from reads
#		prefix=`echo $(basename "${i%.sra}")`
#		SeqPrep -M 0.05 -N 0.75 -m 0.8 -n 0.02 -X 0.25 -Z 26 -f ${prefix}.fastq -r ${prefix}.fastq -1 ${genome_folder}${prefix}.fq.gz -2 ${genome_folder}${prefix}_2.fq.gz
#
#		#remove the fastq file (they are huge)
#done


#rm -f ${sra}*.fastq



####### I want to test if it is something in the seq prep script or if it is the snakemake that is causing the errors
mkdir 2_trimmed_reads/

SeqPrep -M 0.05 -N 0.75 -m 0.8 -n 0.02 -X 0.25 -Z 26 \
-f /home/sspeak/projects/joint/ss_lpa_shared/passenger_pigeon/fastq/SRR1303448.fastq \
-r /home/sspeak/projects/joint/ss_lpa_shared/passenger_pigeon/fastq/SRR1303448.fastq \
-1 trimmed_reads/SRR1303448_trimmed.fq.gz \
-2 2_trimmed_reads/SRR1303448_trimmed.fq.gz
