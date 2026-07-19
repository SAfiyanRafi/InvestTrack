import 'package:isar/isar.dart';

part 'document_attachment.g.dart';

enum AttachmentOwnerType {
  business,
  transaction,
}

@collection
class DocumentAttachment {
  Id id = Isar.autoIncrement;

  @enumerated
  @Index()
  late AttachmentOwnerType ownerType;

  @Index()
  late int ownerId;

  @Index()
  late String displayName;

  late String originalFileName;

  late String filePath;

  late int fileSizeBytes;

  String? extension;

  String? mimeType;

  @Index()
  late DateTime uploadedAt;

  late DateTime updatedAt;
}
