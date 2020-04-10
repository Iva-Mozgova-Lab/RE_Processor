# RE_Processor
processing raw data for Repeat Explorer and Chip_Seq-Mapper programs. The script was set to submitted to Metcentrium cloud computing platform.

# Usage
#for paired-end reads
qsub -v FW='right_reads.fq.gz', RV='lift_reads.fq.gz',HC='header cropping',EC='lenght of output fragment',Rep='replicates',SZ='sample read size' RE_proc_PE.sh 

#for sinle-end reads
qsub -v FW='right_reads.fq.gz',HC='header cropping',EC='lenght of output fragment',Rep='replicates',SZ='sample read size' RE_proc_SE.sh


#for all reads without sampling
SZ='All'
