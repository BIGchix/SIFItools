% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/source_SIFItools.R
\name{get_id_annotation}
\alias{get_id_annotation}
\title{Retrieve the external ids/annotations of a given internal id}
\usage{
get_id_annotation(
  biopax,
  id,
  i,
  matchTable,
  globalReplace.before = c("_", "-"),
  globalReplace.after = matrix(c(" ", ":", "-", "-"), nrow = 2),
  nreport = 1,
  verbose = TRUE
)
}
\arguments{
\item{biopax}{A rBioPax object generated by reading an owl file using package "rBiopaxParser".}

\item{id}{A character string of an internal id. It must be an id of a gene/protein or metabolite.}

\item{i}{An integer of the line number. It is only used for reporting the locations of unexpected ids for debugging.}

\item{matchTable}{A two-column dataframe, with the first column containing the strings that need to be replaced, and the second column containing the strings after replacement. Example: replace "uniprot:" with "UniProt".}

\item{globalReplace.before}{A vector of two elements, specifying the global treatment of special characters which are not desired. This action will be taken BEFORE searching by the internal ids for external ids. Default (c("_","-")) is to replace "_" with "-".}

\item{globalReplace.after}{A vector of two elements, specifying the global treatment of special characters which are not desired. This action will be taken AFTER searching by the internal ids for external ids. Default is a two row matrix, meaning to replace " " with "-", and to replace ":" with "-".}

\item{nreport}{An integar specifying the limit number of candidate annotations for reporting.}

\item{verbose}{Logical, TRUE or FALSE. Whether to report warnings.}
}
\value{
A three-column dataframe containing the edges from substrates and enzymes to intermediate, and from intermediate to products, using external ids.
}
\description{
This function search for the external ids or annotations of a given internal id, while removing the special characters.
}
\details{
This function calls "getXrefAnnotations" from rBioPaxParser to retrieve the external ids and annotations first, then take the first id and unifies the id format according to matchTable. Will report a warning if there is not sufficient number (nreport) of external ids/annotations.
}
