import 'package:ai_gym/screens/coach.dart';
import 'package:ai_gym/screens/community.dart';
import 'package:ai_gym/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> open(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: gymTheme(),
        home: Scaffold(body: screen),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('coach ignores blank sends and responds to a local message', (
    tester,
  ) async {
    await open(tester, const CoachScreen());
    tester.view.physicalSize = const Size(320, 640);
    tester.view.viewInsets = const FakeViewPadding(bottom: 260);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    final input = find.byKey(const Key('coach-input'));
    await tester.enterText(input, '   ');
    await tester.tap(find.byKey(const Key('coach-send')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Phản hồi minh họa:'), findsNothing);

    await tester.enterText(input, '  Hãy giúp tôi khởi động  ');
    await tester.tap(find.byKey(const Key('coach-send')));
    await tester.pumpAndSettle();
    expect(find.text('Hãy giúp tôi khởi động'), findsOneWidget);
    expect(find.textContaining('Phản hồi minh họa:'), findsOneWidget);
    expect(tester.widget<TextField>(input).controller!.text, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('coach suggestion sends a matching local conversation', (
    tester,
  ) async {
    await open(tester, const CoachScreen());
    await tester.ensureVisible(find.text('Tạo lịch tập'));
    await tester.tap(find.text('Tạo lịch tập'));
    await tester.pumpAndSettle();
    expect(find.text('Tạo lịch tập cho tôi'), findsOneWidget);
    expect(find.textContaining('Thứ 2: thân trên'), findsOneWidget);
  });

  testWidgets('community like can be added and removed', (tester) async {
    await open(tester, const CommunityScreen());
    await tester.ensureVisible(find.byKey(const Key('community-like')));
    await tester.tap(find.byKey(const Key('community-like')));
    await tester.pumpAndSettle();
    expect(find.text('129'), findsOneWidget);
    await tester.tap(find.byKey(const Key('community-like')));
    await tester.pumpAndSettle();
    expect(find.text('128'), findsOneWidget);
  });

  testWidgets('community keeps a submitted local comment', (tester) async {
    await open(tester, const CommunityScreen());
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('community-comments')));
    await tester.tap(find.byKey(const Key('community-comments')));
    await tester.pumpAndSettle();
    tester.view.viewInsets = const FakeViewPadding(bottom: 260);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('comment-input')),
      '  Rất ấn tượng!  ',
    );
    await tester.tap(find.byKey(const Key('comment-send')));
    await tester.pumpAndSettle();
    expect(find.text('Rất ấn tượng!'), findsOneWidget);
    await tester.tap(find.byTooltip('Đóng bình luận'));
    tester.view.resetViewInsets();
    await tester.pumpAndSettle();
    expect(find.text('25'), findsOneWidget);
    await tester.tap(find.byKey(const Key('community-comments')));
    await tester.pumpAndSettle();
    expect(find.text('Rất ấn tượng!'), findsOneWidget);
  });

  testWidgets('trainer tab, connection and filters update visible state', (
    tester,
  ) async {
    await open(tester, const CommunityScreen());
    await tester.tap(find.text('Tìm PT / Bạn tập'));
    await tester.pumpAndSettle();
    expect(find.text('Linh Nguyễn'), findsNothing);
    await tester.ensureVisible(find.text('Kết nối ngay'));
    await tester.tap(find.text('Kết nối ngay'));
    await tester.pumpAndSettle();
    expect(find.text('Đã gửi lời mời'), findsOneWidget);
    await tester.tap(find.text('Đã gửi lời mời'));
    await tester.pumpAndSettle();
    expect(find.text('Kết nối ngay'), findsOneWidget);

    await tester.tap(find.byKey(const Key('community-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Đà Nẵng'));
    await tester.tap(find.text('Tăng cơ'));
    await tester.tap(find.text('Áp dụng'));
    await tester.pumpAndSettle();
    expect(find.text('Đà Nẵng • Tăng cơ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
