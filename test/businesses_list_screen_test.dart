import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:investtrack/features/businesses/models/business.dart';
import 'package:investtrack/features/businesses/repositories/business_repository.dart';
import 'package:investtrack/features/businesses/providers/business_provider.dart';
import 'package:investtrack/features/businesses/screens/businesses_list_screen.dart';

class MockBusinessRepository implements BusinessRepository {
  @override
  Future<List<Business>> getAllBusinesses() async => [];

  @override
  Future<Business?> getBusinessById(int id) async => null;

  @override
  Future<void> saveBusiness(Business business) async {}

  @override
  Future<void> deleteBusiness(int id) async {}

  @override
  Stream<List<Business>> watchBusinesses() => Stream.value([
    Business()
      ..id = 1
      ..name = 'Mock Tech Corp'
      ..owner = 'Jane Doe'
      ..category = 'Tech & SaaS'
      ..ownershipPercentage = 80.0
      ..createdDate = DateTime.now()
      ..status = 'Active'
  ]);
}

void main() {
  testWidgets('BusinessesListScreen renders and displays businesses from Mock Repository', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          businessRepositoryProvider.overrideWithValue(MockBusinessRepository()),
        ],
        child: const MaterialApp(
          home: BusinessesListScreen(),
        ),
      ),
    );

    // Let the stream resolve
    await tester.pump();

    // Verify search bar is visible
    expect(find.byType(TextField), findsOneWidget);

    // Verify the business name from the stream is rendered
    expect(find.text('Mock Tech Corp'), findsOneWidget);
  });
}
