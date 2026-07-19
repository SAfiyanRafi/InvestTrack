import 'package:isar/isar.dart';
import '../models/business.dart';
import '../../transactions/models/transaction.dart';
import 'business_repository.dart';

/// Isar database implementation of [BusinessRepository].
class IsarBusinessRepository implements BusinessRepository {
  const IsarBusinessRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<Business>> getAllBusinesses() async {
    return _isar.business.where().findAll();
  }

  @override
  Future<Business?> getBusinessById(int id) async {
    return _isar.business.get(id);
  }

  @override
  Future<void> saveBusiness(Business business) async {
    await _isar.writeTxn(() async {
      await _isar.business.put(business);
    });
  }

  /// Deletes the business and **all transactions belonging to it** in a single
  /// atomic Isar write transaction.
  ///
  /// Atomicity guarantee: if either delete fails, Isar rolls back both
  /// operations so the database never reaches a half-deleted state.
  ///
  /// After this call completes, [watchBusinesses] and the global
  /// [watchTransactions] stream both emit simultaneously, causing the
  /// dashboard provider to recalculate every portfolio metric in the next
  /// Riverpod cycle.
  @override
  Future<void> deleteBusiness(int id) async {
    await _isar.writeTxn(() async {
      // 1. Find all transaction IDs that belong to this business.
      final orphanedTxIds = await _isar.transactions
          .filter()
          .businessIdEqualTo(id)
          .idProperty()
          .findAll();

      // 2. Delete the orphaned transactions first (referential integrity).
      if (orphanedTxIds.isNotEmpty) {
        await _isar.transactions.deleteAll(orphanedTxIds);
      }

      // 3. Delete the business record itself.
      await _isar.business.delete(id);
    });
  }

  @override
  Stream<List<Business>> watchBusinesses() {
    return _isar.business.where().watch(fireImmediately: true);
  }
}
