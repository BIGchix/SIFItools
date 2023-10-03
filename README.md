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
<br><br>
This example shows the mapping of the internal id "SmallMolecule-5a7904c9d2ea1024caa5861c9c6e6eba" to the external id "CHEBI:16814". Note that only the "UnificationXref-..." id is the one we desired. Other ids are the ids that relate to this id.<br>

Therefore, the conversion of an owl file into SIFI format is divided into two steps, first is the construction of the SIFI format table using internal ids, second is to convert the internal ids into external ids. Note, due to the varied naming conventions of different databases, the construction of SIFI table using internal ids is relatively simple, which has been automated by SIFItools. The conversion of internal ids into external ids on the other hand, requires much more manual curations.<br>

To build the SIFI table using internal ids, first we load the libraries:
```R
library(rBiopaxParser)
library(SIFItools)
```
Specify the location to the owl file, and the names of the output files. In this guide, we use [the owl file of KEGG](https://www.pathwaycommons.org/archives/PC2/v12/PathwayCommons12.kegg.BIOPAX.owl.gz) from pathwayCommons version 12.
```R
outpath<-"where you put the owl file/"
input<-"PathwayCommons12.kegg.BIOPAX.owl"
owl<-paste0(outpath,input)
#output files
(out.biopax<-paste0(outpath,dbname,"_biopax.RData"))
(out.reactions.full<-paste0(outpath,dbname,"_reactions.full.RData"))
(out.cplx2cpnt<-paste0(outpath,dbname,"_cplx2cpnt.RData"))
(out.sif<-paste0(outpath,dbname,"_sif.RData"))
```
Before reading the owl file, replace the "\_" by "-". We will use "\_" to separate the subunits of protein complex. In R under macOS, do:
```R
system(paste0("sed -i -e 's/_/-/g' ",owl))
```
Then read the owl file:
```R
hbiopax<-read_owl(owl,out.biopax,input)
```
Note this will create an .RData file containing the hbiopax object. If the .RData file already exists, then this function will skip the reading process and directly load the .RData file.<br>
Then we check the hbiopax object:
```R
head(hbiopax$dt)
unique(hbiopax$dt$class)
```
Then build the table of reactions:
```R
reactions.full<-build_reactionsFull(out.reactions.full,hbiopax,verbose = TRUE)
```
The info on screen looks like this:
```R
[1] "Building reactions.full object..."
[1] "Extracting reactions..."
[1] "Extracting class::BiochemicalReaction..."
[1] "Finished 1000 reactions, total 1782"
[1] "No class::Degradation found."
[1] "No class::Conversion found."
[1] "No class::ComplexAssembly found."
[1] "No class::Transport found."
[1] "No class::TransportWithBiochemicalReaction found."
[1] "No class::TemplateReaction found."
[1] "Adding enzyme info into the dataframe..."
[1] "Adding info for class::Catalysis..."
[1] "Finished 1000 enzymes, total 1782"
[1] "No class::Control found."
[1] "No class::Modulation found."
[1] "Saving reactions.full object to file: /.../curation/PathwayCommons/pcKEGG/pcKEGG_reactions.full.RData"
```
Then build the mapping table of protein complexes to their subunits:
```R
cplx2cpnt<-build_cplx2cpnt(hbiopax,out.cplx2cpnt)
```
The info on screen is:
```R
[1] "Warning: no 'Complex' class in the biopax object."
[1] "Created a void matching table for the downstream steps."
```
So there's no "Complex" class in this owl file. For other larger owl files, this table might be huge.<br>
Next, build the SIFI table using the internal ids, which we refer to as "raw SIFI table":
```R
tmp.sif<-build_rawSIF(out.sif,reactions.full,cplx2cpnt)
```
The info on screen is:
```R
[1] "Building GIN in sif format, with local unreplaced ids..."
[1] "Processed 100 reactions, total 1782"
[1] "Processed 200 reactions, total 1782"
[1] "Processed 300 reactions, total 1782"
[1] "Processed 400 reactions, total 1782"
[1] "Processed 500 reactions, total 1782"
[1] "Processed 600 reactions, total 1782"
[1] "Processed 700 reactions, total 1782"
[1] "Processed 800 reactions, total 1782"
[1] "Processed 900 reactions, total 1782"
[1] "Processed 1000 reactions, total 1782"
[1] "Processed 1100 reactions, total 1782"
[1] "Processed 1200 reactions, total 1782"
[1] "Processed 1300 reactions, total 1782"
[1] "Processed 1400 reactions, total 1782"
[1] "Processed 1500 reactions, total 1782"
[1] "Processed 1600 reactions, total 1782"
[1] "Processed 1700 reactions, total 1782"
[1] "Saving sif dataframe into file: /.../curation/PathwayCommons/pcKEGG/pcKEGG_sif.RData"
```
Now, the raw SIFI table has been built. It's stored in the object "tmp.sif" and in a local file "pcKEGG_sif.RData".
### Create matching table to format external ids.
Before we replace the internal ids with external ids, we need to build a matching table for this specific owl file to format the external ids. As shown in the example of the internal id "SmallMolecule-5a7904c9d2ea1024caa5861c9c6e6eba", the external id is stored as "chebi:CHEBI:16814". In fact, different databases use different names for the same annotation database, for example, in the INOH database, HGNC symbols are described as "hgnc symbol", while in KEGG, it is "hgnc". Since the function getXrefAnnotations from rBiopaxParser will concatenate the database' name with the ids, the final external ids fetched by getXrefAnnotations will be in "hgnc symbol:XXX" for INOH and "hgnc:XXX" for KEGG. To parse these different formats of the external ids, manual curations are needed. Here we have constructed an matching table for replacing the strings into unified formats. Note, we removed the ":" in the external ids during replacement. The matching table for nine databases parsed by pathwayCommons can be found here, in ".RData" format. The table is like this:
```R
load(matchTable.all.RData)
head(matchTable.all)
1                      uniprot:   UniProt
2        uniprot knowledgebase:   UniProt
3              uniprot isoform:   UniProt
4               umbbd-compounds     UMBBD
5 therapeutic targets database:          
6         sequence ontology:SO:        SO
```
During the conversion of the internal ids into external ids, the external ids will be simultaneously formatted.<br>
 <br>
On the other hand, if a new matching table is needed, the following codes might be helpful:
```R
#use KEGG as an example to build a new matching table
(dbName<-unique(hbiopax$dt$property_value[hbiopax$dt$property == "db"])) #show all of the databases presented in this owl file
indx.db<-c()
df.example<-data.frame(examples=rep("example",6)) #initialize the dataframe
for(i in 1:length(dbName)){
  n.uni<-dim(hbiopax$dt[hbiopax$dt$property == "db" & hbiopax$dt$property_value == dbName[i] &hbiopax$dt$class == "UnificationXref",])[1]
  if(n.uni > 0){ #Only the databases with >0 UnificationXRef are considered
    indx.db<-c(indx.db,i)
    idvec<-head(unique(hbiopax$dt$id[hbiopax$dt$property == "db" & hbiopax$dt$property_value == dbName[i]])) #The example ids
    df.example<-cbind(df.example,dbname=hbiopax$dt[hbiopax$dt$id %in% idvec & hbiopax$dt$property == "id",6]) #Store the ids in the dataframe
  }
}
df.example<-df.example[,-1]
colnames(df.example)<-dbName[indx.db]
df.example
```
We will get:
```R
> df.example
  kegg reaction kegg orthology kegg pathway uniprot knowledgebase        chebi kegg compound kegg glycan        cas      mi molecular interactions ontology taxonomy
1        R01615         K03430      rn00230                Q9UHN1  CHEBI:30933        C02325      G10621 14215-68-0 MI:0356                         MI:0360     9606
2        R06539         K13788      rn00710                Q9H3R1  CHEBI:18036        C00672      G00275  3475-65-8 MI:0361                         MI:0829     9606
3        R01818         K00818      rn00906                Q3MUY2  CHEBI:17361        C02700      G10336 10257-28-0 MI:0356                         MI:0360     9606
4        R02557         K02706      rn00362                O24475 CHEBI:506227        C00191      G10609  2280-44-6 MI:0361                         MI:0829     9606
5        R08949         K02434      rn00770                Q16836  CHEBI:17122        C05809      G00289 10139-18-1 MI:0356                         MI:0360     9606
6        R01000         K04092      rn00040                O00408   CHEBI:7274        C05422      G10608  1022-31-7 MI:0361                         MI:0829     9606
```
Note that the function getXrefAnnotations will concatenate the database' name with the ids, for example "CHEBI:30933" will become "chebi:CHEBI:30933", so we have to replace the string "chebi:CHEBI:" with "CHEBI". Here we remove the ":" in all of the ids to avoid unexpected behavior of the functions. So the matching table can be created like this:
```R
matchTable.kegg<-data.frame(toBeReplaced="kegg reaction:",replacedBy="KEGG")
matchTable.kegg<-rbind(matchTable.kegg,data.frame(toBeReplaced="kegg orthology:",replacedBy="KEGG"))
matchTable.kegg<-rbind(matchTable.kegg,data.frame(toBeReplaced="kegg pathway:",replacedBy="KEGG"))
matchTable.kegg<-rbind(matchTable.kegg,data.frame(toBeReplaced="uniprot knowledgebase",replacedBy="UniProt"))
matchTable.kegg<-rbind(matchTable.kegg,data.frame(toBeReplaced="chebi:CHEBI:",replacedBy="CHEBI"))
matchTable.kegg<-rbind(matchTable.kegg,data.frame(toBeReplaced="kegg compound:",replacedBy="KEGG"))
matchTable.kegg<-rbind(matchTable.kegg,data.frame(toBeReplaced="kegg glycan:",replacedBy="KEGG"))
matchTable.kegg<-rbind(matchTable.kegg,data.frame(toBeReplaced="cas:",replacedBy="CAS"))
matchTable.kegg<-rbind(matchTable.kegg,data.frame(toBeReplaced="mi:MI:",replacedBy="MI"))
matchTable.kegg<-rbind(matchTable.kegg,data.frame(toBeReplaced="molecular interactions ontology:MI:",replacedBy="MI"))
```
The result is:
```R
> matchTable.kegg
                          toBeReplaced replacedBy
1                       kegg reaction:       KEGG
2                      kegg orthology:       KEGG
3                        kegg pathway:       KEGG
4                uniprot knowledgebase    UniProt
5                         chebi:CHEBI:      CHEBI
6                       kegg compound:       KEGG
7                         kegg glycan:       KEGG
8                                 cas:        CAS
9                               mi:MI:         MI
10 molecular interactions ontology:MI:         MI
```
Now, the matching table for KEGG has been built, we can proceed to the next step.
### Replace internal ids with external ids
This step is the time limiting step of the whole process. To speed up the process, we can split the process into multiple jobs and run them in parallel. 
```R
(total=dim(tmp.sif)[1]) #The total number of lines
mystart=1 #The starting line number. We recommend to split the table every 2000 lines

if(mystart > total){
  print("Starting number must be smaller than the total number of lines of the edgelist.")
  q(save = "no")
}

if(mystart+2000-1 > total){
  myend = total
}else{
  myend = mystart + 2000 - 1
}

print("Start replacing local id with commonly used ids.")
print(paste0("Starting from line ",mystart,", will end at line ",myend))

tmp.sif.tmp<-replace_id_with_annotation(hbiopax,tmp.sif,mystart,myend,matchTable.kegg,verbose = TRUE)
tmp.sif.tmp<-tmp.sif.tmp[mystart:myend,] #Subsetting the df. The tmp.sif.tmp is a full size dataframe containing all of the edges, but only the internal ids of specified lines have been replaced by external ids.

write.table(tmp.sif.tmp,file = paste0(outpath,dbname,".sif.replaced.",mystart,".",myend,".tsv"),sep="\t",
            row.names = F, col.names = F, quote = F) #Save the result
```
After all of the jobs are done, concatenate the result files and remove the edges with no ending nodes:
```R
system(paste0("'cat ",workdir,dbname,".sif.replaced.* > ",workdir,dbname,".sif.replaced.tsv'"))
system(paste0("'grep -v NoRight ",workdir,dbname,"sif.replaced.tsv > ",workdir,"final.hs.sif.replaced.tsv'"))
```
Now the convertion of a single database's owl file into SIFI format has done.
