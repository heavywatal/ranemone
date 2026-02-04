# Read files recursively in the ANEMONE DB data directory.

ANEMONE DB contains a large collection of small tables, and this package
provides efficient ways to read and process them. It may take a while to
run them for the first time, but subsequent runs will be very quick
because the results are cached.

## Usage

``` r
read_tsv_xz(filename, compress = NULL, ..., limit = 250L, force = FALSE)
```

## Arguments

- filename:

  A filename to read. Files are searched recursively in the path
  returned by
  [`directory_prefix()`](https://heavywatal.github.io/ranemone/reference/path.md).
  It should be one of the following:

  - `community_qc3nn_target.tsv.xz`

  - `community_qc_target.tsv.xz`

  - `community_standard.tsv.xz`

  - `experiment.tsv.xz`

  - `sample.tsv.xz`

- compress:

  Compression method to use: "gz", "bz2", "xz" or "". If `NULL`
  (default), the same one as the input file is used.

- ...:

  Additional arguments passed to
  [`readr::read_tsv()`](https://readr.tidyverse.org/reference/read_delim.html).

- limit:

  Maximum number of files to read at once.

- force:

  Set to `TRUE` to ignore and overwrite existing files in
  [`cache_dir()`](https://heavywatal.github.io/ranemone/reference/cache-dir.md).

## Value

A concatenated data frame.

## See also

<https://db.anemone.bio/about-data/>

## Examples

``` r
if (FALSE) { # \dontrun{
ranemone::read_tsv_xz("sample.tsv.xz")
ranemone::read_tsv_xz("experiment.tsv.xz")
ranemone::read_tsv_xz("community_qc3nn_target.tsv.xz")
} # }
```
