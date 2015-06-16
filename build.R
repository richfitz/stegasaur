#!/usr/bin/env Rscript
msg <- "Marsh's 1896 illustration of S. ungulatus: Note the single row of 12 dorsal plates and eight tail spikes"
stegasaur::encode(msg, "inst/stegosaurus_orig.png", "inst/stegosaurus.png")
message(stegasaur::decode("inst/stegosaurus.png"))
