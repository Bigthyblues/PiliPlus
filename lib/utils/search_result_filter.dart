abstract final class SearchResultFilter {
  static final RegExp _punctuation = RegExp(
    r'[，。！？、；：,.!?;:"“”‘’()（）\[\]{}]+',
  );
  static final RegExp _cjk = RegExp(r'[\u3400-\u9fff]');

  static List<String> queryTokens(String keyword) {
    final segments = keyword
        .toLowerCase()
        .replaceAll(_punctuation, ' ')
        .trim()
        .split(RegExp(r'\s+'))
        .where((token) => token.isNotEmpty);
    return segments.expand((segment) {
      // Long, unsegmented Chinese natural-language queries almost never occur
      // verbatim in metadata. Bigrams retain literal matching while allowing
      // useful partial matches without adding a word-segmentation dependency.
      if (segment.length > 4 && _cjk.hasMatch(segment)) {
        return [
          for (var index = 0; index < segment.length - 1; index++)
            segment.substring(index, index + 2),
        ];
      }
      return [segment];
    }).toSet().toList();
  }

  static int matchScore(String keyword, Iterable<String?> fields) {
    final haystack = fields.whereType<String>().join(' ').toLowerCase();
    return queryTokens(keyword).where(haystack.contains).length;
  }
}
