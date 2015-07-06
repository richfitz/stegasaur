#' 'knitr' hook to encode plot code into figures
#'
#' As plots are generated in a \code{knitr} document, encode the code used to produce them into the resulting PNG files. This can be done by setting the chunk option: \code{figasaur=TRUE} after setting \code{knit_hooks$set(figasaur = hook_figasaur)} at the top of your \code{knitr} document. The \code{knitr_example.Rmd} file included in this package shows a simple example.
#'
#' Note that this only works for PNG files generated for HTML documents, though it does work when the PNGs are embedded in the HTML file (e.g. using the \code{self_contained} option in \code{\link{rmarkdown::render}}. See \code{\link{chunk_hook}} for more information.
#'
#' @export
#' @author David L Miller
#' @references \url{http://yihui.name/knitr/hooks#chunk_hooks}
#' @param before,options,envir see references
#' @seealso encode
hook_figasaur <- function(before, options, envir){

  # need to ensure we're doing html output
  if(options$dev != "png"){
    stop("Only PNG graphics can be used with hook_figasaur")
  }

  # after the code in this chunk ran
  if(!before){
    # get the file
    filename <- knitr::fig_path("png")
    # encode that
    stegasaur::encode(options$code, filename, filename)
  }

}
