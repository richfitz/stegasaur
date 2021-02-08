##' Takes an image matrix from something like [png::readPNG].  Note
##' that this cannot be saved out as jpeg as the lossy compression
##' will drop the message
##'
##' @title Encode text into a lossless image
##'
##' @param content Content to save into the image; can be a text
##'   string or an arbitrary R object.
##'
##' @param img An image matrix to save the message into
##'
##' @param force_object Logical: Force saving a scalar text string as
##'   an R object (will be slightly more space efficient).
##'
##' @export
##' @author Rich FitzJohn
##' @importFrom png readPNG
##' @examples
##' img <- png::readPNG(system.file("img/Rlogo.png", package = "png"))
##' txt <- "hello from stegasaur"
##' img2 <- lsb_encode(txt, img)
##' lsb_decode(img2)
lsb_encode <- function(content, img, force_object = FALSE) {
  text <- !force_object && is.character(content) && length(content) == 1L
  if (text) {
    content <- utf8ToInt(content)
  } else {
    ## TODO: allow raw through here
    content <- serialize(content, NULL)
  }

  img <- lsb_prepare(img)
  ## TODO: using 2^16 here is limiting
  bits <- c(binvalue(length(content), LSB_BITSIZE_LEN),
            as.integer(text),
            binvalue(content, LSB_BITSIZE_CHAR))
  ret <- put_binary_value(bits, img)
  ret / 255
}


##' @export
##' @rdname lsb_encode
lsb_decode <- function(img) {
  img <- lsb_prepare(img)
  i <- seq_len(LSB_BITSIZE_LEN)
  len <- intvalue(img[i] %&% 1L, LSB_BITSIZE_LEN)
  is_text <- as.logical(img[LSB_BITSIZE_LEN + 1L] %&% 1L)

  bits <- img[seq_len(LSB_BITSIZE_CHAR * len) + LSB_BITSIZE_LEN + 1L] %&% 1L
  bytes <- intvalue(bits, LSB_BITSIZE_CHAR)

  if (is_text) {
    intToUtf8(bytes)
  } else {
    unserialize(as.raw(bytes))
  }
}


LSB_BITSIZE_LEN  <- 16L # nolint
LSB_BITSIZE_CHAR <- 8L # nolint also for raw
INT_LEN <- length(intToBits(0L)) # nolint 32L


binvalue <- function(val, bitsize) {
  b <- matrix(as.integer(intToBits(val)), INT_LEN)
  i <- seq_len(bitsize)
  if (sum(b[-i, ])) {
    stop(sprintf("Overflow detected: %d exceeds %d (2^%d)",
                 val, 2^bitsize, bitsize))
  }
  c(b[i, ])
}


intvalue <- function(bits, bitsize) {
  m <- matrix(as.integer(bits), bitsize)
  m <- rbind(m, matrix(0L, INT_LEN - bitsize, ncol(m)))
  packBits(m, "integer")
}


put_binary_value <- function(bits, img) {
  if (length(bits) > length(img)) {
    stop(sprintf(
      "Not enough space in image: message length (%d bits) > image size %d",
      length(bits), length(img)))
  }
  i <- seq_along(bits)
  j <- bits == 1L
  k <- !j
  img[i][j] <- img[i][j] %|% 1L
  img[i][k] <- img[i][k] %&% 254L
  img
}


lsb_prepare <- function(img) {
  if (is.double(img)) {
    img <- img * 255
    storage.mode(img) <- "integer"
  }
  img
}
