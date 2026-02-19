#' Calculate alpha diversity indices
#'
#' Alpha diversity indices are calculated using `ncopiesperml` as a proxy of abundances.
#'
#' The output from these two functions should be equivalent given the same input.
#' `summarize_alpha_diversity()` operates in a tidyverse style with longer data frames,
#' while `calc_alpha_div()` operates on a community composition matrix in wider format
#' using the [vegan](https://cran.r-project.org/package=vegan) package.
#' @param species_df A data frame summarized by species,
#'   e.g., output of [summarize_ncopies()].
#' @param .by Passed to [dplyr::summarize()].
#' @param .groups Passed to [dplyr::summarize()].
#' @returns A data frame with alpha diversity indices.
#' @rdname diversity
#' @export
#' @examples
#' \dontrun{
#' species_df = ranemone::summarize_ncopies(community_df, .by = species)
#' res1 = ranemone::summarize_alpha_diversity(species_df)
#'
#' species_mat = ranemone::pivot_wider_ncopies(community_df, .by = species)
#' res2 = ranemone::calc_alpha_div(species_mat)
#'
#' stopifnot(all.equal(res1, res2))
#' }
summarize_alpha_diversity = function(
  species_df,
  .by = .data$samplename,
  .groups = NULL
) {
  species_df |>
    dplyr::summarize(
      y = calc_alpha(.data$ncopiesperml),
      .by = {{ .by }},
      .groups = .groups
    ) |>
    tidyr::unpack(.data$y) |>
    dplyr::mutate(
      invsimpson = 1 / (1 - .data$simpson),
      pielou = dplyr::if_else(
        .data$richness > 1,
        .data$shannon / log(.data$richness),
        NA_real_
      )
    )
}

calc_alpha = function(x) {
  total = sum(x)
  if (total > 0) {
    p = x / total
    data.frame(
      richness = sum(x > 0),
      shannon = -sum(p * log(p)),
      simpson = 1 - sum(p^2)
    )
  } else {
    data.frame(richness = 0L, shannon = 0, simpson = 1)
  }
}

#' @param mat A community composition matrix (samples x species),
#'   e.g., output of [pivot_wider_ncopies()].
#' @rdname diversity
#' @export
calc_alpha_div = function(mat) {
  richness = vegan::specnumber(mat)
  shannon = vegan::diversity(mat, index = "shannon")
  data.frame(
    samplename = rownames(mat),
    richness = richness,
    shannon = shannon,
    simpson = vegan::diversity(mat, index = "simpson"),
    invsimpson = vegan::diversity(mat, index = "invsimpson"),
    pielou = dplyr::if_else(richness > 1, shannon / log(richness), NA_real_)
  ) |>
    tibble::new_tibble()
}
