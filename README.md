# stegasaur

[![Travis-CI Build Status](https://travis-ci.org/richfitz/stegasaur.svg?branch=master)](https://travis-ci.org/richfitz/stegasaur)

Steganography for R

![stegosaur](https://github.com/richfitz/stegasaur/raw/master/inst/stegosaurus.png)

The aim is to be able to encode arbitrary R objects in cat pictures:

```r
txt <- "this is a secret message"
kitten <- stegasaur::kitten(200, 300)
stegasaur::encode("this is a secret message", kitten, "kitten.png")
```

The file `kitten.png` in the working directory now contains both an adorable kitten and a secret message.  The message can be decoded:

```r
stegasaur::decode("kitten.png")
# [1] "this is a secret message"
```

This works with arbitrary objects, too

```r
x <- runif(10)
stegasaur::encode(x, kitten, "kitten.png")
stegasaur::decode("kitten.png")
# [1] 0.8257649 0.2250323 0.1598864 0.4999668 0.6165416 0.6676501 0.8632083
# [8] 0.6462997 0.1772859 0.2864177
```

An additional helper function allows quick encoding in images, when one would like to encode the plot code with the figure:

```{r}
stegasaur::figasaur({plot(sample(100))}, "randomplot.png")
```

A [`knitr`](http://yihui.name/knitr/) "hook" (`hook_figasaur`) is also included, so one may automatically encode the generating code with plots throughout a `knitr` document. See `knitr_example.Rmd` in the `inst` directory for an example.
