
# tidynlm

## Overview

tidynlm provides easy access to the National Library of Medicine (NLM)
API from within R. The package allows the user to create a dataframe of
NLM documents matching a particular search query using the function
`searchnlm`. The resulting dataframe contains information on attributes
such as authorship and date and place of publication. The documents
themselves can be accessed with the urls in the url column of the
resulting dataframe.

## Installation

You can install the released version of tidynlm from
[GitHub](https://github.com/Reed-Statistics/book_trackR) with:

``` r
# install.packages("devtools")
devtools::install_github("https://github.com/Reed-Statistics/book_trackR")
```

## Usage

`tidynlm` gives access to the NLM API through the function `searchnlm`,
which accepts the arguments:

  - `term` is the search term(s)
  - `field` is the field to search in
  - `retmax` is the number of documents to search
  - `email` allows the NLM to track your API requests
  - `output` determines if a row is a field or a document
  - `collapse_to_first` removes duplicated fields if set to TRUE
  - `print_url` prints the queried URL if set to TRUE

<!-- end list -->

``` r
library(tidynlm)
library(tidyverse)
#> Warning: package 'tidyverse' was built under R version 3.6.3
#> -- Attaching packages ----------------------------------------------------------------------------------------- tidyverse 1.3.0 --
#> v ggplot2 3.3.0     v purrr   0.3.3
#> v tibble  2.1.3     v dplyr   0.8.5
#> v tidyr   1.0.2     v stringr 1.4.0
#> v readr   1.3.1     v forcats 0.5.0
#> Warning: package 'ggplot2' was built under R version 3.6.3
#> Warning: package 'dplyr' was built under R version 3.6.3
#> Warning: package 'forcats' was built under R version 3.6.3
#> -- Conflicts -------------------------------------------------------------------------------------------- tidyverse_conflicts() --
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()

# see the first 10 field-value pairs of Cholera documents
searchnlm(term = "cholera", retmax = 10)
#> # A tibble: 130 x 4
#>   name    value                                      rank  url                  
#>   <chr>   <chr>                                      <chr> <chr>                
#> 1 date    "1881"                                     0     https://resource.nlm~
#> 2 title   "The homoeopathic therapeutics of diarrho~ 0     https://resource.nlm~
#> 3 title   "Therapeutics of diarrhoea"                0     https://resource.nlm~
#> 4 creator "Bell, James B. (James Bachelder), 1838-1~ 0     https://resource.nlm~
#> 5 subject "Diarrhea -- drug therapy"                 0     https://resource.nlm~
#> # ... with 125 more rows

# see the first 100 Cholera documents with the possibility of duplicated fields in the form of list-cols
searchnlm(term = "cholera", retmax = 100, output = "wide")
#> # A tibble: 100 x 16
#> # Groups:   rank, url [100]
#>   rank  url   date  title creator subject description Publication contributor
#>   <chr> <chr> <lis> <lis> <list>  <list>  <list>      <list>      <list>     
#> 1 0     http~ <chr~ <chr~ <chr [~ <chr [~ <chr [1]>   <chr [1]>   <chr [1]>  
#> 2 1     http~ <chr~ <chr~ <chr [~ <chr [~ <chr [1]>   <chr [1]>   <NULL>     
#> 3 2     http~ <chr~ <chr~ <chr [~ <chr [~ <NULL>      <chr [1]>   <NULL>     
#> 4 3     http~ <chr~ <chr~ <chr [~ <chr [~ <NULL>      <chr [1]>   <NULL>     
#> 5 4     http~ <chr~ <chr~ <NULL>  <chr [~ <NULL>      <chr [1]>   <NULL>     
#> # ... with 95 more rows, and 7 more variables: format <list>,
#> #   identifier <list>, language <list>, rights <list>, snippet <list>,
#> #   type <list>, coverage <list>

# query the NLM database for documents pertaining to Cholera and drop duplicated fields
searchnlm(term = "cholera", retmax = 10000, output = "wide", collapse_to_first = TRUE)
#> # A tibble: 2,000 x 17
#> # Groups:   rank, url [2,000]
#>   rank  url   date  title creator subject description Publication contributor
#>   <chr> <chr> <chr> <chr> <chr>   <chr>   <chr>       <chr>       <chr>      
#> 1 0     http~ 1881  "The~ Bell, ~ "Diarr~ 2nd ed. / ~ New York :~ Laird, W. ~
#> 2 1     http~ 1888  "The~ Bell, ~ "Diarr~ 3rd ed      Philadelph~ <NA>       
#> 3 2     http~ 1870  "The~ Bell, ~ "Gastr~ <NA>        New York, ~ <NA>       
#> 4 3     http~ 1893  "The~ Majumd~ "<span~ <NA>        Philadelph~ <NA>       
#> 5 4     http~ 1884  "How~ <NA>    "<span~ <NA>        London : G~ <NA>       
#> # ... with 1,995 more rows, and 8 more variables: format <chr>,
#> #   identifier <chr>, language <chr>, rights <chr>, snippet <chr>, type <chr>,
#> #   coverage <chr>, relation <chr>
```
