context("lsb")

test_that("basic use", {
  img <- png::readPNG(system.file("img/Rlogo.png", package = "png"))
  txt <- "hello from stegasaur"

  img2 <- lsb_encode(txt, img)
  expect_equal(lsb_decode(img2), txt)

  path <- tempfile(fileext = ".png")
  png::writePNG(img2, path)

  img3 <- png::readPNG(path)
  expect_equal(lsb_decode(img3), txt)
})

test_that("store object", {
  img <- png::readPNG(system.file("img/Rlogo.png", package = "png"))
  x <- 1:10

  img2 <- lsb_encode(x, img)
  expect_identical(lsb_decode(img2), x)

  path <- tempfile(fileext = ".png")
  png::writePNG(img2, path)
  img3 <- png::readPNG(path)
  expect_equal(lsb_decode(img3), x)
})


test_that("Require png", {
  img <- png::readPNG(system.file("img/Rlogo.png", package = "png"))
  expect_error(
    encode("text", img, tempfile(fileext = ".jpg")),
    "Format 'jpg' not supported")
  expect_error(
    decode(tempfile(fileext = ".jpg")),
    "Format 'jpg' not supported")
})


test_that("Prevent truncation", {
  img <- png::readPNG(system.file("img/Rlogo.png", package = "png"))
  data <- rep(0, 10000)
  expect_error(
    lsb_encode(data, img),
    "Overflow detected: [0-9]+ exceeds 65536 \\(2\\^16\\)")
  expect_error(
    lsb_encode(rep(0, 8000), img),
    "Not enough space in image: message length \\(.+ bits\\) > image size")
})
