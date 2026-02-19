#' Summarize community data by species, genus, family, etc.
#'
#' `ncopiesperml` is summed for in each sample.
#' Species whose names contain "unidentified" are removed by default.
#' @param community_df A community data frame,
#'   e.g., output of `ranemone::read_tsv_xz("community_qc3nn_target.tsv.xz")`.
#' @param .by Columns by which to summarize, e.g., `species`, `genus`, and/or `family`.
#' @param rm_unidentified A logical value indicating whether to remove "unidentified" species.
#' @returns `summarize_ncopies()` returns a data frame in longer format.
#' @rdname aggregate
#' @export
#' @examples
#' \dontrun{
#' community_df = ranemone::read_tsv_xz("community_qc3nn_target.tsv.xz")
#' species_df = ranemone::summarize_ncopies(community_df, .by = species)
#' genus_df = ranemone::summarize_ncopies(community_df, .by = genus, rm_unidentified = FALSE)
#'
#' species_mat = ranemone::pivot_wider_ncopies(community_df, .by = species)
#' family_mat = ranemone::pivot_wider_ncopies(community_df, .by = family, rm_unidentified = FALSE)
#'
#' taxonomy = ranemone::distinct_taxonomy(community_df)
#' }
summarize_ncopies = function(
  community_df,
  .by = .data$species,
  rm_unidentified = TRUE
) {
  if (rm_unidentified) {
    community_df = remove_unidentified(community_df)
  }
  dplyr::summarize(
    community_df,
    ncopiesperml = sum(.data$ncopiesperml, na.rm = TRUE),
    .by = c(.data$samplename, {{ .by }})
  )
}

#' @returns `pivot_wider_ncopies()` returns a community composition matrix
#'   in wider format (samples x species).
#' @rdname aggregate
#' @export
pivot_wider_ncopies = function(
  community_df,
  .by = .data$species,
  rm_unidentified = TRUE
) {
  if (rm_unidentified) {
    community_df = remove_unidentified(community_df)
  }
  tidyr::pivot_wider(
    community_df,
    id_cols = .data$samplename,
    names_from = {{ .by }},
    names_sort = TRUE,
    values_from = .data$ncopiesperml,
    values_fill = 0,
    values_fn = \(x) sum(x, na.rm = TRUE)
  ) |>
    tibble::column_to_rownames("samplename") |>
    as.matrix()
}

#' @rdname aggregate
#' @export
distinct_taxonomy = function(community_df, rm_unidentified = TRUE) {
  if (rm_unidentified) {
    community_df = remove_unidentified(community_df)
  }
  dplyr::distinct(community_df, !!!rlang::data_syms(.ranks))
}

.ranks = c(
  "kingdom",
  "phylum",
  "class",
  "cohort",
  "order",
  "family",
  "genus",
  "species"
)

remove_unidentified = function(community_df) {
  dplyr::filter(community_df, !stringr::str_detect(.data$species, "unidentified"))
}
