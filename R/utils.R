`%<<%` <- function(x, y) {
  bitops::bitShiftL(x, y)
}

`%>>%` <- function(x, y) {
  bitops::bitShiftR(x, y)
}

`%&%` <- function(x, y) {
  bitops::bitAnd(x, y)
}

`%|%` <- function(x, y) {
  bitops::bitOr(x, y)
}
