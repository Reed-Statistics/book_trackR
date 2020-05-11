
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidynlm

<!-- badges: start -->

<!-- badges: end -->

tidynlm provides easy access to the National Library of Medicine API
from within R. The library currently allows the user to create a
dataframe of documents matching a particular search query. The documents
themselves can be accessed with the urls in the `url` column of the
resulting dataframe.

## Installation

You can install the released version of tidynlm from
[GitHub](https://github.com/Reed-Statistics/book_trackR) with:

``` r
# install.packages("devtools")
devtools::install_github("https://github.com/Reed-Statistics/book_trackR")
```

## Cholera Demo

This is a basic example which shows you how to solve a common problem:

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
cholera <- searchnlm(term = "cholera", retmax = 10000, output = "wide", collapse_to_first = TRUE)
cholera %>%
  mutate(dc.date = as.numeric(dc.date)) %>%
  group_by(dc.date) %>%
  count() %>%
  ungroup() %>%
  ggplot(aes(x = dc.date, y = n)) +
  geom_point() +
  xlim(1770, 2020) +
  theme_classic() +
  labs(x = "Year",
       y = "Number of Documents",
       title = "Number of Documents Involving Cholera by Year",
       subtitle = "National Library of Medicine")
#> Warning: Removed 8 rows containing missing values (geom_point).
```

<img src="man/figures/README-example-1.png" width="100%" />
