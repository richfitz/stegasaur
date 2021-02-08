with_dir <- function(path, code) {
  owd <- setwd(path)
  on.exit(setwd(owd))
  force(code)
}


stegasaur_file <- function(path) {
  system.file(path, package = "stegasaur", mustWork = TRUE)
}
