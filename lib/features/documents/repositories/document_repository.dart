import '../models/document_attachment.dart';

abstract class DocumentRepository {
  Future<List<DocumentAttachment>> getAllAttachments();

  Stream<List<DocumentAttachment>> watchAllAttachments();

  Stream<List<DocumentAttachment>> watchAttachmentsForOwner(
    AttachmentOwnerType ownerType,
    int ownerId,
  );

  Future<void> saveAttachment(DocumentAttachment attachment);

  Future<void> deleteAttachment(int id);

  Future<void> renameAttachment(int id, String displayName);
}
