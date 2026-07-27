import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/isar_database.dart';
import '../models/document_attachment.dart';
import '../repositories/document_repository.dart';
import '../repositories/isar_document_repository.dart';

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return IsarDocumentRepository(isar);
});

final watchDocumentAttachmentsProvider =
    StreamProvider<List<DocumentAttachment>>((ref) {
      final repo = ref.watch(documentRepositoryProvider);
      return repo.watchAllAttachments();
    });

class DocumentFilterState {
  const DocumentFilterState({this.query = '', this.ownerType});

  final String query;
  final AttachmentOwnerType? ownerType;

  DocumentFilterState copyWith({
    String? query,
    AttachmentOwnerType? ownerType,
    bool clearOwnerType = false,
  }) {
    return DocumentFilterState(
      query: query ?? this.query,
      ownerType: clearOwnerType ? null : (ownerType ?? this.ownerType),
    );
  }
}

class DocumentFilterNotifier extends Notifier<DocumentFilterState> {
  @override
  DocumentFilterState build() => const DocumentFilterState();

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setOwnerType(AttachmentOwnerType? ownerType) {
    if (ownerType == null) {
      state = state.copyWith(clearOwnerType: true);
      return;
    }
    state = state.copyWith(ownerType: ownerType);
  }

  void reset() {
    state = const DocumentFilterState();
  }
}

final documentFilterNotifierProvider =
    NotifierProvider<DocumentFilterNotifier, DocumentFilterState>(
      DocumentFilterNotifier.new,
    );

final filteredDocumentAttachmentsProvider =
    Provider<AsyncValue<List<DocumentAttachment>>>((ref) {
      final asyncDocuments = ref.watch(watchDocumentAttachmentsProvider);
      final filter = ref.watch(documentFilterNotifierProvider);

      return asyncDocuments.whenData((documents) {
        final filtered = documents.where((attachment) {
          if (filter.ownerType != null &&
              attachment.ownerType != filter.ownerType) {
            return false;
          }

          if (filter.query.isNotEmpty) {
            final query = filter.query.toLowerCase();
            final displayNameMatch = attachment.displayName
                .toLowerCase()
                .contains(query);
            final fileNameMatch = attachment.originalFileName
                .toLowerCase()
                .contains(query);
            final extensionMatch =
                attachment.extension?.toLowerCase().contains(query) ?? false;

            if (!displayNameMatch && !fileNameMatch && !extensionMatch) {
              return false;
            }
          }

          return true;
        }).toList();

        filtered.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
        return filtered;
      });
    });
