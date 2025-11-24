/// Parses a string into a numeric value or list of numeric values.
///
/// Accepts a string containing one or more numeric values separated by commas
/// and/or whitespace. Returns the parsed result in the most appropriate format.
///
/// **Parameters**
///
/// * `x` : String
///     Input string containing numeric value(s) to parse.
///
/// **Returns**
///
/// * `double` - When input contains a single numeric value
/// * `List<double>` - When input contains multiple numeric values
/// * `String` - Empty string ("") when parsing fails or input is invalid
///
/// **Examples**
///
/// ```dart
/// parseStrToNumOrList("42.5");           // Returns: 42.5 (double)
/// parseStrToNumOrList("1.1, 2.2, 3.3");  // Returns: [1.1, 2.2, 3.3] (List<double>)
/// parseStrToNumOrList("1 2 3");          // Returns: [1.0, 2.0, 3.0] (List<double>)
/// parseStrToNumOrList("invalid");        // Returns: "" (String)
/// parseStrToNumOrList("");               // Returns: "" (String)
/// ```
dynamic parseStrToNumOrList(String x) {

  try {
    // Split the string into parts based on comma or one or more spaces
    List<String> parts = x.trim().split(RegExp(r'[,\s]+'));
    
    // Filter out empty strings and convert to double
    List<double> res = parts
        .where((part) => part.isNotEmpty)
        .map((part) => double.parse(part))
        .toList();
    
    if (res.length == 1) {
      // Ex: [1.1] will convert to 1.1
      return res[0];
    }
    if (res.length > 1) {
      // Ex: [1.1, 1.2, 1.3, 1.45]
      return res;
    }
  } on FormatException {
    // Return empty string for any string that is not compatible (including empty strings)
    return "";
  }


  return "";
}
