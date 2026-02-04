# Get the prefix path to the ANEMONE DB data directory.

`directory_prefix()` reads the `ranemone.directory_prefix` option set by
users, and is used for downloading and reading files. It should be a
persistent directory with easy access, such as `~/db`, not a temporary
directory like [`tempdir()`](https://rdrr.io/r/base/tempfile.html).

## Usage

``` r
directory_prefix()
```

## Value

A path read from the option.

## Details

If not set, it falls back to the `extdata/directory_prefix` in the
package installation directory, which is mainly for testing and
examples.

## Examples

``` r
old = options(ranemone.directory_prefix = "prefix/path/to/data")

ranemone::directory_prefix()
#> prefix/path/to/data

options(old) # reset for this example, not needed in real use
```
