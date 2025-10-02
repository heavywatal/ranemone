test_that("wget works", {
  expect_error(wget_recursive(user = NULL, password = "not-null"), "user")
  expect_error(wget_recursive(user = "not-null", password = NULL), "password")
})
