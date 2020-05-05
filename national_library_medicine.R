library(tidyverse)
library(rvest)

# https://collections.nlm.nih.gov/web_service.html

url_base <- "https://wsearch.nlm.nih.gov/ws/query?db=digitalCollections"

searchnlm <- function(term) {
  term <- paste0("&term=", term)
  url <- paste0(url_base, term)
  print(url)
  content <- read_xml(url)
}