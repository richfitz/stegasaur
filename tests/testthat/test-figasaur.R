context("figasaur")

test_that("recover plot code", {
  dest <- tempfile("testpng", fileext = ".png")
  figasaur(plot(sample(100)), dest)
  expect_match(decode(dest), "plot(sample(100))",
               fixed = TRUE)
})
