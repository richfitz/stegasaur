context("lsb")

test_that("basic use", {
  img <- png::readPNG(system.file("img/Rlogo.png", package="png"))
  txt <- "hello from stegasaur"

  img2 <- lsb_encode(txt, img)
  expect_that(lsb_decode(img2), equals(txt))

  path <- tempfile(fileext=".png")
  png::writePNG(img2, path)

  img3 <- png::readPNG(path)
  expect_that(lsb_decode(img3), equals(txt))
})

test_that("store object", {
  img <- png::readPNG(system.file("img/Rlogo.png", package="png"))
  x <- 1:10

  img2 <- lsb_encode(x, img)
  expect_that(lsb_decode(img2), is_identical_to(x))

  path <- tempfile(fileext=".png")
  png::writePNG(img2, path)
  img3 <- png::readPNG(path)
  expect_that(lsb_decode(img3), equals(x))
})
