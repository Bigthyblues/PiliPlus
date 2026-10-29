abstract final class ContentFilter {
  static const _badgeKeys = {
    'badge',
    'badge_text',
    'cover_badge',
    'cover_badge_style',
    'cover_right_text',
    'business_info',
    'rcmd_reason',
  };

  static String? _badgeText(Object? value) {
    if (value is String) return value;
    if (value is Map) {
      for (final key in const ['text', 'content']) {
        final text = _badgeText(value[key]);
        if (text?.isNotEmpty == true) return text;
      }
    }
    if (value is List) {
      for (final item in value) {
        final text = _badgeText(item);
        if (text?.isNotEmpty == true) return text;
      }
    }
    return null;
  }

  static String? badgeText(Map<String, dynamic> json) {
    for (final key in _badgeKeys) {
      final text = _badgeText(json[key]);
      if (text?.isNotEmpty == true) return text;
    }
    return null;
  }

  static bool isCharging(Map<String, dynamic> json) {
    if (json['charging_pay'] case final Map chargingPay) {
      if (chargingPay['level'] != null) return true;
    }
    return _matchingBadge(json, (text) => text.contains('充电专属')) != null;
  }

  static String? paidLabel(Map<String, dynamic> json) {
    final pgcLabel = json['pgc_label'];
    if (pgcLabel is String && _isPaidLabel(pgcLabel)) return pgcLabel;
    return _matchingBadge(json, _isPaidLabel);
  }

  static bool isPaid(Map<String, dynamic> json) => paidLabel(json) != null;

  static bool _isPaidLabel(String label) =>
      const ['付费', '会员', '大会员', '专享'].any(label.contains);

  static String? _matchingBadge(
    Map<String, dynamic> json,
    bool Function(String) test,
  ) {
    String? visit(Object? value) {
      if (value is String) return test(value) ? value : null;
      if (value is Map) {
        for (final entry in value.entries) {
          final match = visit(entry.value);
          if (match != null) return match;
        }
      }
      if (value is List) {
        for (final item in value) {
          final match = visit(item);
          if (match != null) return match;
        }
      }
      return null;
    }

    for (final key in _badgeKeys) {
      final match = visit(json[key]);
      if (match != null) return match;
    }
    return null;
  }
}
