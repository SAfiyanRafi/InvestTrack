import 'package:isar/isar.dart';

import '../models/document_attachment.dart';
import 'document_repository.dart';

class IsarDocumentRepository implements DocumentRepository {
  const IsarDocumentRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<DocumentAttachment>> getAllAttachments() {
    return _isar.documentAttachments.where().sortByUploadedAtDesc().findAll();
  }

  @override
  Stream<List<DocumentAttachment>> watchAllAttachments() {
    return _isar.documentAttachments.where().sortByUploadedAtDesc().watch(
      fireImmediately: true,
    );
  }

  @override
  Stream<List<DocumentAttachment>> watchAttachmentsForOwner(
    AttachmentOwnerType ownerType,
    int ownerId,
  ) {
    return _isar.documentAttachments
        .filter()
        .ownerTypeEqualTo(ownerType)
        .and()
        .ownerIdEqualTo(ownerId)
        .sortByUploadedAtDesc()
        .watch(fireImmediately: true);
  }

  @override
  Future<void> saveAttachment(DocumentAttachment attachment) async {
    await _isar.writeTxn(() async {
      await _isar.documentAttachments.put(attachment);
    });
  }

  @override
  Future<void> deleteAttachment(int id) async {
    await _isar.writeTxn(() async {
      await _isar.documentAttachments.delete(id);
    });
  }

  @override
  Future<void> renameAttachment(int id, String displayName) async {
    final existing = await _isar.documentAttachments.get(id);
    if (existing == null) return;

    existing.displayName = displayName;
    existing.updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.documentAttachments.put(existing);
    });
  }
}
