#!/bin/bash
#SBATCH --job-name=adding_paths    # Job name
#SBATCH --mail-type=NONE          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=hgg16hgu@uea.ac.uk   # Where to send mail
#SBATCH --partition=short            #the partition that it is submitted to
#SBATCH --ntasks=2                   # Run on a single CPU
#SBATCH --mem=12G                     # Job memory request
#SBATCH --time=06:00:00               # Time limit hrs:min:sec
#SBATCH --output=Paths_%j.log   # Standard output and error log
#SBATCH --error=Paths_%j.err

##############################################################################
######## Edit these to fill in the paths to the correct destinations #########
##############################################################################

##### edit the right side of the sed comands leave the left hand placeholders intact
##### once this is run check all of the config files to fill in any genome paths

while read p
do
echo $p

sed -i 's\{path_to_LoadLift}\{EDIT_THIS_TO_THE_PATH_TO_LoadLift}\g' $p
sed -i 's\{path_to_raw_chCADD}\{EDIT_THIS_TO_THE_PATH}\g' $p
sed -i 's\{path_to_working_dir}\{EDIT_THIS_TO_WORKING_DIR}\g' $p
sed -i 's\{shortened_name}\{EDIT_THIS_TO_SP_NAME}\g' $p

done < snake_list/list_of_snakefiles.txt


