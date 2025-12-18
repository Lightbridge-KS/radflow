import '../../../core/result.dart';
import '../calculator_error.dart';

/// Allowed values for each TIRADS category
const Map<String, List<String>> tiradsMapCategories = {
  "composition": ["cystic", "spongiform", "mixed", "solid", "undetermined"],
  "echogenicity": ["an", "hyper", "iso", "hypo", "very-hypo", "undetermined"],
  "shape": ["wider", "taller"],
  "margin": ["undetermined", "smooth", "ill-defined", "lob-irreg", "extra"],
  "echogenic_foci": ["none-comet", "macro-calc", "rim-calc", "punctate"],
};

/// Validates TIRADS inputs and returns Result
///
/// Returns [Success] with null if valid, [Failure] with [ValidationError] if invalid.
Result<void, ValidationError> validateTiradsArgsResult({
  required String composition,
  required String echogenicity,
  required String shape,
  required String margin,
  required List<String> echogenicFoci,
}) {
  if (!tiradsMapCategories["composition"]!.contains(composition)) {
    return Failure(ValidationError(
      'Invalid composition: "$composition". Must be one of: ${tiradsMapCategories["composition"]!.join(", ")}',
    ));
  }

  if (!tiradsMapCategories["echogenicity"]!.contains(echogenicity)) {
    return Failure(ValidationError(
      'Invalid echogenicity: "$echogenicity". Must be one of: ${tiradsMapCategories["echogenicity"]!.join(", ")}',
    ));
  }

  if (!tiradsMapCategories["shape"]!.contains(shape)) {
    return Failure(ValidationError(
      'Invalid shape: "$shape". Must be one of: ${tiradsMapCategories["shape"]!.join(", ")}',
    ));
  }

  if (!tiradsMapCategories["margin"]!.contains(margin)) {
    return Failure(ValidationError(
      'Invalid margin: "$margin". Must be one of: ${tiradsMapCategories["margin"]!.join(", ")}',
    ));
  }

  for (final f in echogenicFoci) {
    if (!tiradsMapCategories["echogenic_foci"]!.contains(f)) {
      return Failure(ValidationError(
        'Invalid echogenic foci: "$f". Must be one of: ${tiradsMapCategories["echogenic_foci"]!.join(", ")}',
      ));
    }
  }

  // Check for duplicates
  final uniqueValues = echogenicFoci.toSet();
  if (echogenicFoci.length != uniqueValues.length) {
    return Failure(ValidationError('Echogenic foci values cannot be duplicated'));
  }

  // Check foci exclusivity
  final exclusivityResult = validateEchogenicFociExclusivity(echogenicFoci);
  if (exclusivityResult.isFailure) {
    return exclusivityResult;
  }

  return const Success(null);
}

/// Validates 'none-comet' exclusivity with other echogenic foci
///
/// If 'none-comet' is selected, no other foci can be selected.
Result<void, ValidationError> validateEchogenicFociExclusivity(List<String> foci) {
  if (foci.contains("none-comet") && foci.length > 1) {
    return Failure(ValidationError(
      '"None or large comet-tail artifacts" cannot be selected with other echogenic foci',
    ));
  }
  return const Success(null);
}

/// Validates nodule size if provided
Result<void, ValidationError> validateSizeResult(double? sizeInCm) {
  if (sizeInCm != null && sizeInCm <= 0) {
    return Failure(ValidationError('Nodule size must be a positive value'));
  }
  return const Success(null);
}

// ============================================================
// Legacy validation function (kept for backward compatibility)
// ============================================================

/// Validates all TIRADS input parameters against allowed values
///
/// Raises [ArgumentError] if any parameter contains invalid values.
@Deprecated('Use validateTiradsArgsResult() for Result-based error handling')
void validateTiradsArgs(String composition, String echogenicity,
                     String shape, String margin, List<String> echogenicFoci) {
  
  final Map<String, List<String>> tiradsMapCategories = {
    "composition": ["cystic", "spongiform", "mixed", "solid", "undetermined"],
    "echogenicity": ["an", "hyper", "iso", "hypo", "very-hypo", "undetermined"],
    "shape": ["wider", "taller"],
    "margin": ["undetermined", "smooth", "ill-defined", "lob-irreg", "extra"],
    "echogenic_foci": ["none-comet", "macro-calc", "rim-calc", "punctate"]
  };
  
  // Check echogenic_foci is a list of strings (Dart typing already ensures this)
  
  if (!tiradsMapCategories["composition"]!.contains(composition)) {
    throw ArgumentError('Invalid value for composition; must be any of "cystic", "spongiform", "mixed", "solid", "undetermined"');
  }
  
  if (!tiradsMapCategories["echogenicity"]!.contains(echogenicity)) {
    throw ArgumentError('Invalid value for echogenicity; must be any of "an", "hyper", "iso", "hypo", "very-hypo", "undetermined"');
  }
  
  if (!tiradsMapCategories["shape"]!.contains(shape)) {
    throw ArgumentError('Invalid value for shape; must be any of "wider", "taller"');
  }
  
  if (!tiradsMapCategories["margin"]!.contains(margin)) {
    throw ArgumentError('Invalid value for margin; must be any of "undetermined", "smooth", "ill-defined", "lob-irreg", "extra"');
  }
  
  for (String f in echogenicFoci) {
    if (!tiradsMapCategories["echogenic_foci"]!.contains(f)) {
      throw ArgumentError('Invalid value(s) in echogenic_foci; must be in "none-comet", "macro-calc", "rim-calc", "punctate"');
    }
  }
  
  // Check for duplicates in echogenicFoci
  final Set<String> uniqueValues = echogenicFoci.toSet();
  if (echogenicFoci.length != uniqueValues.length) {
    throw ArgumentError("Values in echogenic_foci cannot be duplicated");
  }
}