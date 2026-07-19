import 'package:isar/isar.dart';

part 'business.g.dart';

@collection
class Business {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String name;

  String? owner;

  @Index(type: IndexType.value)
  String? category;

  @Index(type: IndexType.value)
  String status = 'Active'; // 'Active', 'Archived'

  String? description;

  String? location;

  double ownershipPercentage = 100.0;

  late DateTime createdDate;

  String? logoPath;

  List<String> tags = [];
}
