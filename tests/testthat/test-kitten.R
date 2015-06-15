context("kitten")

test_that("download", {
  dest <- kitten(200, 300, quiet=TRUE)
  expect_that(file.exists(dest), is_true())
  img <- jpeg::readJPEG(dest)
  expect_that(img, is_a("array"))
  expect_that(dim(img), equals(c(300, 200, 3)))
})
