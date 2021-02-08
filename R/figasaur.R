##' Encode plot commands into a plot file
##'
##' The code supplied in `code` (typially in curly braces) is used to
##' create a figure which has the plotting code encoded as a character
##' string in the file. This information can be extracted using
##' [stegasaur::decode].
##'
##' @param code code use to produce the figure you want
##'
##' @param filename name of the file to write
##'
##' @param ... extra arguments to go to [png]
##'
##' @author David L Miller
##' @export
##' @importFrom grDevices png dev.off
##' @examples
##' # encode the code in the curly braces into its corresponding plot
##' path <- tempfile(fileext = ".png")
##' figasaur({plot(sample(100))}, path)
##'
##' # extract the information
##' cat(decode(path))
figasaur <- function(code, filename, ...) {
  tmp <- tempfile(fileext = ".png")
  txt <- deparse(substitute(code))
  png(tmp, ...)
  tryCatch(
    force(code),
    finally = dev.off())
  stegasaur::encode(paste0(txt, "\n", collapse = ""), tmp, filename)
}
