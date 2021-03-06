#' Retrieve information from ChemIDPlus
#'
#' Retrieve information from ChemIDPlus
#' \url{https://chem.nlm.nih.gov/chemidplus}
#'
#' @import xml2
#' @importFrom rvest html_table
#' @importFrom stats rgamma
#' @importFrom utils URLencode URLdecode
#'
#' @param query character; query string
#' @param from character; type of query string. \code{"rn"} for registry number
#'   (see
#'   \href{https://chem.nlm.nih.gov/chemidplus/jsp/chemidheavy/help.jsp#LiteSearchDataFields}{documentation}
#'   for more details), \code{"name"} for common name, or \code{"inchikey"} for
#'   inchikey as input. \code{"cas"} is a synonym for \code{"rn"} and provided
#'   for consistency across functions.
#' @param match character; How should multiple hits be handled? \code{"first"}
#' returns only the first match, \code{"best"} the best matching (by name) ID,
#' \code{"ask"} enters an interactive mode and the user is asked for input,
#' \code{"na"} returns NA if multiple hits are found.
#' @param verbose logical; should a verbose output be printed on the console?
#' @param type deprecated
#' @return A list of 8 entries: name (vector), synonyms (vector), cas (vector),
#' inchi (vector), inchikey (vector), smiles(vector), toxicity (data.frame),
#' physprop (data.frame) and source_url.
#' @note Please respect the Terms and Conditions of the National Library of
#' Medicine, \url{https://www.nlm.nih.gov/databases/download.html}.
#'
#' @export
#' @examples
#' \dontrun{
#' # might fail if API is not available
#' # query common name
#' y1 <- ci_query(c('Formaldehyde', 'Triclosan'), from = 'name')
#' names(y1)
#' str(y1[['Triclosan']]) # lots of information inside
#' y1[['Triclosan']]$inchikey
#'
#' # Query by CAS
#' y2 <- ci_query('50-00-0', from = 'rn', match = 'first')
#' y2[['50-00-0']]$inchikey
#'
#' # query by inchikey
#' y3 <- ci_query('WSFSSNUMVMOOMR-UHFFFAOYSA-N', from = 'inchikey')
#' y3[[1]]$name
#'
#' # extract lop-P
#'sapply(y1, function(y){
#'  if (length(y) == 1 && is.na(y))
#'    return(NA)
#'  y$physprop$Value[y$physprop$`Physical Property` == 'log P (octanol-water)']
#'  })
#' }
ci_query <- function(query, from = c('name', 'rn', 'inchikey', 'cas'),
                     match = c('best', 'first', 'ask', 'na'),
                     verbose = TRUE, type){
  if(!missing(type)) {
    warning('"type" is deprecated. Please use "from" instead. ')
    from <- type
  }

  from <- match.arg(from)
  match <- match.arg(match)
  foo <- function(query, from, match, verbose){
    on.exit(suppressWarnings(closeAllConnections()))
    if (is.na(query)) {
      message('query is NA! Returning NA.\n')
      return(NA)
    }
    query <- URLencode(query, reserved = TRUE)
    baseurl <- switch(
      from,
      rn = 'https://chem.nlm.nih.gov/chemidplus/rn/startswith/',
      name = "https://chem.nlm.nih.gov/chemidplus/name/startswith/",
      inchikey = "https://chem.nlm.nih.gov/chemidplus/inchikey/startswith/")
    # return max 50 hits
    qurl <- paste0(baseurl, query, '?DT_START_ROW=0&DT_ROWS_PER_PAGE=50')
    if (verbose)
      message(qurl)
    Sys.sleep( rgamma(1, shape = 15, scale = 1/10))
    ttt <- try(read_html(qurl), silent = TRUE)
    if (inherits(ttt, 'try-error')) {
      message('Not found! Returning NA.\n')
      return(NA)
    }

    tit <- xml_text(xml_find_all(ttt, "//head/title"))
    no <- xml_text(xml_find_all(ttt, "//h3"))
    if (length(no) != 0 && 'The following query produced no records:' %in% no) {
      message('Not found! Returning NA.\n')
      return(NA)
    }

    # handle multiple inputs
    if (grepl('^ChemIDplus Results - Chemical information', x = tit)) {
      if (verbose)
        message("More then one Link found. \n")
      hit_names <- xml_text(xml_find_all(ttt, "//a[@title='Open record details']"))
      hit_cas <- xml_text(xml_find_all(ttt, "//a[@title='Open record details']/following-sibling::text()[1]"))
      # exclude missing cas
      trm <- nchar(hit_cas) < 5
      hit_cas <- hit_cas[!trm]
      hit_names <- hit_names[!trm]

      if (match == 'first') {
        if (verbose)
          message("Returning first match. \n")
        hit_cas <- hit_cas[1]
        matched_sub <- hit_names[1]
        d <- 'first'
      }

      if (match == 'best') {
        if (verbose)
          message("Returning best match. \n")
        hit_names <- gsub(' \\[.*\\]', '', hit_names)
        dd <- adist(URLdecode(query), hit_names) / nchar(hit_names)
        hit_cas <- hit_cas[which.min(dd)]
        matched_sub <- hit_names[which.min(dd)]
        d <- dd[which.min(dd)]
      }

      if (match == 'na') {
        if (verbose)
          message("Returning NA. \n")
        return(NA)
      }

      if (match == 'ask') {
        tochoose <- data.frame(name = hit_names, cas = hit_cas)
        print(tochoose)
        message("\nEnter rownumber of compounds (other inputs will return 'NA'):\n") # prompt
        take <- as.numeric(scan(n = 1, quiet = TRUE))
        if (length(take) == 0) {
          return(NA)
        }
        if (take %in% seq_len(nrow(tochoose))) {
          hit_cas <- hit_cas[take]
          matched_sub <- hit_names[take]
          d <- 'interactive'
        }
      }

      # check hit
      if (is.na(hit_cas)) {
        if (verbose)
          message('CAS not found! Returning NA.\n')
        return(NA)
      }

      # retry with CAS-API
      qurl <- paste0('https://chem.nlm.nih.gov/chemidplus/rn/', hit_cas)
      if (verbose)
        message(qurl)
      Sys.sleep( rgamma(1, shape = 15, scale = 1/10))
      ttt <- try(read_html(qurl), silent = TRUE)
      source_url <- qurl
    } else {
      d <- 'direct match'
      matched_sub <- xml_text(xml_find_all(ttt, "//h3[contains(., 'Name of Substance')]/following-sibling::div[1]//li"))[1]
      source_url <- gsub('^(.*)\\?.*', '\\1', qurl)
    }

    if(is.na(xml_find_first(ttt, "//h3[contains(., 'Name of Substance')]/following-sibling::div[1]//li"))){
      name <- NA
    }else{
      name <- xml_text(xml_find_all(ttt, "//h3[contains(., 'Name of Substance')]/following-sibling::div[1]//li"))
    }

    if(is.na(xml_find_first(ttt, "//h3[contains(., 'Synonyms')]/following-sibling::div[1]//li"))){
      synonyms <- NA
    }else{
      synonyms <- xml_text(xml_find_all(ttt, "//h3[contains(., 'Synonyms')]/following-sibling::div[1]//li"))
    }

    if(is.na(xml_find_first(ttt, "//h3[contains(., 'CAS Registry')]/following-sibling::ul[1]//li"))){
      cas <- NA
    } else {
      cas <- xml_text(xml_find_all(ttt, "//h3[contains(., 'CAS Registry')]/following-sibling::ul[1]//li"))
    }

    if(is.na(xml_find_first(ttt, "//h3[contains(., 'InChI')]/following-sibling::text()[1]"))){
      inchi <- NA
    } else {
      inchi <- gsub('\\n|\\t', '',
                    xml_text(xml_find_all(ttt, "//h3[contains(., 'InChI')]/following-sibling::text()[1]"))[1]
      )
    }

    if(is.na(xml_find_first(ttt, "//h3[contains(., 'InChIKey')]/following-sibling::text()[1]"))){
      inchikey <- NA
    } else {
      inchikey <- gsub('\\n|\\t|\\r', '',
                       xml_text(xml_find_all(ttt, "//h3[contains(., 'InChIKey')]/following-sibling::text()[1]"))
                       )
    }

    if(is.na(xml_find_first(ttt, "//h3[contains(., 'Smiles')]/following-sibling::text()[1]"))){
      smiles <- NA
    } else {
      smiles <- gsub('\\n|\\t|\\r', '',
                     xml_text(xml_find_all(ttt, "//h3[contains(., 'Smiles')]/following-sibling::text()[1]"))
      )
    }

    if(is.na(xml_find_first(ttt, "//h2[contains(., 'Toxicity')]/following-sibling::div//table"))){
      toxicity <- NA
    } else {
      toxicity <- html_table(xml_find_all(ttt, "//h2[contains(., 'Toxicity')]/following-sibling::div//table"))[[1]]
    }

     if(is.na(xml_find_first(ttt, "//h2[contains(., 'Physical Prop')]/following-sibling::div//table"))){
      physprop <- NA
    } else {
      physprop <- html_table(xml_find_all(ttt, "//h2[contains(., 'Physical Prop')]/following-sibling::div//table"))[[1]]
      physprop[ , 'Value'] <- as.numeric(physprop[ , 'Value'])
      #= same as physprop
    }


    out <- list(name = name, synonyms = synonyms, cas = cas, inchi = inchi,
                inchikey = inchikey, smiles = smiles, toxicity = toxicity,
                physprop = physprop, source_url = source_url)
    attr(out, "matched") <- matched_sub
    attr(out, "distance") <- d
    class(out) <- 'chemid'
    return(out)
  }
  out <- lapply(query, foo, from = from, match = match, verbose = verbose)
  out <- setNames(out, query)
  class(out) <- c('ci_query', 'list')
  return(out)
}
