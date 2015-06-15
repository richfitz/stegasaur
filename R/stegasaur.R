##' Encode data in an image
##' @title Encode data in an image
##' @param content Content to encode: any R object is OK (see
##' \code{\link{lsb_encode}}).
##' @param file_in Source filename
##' @param file_out Destination filename (can be the same as the
##' source filename for a destructive update)
##' @export
##' @author Rich FitzJohn
##' # file included with the package:
##' file_in <- system.file("man_with_cats.jpg", package="stegasaur")
##' # output a png in a temporary directory:
##' file_out <- tempfile("kitten", fileext=".png")
##' # some random data to encode:
##' x <- runif(10)
##' encode(x, file_in, file_out)
##' # extract the data:
##' decode(file_out)
##'
##' # On a mac, this will open the file in preview: the data should be
##' # imperciptible to the human eye:
##' \dontrun{
##' system2("open", file_out)
##' }
encode <- function(content, file_in, file_out) {
  img <- read_img(file_in)
  format_out <- tolower(file_ext(file_out))
  if (format_out == "png") {
    png::writePNG(lsb_encode(content, img), file_out)
  } else {
    stop(sprintf("Format %s not supported", format_out))
  }
  invisible(file_out)
}

##' Decode data from an image that has been encoded with
##' \code{\link{encode}}.
##' @title Decode data from an image
##' @param filename Filename to load
##' @export
##' @author Rich FitzJohn
##' @seealso \code{\link{encode}}, which includes an example.
decode <- function(filename) {
  img <- read_img(filename)
  format <- file_ext(filename)
  if (format == "png") {
    lsb_decode(img)
  } else {
    stop(sprintf("Format %s not supported", format_out))
  }
}

read_img <- function(filename, format=NULL) {
  if (is.null(format)) {
    format <- file_ext(filename)
  }
  switch(tolower(format),
         png=png::readPNG(filename),
         jpeg=jpeg::readJPEG(filename),
         jpg=jpeg::readJPEG(filename),
         stop("Unknown format"))
}

file_ext <- function(filename) {
  sub(".*\\.([[:alnum:]]+)$", "\\1", filename)
}
