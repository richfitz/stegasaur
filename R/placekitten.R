##' Download a kitten picture from placekitten.com
##' @title Download a kitten
##' @param width Width, in pixels
##' @param height Height, in pixels
##' @param destfile File to save into.  By default this is a temporary
##' file.
##' @param ... Additional parameters passed through to
##' \code{\link{download.file}}
##' @return The filename saved in (useful when using the default
##' \code{destfile})
##' @export
kitten <- function(width, height,
                   destfile=tempfile("kitten", fileext=".jpg"), ...) {
  url <- sprintf("http://placekitten.com/g/%d/%d", width, height)
  download.file(url, destfile, ...)
  destfile
}
