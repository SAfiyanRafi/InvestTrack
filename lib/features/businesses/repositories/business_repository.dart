import '../models/business.dart';

/// Contract interface defining database CRUD and streaming operations for [Business].
abstract class BusinessRepository {
  /// Fetches all businesses persisted in the local database.
  Future<List<Business>> getAllBusinesses();

  /// Fetches a specific business profile by its unique database ID.
  Future<Business?> getBusinessById(int id);

  /// Persists (creates or updates) a business profile.
  Future<void> saveBusiness(Business business);

  /// Deletes a business profile by its unique ID.
  Future<void> deleteBusiness(int id);

  /// Emits a new list of businesses whenever the database collection changes.
  Stream<List<Business>> watchBusinesses();
}
