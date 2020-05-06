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

# takes a search term and queries the National Library of Medicine
searchnlm <- function(term) {
  term <- paste0("&term=", term)
  url <- paste0("https://wsearch.nlm.nih.gov/ws/query?db=digitalCollections", term)
  raw_xml <- read_xml(url)
  # list of documents
  # ".//document" is a single document in the NLM database
  documents <- raw_xml %>%
    xml_find_all(".//document") %>%
  content <- documents %>%
    map(xml_children) %>% # a piece of data e.g. title, creator, subject, etc
    map_dfr(extract_content)
  list(documents, content)
}

test <- searchnlm("cholera")

url <- paste0(url_base, "&term=cholera")
test2 <- read_xml(url)