test_that("cache_dir works", {
  temp = fs::path(tempdir())
  withr::with_options(
    list(ranemone.cache_dir = temp),
    expect_identical(cache_dir(), temp)
  )
  withr::with_options(
    list(ranemone.cache_dir = NULL),
    expect_identical(cache_dir(), fs::path(tools::R_user_dir("ranemone", "cache")))
  )
  withr::with_options(
    list(ranemone.cache_dir = ""),
    expect_identical(cache_dir(), fs::path("."))
  )
  withr::with_options(
    list(ranemone.cache_dir = NA),
    expect_identical(fs::path(fs::path_dir(cache_dir())), fs::path(tempdir()))
  )
  withr::with_options(
    list(ranemone.cache_dir = FALSE),
    expect_identical(fs::path(fs::path_dir(cache_dir())), fs::path(tempdir()))
  )
})

test_that("call_cache works", {
  if (exists("print(hello", cache_env())) {
    rm("print(hello", envir = cache_env())
  }
  expect_output(call_cache(print, "hello"), "hello") |>
    expect_identical("hello")
  expect_silent(call_cache(print, "hello")) |>
    expect_identical("hello")
  rm("print(hello", envir = cache_env())
})
