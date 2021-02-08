context("knitr")

test_that("can run knitr hook", {
  tmp <- tempfile()
  dir.create(tmp)
  file.copy(
    system.file("knitr_example.Rmd", package = "stegasaur", mustWork = TRUE),
    tmp)

  e <- new.env(parent = topenv())
  with_dir(tmp, knitr::knit("knitr_example.Rmd", quiet = TRUE, envir = e))
  path <- dir(tmp, recursive = TRUE, pattern = "\\.png", ignore.case = TRUE)
  expect_length(path, 1)
  expect_equal(
    decode(file.path(tmp, path)),
    "plot(sample(100))")
})
