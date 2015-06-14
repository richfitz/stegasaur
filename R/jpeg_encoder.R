## Python version imports:
##   Image, math, operator, logging
## plus a bunch of stuff from util, but that's it's own stuff.

##' @importFrom jpeg readJPEG
jpeg_info <- function(image, comment="") {
  n <- 3L
  dat <-
    structure(
      list(
        precision=8L,
        comp_num = n,
        com_id = c(1L, 2L, 3L),
        ss = 0L,
        se = 63L,
        ah = 0L,
        al = 0L,
        hsamp_factor   = c(2L, 1L, 1L),
        vsamp_factor   = c(2L, 1L, 1L),
        qtable_number  = c(0L, 1L, 1L),
        dctable_number = c(0L, 1L, 1L),
        actable_number = c(0L, 1L, 1L),

        components   = vector("list", n),
        comp_width   = integer(n),
        comp_height  = integer(n),
        block_width  = integer(n),
        block_height = integer(n),
        comment      = comment,
        image_width  = ncol(image),
        image_height = nrow(image),
        pixels       = image),
      class="jpeg_info")
  dat$components <- jpeg_info_ycc(dat)
  dat
}

jpeg_info_ycc <- function(obj) {
  max_hsamp_factor <- max(obj$hsamp_factor)
  max_vsamp_factor <- max(obj$vsamp_factor)

  for (i in seq_len(obj$comp_num)) {
    obj$comp_width[i] <- as.integer(ceiling(obj$image_width / 8.0) * 8)
    obj$comp_width[i] <- obj$comp_width[i] / max_hsamp_factor * obj$hsamp_factor[i]
    obj$block_width[i] <- as.integer(ceiling(obj$comp_width[i] / 8.0))

    obj$comp_height[i] <- as.integer(ceiling(obj$image_height / 8.0) * 8)
    obj$comp_height[i] <- obj$comp_height[i] / max_vsamp_factor * obj$vsamp_factor[i]
    obj$block_height[i] <- as.integer(ceiling(obj$comp_height[i] / 8.0))
  }

  r <- obj$pixels[, , 1]
  g <- obj$pixels[, , 2]
  b <- obj$pixels[, , 3]
  x <- seq_len(obj$image_width)
  y <- seq_len(obj$image_height)
  Y <- Cb <- Cr <- matrix(0.0, obj$comp_height[[1]], obj$comp_width[[1]])
  Y[y, x]  <-  0.299   * r + 0.587   * g + 0.114   * b
  Cb[y, x] <- -0.16874 * r - 0.33126 * g + 0.5     * b + 128
  Cr[y, x] <-  0.5     * r - 0.41869 * g - 0.08131 * b + 128

  list(Y,
       down_sample(obj, Cb, 2),
       down_sample(obj, Cr, 3))
}

## ## Manually:
## res <- matrix(NA_real_, max(outrow), max(outcol))
## for (i in outcol) {
##   for (j in outrow) {
##     ii <- (i - 1L) %<<% 1L + 1L
##     jj <- (j - 1L) %<<% 1L + 1L
##     bias <- (i - 1L) %% 2L + 1L
##     res[j, i] <-   sum(C[jj,      ii],
##                        C[jj,      ii + 1L],
##                        C[jj + 1L, ii],
##                        C[jj + 1L, ii + 1L],
##                        bias) / 4.0
##   }
## }
down_sample <- function(obj, C, comp) {
  nc <- obj$comp_width[[comp]]
  nr <- obj$comp_height[[comp]]

  i <- rep((seq_len(nc) - 1L) %<<% 1L + 1L, each=nr)
  j <- rep((seq_len(nr) - 1L) %<<% 1L + 1L, nc)
  bias <- rep(1:2, each=nr, length.out=nr * nc)

  res <- (C[cbind(j,      i     )] +
          C[cbind(j,      i + 1L)] +
          C[cbind(j + 1L, i     )] +
          C[cbind(j + 1L, i + 1L)] +
          bias) / 4.0
  matrix(res, nr, nc)
}
