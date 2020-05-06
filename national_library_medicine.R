library(tidyverse)
library(xml2)

# https://collections.nlm.nih.gov/web_service.html

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
  parsed["rank"] <- xml_attr(document, "rank")
  parsed
}

# takes a search term and queries the National Library of Medicine
searchnlm <- function(term) {
  term <- paste0("&term=", term)
  url <- paste0("https://wsearch.nlm.nih.gov/ws/query?db=digitalCollections", term)
  raw_xml <- read_xml(url)
  documents <- raw_xml %>%
    # ".//document" is a single document in the NLM database
    xml_find_all(".//document")
  documents %>%
    map_dfr(parse_document)
}

test <- searchnlm("cholera")