##' Takes an image matrix from something like \code{readPNG}.  Note
##' that this cannot be saved out as jpeg as the lossy compression
##' will drop the message
##'
##' @title Encode text into a lossless image
##' @param txt Text contents to save into the file (raw will be
##' supported soon).
##' @param img An image matrix to save the message into
##' @export
##' @author Rich FitzJohn
##' @importFrom png readPNG
##' @examples
##' img <- png::readPNG(system.file("img/Rlogo.png", package="png"))
##' txt <- "hello from stegasaur"
##' img2 <- lsb_encode(txt, img)
##' lsb_decode(img2)
lsb_encode <- function(txt, img) {
  img <- lsb_prepare(img)
  len <- binvalue(nchar(txt), LSB_BITSIZE_LEN)
  chars <- binvalue(utf8ToInt(txt), LSB_BITSIZE_CHAR)
  ret <- put_binary_value(c(len, chars), img)
  ret / 255
}

##' @export
##' @rdname lsb_encode
lsb_decode <- function(img) {
  img <- lsb_prepare(img)
  i <- seq_len(LSB_BITSIZE_LEN)
  len <- intvalue(img[i] %&% 1L, LSB_BITSIZE_LEN)
  j <- seq_len(LSB_BITSIZE_CHAR * len) + LSB_BITSIZE_LEN
  intToUtf8(intvalue(img[j] %&% 1L, LSB_BITSIZE_CHAR))
}


LSB_BITSIZE_LEN  <- 16L
LSB_BITSIZE_CHAR <- 8L
INT_LEN <- length(intToBits(0L))

binvalue <- function(val, bitsize) {
  b <- matrix(as.integer(intToBits(val)), INT_LEN)
  i <- seq_len(bitsize)
  if (sum(b[-i, ])) {
    stop("Overflow detected")
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
    stop("not enough space")
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
