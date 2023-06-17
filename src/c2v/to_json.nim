import std/strutils
import std/parsecsv
import std/json

proc isInt(str: string): bool =
  result = true

  for c in str:
    if not c.isDigit():
      return false

proc toJsonType(str: string): JsonNode =
  ## Convert string to JSON type

  case str
  of "true":
    % true
  of "false":
    % false
  elif str.isInt():
    % parseInt(str)
  else:
    % str

# ------

proc csvToJson*(
  filename: string; ## CSV file
  separator = ','; ## CSV parser config
  quote = '"';
  escape: char = '\0';
  skipInitialSpace: bool = true): JsonNode =
  ## Convert CSV to Json as an array of objects

  result = newJArray()

  var p: CsvParser

  p.open(filename, separator, quote, escape, skipInitialSpace)
  p.readHeaderRow()

  while p.readRow():
    let currObj = newJObject()

    for col in p.headers:
      let entry = p.rowEntry(col)

      currObj[col] = entry.toJsonType()

    result.add currObj

  p.close()

proc csvToJsonHash*(
  filename: string; ## CSV file
  separator = ','; ## CSV parser config
  quote = '"';
  escape: char = '\0';
  skipInitialSpace: bool = true): JsonNode =
  ## Convert CSV into an object instead of an array. First column is used as hash key.

  result = newJObject()

  var p: CsvParser

  p.open(filename, separator, quote, escape, skipInitialSpace)
  p.readHeaderRow()

  while p.readRow():
    let currObj = newJObject()

    for col in p.headers[1..^1]: # iterate through the headers, but exclude the first header
      let entry = p.rowEntry(col)

      currObj[col] = entry.toJsonType()

    # Set key as first header and set currObj as value
    result[p.rowEntry(p.headers[0])] = currObj

  p.close()

proc csvToJsonArr*(
  filename: string; ## CSV file
  separator = ','; ## CSV parser config
  quote = '"';
  escape: char = '\0';
  skipInitialSpace: bool = true): JsonNode =
  ## Convert CSV into an object instead of an array. First column is used as hash key.

  result = newJArray()

  var p: CsvParser

  p.open(filename, separator, quote, escape, skipInitialSpace)
  p.readHeaderRow()

  while p.readRow():
    let currObj = newJArray()

    for col in p.headers:
      let entry = p.rowEntry(col)

      currObj.add entry.toJsonType()

    result.add currObj

  p.close()

proc csvToJsonColArr*(
  filename: string; ## CSV file
  separator = ','; ## CSV parser config
  quote = '"';
  escape: char = '\0';
  skipInitialSpace: bool = true): JsonNode =
  ## Convert CSV into an object instead of an array. First column is used as hash key.

  result = newJObject()

  var p: CsvParser

  p.open(filename, separator, quote, escape, skipInitialSpace)
  p.readHeaderRow()

  while p.readRow():
    for col in p.headers:
      let entry = p.rowEntry(col)

      if not result.hasKey(col):
        result[col] = newJArray()

      result[col].add entry.toJsonType()

  p.close()
