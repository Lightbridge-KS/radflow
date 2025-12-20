// ===== Data Module for TI-RADS Calculator =====

class TiradsCalculatorData {

  // Mapping for category descriptions in the Mustache Template
  static const Map<String, Map<String, String>> tiradsMapDesc = {
    "composition": {
      "cystic": "cystic",
      "spongiform": "spongiform",
      "mixed": "mixed cystic and solid",
      "solid": "solid",
      "undetermined": "cannot be determined composition due to calcification",
    },
    "echogenicity": {
      "an": "anechoic",
      "hyper": "hyper/isoechoic",
      "iso": "isoechoic",
      "hypo": "hypoechoic",
      "very-hypo": "very hypoechoic",
      "undetermined": "can not be determined echogenicity",
    },
    "shape": {"wider": "", "taller": "taller-than-wide"},
    "margin": {
      "undetermined": "can not be determined margin",
      "smooth": "smooth",
      "ill-defined": "ill-defined",
      "lob-irreg": "lobulated or irregular",
      "extra": "extrathyroidal extension",
    },
    "echogenic_foci": {
      "none-comet": "none or Large comet-tail artifacts",
      "macro-calc": "macrocalcification",
      "rim-calc": "rim calcification",
      "punctate": "punctate echogenic foci",
    },
  };

  // Mapping for `DropdownMenu` or `CheckboxListTile` in the UI layer
  static const Map<String, Map<String, String>> tiradsMapUIchoices = {
    "composition": {
      "cystic": "Cystic or almost completely cystic (0)",
      "spongiform": "Spongiform (0)",
      "mixed": "Mixed cystic and solid (1)",
      "solid": "Solid or almost completely solid (2)",
      "undetermined": "Cannot be determined due to calcification (2)",
    },
    "echogenicity": {
      "an": "Anechoic (0)",
      "hyper": "Hyperechoic or Isoechoic (1)",
      "iso": "Isoechoic (1)",
      "hypo": "Hypoechoic (2)",
      "very-hypo": "Very hypoechoic (3)",
      "undetermined": "Can not be determined (1)",
    },
    "shape": {"wider": "Wider-than-tall (0)", "taller": "Taller-than-wide (3)"},
    "margin": {
      "undetermined": "Can not be determined (0)",
      "smooth": "Smooth (0)",
      "ill-defined": "Ill-defined (0)",
      "lob-irreg": "Lobulated or Irregular (2)",
      "extra": "Extrathyroidal extension (3)",
    },
    "echogenic_foci": {
      "none-comet": "None or Large comet-tail artifacts (0)",
      "macro-calc": "Macrocalcification (1)",
      "rim-calc": "Rim calcification (2)",
      "punctate": "Punctate echogenic foci (3)",
    },
  };

  static const Map<String, Map<String, int>> tiradsMapPoints = {
    "composition": {
      "cystic": 0,
      "spongiform": 0,
      "mixed": 1,
      "solid": 2,
      "undetermined": 2,
    },
    "echogenicity": {
      "an": 0,
      "hyper": 1,
      "iso": 1,
      "hypo": 2,
      "very-hypo": 3,
      "undetermined": 1,
    },
    "shape": {"wider": 0, "taller": 3},
    "margin": {
      "undetermined": 0,
      "smooth": 0,
      "ill-defined": 0,
      "lob-irreg": 2,
      "extra": 3,
    },
    "echogenic_foci": {
      "none-comet": 0,
      "macro-calc": 1,
      "rim-calc": 2,
      "punctate": 3,
    },
  };

  static const Map<String, String> tiradsMapLevels = {
    "TR1": "Benign",
    "TR2": "Not Suspicious",
    "TR3": "Mildly Suspicious",
    "TR4": "Moderately Suspicious",
    "TR5": "Highly Suspicious",
  };

  /// FNA and follow-up size cutoffs by TR level (in cm)
  /// - fna: Size threshold for FNA recommendation
  /// - follow: Size threshold for follow-up recommendation
  /// - null means no FNA/follow-up recommended at any size
  static const Map<String, Map<String, double?>> tiradsRecommendationCutoffs = {
    "TR1": {"fna": null, "follow": null},
    "TR2": {"fna": null, "follow": null},
    "TR3": {"fna": 2.5, "follow": 1.5},
    "TR4": {"fna": 1.5, "follow": 1.0},
    "TR5": {"fna": 1.0, "follow": 0.5},
  };
}
