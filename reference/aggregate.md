# Summarize community data by species, genus, family, etc.

`ncopiesperml` is summed for in each sample. Species whose names contain
"unidentified" are removed by default.

## Usage

``` r
summarize_ncopies(community_df, .by = .data$species, rm_unidentified = TRUE)

pivot_wider_ncopies(community_df, .by = .data$species, rm_unidentified = TRUE)
```

## Arguments

- community_df:

  A community data frame, e.g., output of
  `ranemone::read_tsv_xz("community_qc3nn_target.tsv.xz")`.

- .by:

  Columns by which to summarize, e.g., `species`, `genus`, and/or
  `family`.

- rm_unidentified:

  A logical value indicating whether to remove "unidentified" species.

## Value

`summarize_ncopies()` returns a data frame in longer format.

`pivot_wider_ncopies()` returns a community composition matrix in wider
format (samples x species).

## Examples

``` r
if (FALSE) { # \dontrun{
community_df = ranemone::read_tsv_xz("community_qc3nn_target.tsv.xz")
species_df = ranemone::summarize_ncopies(community_df, .by = species)
genus_df = ranemone::summarize_ncopies(community_df, .by = genus, rm_unidentified = FALSE)

species_mat = ranemone::pivot_wider_ncopies(community_df, .by = species)
family_mat = ranemone::pivot_wider_ncopies(community_df, .by = family, rm_unidentified = FALSE)
} # }
```
