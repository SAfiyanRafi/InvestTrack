import '../models/transaction.dart';

/// Contract interface defining database CRUD and streaming operations for [Transaction].
abstract class TransactionRepository {
  /// Fetches all transactions persisted in the local database.
  Future<List<Transaction>> getAllTransactions();

  /// Fetches all transactions for a specific business ID.
  Future<List<Transaction>> getTransactionsForBusiness(int businessId);

  /// Fetches a specific transaction by its unique database ID.
  /// Returns null if no transaction with that ID exists.
  Future<Transaction?> getTransactionById(int id);

  /// Persists (creates or updates) a transaction record.
  Future<void> saveTransaction(Transaction transaction);

  /// Deletes a single transaction by its unique ID.
  Future<void> deleteTransaction(int id);

  /// Deletes **all** transactions whose [Transaction.businessId] matches
  /// [businessId]. Exposed as an explicit named method so that higher-level
  /// services or use-cases can call it directly without accessing Isar.
  ///
  /// Note: cascade deletion triggered by [BusinessRepository.deleteBusiness]
  /// already calls this logic internally (atomically). This method is provided
  /// for additional flexibility and testability.
  Future<void> deleteAllTransactionsForBusiness(int businessId);

  /// Emits a new list of all transactions whenever the database collection changes.
  Stream<List<Transaction>> watchTransactions();

  /// Emits a new list of transactions for a specific business whenever
  /// that business's transaction collection changes.
  Stream<List<Transaction>> watchTransactionsForBusiness(int businessId);
}
