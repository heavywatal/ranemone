test_that("data_path works", {
  temp = fs::path(tempdir())
  withr::with_options(
    list(ranemone.data_path = temp),
    expect_identical(data_path(), temp)
  )
  extdata = fs::path(system.file("extdata", "data_path", package = "ranemone"))
  withr::with_options(
    list(ranemone.data_path = NULL),
    expect_identical(data_path(), extdata)
  )
})
