import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:investtrack/features/businesses/models/business.dart';
import 'package:investtrack/features/businesses/repositories/isar_business_repository.dart';
import 'package:investtrack/features/transactions/models/transaction.dart';

void main() {
  late Isar isar;
  late IsarBusinessRepository repository;
  late Directory tempDir;

  setUpAll(() async {
    // Downloads and initializes native Isar binaries locally for unit testing
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('isar_business_test_');
    isar = await Isar.open(
      [BusinessSchema, TransactionSchema],
      directory: tempDir.path,
      name: 'business_test_db',
    );
    repository = IsarBusinessRepository(isar);
  });

  tearDown(() async {
    await isar.close();
    await tempDir.delete(recursive: true);
  });

  test('Business CRUD operations persist and delete successfully', () async {
    // 1. Create (Save)
    final business = Business()
      ..name = 'Test Tech Inc'
      ..owner = 'Alice Smith'
      ..category = 'Tech & SaaS'
      ..ownershipPercentage = 60.0
      ..createdDate = DateTime.now();

    await repository.saveBusiness(business);
    expect(business.id, isNot(0));

    // 2. Read (Get)
    final fetched = await repository.getBusinessById(business.id);
    expect(fetched, isNotNull);
    expect(fetched!.name, equals('Test Tech Inc'));
    expect(fetched.owner, equals('Alice Smith'));
    expect(fetched.ownershipPercentage, equals(60.0));

    // 3. Update
    fetched.name = 'Updated Tech Corp';
    await repository.saveBusiness(fetched);

    final updated = await repository.getBusinessById(business.id);
    expect(updated!.name, equals('Updated Tech Corp'));

    // 4. Get All
    final list = await repository.getAllBusinesses();
    expect(list.length, equals(1));

    // 5. Delete
    await repository.deleteBusiness(business.id);
    final deleted = await repository.getBusinessById(business.id);
    expect(deleted, isNull);
  });

  test('Watch businesses stream emits updates dynamically', () async {
    final stream = repository.watchBusinesses();

    // Verify stream emits in sequence:
    // 1. Initial list (empty)
    // 2. Updated list (1 item)
    expect(stream, emitsInOrder([isEmpty, hasLength(1)]));

    final business = Business()
      ..name = 'Real Estate Fund'
      ..category = 'Real Estate'
      ..createdDate = DateTime.now();

    // Trigger update
    await repository.saveBusiness(business);
  });
}
