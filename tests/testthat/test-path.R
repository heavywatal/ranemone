test_that("directory_prefix works", {
  temp = fs::path(tempdir())
  withr::with_options(
    list(ranemone.directory_prefix = temp),
    expect_identical(directory_prefix(), temp)
  )
  extdata = fs::path(system.file("extdata", "directory_prefix", package = "ranemone"))
  withr::with_options(
    list(ranemone.directory_prefix = NULL),
    expect_identical(directory_prefix(), extdata)
  )
})
