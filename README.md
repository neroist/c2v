# c2v

A tool that converts CSV files into JSON. Supports four different types of
JSON outputs:

- Default: Outputs array of objects, each object representing a CSV row.
Each key is a header and the corresponding value being the value of that
header in the represented row.
- Hash/Keyed: Output an object instead of an array. First column is used as
hash key.
- Array: Outputs an array of arrays, each nested array representing a CSV row.
- Column Array: Similar to Array, except it outputs an object, with each
key representing a CSV header and each corresponding value being the array
of values under the header.

## Usage

```text
Usage:
  c2v [optional-params] [filename: string...]
Convert CSV file to JSON
Options:
  -h, --help                         print this cligen-erated help
  --help-syntax                      advanced: prepend,plurals,..
  -v, --version   bool    false      print version
  -s=, --sep=     char    ','        The character used to separate fields in the CSV file.
  -q=, --quote=   char    '\"'       The character to quote fields containing special characters like `separator`, `quote` or new-line characters. '0' (nul) disables the parsing of quotes.
  -e=, --escape=  char    '\x00'     Removes any special meaning from the specified character; '0' disables escaping; if escaping is disabled and `quote` is not '0', two `quote` characters are
                                     parsed as one literal `quote` character.
  --skip          bool    true       Whether or not to skip whitespace immediately following the separator.
  -o=, --out=     string  ""         The output filename. By default is it set to the input filename with the file extension changed to ".json"
  -p, --print     bool    false      Whether or not to print the produced JSON to stdout. If this is true then `out` is ignored.
  --output=       string  "default"  The type of JSON output to produce. Accepted values: default, hash, array, colarr.
  -m, --minify    bool    false      Whether or not to minify the JSON output. If true, the `indent` option is ignored.
  -i=, --indent=  int     4          How much, in spaces, to indent the JSON output. If `minify` is true, this option is ignored.
```

## Examples

Example CSV data to test n play around with in C2V are found in the
[`examples/`](examples/) directory.
