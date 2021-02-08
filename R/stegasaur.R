##' Encode data in an image
##'
##' @title Encode data in an image
##'
##' @param content Content to encode: any R object is OK (see
##'   [stegasaur::lsb_encode]).
##'
##' @param file_in Source filename
##'
##' @param file_out Destination filename (can be the same as the
##'   source filename for a destructive update)
##'
##' @export
##' @examples
##' # file included with the package:
##' file_in <- system.file("man_with_cats.jpg", package = "stegasaur")
##'
##' # output a png in a temporary directory:
##' file_out <- tempfile("kitten", fileext = ".png")
##'
##' # some random data to encode:
##' x <- runif(10)
##' stegasaur::encode(x, file_in, file_out)
##'
##' # extract the data:
##' stegasaur::decode(file_out)
encode <- function(content, file_in, file_out) {
  format_out <- tolower(file_ext(file_out))
  if (format_out != "png") {
    stop(sprintf("Format '%s' not supported", format_out))
  }
  img <- read_img(file_in)
  png::writePNG(lsb_encode(content, img), file_out)
  invisible(file_out)
}


##' Decode data from an image that has been encoded with
##' [stegasaur::encode].
##'
##' @title Decode data from an image
##'
##' @param filename Filename to load
##'
##' @export
##' @seealso [stegasaur::encode], which includes an example.
decode <- function(filename) {
  format <- file_ext(filename)
  if (format != "png") {
    stop(sprintf("Format '%s' not supported", format))
  }
  lsb_decode(png::readPNG(filename))
}
