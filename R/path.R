#' Get the path to the ANEMONE DB data directory.
#'
#' Set `ranemone.data_path` option to specify the path to the directory
#' containing ANEMONE DB data files, and use `data_path()` to get it.
#' It is used internally by other functions to locate the data files.
#' @returns A path read from the option.
#' @rdname path
#' @export
#' @examples
#' old = options(ranemone.data_path = "path/to/your/data")
#'
#' ranemone::data_path()
#'
#' options(old) # reset for this example, not needed in real use
data_path = function() {
  extdata = system.file("extdata", "data_path", package = "ranemone")
  fs::path(getOption("ranemone.data_path", extdata))
}
