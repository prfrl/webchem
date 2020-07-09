
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Webchem

<!-- badges: start -->

[![CRAN](https://www.r-pkg.org/badges/version/webchem)](https://CRAN.R-project.org/package=webchem)
[![Travis](https://travis-ci.org/ropensci/webchem.png)](https://travis-ci.org/ropensci/webchem)
[![AppVeyor](https://ci.appveyor.com/api/projects/status/8m7wpfnxn41kqjnl?svg=true)](https://ci.appveyor.com/project/ropensci/webchem)
[![Coverage](https://codecov.io/github/ropensci/webchem/coverage.svg?branch=master)](https://codecov.io/gh/ropensci/webchem/branch/master)
[![Downloads](https://cranlogs.r-pkg.org/badges/webchem)](https://cran.r-project.org/package=webchem)
[![Total
Downloads](https://cranlogs.r-pkg.org/badges/grand-total/webchem?color=blue)](https://cran.r-project.org/package=webchem)
[![DOI](https://zenodo.org/badge/17223/ropensci/webchem.svg)](https://zenodo.org/badge/latestdoi/17223/ropensci/webchem)

<!-- badges: end -->

`webchem` is a R package to retrieve chemical information from the web.
This package interacts with a suite of web APIs to retrieve chemical
information.

The functions in the package that hit a specific API have a prefix and
suffix separated by an underscore (`prefix_suffix()`). They follow the
format of `source_functionality`, with the exception of functions that
retrieve database identifiers which follow the format of
`get_identifier`. e.g.`cs_compinfo` uses ChemSpider to retrieve compound
informations and `get_csid()` retrieves ChemSpider IDs.

## Fill out the survey\!

Do you use chemical information databases in your work? Help us help you
by filling out our short survey at
<https://forms.gle/V7dfGGn73dkesn5L6>.

The `webchem` survey allows us to learn which databases you use and how
you interact with chemical data. This is extremely valuable information
for us and guides our development efforts. The survey takes about 5
minutes to fill out.

## Chemical databases currently accessed by webchem

At least some of the data in the following sources is accesible through
`webchem` functions. To learn more about what is available, browse the
documentation
[here](https://docs.ropensci.org/webchem/reference/index.html).

  - [Alan Wood’s Compendium of Pesticide Common
    Names](http://www.alanwood.net/pesticides/)
  - [ChEBI](https://www.ebi.ac.uk/chebi/)
  - [Chemical Identifier Resolver
    (CIR)](http://cactus.nci.nih.gov/chemical/structure)
  - [Chemical Translation Service
    (CTS)](http://cts.fiehnlab.ucdavis.edu/)
  - [ChemIDplus](http://chem.sis.nlm.nih.gov/chemidplus/)
  - [ChemSpider](http://www.chemspider.com/) (requires an [API
    token](\(https://developer.rsc.org/\)))
  - [ETOX](http://webetox.uba.de/webETOX/index.do)
  - [Flavornet](http://www.flavornet.org)
  - [NIST](https://webbook.nist.gov) (currently gas chromatography
    retention indices only)
  - [OPSIN](http://opsin.ch.cam.ac.uk/instructions.html)
  - [PAN Pesticide Database](http://www.pesticideinfo.org/)
  - [PubChem](https://pubchem.ncbi.nlm.nih.gov/)
  - [U.S. EPA Substance Registry Service
    (SRS)](https://cdxnodengn.epa.gov/cdx-srs-rest/)
  - [Wikidata](https://www.wikidata.org/wiki/Wikidata:WikiProject_Chemistry)

#### API keys

Some ChemSpider functions require an API key. Please register at RSC
(<https://developer.rsc.org/>) to retrieve an API key.

## Installation

#### Install from CRAN (stable version)

``` r
install.packages("webchem")
```

#### Install from Github (development version)

``` r
install.packages("devtools")
library("devtools")
install_github("ropensci/webchem")
```

### Acknowledgements

Without the fantastic web services `webchem` wouldn’t be here.
Therefore, kudos to the web service providers and developers\! Please
remember to acknowledge these data resources in your work using
`webchem`.

### Related Projects

You can find some related packages in the [ChemPhys CRAN Task
View](https://cran.r-project.org/web/views/ChemPhys.html)

If you’re more familiar with Python you should check out [Matt
Swains](https://github.com/mcs07) repositories:
[ChemSpiPy](https://github.com/mcs07/ChemSpiPy),
[PubChemPy](https://github.com/mcs07/PubChemPy) and
[CirPy](https://github.com/mcs07/CIRpy) provide similar functionality as
`webchem`.

### Want to contribute?

Check out our [contribution guide
here](https://github.com/ropensci/webchem/blob/master/CONTRIBUTING.md).

### Meta

  - Please [report any issues, bugs or feature
    requests](https://github.com/ropensci/webchem/issues).
  - License: MIT
  - Get citation information for `webchem` in R with
    `citation("webchem")`
  - Please note that this package is released with a [Contributor Code
    of Conduct](https://ropensci.org/code-of-conduct/). By contributing
    to this project, you agree to abide by its
terms.

[![ropensci](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
