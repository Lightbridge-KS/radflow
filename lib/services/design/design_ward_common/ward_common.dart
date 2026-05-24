import '../_utils.dart';

/// The role of the person filling out a ward protocol form.
///
/// `label` doubles as the dropdown display text and the output line prefix
/// (e.g. `Fellow: <name> (Tel: <tel>)`), so changes here propagate to both
/// the UI and the rendered protocol.
enum ProtocolAuthor {
  resident('Resident'),
  fellow('Fellow'),
  staff('Staff');

  final String label;
  const ProtocolAuthor(this.label);
}

/// Shared "Check ภาพ" + author identification inputs collected on every
/// Protocol Ward screen (CVS, Chest, Abdomen, MSK, …).
///
/// Immutable; the input widget rebuilds a fresh instance on every change and
/// the screen feeds it into [WardCommon.append] when generating output.
class WardCommonValues {
  final bool checkImage;
  final bool beforeIv;
  final bool afterIv;
  final ProtocolAuthor author;
  final String authorName;
  final String authorTel;

  const WardCommonValues({
    required this.checkImage,
    required this.beforeIv,
    required this.afterIv,
    required this.author,
    required this.authorName,
    required this.authorTel,
  });

  /// Default state: nothing ticked, no text filled in, author = Resident
  /// (the most common case — preserves prior behavior for users who never
  /// touch the role selector).
  const WardCommonValues.empty()
      : checkImage = false,
        beforeIv = false,
        afterIv = false,
        author = ProtocolAuthor.resident,
        authorName = '',
        authorTel = '';

  WardCommonValues copyWith({
    bool? checkImage,
    bool? beforeIv,
    bool? afterIv,
    ProtocolAuthor? author,
    String? authorName,
    String? authorTel,
  }) {
    return WardCommonValues(
      checkImage: checkImage ?? this.checkImage,
      beforeIv: beforeIv ?? this.beforeIv,
      afterIv: afterIv ?? this.afterIv,
      author: author ?? this.author,
      authorName: authorName ?? this.authorName,
      authorTel: authorTel ?? this.authorTel,
    );
  }
}

/// Renders the trailing block appended to a ward protocol body.
///
/// Composed of two independent lines:
/// - the "Check ภาพ …" line, when `checkImage` is true;
/// - the author line (`<role>: <name> (Tel: <tel>)`), when `checkImage` is
///   true OR Name/Tel carries any non-blank text (the author may want to
///   attach reference info without claiming the image-check action).
///
/// Returns an empty string when neither line is needed, so callers can do
/// `body + (trailer.isEmpty ? '' : '\n$trailer')` without a branch.
class WardCommon {
  const WardCommon();

  String append(WardCommonValues v) {
    final hasAuthorText = v.authorName.trim().isNotEmpty ||
        v.authorTel.trim().isNotEmpty;

    final parts = <String>[];

    if (v.checkImage) {
      if (!v.beforeIv && !v.afterIv) {
        // No phase chosen yet — render just the marker so the line doesn't
        // dangle a meaningless "... ฉีด IV contrast" suffix.
        parts.add('Check ภาพ ...');
      } else {
        final phase = _phaseToken(beforeIv: v.beforeIv, afterIv: v.afterIv);
        parts.add('Check ภาพ $phase ฉีด IV contrast');
      }
    }

    if (v.checkImage || hasAuthorText) {
      final name = dashIfBlank(v.authorName);
      final tel = dashIfBlank(v.authorTel);
      parts.add('${v.author.label}: $name (Tel: $tel)');
    }

    return parts.join('\n\n');
  }

  String _phaseToken({required bool beforeIv, required bool afterIv}) {
    assert(beforeIv || afterIv,
        'caller must short-circuit before invoking _phaseToken with neither phase set');
    if (beforeIv && afterIv) return 'ก่อน + หลัง';
    return beforeIv ? 'ก่อน' : 'หลัง';
  }
}
