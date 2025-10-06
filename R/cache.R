#' Utilities for caching
#'
#' Some expensive operations are cached to avoid recomputing them.
#' Intermediate results are stored in a cache directory.
#' Users can set it via `ranemone.cache_dir` option.
#' The default is set with [tools::R_user_dir()], which persists across R sessions.
#'
#' General recommendation is to set it to a persistent directory with easy access,
#' such as `~/.cache/ranemone`, not a temporary directory like [tempdir()].
#' Setting it to `NA` or `FALSE` will make a new temporary directory each time
#' [cache_dir()] is called, which virtually disables caching (not recommended).
#' You can share the cache directory with other users on the same machine by
#' setting it to a common directory, such as `/tmp/ranemone-cache`.
#' @returns `cache_dir()` returns the path to the cache directory.
#' @rdname cache-dir
#' @export
#' @examples
#' old = options(ranemone.cache_dir = "~/.cache/ranemone-example")
#'
#' ranemone::cache_dir()
#'
#' \dontrun{
#' # Calculate the size
#' fs::dir_info(ranemone::cache_dir(), recurse = TRUE)$size |> sum()
#' }
#'
#' options(old) # reset for this example, not needed in real use
cache_dir = function() {
  x = getOption("ranemone.cache_dir", tools::R_user_dir("ranemone", "cache"))
  if (is.na(x) || isFALSE(x)) {
    x = tempfile("ranemone-cache")
  } else if (!nzchar(x)) {
    x = "."
  }
  fs::path(x)
}

call_cache = function(.f, .x, ...) {
  f_quo = rlang::enquo(.f)
  f_name = rlang::quo_text(f_quo)
  .key = paste(f_name, .x, sep = "(")
  envir = cache_env()
  if (!exists(.key, envir)) {
    value = .f(.x, ...)
    assign(.key, value, envir)
  }
  get(.key, envir)
}

cache_env = function() {
  if (is.null(asNamespace("ranemone")$.__DEVTOOLS__)) {
    .cache_env
  } else {
    .GlobalEnv
  }
}

.cache_env = new.env(parent = emptyenv())
