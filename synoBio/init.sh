#!/usr/bin/env bash
set -e

##### Initialising a working environment in current directory 
SELF=${BASH_SOURCE[0]}
ENVDIR=$PWD

############################################
echo ==== Installing binaries
JARLIB=$PWD/jar
mkdir -p $PWD/bin
mkdir -p $JARLIB

### Trimmomatic
# must supply absolute paths
TRIMDIR=/home/birte/IGZ_data/software/Trimmomatic-0.39
#printf '#!/usr/bin/env bash \njava -jar $TRIMDIR/trimmomatic-0.39.jar "$@"'>$ENVDIR/bin/trimmomatic
printf "#!/usr/bin/env bash \njava -jar $TRIMDIR/trimmomatic-0.39.jar \"\$@\"">$ENVDIR/bin/trimmomatic #Birte: needs outer double quotes, needs \ to preserve "$@" (inner double quotes)

### HISAT2
ln -sf /home/birte/IGZ_data/software/hisat2-2.1.0/* $ENVDIR/bin
### Bowtie2
ln -sf /home/birte/IGZ_data/software/bowtie2-2.4.1-linux-x86_64/* $ENVDIR/bin #Birte: not tested yet if this works
### picard for dedup
#ln -sf /home/Program_NGS_sl-pw-srv01/picard-tools-1.103/*.jar $JARLIB
ln -sf /home/birte/IGZ_data/software/picard.jar $JARLIB #Birte: different from before logic, no picard-tools folder anymore
### StringTie
ln -sf /home/birte/IGZ_data/software/stringtie-2.1.1.Linux_x86_64/stringtie $ENVDIR/bin
### Samtools
ln -sf /home/birte/IGZ_data/software/samtools-1.10/samtools $ENVDIR/bin #Birte: not tested yet if this works
### FASTQC
# ln -sf /home/birte/IGZ_data/software/FASTQC/fastqc $ENVDIR/bin #Birte: fastq dependency not working like this, use trimmomatic strategy
FASTQCDIR=/home/birte/IGZ_data/software/FastQC #Birte 04-2020
printf "#!/usr/bin/env bash \n$FASTQCDIR/fastqc \"\$@\"">$ENVDIR/bin/fastqc #Birte 04-2020

#     ##### Assumed installed 
#     # fastqc #Birte: no longer assumed
# pip install --user pyfaidx
echo ---- Installing binaries
############################################



# ############################################
# echo ==== Preparing different FASTA files =====
# #### Prepare adapter fasta
# mkdir -p $PWD/adapters
# ln -sf $TRIMDIR/adapters/* adapters
# cd adapters
# if [ ! -e "TruSeq3-PE-all.fa" ]; then
# #     :
# # else
#     cat TruSeq3-PE*.fa >TruSeq3-PE-all.fa
# fi
# cd ..

# #### Index genome.fa
# mkdir -p $PWD/ref
# #ln -s /home/ref_genew/Brachypodium_Bd21_v3.1/assembly/Bdistachyon_314_v3.0.fa ref/genome.fa
# ln -sf /home/ref_genew/Brachypodium_Bd21_v3.1/* ref
# ln -sf $PWD/ref/assembly/*.fa ref/genome.fa
# faidx ref/genome.fa -i chromsizes > ref/genome.sizes
# echo ---- Preparing different FASTA files ----
# ############################################


ORIGIN=`readlink -f ${SELF%/*}` 
cp -prf $ORIGIN/* -t $PWD/bin ### Feng: copy everything into bin
cp -pf $PWD/bin/activate.sh $PWD/bin/activate ### Feng: not essential
chmod +x $PWD/bin/*
# cp -u $ORIGIN/activate.sh bin/activate
# cp -u $ORIGIN/*.sh bin/
# cp -u $ORIGIN/checkVars bin/ # line added by Birte 04-2020
# cp -u $ORIGIN/logRun bin/ # line added by Birte 04-2020
# cp -uR $ORIGIN/config config
echo export ORIGIN=$ORIGIN >> bin/activate



