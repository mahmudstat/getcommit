
<!-- README.md is generated from README.Rmd. Please edit that file -->

# getcommit

<!-- badges: start -->

<!-- badges: end -->

The goal of **getcommit** is to provide a simple interface for
retrieving commit history from GitHub repositories and analyzing
developer activity over time.

With **getcommit**, you can:  
- Fetch recent commits from any public GitHub repository.  
- Filter commits by branch, date range, or number of commits.  
- Export commit history to a tidy data frame or CSV.  
- Visualize commit activity (e.g., by date, author, or time of day) in
R.

## Installation

You can install the development version of getcommit from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("mahmudstat/getcommit")
```

## Examples

Let us see some commits from the `dplyr` package of the `tidyverse`
ecosystem.

``` r
library(getcommit)
comm <- get_commits("tidyverse/dplyr", n = 30, from = "2024-05-15", to = "2025-09-02")
head(comm)
#> # A tibble: 6 × 4
#>   author         date                message                               sha  
#>   <chr>          <dttm>              <chr>                                 <chr>
#> 1 Davis Vaughan  2025-07-25 13:22:14 Use finalized `format-suggest.yaml`   384f…
#> 2 Davis Vaughan  2025-07-23 20:01:50 Switch to updated `format-suggest.ya… 4298…
#> 3 Davis Vaughan  2025-07-23 19:54:08 Add current `format-suggest.yaml` wo… 82d3…
#> 4 Davis Vaughan  2025-07-23 19:53:14 Format with Air 0.7.0                 bc9a…
#> 5 Hadley Wickham 2025-05-30 15:43:14 Add kapa ai to navbar (#7684)         be3e…
#> 6 Davis Vaughan  2025-03-03 19:42:02 `use_air()`                           2d87…
```

## Commits by Mahedi Bhai

``` r
library(getcommit)
comm <- get_commits("Mahedi-61/Mahedi-61.github.io", n = 25, from = "2021-01-11", to = "2025-09-02")
head(comm)
#> # A tibble: 6 × 4
#>   author          date                message                     sha           
#>   <chr>           <dttm>              <chr>                       <chr>         
#> 1 Mahedi61        2024-12-02 03:48:58 pub link update             c93b332a308c6…
#> 2 Mahedi61        2024-11-29 06:08:29 updating resume             3044c2483eccd…
#> 3 Mahedi61        2024-11-20 06:39:46 update at Nov 20, 2024 last b103bf803aa54…
#> 4 Mahedi61        2024-11-20 05:51:48 update at Nov 20, 2024      5e2e18f14a526…
#> 5 Mahedi61        2024-11-20 02:58:03 after CVPR'25 submission    05ce3be7d5907…
#> 6 Md Mahedi Hasan 2024-01-05 00:21:11 Update pub.md               c03c75ae01a7b…
```

## Viewing the commits on the clockplot

``` r
library(clockplot)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(hms)
comm <- comm %>%
  mutate(hms = hms::as_hms(date))
# Step 2: Plot with clockplot
clock_chart_qlt(
  comm,
  time = hms,
  crit = author
)
```

<img src="man/figures/README-plot_list-1.png" width="100%" />
