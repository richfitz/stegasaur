`%&%` <- function(x, y) { # nolint
  bitwAnd(x, y)
}


`%|%` <- function(x, y) { # nolint
  bitwOr(x, y)
}


read_img <- function(filename) {
  format <- file_ext(filename)
  switch(tolower(format),
         png = png::readPNG(filename),
         jpeg = jpeg::readJPEG(filename),
         jpg = jpeg::readJPEG(filename),
         stop(sprintf("Unknown format '%s'", format)))
}

  
file_ext <- function(filename) {
  sub(".*\\.([[:alnum:]]+)$", "\\1", filename)
}
