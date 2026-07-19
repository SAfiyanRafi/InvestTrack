import 'package:isar/isar.dart';

part 'transaction.g.dart';

/// Defines the supported transaction events in the financial ledger.
enum TransactionType {
  investment,
  additionalInvestment,
  income,
  dividend,
  expense,
  withdrawal,
  loan,
  loanRepayment,
  assetPurchase,
  assetSale,
  tax,
  other,
}

@collection
class Transaction {
  Id id = Isar.autoIncrement;

  @Index()
  late int businessId;

  @enumerated
  @Index()
  late TransactionType type;

  late double amount;

  String currency = 'PKR';

  @Index()
  late DateTime date;

  String? description;

  @Index()
  String? category;

  String? attachmentPath;

  List<String> tags = [];
}
