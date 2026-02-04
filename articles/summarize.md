# Summarizing data

## Setup

Load packages. [tidyverse](https://www.tidyverse.org/) is a collection
of useful packages for data science.

``` r
# install.packages("pak")
# pak::pak("tidyverse")
library(conflicted) # for safety
library(tidyverse)
library(ranemone)
```

Set options for your data and cache directories. See the [Get
started](https://heavywatal.github.io/ranemone/articles/ranemone.md)
page for details.

``` r
options(ranemone.directory_prefix = "~/db")
options(ranemone.cache_dir = "~/.cache/ranemone")
```

## Reading files

Read all files with the given file name recursively in
[`directory_prefix()`](https://heavywatal.github.io/ranemone/reference/path.md).

``` r
sample_df = ranemone::read_tsv_xz("sample.tsv.xz")
experiment_df = ranemone::read_tsv_xz("experiment.tsv.xz")
community_df = ranemone::read_tsv_xz("community_qc3nn_target.tsv.xz")
```

## Using community tables

The community table contains many columns. You may want to select a
smaller number of columns for analysis.

``` r
dim(community_df)
str(community_df)

comm = community_df |>
  dplyr::select(samplename, family, genus, species, sequence, nreads, ncopiesperml)

dim(comm)
str(comm)
print(comm)
```

Alpha diversity can be calculated using the `ncopiesperml` column after
aggregating them for each species in each sample.

``` r
species_df = community_df |>
  ranemone::summarize_ncopies(.by = species)

dim(species_df)
str(species_df)
print(species_df)

ranemone::summarize_alpha_diversity(species_df)
```

You can replace `species` with `genus`, `family`, or other levels as
needed.

## Making community composition tables

A community composition matrix in wider format is also supported.

``` r
species_mat = community_df |>
  ranemone::pivot_wider_ncopies(.by = species)

ranemone::calc_alpha_div(species_mat)
```
