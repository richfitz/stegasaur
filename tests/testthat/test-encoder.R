context("jpeg_encoder")

test_that("load", {
  image <- jpeg::readJPEG("origin.jpg")
  obj <- jpeg_info(image)
})
