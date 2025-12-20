// Data Models for TI-RADS Calculator

/// Input categories for TIRADS assessment
typedef TiradsCategory = ({
  String composition,
  String echogenicity,
  String shape,
  String margin,
  List<String> echogenicFoci,
});

/// Points breakdown by category
typedef TiradsCategoryPoints = ({
  int composition,
  int echogenicity,
  int shape,
  int margin,
  int echogenicFoci,
});

/// Human-readable descriptions for template rendering
typedef TiradsCategoryDescriptions = ({
  String composition,
  String echogenicity,
  String shape,
  String margin,
  String echogenicFociJoined,
});

/// Size-based FNA recommendation
typedef TiradsRecommendation = ({
  String action,
  String? fnaCutoff,
  String? followCutoff,
  String summary,
});

/// Input data for batch nodule assessment
typedef TiradsNoduleInput = ({
  int id,
  String location,
  String composition,
  String echogenicity,
  String shape,
  String margin,
  List<String> echogenicFoci,
  double? sizeInCm,
});

/// Single nodule assessment result
typedef TiradsNoduleAssessment = ({
  int id,
  String location,
  double? sizeInCm,
  int pointsTotal,
  String tiradsLevel,
  String tiradsLevelDesc,
  TiradsRecommendation recommendation,
  TiradsCategoryPoints points,
  TiradsCategory category,
  TiradsCategoryDescriptions categoryDescriptions,
});

/// Overall assessment containing multiple nodules
typedef TiradsOverallAssessment = ({
  List<TiradsNoduleAssessment> nodules,
  int totalNodules,
  String highestTiradsLevel,
  String? summary,
});
