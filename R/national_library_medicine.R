library(tidyverse)
library(xml2)

# https://collections.nlm.nih.gov/web_service.html
# will be useful for generating the documentation for these packages

extract_content <- function(raw_content) {
  # generate an empty named list
  content <- list(NA, NA)
  names(content) <- c("name", "value")
  # fill out the list
  content["name"] <- xml_attr(raw_content, "name")
  content["value"] <- xml_text(raw_content)
  # return the named list
  content
}

parse_document <- function(document) {
  parsed <- document %>%
    xml_children() %>%
    map_dfr(extract_content)
  # rank uniquely identifies a document within a query?
  parsed["rank"] <- xml_attr(document, "rank")
  # permanent url to that document (making it a valid, although verbose, unique id)
  parsed["url"] <- xml_attr(document, "url")
  parsed
}

#' Takes a search term and queries the National Library of Medicine
#' 
#' @param term The search term to query
#' @param retmax The number of observations you want to query. Defaults to 10.
#' 
#' @example searchnlm("opioid")
# term can be passed as a string with spaces, which will be treated as ANDs
# or as a a character vector, where each element will be treated as ORs (in the future)
searchnlm <- function(term, retmax = NA) {
  
  # generate the URL to query
  # replace spaces in term with "+" as requested by
  term <- str_replace_all(term, " ", "+")
  # add the term prefix
  term <- paste0("&term=", term)
  url <- paste0("https://wsearch.nlm.nih.gov/ws/query?db=digitalCollections", term)
  # add retmax to url if it exists
  if(!is.na(retmax)) {
    url <- paste0(url, "&retmax=", retmax)
  }
  
  # execute the query and parse the XML it returns
  raw_xml <- read_xml(url)
  documents <- raw_xml %>%
    # ".//document" is a single document in the NLM database
    xml_find_all(".//document")
  documents %>%
    map_dfr(parse_document)
  
}

test <- searchnlm("cholera", retmax = 2000)