install.packages("bio3d")
library(bio3d)

#STEP 1. Read our globin alignment
  #Use alignment input here
inputfile <- "https://bioboot.github.io/bimm143_F21/class-material/globin_alignment.fa"
aln <- read.fasta(inputfile)
aln

#STEP 2. Identifying conserved positions
  #score positional conservation in the alignment with the conserv() function
sim <- conserv(aln)

  #plot of alignment vs conservation score
plot(sim, typ = "h", xlab = "Alignment position", ylab = "Conservation score")

  #put the most conserved (highest scoring) first
inds <- order(sim, decreasing = TRUE)
head(sim[inds])

positions <- data.frame(pos = 1:length(sim),
                        aa = aln$ali[1,],
                        score = sim)
head(positions)

  #look at the most conserved positions
head(positions[inds,])

  #convert one-letter code to 3 letter code
aa123(positions[inds,]$aa)[1:3]

#STEP 3. Relationship between sequences
install.packages("pheatmap")
library(pheatmap)

ide <- seqidentity(aln)
pheatmap((1-ide))