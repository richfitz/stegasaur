#' Encode plot commands into a plot file
#'
#' The code supplied in \code{code} (in curly braces) is used to create a figure which has the plotting code encoded as a character string in the file. This information can be extracted using \code{\link{decode}}.
#'
#' @param code code use to produce the figure you want
#' @param filename name of the file to write
#' @param \dots extra arguments to go to \code{\link{png}}
#'
#' @author David L Miller
#' @export
#' @importFrom grDevices png dev.off
#' @examples
#' # encode the code in the curly braces into its corresponding plot
#' # in the file simpleplot.png
#' figasaur({plot(sample(100))}, "simpleplot.png")
#' # extract the information
#' cat(decode("simpleplot.png"))
figasaur <- function(code, filename, ...){

  #code <- substitute(code)

  # temporary file where we make the plot first
  tmp_plot_file <- tempfile("tmpplot", fileext=".png")

  # do the ploting
  png(tmp_plot_file, ...)

  # check that code ran okay
  try_code <- try(eval(code))

  # stop the device
  dev.off()

  # if something bad happened to the code
  if(class(try_code)=="try-error"){
    stop("Code in 'code' caused an error, no image encoded.")
  }

  # encode the plotting code into the figure
  stegasaur::encode(paste0(paste(deparse(substitute(code)),collapse="\n"),"\n"),
                    tmp_plot_file, filename)

}
