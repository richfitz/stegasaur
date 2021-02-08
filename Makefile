PACKAGE := $(shell grep '^Package:' DESCRIPTION | sed -E 's/^Package:[[:space:]]+//')
RSCRIPT = Rscript --no-init-file

all:
	${RSCRIPT} -e 'library(methods); devtools::compile_dll()'

test:
	${RSCRIPT} -e 'library(methods); devtools::test()'

test_all:
	REMAKE_TEST_INSTALL_PACKAGES=true make test

roxygen:
	@mkdir -p man
	${RSCRIPT} -e "library(methods); devtools::document()"

install:
	R CMD INSTALL .

build:
	R CMD build .

README.md: README.Rmd
	Rscript -e 'library(methods); devtools::load_all(); knitr::knit("README.Rmd")'
	sed -i.bak 's/[[:space:]]*$$//' README.md
	rm -f $@.bak

check:
	_R_CHECK_CRAN_INCOMING_=FALSE make check_all

check_all:
	${RSCRIPT} -e "rcmdcheck::rcmdcheck(args = c('--as-cran', '--no-manual'))"

clean:
	rm -f src/*.o src/*.so

vignettes/RedisAPI.Rmd: vignettes/src/RedisAPI.R
	${RSCRIPT} -e 'library(sowsear); sowsear("$<", output="$@")'

vignettes: vignettes/RedisAPI.Rmd
	${RSCRIPT} -e 'library(methods); devtools::build_vignettes()'

.PHONY: clean all test document install vignettes
