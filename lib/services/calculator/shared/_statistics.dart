/// Statistical utility functions for calculator operations
class Statistics {
  /// Calculate the arithmetic mean of a list of numbers
  ///
  /// Parameters
  /// ----------
  /// numbers : List of double
  ///     List of numbers to calculate mean from
  ///
  /// Returns
  /// -------
  /// double
  ///     The arithmetic mean of the input numbers
  ///
  /// Throws
  /// ------
  /// ArgumentError
  ///     If the input list is empty
  static double mean(List<double> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError('Cannot calculate mean of empty list');
    }
    
    return numbers.reduce((a, b) => a + b) / numbers.length;
  }
}
