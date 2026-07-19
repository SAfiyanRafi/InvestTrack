import 'package:isar/isar.dart';
import '../models/transaction.dart';
import 'transaction_repository.dart';

/// Isar database implementation of [TransactionRepository].
class IsarTransactionRepository implements TransactionRepository {
  const IsarTransactionRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<Transaction>> getAllTransactions() async {
    return _isar.transactions.where().findAll();
  }

  @override
  Future<List<Transaction>> getTransactionsForBusiness(int businessId) async {
    return _isar.transactions.filter().businessIdEqualTo(businessId).findAll();
  }

  @override
  Future<Transaction?> getTransactionById(int id) async {
    return _isar.transactions.get(id);
  }

  @override
  Future<void> saveTransaction(Transaction transaction) async {
    await _isar.writeTxn(() async {
      await _isar.transactions.put(transaction);
    });
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await _isar.writeTxn(() async {
      await _isar.transactions.delete(id);
    });
  }

  /// Deletes every transaction whose [Transaction.businessId] equals
  /// [businessId]. Used by the cascade-delete path and by any future
  /// service/use-case that needs bulk removal without touching Isar directly.
  @override
  Future<void> deleteAllTransactionsForBusiness(int businessId) async {
    await _isar.writeTxn(() async {
      final ids = await _isar.transactions
          .filter()
          .businessIdEqualTo(businessId)
          .idProperty()
          .findAll();
      if (ids.isNotEmpty) {
        await _isar.transactions.deleteAll(ids);
      }
    });
  }

  @override
  Stream<List<Transaction>> watchTransactions() {
    return _isar.transactions.where().watch(fireImmediately: true);
  }

  @override
  Stream<List<Transaction>> watchTransactionsForBusiness(int businessId) {
    return _isar.transactions
        .filter()
        .businessIdEqualTo(businessId)
        .watch(fireImmediately: true);
  }
}
