Data import
================

``` r
library(tidyverse)
```

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.1.4     ✔ readr     2.1.5
    ## ✔ forcats   1.0.0     ✔ stringr   1.5.1
    ## ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
    ## ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
    ## ✔ purrr     1.0.2     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
# what we want to use is the readr package -- to import data
```

## Read in some data

use path to open the data set(be specific) there are two ways to open
the files. \* absolute way(from the original folder) \* relative
way(from your current working directory) one good way of relative path
is that anyone who copies this code and data and set their derectory the
same way, the code still work.

Read in a litters dataset.

``` r
litters_df = read.csv("./data/FAS_litters.csv")
litters_df = janitor::clean_names(litters_df)
```

## take a look at the data
