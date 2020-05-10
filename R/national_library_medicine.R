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
#' @param term The search term to query. By default spaces will be parsed as ANDs, and seperate elements in the vector as ORs.
#' @param field The field to query. Defaults to querying all fields. Includes choices such as "creator", "subject", "title", and "description"
#' @param retmax The number of observations you want to query. Defaults to 10.
#' @param email Your email address as a string. Optional--it allows the National Library of Medicine to contact you if there are problems with your queries.
#'
#' @example searchnlm("opioid")
#' @example searchnlm("cholera", field = "subject")
#' @return Returns a dataframe where each row is a field of a record in the NLM databse. Rank and url uniquely identify the works in the NLM database.
#' @export
searchnlm <- function(term, field = NA, retmax = NA, email = NA) {

  #############################
  # generate the URL to query #
  #############################
  # replace spaces in term with "+"
  term <- str_replace_all(term, " ", "+")
  # convert a mutli-element term to ORs, which is represented by "+OR+"
  if(length(term) > 1) {
    term <- cat(term, sep = "+OR+")
  }
  # add field to term if it exists
  if(!is.na(field)) {
    term <- paste0("dc:", field, ":", term)
  }
  # add the term prefix (must be last step)
  term <- paste0("&term=", term)
  # combine term with the base url
  url <- paste0("https://wsearch.nlm.nih.gov/ws/query?db=digitalCollections", term)
  # add retmax to url if it exists
  if(!is.na(retmax)) {
    url <- paste0(url, "&retmax=", retmax)
  }
  # add email to url if it exists
  if(!is.na(email)) {
    url <- paste0(url, "&email=", email)
  }
  print(url)

  ##################################################
  # execute the query and parse the XML it returns #
  ##################################################
  raw_xml <- read_xml(url)
  documents <- raw_xml %>%
    # ".//document" is a single document in the NLM database
    xml_find_all(".//document")
  documents %>%
    map_dfr(parse_document)

}

test <- searchnlm("cholera", retmax = 2000)
