context("figuredout")

test_that("recover plot code", {
  dest <- tempfile("testpng",fileext=".png")
  figuredout({plot(sample(100))}, dest)
  expect_equal(decode(dest),"{\n    plot(sample(100))\n}\n")
})
