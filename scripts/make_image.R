#!/usr/bin/env Rscript
root <- here::here()
pkgload::load_all(root)
msg <- paste("Marsh's 1896 illustration of S. ungulatus:",
             "Note the single row of 12 dorsal plates and eight tail spikes")
stegasaur::encode(msg,
                  file.path(root, "inst/stegosaurus_orig.png"),
                  file.path(root, "inst/stegosaurus.png"))
message(stegasaur::decode(file.path(root, "inst/stegosaurus.png")))
