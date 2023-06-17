# Package

version       = "0.1.0"
author        = "Jasmine"
description   = "CSV to JSON converter"
license       = "MIT"
srcDir        = "src"
bin           = @["c2v"]


# Dependencies

requires "nim >= 1.6.10"
requires "cligen"
requires "fab"