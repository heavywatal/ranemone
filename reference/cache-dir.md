# Utilities for caching

Some expensive operations are cached to avoid recomputing them.
Intermediate results are stored in a cache directory. Users can set it
via `ranemone.cache_dir` option. The default is set with
[`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html), which
persists across R sessions.

## Usage

``` r
cache_dir()
```

## Value

`cache_dir()` returns the path to the cache directory.

## Details

General recommendation is to set it to a persistent directory with easy
access, such as `~/.cache/ranemone`, not a temporary directory like
[`tempdir()`](https://rdrr.io/r/base/tempfile.html). Setting it to `NA`
or `FALSE` will make a new temporary directory each time `cache_dir()`
is called, which virtually disables caching (not recommended). You can
share the cache directory with other users on the same machine by
setting it to a common directory, such as `/tmp/ranemone-cache`.

## Examples

``` r
old = options(ranemone.cache_dir = "~/.cache/ranemone-example")

ranemone::cache_dir()
#> ~/.cache/ranemone-example

if (FALSE) { # \dontrun{
# Calculate the size
fs::dir_info(ranemone::cache_dir(), recurse = TRUE)$size |> sum()
} # }

options(old) # reset for this example, not needed in real use
```
