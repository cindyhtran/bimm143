### HEATMAP ###
#STEP 1. Read alignment
#install.packages("bio3d")
library(bio3d)

inputfile <- "C:/Users/cindy/Downloads/musclealignmentfasta.fst"

aln <- read.fasta(inputfile)
aln

#STEP 2. Identifying conserved positions
  #score positional conservation in the alignment with conserv() function
sim <- conserv(aln)

  #make plot of alignment position vs conservation score
plot(sim, type = "h", xlab = "Alignment Position", ylab = "Conservation Score")

  #order our sim vector of conservation scores to put the most conserved (highest scoring) first
inds <- order(sim, decreasing = TRUE)
head(sim[inds])

  #make dataframe that has position number, amino acid in aquaporin seq, and conservation score
positions <- data.frame(pos = 1:length(sim),
                        aa = aln$ali[1,],
                        score = sim)
head(positions)

  #looking at most conserved positions
head(positions[inds,])

  #convert 1-letter code for the amino acids into 3-letter code
aa123(positions[inds,]$aa)[1:3]

#STEP 3. Relationship between sequences
  #using seqidentity() to calculate the sequence identity between all pairs of sequences and using the resulting matrix of identity scores to generate a heatmap of the relationship between sequences
#install.packages("pheatmap")
library(pheatmap)

ide <- seqidentity(aln)
pheatmap((1-ide), fontsize = 11)

### BIO 3D ###

library(bio3d)
alnmt <- read.fasta("musclealignmentfasta.fst")
conalnmt <- consensus(alnmt)
a <- print(conalnmt$seq)
b <- blast.pdb(a)
hits <- plot(b)

# List out some 'top hits'
hits$pdb.id

b$hit.tbl

# Download releated PDB files
files <- get.pdb(hits$pdb.id, path="pdbs", split=TRUE, gzip=TRUE)

# Align releated PDBs
BiocManager::install("msa")
pdbs <- pdbaln(files, fit = TRUE, exefile="msa")

# Vector containing PDB codes for figure axis
ids <- basename.pdb(pdbs$id)

# Draw schematic alignment
plot(pdbs, labels=ids)

#Annotate
as.vector(ids)
anno <- pdb.annotate(ids)
unique(anno$source)
anno









