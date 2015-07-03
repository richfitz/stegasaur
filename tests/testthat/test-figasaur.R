context("figasaur")

test_that("recover plot code", {
  dest <- tempfile("testpng",fileext=".png")
  figasaur({plot(sample(100))}, dest)
  expect_equal(decode(dest),"{\n    plot(sample(100))\n}\n")
})
