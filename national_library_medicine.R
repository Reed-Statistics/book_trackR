library(tidyverse)
library(xml2)

# https://collections.nlm.nih.gov/web_service.html

url_base <- "https://wsearch.nlm.nih.gov/ws/query?db=digitalCollections"


extract_nlm_entry <- function(nlm_entry) {
  nlm_entry %>%
    xml_children()
}

# takes a search term and queries the National Library of Medicine
searchnlm <- function(term) {
  term <- paste0("&term=", term)
  url <- paste0(url_base, term)
  tmp <- read_xml(url) %>%
    xml_children()
  content <- tmp[7] %>%
    xml_children() %>%
    xml_siblings %>%
    map(extract_nlm_entry)
}

test <- searchnlm("cholera")

url <- paste0(url_base, "&term=cholera")
test2 <- read_xml(url)