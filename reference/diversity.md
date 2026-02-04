# Calculate alpha diversity indices

Alpha diversity indices are calculated using `ncopiesperml` as a proxy
of abundances.

## Usage

``` r
summarize_alpha_diversity(species_df, .by = .data$samplename, .groups = NULL)

calc_alpha_div(mat)
```

## Arguments

- species_df:

  A data frame summarized by species, e.g., output of
  [`summarize_ncopies()`](https://heavywatal.github.io/ranemone/reference/aggregate.md).

- .by:

  Passed to
  [`dplyr::summarize()`](https://dplyr.tidyverse.org/reference/summarise.html).

- .groups:

  Passed to
  [`dplyr::summarize()`](https://dplyr.tidyverse.org/reference/summarise.html).

- mat:

  A community composition matrix (samples x species), e.g., output of
  [`pivot_wider_ncopies()`](https://heavywatal.github.io/ranemone/reference/aggregate.md).

## Value

A data frame with alpha diversity indices.

## Details

The output from these two functions should be equivalent given the same
input. `summarize_alpha_diversity()` operates in a tidyverse style with
longer data frames, while `calc_alpha_div()` operates on a community
composition matrix in wider format using the
[vegan](https://cran.r-project.org/package=vegan) package.

## Examples

``` r
if (FALSE) { # \dontrun{
species_df = ranemone::summarize_ncopies(community_df, .by = species)
res1 = ranemone::summarize_alpha_diversity(species_df)

species_mat = ranemone::pivot_wider_ncopies(community_df, .by = species)
res2 = ranemone::calc_alpha_div(species_mat)

stopifnot(all.equal(res1, res2))
} # }
```
