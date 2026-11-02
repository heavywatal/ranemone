#' Get the prefix path to the ANEMONE DB data directory.
#'
#' `directory_prefix()` reads the `ranemone.directory_prefix` option set by users,
#' and is used for downloading and reading public files.
#' It should be a persistent directory with easy access, such as `~/db`,
#' not a temporary directory like [tempdir()].
#'
#' If not set, it falls back to the `extdata/directory_prefix` in the package
#' installation directory, which is mainly for testing and examples.
#'
#' `directory_prefix_local()` reads the `ranemone.directory_prefix_local` option
#' set by users to read local files not available in the public ANEMONE DB.
#' @returns A path read from the option.
#' @rdname path
#' @export
#' @examples
#' old = options(
#'   ranemone.directory_prefix = "prefix/path/to/public/data",
#'   ranemone.directory_prefix_local = "prefix/path/to/local/data"
#' )
#' ranemone::directory_prefix()
#' ranemone::directory_prefix_local()
#'
#' options(old) # reset for this example, not needed in real use
directory_prefix = function() {
  extdata = system.file("extdata", "directory_prefix", package = "ranemone")
  fs::path(getOption("ranemone.directory_prefix", extdata))
}

#' @rdname path
#' @export
directory_prefix_local = function() {
  fs::path(getOption("ranemone.directory_prefix_local"))
}

data_path = function() {
  x = c(directory_prefix(), directory_prefix_local())
  y = x / "db.anemone.bio"
  ifelse(fs::dir_exists(y), y, x)
}
