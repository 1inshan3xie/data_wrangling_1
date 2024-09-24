Tidy Data
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
library(haven)
```

``` r
pulse_df = 
  haven::read_sas("./data/public_pulse_data.sas7bdat") |>
  janitor::clean_names()
```

This needs to go from wide to long format

``` r
pulse_tidy_df = 
  pivot_longer(
    pulse_df, 
    bdi_score_bl:bdi_score_12m,
    names_to = "visit", 
    values_to = "bdi",
    names_prefix = "bdi_score_"
    ) |>
  mutate(
    visit = replace(visit, visit == "bl" , "00m")
  ) |> ##把bl改成00m
  relocate(id, visit)
```

example of litters wide

``` r
litters_wide = 
  read_csv(
    "./data/FAS_litters.csv",
    na = c("NA", ".", "")) |>
  janitor::clean_names() |>
  select(litter_number, ends_with("weight")) |> 
  pivot_longer(
    gd0_weight:gd18_weight,
    names_to = "gd", 
    values_to = "weight") |> 
  mutate(
    gd = case_match(
      gd,
      "gd0_weight"  ~ 0,
      "gd18_weight" ~ 18
    ))
```

    ## Rows: 49 Columns: 8
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (2): Group, Litter Number
    ## dbl (6): GD0 weight, GD18 weight, GD of Birth, Pups born alive, Pups dead @ ...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

pivot_wider 相当于pivot_wide的反函数

``` r
analysis_result = 
  tibble(
    group = c("treatment", "treatment", "placebo", "placebo"),
    time = c("pre", "post", "pre", "post"),
    mean = c(4, 8, 3.5, 4)
  )
analysis_result
```

    ## # A tibble: 4 × 3
    ##   group     time   mean
    ##   <chr>     <chr> <dbl>
    ## 1 treatment pre     4  
    ## 2 treatment post    8  
    ## 3 placebo   pre     3.5
    ## 4 placebo   post    4

``` r
# to make it less tidy
pivot_wider(
  analysis_result, 
  names_from = "time", 
  values_from = "mean")
```

    ## # A tibble: 2 × 3
    ##   group       pre  post
    ##   <chr>     <dbl> <dbl>
    ## 1 treatment   4       8
    ## 2 placebo     3.5     4

``` r
fellowship_ring = 
  readxl::read_excel("./data/LotR_Words.xlsx", range = "B3:D6") |>
  mutate(movie = "fellowship_ring")

two_towers = 
  readxl::read_excel("./data/LotR_Words.xlsx", range = "F3:H6") |>
  mutate(movie = "two_towers")

return_king = 
  readxl::read_excel("./data/LotR_Words.xlsx", range = "J3:L6") |>
  mutate(movie = "return_king")

lotr_df =
  bind_rows(fellowship_ring , two_towers, return_king) |>
  janitor::clean_names() |>
  pivot_longer(
    female:male,
    names_to = "gender", 
    values_to = "words") |>
  mutate(race = str_to_lower(race)) |> 
  select(movie, everything()) 
```

## 加入数据集

第一个数据集

``` r
pup_df = 
  read_csv(
    "./data/FAS_pups.csv",
    na = c("NA", "", ".")) |>
  janitor::clean_names() |>
  mutate(
    sex = 
      case_match(
        sex, 
        1 ~ "male", 
        2 ~ "female"),
    sex = as.factor(sex)) 
```

    ## Rows: 313 Columns: 6
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (1): Litter Number
    ## dbl (5): Sex, PD ears, PD eyes, PD pivot, PD walk
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

第二个数据集

``` r
litter_df = 
  read_csv(
    "./data/FAS_litters.csv",
    na = c("NA", ".", "")) |>
  janitor::clean_names() |>
  separate(group, into = c("dose", "day_of_tx"), sep = 3) |>
  relocate(litter_number) |>
  mutate(
    wt_gain = gd18_weight - gd0_weight,
    dose = str_to_lower(dose))
```

    ## Rows: 49 Columns: 8
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (2): Group, Litter Number
    ## dbl (6): GD0 weight, GD18 weight, GD of Birth, Pups born alive, Pups dead @ ...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

将两个数据集合并

``` r
fas_df = 
  left_join(pup_df, litter_df, by = "litter_number") |>
  relocate(litter_number, dose, day_of_tx ) #调整表格内部顺序

fas_df
```

    ## # A tibble: 313 × 15
    ##    litter_number dose  day_of_tx sex   pd_ears pd_eyes pd_pivot pd_walk
    ##    <chr>         <chr> <chr>     <fct>   <dbl>   <dbl>    <dbl>   <dbl>
    ##  1 #85           con   7         male        4      13        7      11
    ##  2 #85           con   7         male        4      13        7      12
    ##  3 #1/2/95/2     con   7         male        5      13        7       9
    ##  4 #1/2/95/2     con   7         male        5      13        8      10
    ##  5 #5/5/3/83/3-3 con   7         male        5      13        8      10
    ##  6 #5/5/3/83/3-3 con   7         male        5      14        6       9
    ##  7 #5/4/2/95/2   con   7         male       NA      14        5       9
    ##  8 #4/2/95/3-3   con   7         male        4      13        6       8
    ##  9 #4/2/95/3-3   con   7         male        4      13        7       9
    ## 10 #2/2/95/3-2   con   7         male        4      NA        8      10
    ## # ℹ 303 more rows
    ## # ℹ 7 more variables: gd0_weight <dbl>, gd18_weight <dbl>, gd_of_birth <dbl>,
    ## #   pups_born_alive <dbl>, pups_dead_birth <dbl>, pups_survive <dbl>,
    ## #   wt_gain <dbl>
