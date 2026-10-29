import 'package:PiliPlus/utils/content_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContentFilter', () {
    test('detects charging metadata without matching ordinary titles', () {
      expect(
        ContentFilter.isCharging({
          'charging_pay': {'level': 1},
        }),
        isTrue,
      );
      expect(
        ContentFilter.isCharging({'title': '给手机充电的正确方法'}),
        isFalse,
      );
    });

    test('detects nested charging and paid badges', () {
      expect(
        ContentFilter.isCharging({
          'cover_badge': {'text': '充电专属'},
        }),
        isTrue,
      );
      expect(
        ContentFilter.paidLabel({
          'badge': {'text': '大会员专享'},
        }),
        '大会员专享',
      );
      expect(ContentFilter.isPaid({'badge': '普通视频'}), isFalse);
    });
  });
}
