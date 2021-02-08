context("kitten")

test_that("download", {
  testthat::skip_if_offline()
  dest <- kitten(200, 300, quiet = TRUE)
  expect_true(file.exists(dest))
  img <- jpeg::readJPEG(dest)
  expect_is(img, "array")
  expect_equal(dim(img), c(300, 200, 3))
})
