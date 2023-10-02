# SIFItools
A R package to convert BioPAX level3 owl files into Simple Interaction Format with Intermediates(SIFI)
## Installation
SIFItools can be installed directly from github:
```R
library("devtools")
install_github("BIGchix/SIFItools/SIFItools_1.0")
library(SIFItools)
```
SIFItools was built upon "rBiopaxParser", which can be automatically installed with the codes above, or individually by:
```R
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("rBiopaxParser")
```
## A brief guide for conversion of Biopax level3 owl files into SIFI format
### SIFI format
SIFI is a variant format of Simple Interaction Format(SIF). It consists of three columns, where the first column is the starting node of an edge, the second column is the type of the edge, and the third column is the ending node of the edge. For example:
```
node1 positive node1;node2
node2 positive node1;node2
node1;node2 positive node3
```
This example represents a reaction where node1 and node2 generate node3. There is an "intermediate" node (node1;node2) to describe the relations between node1,2,and 3.<br>
<img width="562" alt="image" src="https://github.com/BIGchix/SIFItools/assets/50654825/97a268a4-ab23-4e9b-b7af-5bc8c2df5835">
The nodes in SIFI format may represent "intermediates" other than real molecules, which makes it slightly different from SIF. The notion of "intermediates" here is borrowed and simplified from chemical reactions, where substrate molecules get close enough to each other and forms "intermediates" before they are converted into products.
