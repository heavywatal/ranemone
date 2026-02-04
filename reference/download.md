# Download data from ANEMONE DB

`wget` is used to download data files recursively from ANEMONE DB. Your
user name and a temporary password generated in the website are
required.

## Usage

``` r
wget_recursive(
  rel_url = "dist/",
  opts = c("--reject=.fastq.xz,.png", "--no-verbose"),
  ...,
  user = getOption("ranemone.user"),
  password = getOption("ranemone.password")
)
```

## Arguments

- rel_url:

  A relative URL from the server root. If a directory is given, it
  should end with a slash `/` for `--no-parent` to work as expected.

- opts:

  Additional options passed to `wget`.
  `--recursive --level=0 --no-parent --continue` are preset.
  `--directory-prefix` is set from
  [`directory_prefix()`](https://heavywatal.github.io/ranemone/reference/path.md).
  `--http-user` and `--http-password` are set from `user` and `password`
  arguments, respectively. Currently `-N/--timestamping` does not work
  with the server: "Last-modified header missing – time-stamps turned
  off."

- ...:

  Additional arguments passed to
  [`base::system2()`](https://rdrr.io/r/base/system2.html).

- user:

  Your ANEMONE DB user name. Setting it via
  `options(ranemone.user = "_")` will be easier for repeated use.

- password:

  "Data Download Password" generated in the "Member Menu \> Settings \>
  Data Download" page, not your login password. Setting it via
  `options(ranemone.password = "_")` will be easier for repeated use.

## Value

The return value of
[`base::system2()`](https://rdrr.io/r/base/system2.html).

## Details

The directory tree starting from `db.anemone.bio/` will be created under
[`directory_prefix()`](https://heavywatal.github.io/ranemone/reference/path.md)
according to the default behavior of `wget -r`, which is assumed by
other functions in this package.

## See also

<https://db.anemone.bio/how-to-download-data/>,
<https://www.gnu.org/software/wget/manual/wget.html>

## Examples

``` r
if (FALSE) { # \dontrun{
options(ranemone.directory_prefix = "prefix/path/to/data")
options(ranemone.user = "your-username")
options(ranemone.password = "generated-password") # not yours

ranemone::wget_recursive("dist/MiFish/ANEMONE/2023KibanS/2023KibanSRUN01/")

fs::dir_ls(directory_prefix()) # "db.anemone.bio"
} # }
```
