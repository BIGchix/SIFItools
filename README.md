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
### Introduction to SIFI format
SIFI is a variant format of Simple Interaction Format(SIF). It consists of three columns, where the first column is the starting node of an edge, the second column is the type of the edge, and the third column is the ending node of the edge. For example:
```
Node1 positive Node1;Node2
Node2 positive Node1;Node2
Node1;Node2 positive Node3
```
This example represents a reaction where Node1 and Node2 generate Node3. There is an "intermediate" node (Node1;Node2) to describe the relations between Node1,2,and 3.<br>
<img width="562" alt="image" src="https://github.com/BIGchix/SIFItools/assets/50654825/97a268a4-ab23-4e9b-b7af-5bc8c2df5835">
The nodes in SIFI format may represent "intermediates" other than real molecules, which makes it slightly different from SIF. The notion of "intermediates" here is borrowed and simplified from chemical reactions, where substrate molecules get close enough to each other and forms "intermediates" before they are converted into products.
### Build SIFI format table using internal ids
In each owl file, the relations between molecules are described using the internal ids, which are linked to the external ids of molecules or entities. For example, 
<img width="1249" alt="image" src="https://github.com/BIGchix/SIFItools/assets/50654825/9d5dc162-3ae4-47a7-8862-0792f23dc5b2">
This example shows the mapping of the internal id "SmallMolecule-5a7904c9d2ea1024caa5861c9c6e6eba" to the external id "CHEBI:16814". Note that only the "UnificationXref-..." id is the one we desired. Other ids are the ids that relate to this id.<br>
Therefore, the conversion of an owl file into SIFI format is divided into two steps, first is the construction of the SIFI format table using internal ids, second is to convert the internal ids into external ids. Note, due to the varied naming conventions of different databases, the construction of SIFI table using internal ids is relatively simple, which has been automated by SIFItools. The conversion of internal ids into external ids on the other hand, requires much more manual curations.<br>


