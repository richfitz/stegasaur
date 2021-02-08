##' 'knitr' hook to encode plot code into figures
##'
##' As plots are generated in a `knitr` document, encode the code used
##' to produce them into the resulting PNG files. This can be done by
##' setting the chunk option: `figasaur = TRUE` after setting
##' `knit_hooks$set(figasaur = hook_figasaur)` at the top of your
##' `knitr` document. The `knitr_example.Rmd` file included in this
##' package shows a simple example.
##'
##' Note that this only works for PNG files generated for HTML
##' documents, though it does work when the PNGs are embedded in the
##' HTML file (e.g. using the \code{self_contained} option in
##' \code{\link[rmarkdown]{render}}. See
##' \code{\link[knitr]{chunk_hook}} for more information.
##'
##' @export
##' @author David L Miller
##'
##' @references \url{http://yihui.name/knitr/hooks#chunk_hooks}
##'
##' @param before,options,envir Arguments as required by knitr; please
##'   see references for details
##'
##' @seealso encode
##' @examples
##' writeLines(readLines(
##'   system.file("knitr_example.Rmd", package = "stegasaur")))
hook_figasaur <- function(before, options, envir) {
  if (options$dev == "png" && !before) {
    filename <- knitr::fig_path("png")
    stegasaur::encode(options$code, filename, filename)
  }
}
