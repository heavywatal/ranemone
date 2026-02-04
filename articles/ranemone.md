# ranemone

## Installation

You can install the development version from
[GitHub](https://github.com/):

``` r
# install.packages("pak")
pak::pak("heavywatal/ranemone")
```

Use the same command from time to time to update the package.

## Usage

``` r
library(ranemone)
```

## Download data

ranemone provides a function to download data files recursively from
[ANEMONE DB](https://db.anemone.bio/) in the same way as instructed on
the website. Use `ranemone.directory_prefix` option to specify an
existing data tree or a new destination for downloading.

``` r
options(ranemone.directory_prefix = "~/db")
ranemone::directory_prefix()
```

Authentication requires your username and a temporary password generated
in [ANEMONE DB](https://db.anemone.bio/).

``` r
options(ranemone.user = "your-username")
options(ranemone.password = "generated-password") # not yours

ranemone::wget_recursive("dist/MiFish/ANEMONE/")
```

This command tries not to overwrite existing files.

## Read files

[ANEMONE DB](https://db.anemone.bio/) consists of many small files. It
can take time to list and read them all. This package provides a caching
mechanism to speed up the process for repeated use. You can check and
change the cache directory as follows:

``` r
ranemone::cache_dir()
options(ranemone.cache_dir = "~/.cache/ranemone")
ranemone::cache_dir()
```

Read all files with the given file name recursively in
[`directory_prefix()`](https://heavywatal.github.io/ranemone/reference/path.md).

``` r
sample_df = ranemone::read_tsv_xz("sample.tsv.xz")
experiment_df = ranemone::read_tsv_xz("experiment.tsv.xz")
community_df = ranemone::read_tsv_xz("community_qc3nn_target.tsv.xz")
```

The results are cached in
[`cache_dir()`](https://heavywatal.github.io/ranemone/reference/cache-dir.md),
which makes subsequent calls faster.

``` r
fs::dir_ls(ranemone::cache_dir())
```
