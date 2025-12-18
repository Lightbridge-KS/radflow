import 'tirads_calculator_data.dart';
import 'models/tirads_models.dart';
import '_validate_tirads_args.dart';
import '../../../core/result.dart';
import '../calculator_error.dart';

/// TI-RADS (Thyroid Imaging Reporting and Data System) Calculator
///
/// Calculates ACR TI-RADS level and FNA/follow-up recommendations
/// for thyroid nodules based on ultrasound characteristics.
class TiradsCalculator {
  // ============================================================
  // Public Methods
  // ============================================================

  /// Assesses a single thyroid nodule
  ///
  /// Returns a [Result] containing either [TiradsNoduleAssessment] or [CalculatorError].
  static Result<TiradsNoduleAssessment, CalculatorError> getTiradsNoduleAssessment({
    required int id,
    required String location,
    required String composition,
    required String echogenicity,
    required String shape,
    required String margin,
    required List<String> echogenicFoci,
    double? sizeInCm,
  }) {
    // Validate inputs
    final validationResult = validateTiradsArgsResult(
      composition: composition,
      echogenicity: echogenicity,
      shape: shape,
      margin: margin,
      echogenicFoci: echogenicFoci,
    );
    if (validationResult.isFailure) {
      return Failure(validationResult.errorOrNull!);
    }

    // Validate size
    final sizeResult = validateSizeResult(sizeInCm);
    if (sizeResult.isFailure) {
      return Failure(sizeResult.errorOrNull!);
    }

    try {
      // Calculate points
      final points = _calculatePoints(
        composition: composition,
        echogenicity: echogenicity,
        shape: shape,
        margin: margin,
        echogenicFoci: echogenicFoci,
      );

      final pointsTotal = points.composition +
          points.echogenicity +
          points.shape +
          points.margin +
          points.echogenicFoci;

      // Determine TR level
      final tiradsLevel = _determineTrLevel(pointsTotal);
      if (tiradsLevel == null) {
        return Failure(CalculationError(
          'Invalid TI-RADS total: $pointsTotal. This should be unreachable with ACR scoring.',
        ));
      }

      final tiradsLevelDesc = TiradsCalculatorData.tiradsMapLevels[tiradsLevel]!;

      // Get recommendation
      final recommendation = _getRecommendation(tiradsLevel, sizeInCm);

      // Build category record
      final category = (
        composition: composition,
        echogenicity: echogenicity,
        shape: shape,
        margin: margin,
        echogenicFoci: echogenicFoci,
      );

      // Build descriptions
      final categoryDescriptions = _getCategoryDescriptions(category);

      return Success((
        id: id,
        location: location,
        sizeInCm: sizeInCm,
        pointsTotal: pointsTotal,
        tiradsLevel: tiradsLevel,
        tiradsLevelDesc: tiradsLevelDesc,
        recommendation: recommendation,
        points: points,
        category: category,
        categoryDescriptions: categoryDescriptions,
      ));
    } catch (e) {
      return Failure(CalculationError('Unexpected error: $e'));
    }
  }

  /// Assesses multiple thyroid nodules
  ///
  /// Returns a [Result] containing [TiradsOverallAssessment] or [CalculatorError].
  /// Fails on first invalid nodule.
  static Result<TiradsOverallAssessment, CalculatorError>
      getTiradsOverallAssessment({
    required List<TiradsNoduleInput> nodules,
  }) {
    if (nodules.isEmpty) {
      return Failure(ValidationError('At least one nodule is required'));
    }

    final List<TiradsNoduleAssessment> assessments = [];

    for (final nodule in nodules) {
      final result = getTiradsNoduleAssessment(
        id: nodule.id,
        location: nodule.location,
        composition: nodule.composition,
        echogenicity: nodule.echogenicity,
        shape: nodule.shape,
        margin: nodule.margin,
        echogenicFoci: nodule.echogenicFoci,
        sizeInCm: nodule.sizeInCm,
      );

      switch (result) {
        case Success(value: final assessment):
          assessments.add(assessment);
        case Failure(error: final err):
          return Failure(err);
      }
    }

    final highestLevel = _getHighestTrLevel(assessments);
    final summary = _buildOverallSummary(assessments);

    return Success((
      nodules: assessments,
      totalNodules: assessments.length,
      highestTiradsLevel: highestLevel,
      summary: summary,
    ));
  }

  /// Converts a [TiradsNoduleAssessment] to a Map for Mustache template rendering
  static Map<String, dynamic> noduleToTemplateData(TiradsNoduleAssessment nodule) {
    return {
      // Basic info
      "id": nodule.id,
      "location": nodule.location,
      "sizeInCm": nodule.sizeInCm,
      "hasSizeProvided": nodule.sizeInCm != null,

      // Score
      "pointsTotal": nodule.pointsTotal,
      "tiradsLevel": nodule.tiradsLevel,
      "tiradsLevelDesc": nodule.tiradsLevelDesc,

      // Points breakdown
      // "compositionPoints": nodule.points.composition,
      // "echogenicityPoints": nodule.points.echogenicity,
      // "shapePoints": nodule.points.shape,
      // "marginPoints": nodule.points.margin,
      // "echogenicFociPoints": nodule.points.echogenicFoci,

      // Category values (short codes)
      // "composition": nodule.category.composition,
      // "echogenicity": nodule.category.echogenicity,
      // "shape": nodule.category.shape,
      // "margin": nodule.category.margin,
      // "echogenicFoci": nodule.category.echogenicFoci,

      // Category descriptions (human-readable)
      "compositionDesc": nodule.categoryDescriptions.composition,
      "echogenicityDesc": nodule.categoryDescriptions.echogenicity,
      "shapeDesc": nodule.categoryDescriptions.shape,
      "marginDesc": nodule.categoryDescriptions.margin,
      "echogenicFociDesc": nodule.categoryDescriptions.echogenicFociJoined,

      // Boolean flags for conditional description rendering
      "isShapeTaller": nodule.category.shape == "taller",
      "isMarginExtra": nodule.category.margin == "extra",
      "isEchogenicFociNoneComet": nodule.category.echogenicFoci.length == 1 &&
          nodule.category.echogenicFoci.first == "none-comet",

      // Recommendation
      "recommendationAction": nodule.recommendation.action,
      "recommendationFnaCutoff": nodule.recommendation.fnaCutoff,
      "recommendationFollowCutoff": nodule.recommendation.followCutoff,
      "recommendationSummary": nodule.recommendation.summary,

      // Boolean flags for conditional rendering
      "isTR1": nodule.tiradsLevel == "TR1",
      "isTR2": nodule.tiradsLevel == "TR2",
      "isTR3": nodule.tiradsLevel == "TR3",
      "isTR4": nodule.tiradsLevel == "TR4",
      "isTR5": nodule.tiradsLevel == "TR5",
      "needsFNA": nodule.recommendation.action == "FNA recommended",
      "needsFollowUp": nodule.recommendation.action == "Follow-up recommended",
      "noActionNeeded": nodule.recommendation.action == "No FNA" || nodule.recommendation.action == "No FNA or follow-up",
    };
  }

  /// Converts a [TiradsOverallAssessment] to a Map for Mustache template rendering
  ///
  /// Nodules are sorted by TR level (high to low: TR5 → TR1).
  static Map<String, dynamic> overallToTemplateData(
      TiradsOverallAssessment assessment) {
    // Sort nodules by TR level (high to low)
    final sortedNodules = List<TiradsNoduleAssessment>.from(assessment.nodules)
      ..sort((a, b) => _compareTrLevel(b.tiradsLevel, a.tiradsLevel));

    return {
      "totalNodules": assessment.totalNodules,
      "hasMultipleNodules": assessment.totalNodules > 1,
      "hasSingleNodule": assessment.totalNodules == 1,
      "highestTiradsLevel": assessment.highestTiradsLevel,
      "highestTiradsLevelDesc":
          TiradsCalculatorData.tiradsMapLevels[assessment.highestTiradsLevel],
      "summary": assessment.summary,
      "nodules": sortedNodules.map(noduleToTemplateData).toList(),
    };
  }

  /// Compares two TR levels for sorting. Returns negative if a < b, positive if a > b.
  static int _compareTrLevel(String a, String b) {
    const levelOrder = ["TR1", "TR2", "TR3", "TR4", "TR5"];
    return levelOrder.indexOf(a).compareTo(levelOrder.indexOf(b));
  }

  // ============================================================
  // Private Helper Methods
  // ============================================================

  static TiradsCategoryPoints _calculatePoints({
    required String composition,
    required String echogenicity,
    required String shape,
    required String margin,
    required List<String> echogenicFoci,
  }) {
    final compositionPts =
        TiradsCalculatorData.tiradsMapPoints["composition"]![composition]!;
    final echogenicityPts =
        TiradsCalculatorData.tiradsMapPoints["echogenicity"]![echogenicity]!;
    final shapePts =
        TiradsCalculatorData.tiradsMapPoints["shape"]![shape]!;
    final marginPts =
        TiradsCalculatorData.tiradsMapPoints["margin"]![margin]!;

    // Sum all selected echogenic foci points
    final echogenicFociPts = echogenicFoci.fold<int>(
      0,
      (sum, foci) =>
          sum + TiradsCalculatorData.tiradsMapPoints["echogenic_foci"]![foci]!,
    );

    return (
      composition: compositionPts,
      echogenicity: echogenicityPts,
      shape: shapePts,
      margin: marginPts,
      echogenicFoci: echogenicFociPts,
    );
  }

  /// Returns TR level string or null if points is invalid (1)
  static String? _determineTrLevel(int pointsTotal) {
    if (pointsTotal == 0) return "TR1";
    if (pointsTotal == 1) return null; // Invalid - unreachable with ACR scoring
    if (pointsTotal == 2) return "TR2";
    if (pointsTotal == 3) return "TR3";
    if (pointsTotal >= 4 && pointsTotal <= 6) return "TR4";
    if (pointsTotal >= 7) return "TR5";
    return null;
  }

  static TiradsRecommendation _getRecommendation(
      String tiradsLevel, double? sizeInCm) {
    final cutoffs =
        TiradsCalculatorData.tiradsRecommendationCutoffs[tiradsLevel]!;
    final fnaCutoff = cutoffs["fna"];
    final followCutoff = cutoffs["follow"];

    // TR1 and TR2: No FNA at any size
    if (fnaCutoff == null && followCutoff == null) {
      return (
        action: "No FNA",
        fnaCutoff: null,
        followCutoff: null,
        summary: "",
      );
    }

    // TR3-TR5: Size-dependent recommendation
    final fnaCutoffStr = "≥${fnaCutoff!} cm";
    final followCutoffStr = "≥${followCutoff!} cm";

    if (sizeInCm == null) {
      // No size provided: show both cutoffs
      return (
        action: "Size-dependent",
        fnaCutoff: fnaCutoffStr,
        followCutoff: followCutoffStr,
        summary: "FNA if $fnaCutoffStr, Follow if $followCutoffStr",
      );
    }

    // Size provided: evaluate against cutoffs
    if (sizeInCm >= fnaCutoff) {
      return (
        action: "FNA recommended",
        fnaCutoff: fnaCutoffStr,
        followCutoff: followCutoffStr,
        summary: "FNA is recommended",
      );
    } else if (sizeInCm >= followCutoff) {
      return (
        action: "Follow-up recommended",
        fnaCutoff: fnaCutoffStr,
        followCutoff: followCutoffStr,
        summary: "Follow-up is recommended",
      );
    } else {
      return (
        action: "No FNA or follow-up",
        fnaCutoff: fnaCutoffStr,
        followCutoff: followCutoffStr,
        summary: "",
      );
    }
  }

  static TiradsCategoryDescriptions _getCategoryDescriptions(
      TiradsCategory category) {
    final compositionDesc =
        TiradsCalculatorData.tiradsMapDesc["composition"]![category.composition]!;
    final echogenicityDesc =
        TiradsCalculatorData.tiradsMapDesc["echogenicity"]![category.echogenicity]!;
    final shapeDesc =
        TiradsCalculatorData.tiradsMapDesc["shape"]![category.shape]!;
    final marginDesc =
        TiradsCalculatorData.tiradsMapDesc["margin"]![category.margin]!;

    final echogenicFociDescList = category.echogenicFoci
        .map((f) => TiradsCalculatorData.tiradsMapDesc["echogenic_foci"]![f]!)
        .toList();

    return (
      composition: compositionDesc,
      echogenicity: echogenicityDesc,
      shape: shapeDesc,
      margin: marginDesc,
      echogenicFociJoined: echogenicFociDescList.join(", "),
    );
  }

  static String _getHighestTrLevel(List<TiradsNoduleAssessment> nodules) {
    if (nodules.isEmpty) return "TR1";

    const levelOrder = ["TR1", "TR2", "TR3", "TR4", "TR5"];
    int highestIndex = 0;

    for (final nodule in nodules) {
      final index = levelOrder.indexOf(nodule.tiradsLevel);
      if (index > highestIndex) {
        highestIndex = index;
      }
    }

    return levelOrder[highestIndex];
  }

  static String? _buildOverallSummary(List<TiradsNoduleAssessment> nodules) {
    if (nodules.isEmpty) return null;
    if (nodules.length == 1) return null;

    final highestLevel = _getHighestTrLevel(nodules);
    final highestDesc = TiradsCalculatorData.tiradsMapLevels[highestLevel];

    // Count nodules needing FNA
    final fnaCount = nodules
        .where((n) => n.recommendation.action == "FNA recommended")
        .length;
    final followCount = nodules
        .where((n) => n.recommendation.action == "Follow-up recommended")
        .length;

    final parts = <String>[];
    parts.add("- ${nodules.length} nodules evaluated");
    parts.add("- Highest category: $highestLevel ($highestDesc)");
    if (fnaCount > 0) parts.add("- $fnaCount nodule(s) recommended for FNA");
    if (followCount > 0) parts.add("- $followCount nodule(s) recommended for follow-up");

    return parts.join("\n");
  }

  // ============================================================
  // Deprecated Methods (Backward Compatibility)
  // ============================================================

  @Deprecated('Use getTiradsNoduleAssessment() instead')
  static Map<String, String> getTiradsLevels({
    required String composition,
    required String echogenicity,
    required String shape,
    required String margin,
    required List<String> echogenicFoci,
  }) {
    // ignore: deprecated_member_use_from_same_package
    validateTiradsArgs(composition, echogenicity, shape, margin, echogenicFoci);

    final Map<String, dynamic> pt = getTiradsPoints(
      composition: composition,
      echogenicity: echogenicity,
      shape: shape,
      margin: margin,
      echogenicFoci: echogenicFoci,
    );

    final int pointsTotal = pt["points_tot"] as int;

    String tr;
    if (pointsTotal == 1) {
      throw StateError(
        'Invalid TI-RADS total: 1. This should be unreachable with ACR scoring.',
      );
    }

    if (pointsTotal >= 7) {
      tr = "TR5";
    } else if (pointsTotal >= 4) {
      tr = "TR4";
    } else if (pointsTotal == 3) {
      tr = "TR3";
    } else if (pointsTotal == 2) {
      tr = "TR2";
    } else if (pointsTotal == 0) {
      tr = "TR1";
    } else {
      tr = "Undefined";
    }

    return {"tr": tr, "desc": TiradsCalculatorData.tiradsMapLevels[tr]!};
  }

  @Deprecated('Use getTiradsNoduleAssessment() instead')
  static Map<String, dynamic> getTiradsPoints({
    required String composition,
    required String echogenicity,
    required String shape,
    required String margin,
    required List<String> echogenicFoci,
  }) {
    // ignore: deprecated_member_use_from_same_package
    validateTiradsArgs(composition, echogenicity, shape, margin, echogenicFoci);

    final Map<String, dynamic> userSelections = {
      "composition": composition,
      "echogenicity": echogenicity,
      "shape": shape,
      "margin": margin,
      "echogenic_foci": echogenicFoci,
    };

    final Map<String, int> points = {};

    userSelections.forEach((String category, dynamic selection) {
      if (category == "echogenic_foci") {
        points[category] = (selection as List<String>).fold(
          0,
          (sum, s) => sum + TiradsCalculatorData.tiradsMapPoints[category]![s]!,
        );
      } else {
        points[category] =
            TiradsCalculatorData.tiradsMapPoints[category]![selection]!;
      }
    });

    int pointsTotal = points.values.reduce((sum, value) => sum + value);

    return {
      "points": points,
      "points_tot": pointsTotal,
      "categories": {
        "composition": composition,
        "echogenicity": echogenicity,
        "shape": shape,
        "margin": margin,
        "echogenic_foci": echogenicFoci,
      },
    };
  }
}
