#' Utilities for FishBase data fetching and caching
#'
#' Call [rfishbase::fb_tbl()] to fetch data from [FishBase](https://www.fishbase.se/)
#' and cache the result in [cache_dir()].
#'
#' Note that some species have duplicated rows in ecology table,
#' which is resolved in `fb_species_ecology_estimate()`.
#' @param tbl,... Passed to `rfishbase::fb_tbl()`.
#' @param force Set to `TRUE` to ignore and overwrite existing cached files in [cache_dir()].
#' @returns A data frame.
#' @rdname fishbase
#' @export
#' @examples
#' \dontrun{
#' fb_species_ecology_estimate()
#'
#' fb_species = read_fb_tbl("species")
#' fb_ecology = read_fb_tbl("ecology")
#' fb_estimate = read_fb_tbl("estimate")
#' }
read_fb_tbl = function(tbl, ..., force = FALSE) {
  cache_file = cache_dir() / paste0("fb_", tbl, ".tsv.gz")
  if (force || !fs::file_exists(cache_file)) {
    x = rfishbase::fb_tbl(tbl, ...)
    if (tbl == "species") {
      x = x |>
        dplyr::mutate(
          FBname = stringr::str_remove(.data$FBname, "[\\r\\n]+.+"),
          Remark = stringr::str_replace_all(.data$Remark, "\\s+", " "),
          Comments = stringr::str_replace_all(.data$Comments, "\\s+", " "),
          Profile = stringr::str_replace_all(.data$Profile, "\\s+", " ")
        )
    } else if (tbl == "ecology") {
      x = x |>
        dplyr::mutate(
          DietRemark = stringr::str_trim(.data$DietRemark),
          AddRems = stringr::str_replace_all(.data$AddRems, "\\s+", " "),
          AssociationsWith = stringr::str_replace_all(
            .data$AssociationsWith,
            "\\s+",
            " "
          ),
          AssociationsRemarks = stringr::str_replace_all(
            .data$AssociationsRemarks,
            "\\s+",
            " "
          )
        )
    }
    fs::dir_create(fs::path_dir(cache_file))
    readr::write_tsv(x, cache_file, na = "")
  }
  .cols = NULL
  if (tbl == "species") {
    .cols = readr::cols(EggPic = "c", LifeCycle = "c", Profile = "c")
  } else if (tbl == "ecology") {
    .cols = readr::cols(
      OHRemarks = "c",
      IHRemarks = "c",
      OIRemarks = "c",
      Circadian3 = "c",
      BioAspect3 = "c"
    )
  }
  readr::read_tsv(cache_file, col_types = .cols)
}

#' @returns `fb_species_ecology_estimate()` selects essential columns from
#'   "species", "ecology", and "estimate" tables.
#' @rdname fishbase
#' @export
fb_species_ecology_estimate = function(..., force = FALSE) {
  fb_species = read_fb_tbl("species", ..., force = force) |>
    dplyr::select(.fb_species_cols)
  fb_ecology = read_fb_tbl("ecology", ..., force = force) |>
    dplyr::select(.fb_ecology_cols) |>
    dplyr::summarize(
      dplyr::across(dplyr::everything(), unique_non_na),
      .by = .data$SpecCode
    )
  fb_estimate = read_fb_tbl("estimate", ..., force = force) |>
    dplyr::select(.fb_estimate_cols)
  res = fb_species |>
    dplyr::left_join(fb_ecology, by = "SpecCode") |>
    dplyr::left_join(fb_estimate, by = "SpecCode")
  res
}

unique_non_na = function(x) {
  x = unique(stats::na.omit(x))
  if (length(x) == 0L) {
    return(NA)
  } else if (length(x) == 1L) {
    return(x)
  }
  if (is.numeric(x)) {
    mean(x[x != 0])
  } else if (is.character(x)) {
    paste(x, collapse = "; ")
  } else if (inherits(x, "POSIXt")) {
    max(x)
  } else {
    x
  }
}

.fb_species_cols = c(
  "SpecCode",
  "Genus",
  "Species",
  "FBname",
  "BodyShapeI",
  "DemersPelag",
  "Vulnerability",
  "VulnerabilityClimate",
  "Length",
  "Importance",
  "PriceCateg",
  "UsedforAquaculture",
  "UsedasBait",
  "Aquarium"
)

.fb_ecology_cols = c(
  "SpecCode",
  "DietTroph",
  "DietSeTroph",
  "FoodTroph",
  "FoodSeTroph"
)

.fb_estimate_cols = c(
  "SpecCode",
  "TempPrefMean",
  "TempPrefMax",
  "TempPrefMin"
)
