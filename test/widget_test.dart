import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/main.dart';

void main() {
  testWidgets('app launches', (tester) async {
    await tester.pumpWidget(const FoodDeliveryApp());
    await tester.pump();
    expect(find.text('FoodieGo'), findsOneWidget);
  });
}
