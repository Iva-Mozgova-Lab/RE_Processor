#!/bin/bash
# script to pre-process reads for RepeatExplorer
# check fastq suffixes (.fq.gz)

#PBS -N RE_SE
#PBS -l select=1:ncpus=8:mem=16gb:scratch_local=50gb
#PBS -l walltime=24:00:00

module add trimmomatic-0.36
module purge
module add repeatexplorerREportal
module unload python-2.7.10-gcc
module add python-2.7.5

cd /storage/plzen1/home/sharaf/ZE_SE_Chip/

fbname=$(basename "$FW" .)
fbname=${fbname%.fq.gz*}


mkdir $fbname


#removing adaptors, filtering reads and their trimming to set length

java -jar /software/trimmomatic/0.36/dist/jar/trimmomatic-0.36.jar SE -threads 8 -phred33 $FW $fbname/$fbname.fq.gz LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 HEADCROP:$HC CROP:$EC MINLEN:$EC

#java -jar /software/trimmomatic/0.36/dist/jar/trimmomatic-0.36.jar PE -threads 8 -phred33 $fbname/*_1P.fq.gz $fbname/*_2P.fq.gz -baseout $fbname/$fbname.sectrim.fq.gz CROP:$EC MINLEN:$EC 

#rm $fbname/*_1P.fq.gz $fbname/*_2P.fq.gz $fbname/*_1U.fq.gz $fbname/*_2U.fq.gz

#convert paired fastq to fasta
zcat $fbname/*.fq.gz | sed -n '1~4s/^@/>/p;2~4p' > $fbname/$fbname.fasta

sed "s/\// /g;s/:/_/g;s/1_N.*/ 1/g;s/ .*/ 1/g" $fbname/$fbname.fasta >> $fbname/$fbname.renamed.fasta




#sampling
#This script will select random sample of sequences of given size from fasta file.
#For reproducibility random number generator is set according -s parametr

RG=$((100000-1+1))
RN=$$

if [ "$SZ" == All ];then
    exit
else	
    for Sample in $(seq $Rep);
    do
        NUMBER=$(($(($RN%$RG))+1))

        /storage/brno7-cerit/home/galaxyelixir/galaxy/tools/umbr_utils/utils/sample_fasta -f $fbname/$fbname.1P2P.interlaced.fasta -s $NUMBER -n $SZ -p true > $fbname/$fbname.1P2P_interlaced.$Sample.$SZ.fasta;
    done
fi


