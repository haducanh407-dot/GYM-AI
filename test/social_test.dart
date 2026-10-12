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
    expect(tester.widget<TextField>(input).controller!.text, '   ');

    await tester.enterText(input, '  Hay giup toi khoi dong  ');
    await tester.tap(find.byKey(const Key('coach-send')));
    await tester.pumpAndSettle();
    expect(find.text('Hay giup toi khoi dong'), findsOneWidget);
    expect(tester.widget<TextField>(input).controller!.text, isEmpty);
    expect(tester.takeException(), isNull);
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
      '  Rat an tuong!  ',
    );
    await tester.tap(find.byKey(const Key('comment-send')));
    await tester.pumpAndSettle();
    expect(find.text('Rat an tuong!'), findsOneWidget);
    await tester.tap(find.byTooltip('Dong binh luan'));
    tester.view.resetViewInsets();
    await tester.pumpAndSettle();
    expect(find.text('25'), findsOneWidget);
    await tester.tap(find.byKey(const Key('community-comments')));
    await tester.pumpAndSettle();
    expect(find.text('Rat an tuong!'), findsOneWidget);
  });

  testWidgets('community can create, edit and delete a post', (tester) async {
    await open(tester, const CommunityScreen());

    await tester.tap(find.byKey(const Key('create-post')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('post-content-input')),
      '  Buoi tap lung rat on  ',
    );
    await tester.tap(find.byKey(const Key('save-post')));
    await tester.pumpAndSettle();
    expect(find.text('Buoi tap lung rat on'), findsOneWidget);

    await tester.tap(find.byKey(const Key('post-menu-post-3')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('edit-post-post-3')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('post-content-input')),
      'Da sua noi dung',
    );
    await tester.tap(find.byKey(const Key('save-post')));
    await tester.pumpAndSettle();
    expect(find.text('Da sua noi dung'), findsOneWidget);
    expect(find.text('Buoi tap lung rat on'), findsNothing);

    await tester.tap(find.byKey(const Key('post-menu-post-3')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('delete-post-post-3')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-delete-post')));
    await tester.pumpAndSettle();
    expect(find.text('Da sua noi dung'), findsNothing);
  });

  testWidgets('trainer tab, connection and filters update visible state', (
    tester,
  ) async {
    await open(tester, const CommunityScreen());
    await tester.tap(find.text('Tim PT / Ban tap'));
    await tester.pumpAndSettle();
    expect(find.text('Linh Nguyen'), findsNothing);
    await tester.ensureVisible(find.text('Ket noi ngay'));
    await tester.tap(find.text('Ket noi ngay'));
    await tester.pumpAndSettle();
    expect(find.text('Da gui loi moi'), findsOneWidget);
    await tester.tap(find.text('Da gui loi moi'));
    await tester.pumpAndSettle();
    expect(find.text('Ket noi ngay'), findsOneWidget);

    await tester.tap(find.byKey(const Key('community-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Da Nang'));
    await tester.tap(find.text('Tang co'));
    await tester.tap(find.text('Ap dung'));
    await tester.pumpAndSettle();
    expect(find.text('Da Nang - Tang co'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
