library(tidyverse)
library(xml2)

# https://collections.nlm.nih.gov/web_service.html

# takes a search term and queries the National Library of Medicine
searchnlm <- function(term) {
  term <- paste0("&term=", term)
  url <- paste0("https://wsearch.nlm.nih.gov/ws/query?db=digitalCollections", term)
  raw_xml <- read_xml(url)
  documents <- raw_xml %>% xml_find_all(".//document")
}

test <- searchnlm("cholera")

url <- paste0(url_base, "&term=cholera")
test2 <- read_xml(url)