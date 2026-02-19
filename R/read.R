#' Read files recursively in the ANEMONE DB data directory.
#'
#' ANEMONE DB contains a large collection of small tables,
#' and this package provides efficient ways to read and process them.
#' It may take a while to run them for the first time,
#' but subsequent runs will be very quick because the results are cached.
#' @seealso <https://db.anemone.bio/about-data/>
#' @param filename A filename to read.
#' Files are searched recursively in the path returned by [directory_prefix()].
#' It should be one of the following:
#' * `community_qc3nn_target.tsv.xz`
#' * `community_qc_target.tsv.xz`
#' * `community_standard.tsv.xz`
#' * `experiment.tsv.xz`
#' * `sample.tsv.xz`
#' @param compress Compression method to use: "gz", "bz2", "xz" or "".
#' If `NULL` (default), the same one as the input file is used.
#' @param ... Additional arguments passed to [readr::read_tsv()].
#' @param limit Maximum number of files to read at once.
#' @param force Set to `TRUE` to ignore and overwrite existing files in [cache_dir()].
#' @returns A concatenated data frame.
#' @rdname read
#' @export
#' @examples
#' \dontrun{
#' ranemone::read_tsv_xz("sample.tsv.xz")
#' ranemone::read_tsv_xz("experiment.tsv.xz")
#' ranemone::read_tsv_xz("community_qc3nn_target.tsv.xz")
#' }
read_tsv_xz = function(filename, compress = NULL, ..., limit = 250L, force = FALSE) {
  cache_file = cache_dir() / filename
  if (!is.null(compress)) {
    cache_file = fs::path_ext_set(cache_file, compress)
  }
  if (force || !fs::file_exists(cache_file)) {
    x = read_tsv_xz_impl(filename, ..., limit = limit)
    fs::dir_create(fs::path_dir(cache_file))
    readr::write_tsv(x, cache_file, na = "")
  }
  readr::read_tsv(cache_file, ...)
}

read_tsv_xz_impl = function(filename, ..., limit = 250L) {
  if (!(filename %in% .filenames)) {
    warning("filename should be one of ", toString(.filenames), call. = FALSE)
  }
  prefix = call_cache(list_sample_dirs, data_path())
  sample_name = fs::path_file(prefix)
  is_39cols = sample_name %in% .samples39cols # workaround
  x40 = read_many_tsv(prefix[!is_39cols] / filename, ..., limit = limit)
  x39 = readr::read_tsv(prefix[is_39cols] / filename, ...)
  x = dplyr::bind_rows(x40, x39)
  if (filename %in% c("experiment.tsv.xz", "sample.tsv.xz")) {
    x = pivot_wider_key_value(x)
    if ("salinity" %in% names(x)) {
      # workaround for .sample2dots
      x = dplyr::mutate(x, salinity = stringr::str_replace(.data$salinity, "\\.+", "."))
    }
  }
  if ("collection_date" %in% names(x)) {
    # workaround for broken time format
    x = dplyr::mutate(
      x,
      collection_date = stringr::str_replace(.data$collection_date, "T(\\d):", "T0\\1:")
    )
  }
  if ("collection_date_local" %in% names(x)) {
    # workaround for broken time format
    x = dplyr::mutate(
      x,
      collection_date_local = stringr::str_replace(
        .data$collection_date_local,
        "T(\\d):",
        "T0\\1:"
      )
    )
  }
  x
}

list_sample_dirs = function(path = data_path()) {
  fs::dir_ls(path, recurse = TRUE, regexp = "sample\\.tsv\\.xz$") |>
    fs::path_dir() |>
    fs::path()
}

pivot_wider_key_value = function(x) {
  tidyr::pivot_wider(
    x,
    id_cols = "samplename",
    names_from = "key",
    values_from = "value"
  )
}

read_many_tsv = function(file, ..., limit) {
  split_vector(file, size = limit) |>
    purrr::map(\(x) readr::read_tsv(x, ...)) |>
    purrr::list_rbind()
}

split_vector = function(x, size) {
  group = seq.int(0L, length(x) - 1L) %/% size
  unname(split(x, group))
}

.filenames = c(
  "community_qc3nn_target.tsv.xz",
  "community_qc_target.tsv.xz",
  "community_standard.tsv.xz",
  "experiment.tsv.xz",
  "sample.tsv.xz"
)

.samples39cols = c(
  "2019KibanSRUN04__20190314T0500-HUF-Amaharashi-NC__MiFish",
  "2019KibanSRUN04__20190314T0500-HUF-Amaharashi__MiFish",
  "2021NipponYusenRUN01__20210626T0700-NYK-2021-PirikaMosiriMaru-St1-NC__MiFish",
  "2021NipponYusenRUN01__20210626T0700-NYK-2021-PirikaMosiriMaru-St1__MiFish",
  "2021NipponYusenRUN01__20210803T0430-NYK-2021-PirikaMosiriMaru-St4__MiFish",
  "2021NipponYusenRUN01__20210922T0300-NYK-2021-PirikaMosiriMaru-St7-NC__MiFish",
  "2021NipponYusenRUN01__20210922T0300-NYK-2021-PirikaMosiriMaru-St7__MiFish",
  "2021NipponYusenRUN01__20210925T0300-NYK-2021-PirikaMosiriMaru-St8-NC__MiFish",
  "2021NipponYusenRUN01__20210925T0300-NYK-2021-PirikaMosiriMaru-St8__MiFish"
)

# duplicated dots like 3..39 and 3..44
.samples2dots = c(
  "2022KibanSRUN01__20210628T0100-SMB-SugashimaRinkai__MiFish",
  "2020KibanSRUN01__20200702T0530-RUI-Iriomote__MiFish"
)
