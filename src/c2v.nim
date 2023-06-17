import std/strutils
import std/json
import std/os

import cligen
import fab

import ./c2v/to_json

proc main(
  sep = ',', 
  quote = '"', 
  escape: char = '\0',
  skip: bool = true,
  `out`: string = "",
  print: bool = false,
  output: string = "default",
  minify: bool = false,
  indent: int = 4,
  filename: seq[string]
) = 
  ## Convert CSV file to JSON. JSON is prettified by default.

  # --- error checking
  if filename.len != 1:
    bad "No file provided or more than one file provided"

    return

  if not filename[0].fileExists():
    bad "File \"$1\" does not exist!" % [filename[0]]

    return
  # ---

  let 
    filename = filename[0]
  
    `out` = if `out`.len == 0: 
      filename.changeFileExt("json")
    else: 
      `out`
    
  var 
    json: JsonNode
  
  case output.normalize()
  of "default", "d":
    json = csvToJson(filename, sep, quote, escape, skip)
  of "hash", "keyed", "keys", "key", "h", "k":
    json = csvToJsonHash(filename, sep, quote, escape, skip)
  of "array", "arr", "a":
    json = csvToJsonArr(filename, sep, quote, escape, skip)
  of "columnarray", "colarray", "columnarr", "colarr", "ca", "c":
    json = csvToJsonColArr(filename, sep, quote, escape, skip)
  else:
    info "Output type \"$1\" is not valid! Falling back to default." % [output]

    json = csvToJson(filename, sep, quote, escape, skip)

  if not print:
    writeFile(`out`):
      if minify:
        $json
      else:
        json.pretty(indent)
  else:
    echo:
      if minify:
        $json
      else:
        json.pretty(indent)

when isMainModule:
  clCfg.version = "0.1.0"

  dispatch(
    main, 
    cmdName="c2v", 
    help={
      "sep":    "The character used to separate fields in the CSV file.",
      "quote":  "The character to quote fields containing special characters " &
                "like `separator`, `quote` or new-line characters. '\\0' (nul) " &
                "disables the parsing of quotes.",
      "escape": "Removes any special meaning from the specified character; '\\0' " &
                "disables escaping; if escaping is disabled and `quote` is not '\\0', " &
                "two `quote` characters are parsed as one literal `quote` character.",
      "skip":   "Whether or not to skip whitespace immediately following the separator.",
      "out":    "The output filename. By default is it set to the input filename with the " &
                "file extension changed to \".json\"",
      "print":  "Whether or not to print the produced JSON to stdout. If this is true then " &
                "`out` is ignored.",
      "output": "The type of JSON output to produce. Accepted values: default, hash, array, colarr.",
      "minify": "Whether or not to minify the JSON output. If true, the `indent` option is ignored.",
      "indent": "How much, in spaces, to indent the JSON output. If `minify` is true, this option " &
                "is ignored."
    },
    short={
      "version": 'v'
    }
  )
