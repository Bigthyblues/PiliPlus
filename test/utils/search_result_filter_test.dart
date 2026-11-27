import 'package:PiliPlus/utils/search_result_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('long Chinese sentences use partial literal matches', () {
    const query = '我想学习如何制作一个巧克力蛋糕';
    final tokens = SearchResultFilter.queryTokens(query);

    expect(tokens, contains('巧克'));
    expect(tokens, contains('蛋糕'));
    expect(
      SearchResultFilter.matchScore(query, ['新手巧克力蛋糕制作教程']),
      greaterThan(0),
    );
  });

  test('English terms remain separate and case insensitive', () {
    expect(
      SearchResultFilter.matchScore(
        'Flutter State Management',
        ['A flutter state tutorial'],
      ),
      2,
    );
  });
}
