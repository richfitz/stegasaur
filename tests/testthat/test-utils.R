context("utils")

test_that("can wrap around reading jpeg files", {
  path <- stegasaur_file("man_with_cats.jpg")
  tmp <- tempfile(fileext = ".JPEG")
  file.copy(path, tmp)
  on.exit(unlink(tmp))
  expect_identical(read_img(path), jpeg::readJPEG(path))
  expect_identical(read_img(tmp), jpeg::readJPEG(path))
})


test_that("Don't read unknown formats", {
  expect_error(
    read_img(stegasaur_file("knitr_example.Rmd")),
    "Unknown format 'Rmd'")
})
