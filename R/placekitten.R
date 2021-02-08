##' Download a kitten picture from placekitten.com
##'
##' @title Download a kitten
##'
##' @param width Width, in pixels
##'
##' @param height Height, in pixels
##'
##' @param destfile File to save into.  By default this is a temporary
##'   file with an extension ".jpg"
##'
##' @param ... Additional parameters passed through to
##'   `download.file`.
##'
##' @return The filename saved in (useful when using the default
##'   `destfile`
##' @export
##' @examples
##' stegasaur::kitten(200, 200)
kitten <- function(width, height,
                   destfile = tempfile("kitten", fileext = ".jpg"), ...) {
  url <- sprintf("http://placekitten.com/g/%d/%d", width, height)
  utils::download.file(url, destfile, ..., mode = "wb")
  destfile
}
