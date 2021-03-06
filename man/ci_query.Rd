% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/chemid.R
\name{ci_query}
\alias{ci_query}
\title{Retrieve information from ChemIDPlus}
\usage{
ci_query(
  query,
  from = c("name", "rn", "inchikey", "cas"),
  match = c("best", "first", "ask", "na"),
  verbose = TRUE,
  type
)
}
\arguments{
\item{query}{character; query string}

\item{from}{character; type of query string. \code{"rn"} for registry number
(see
\href{https://chem.nlm.nih.gov/chemidplus/jsp/chemidheavy/help.jsp#LiteSearchDataFields}{documentation}
for more details), \code{"name"} for common name, or \code{"inchikey"} for
inchikey as input. \code{"cas"} is a synonym for \code{"rn"} and provided
for consistency across functions.}

\item{match}{character; How should multiple hits be handled? \code{"first"}
returns only the first match, \code{"best"} the best matching (by name) ID,
\code{"ask"} enters an interactive mode and the user is asked for input,
\code{"na"} returns NA if multiple hits are found.}

\item{verbose}{logical; should a verbose output be printed on the console?}

\item{type}{deprecated}
}
\value{
A list of 8 entries: name (vector), synonyms (vector), cas (vector),
inchi (vector), inchikey (vector), smiles(vector), toxicity (data.frame),
physprop (data.frame) and source_url.
}
\description{
Retrieve information from ChemIDPlus
\url{https://chem.nlm.nih.gov/chemidplus}
}
\note{
Please respect the Terms and Conditions of the National Library of
Medicine, \url{https://www.nlm.nih.gov/databases/download.html}.
}
\examples{
\dontrun{
# might fail if API is not available
# query common name
y1 <- ci_query(c('Formaldehyde', 'Triclosan'), from = 'name')
names(y1)
str(y1[['Triclosan']]) # lots of information inside
y1[['Triclosan']]$inchikey

# Query by CAS
y2 <- ci_query('50-00-0', from = 'rn', match = 'first')
y2[['50-00-0']]$inchikey

# query by inchikey
y3 <- ci_query('WSFSSNUMVMOOMR-UHFFFAOYSA-N', from = 'inchikey')
y3[[1]]$name

# extract lop-P
sapply(y1, function(y){
 if (length(y) == 1 && is.na(y))
   return(NA)
 y$physprop$Value[y$physprop$`Physical Property` == 'log P (octanol-water)']
 })
}
}
