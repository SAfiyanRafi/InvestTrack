import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../businesses/models/business.dart';
import '../../businesses/providers/business_provider.dart';
import '../../transactions/models/transaction.dart';
import '../../transactions/providers/transaction_provider.dart';
import '../../notifications/providers/notification_event_engine.dart';
import '../models/document_attachment.dart';
import '../providers/document_provider.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final asyncAttachments = ref.watch(filteredDocumentAttachmentsProvider);
    final filterState = ref.watch(documentFilterNotifierProvider);
    final filterNotifier = ref.read(documentFilterNotifierProvider.notifier);

    final businesses = ref.watch(watchBusinessesProvider).valueOrNull ?? const [];
    final transactions = ref.watch(watchTransactionsProvider).valueOrNull ?? const <Transaction>[];

    final businessNames = <int, String>{
      for (final business in businesses) business.id: business.name,
    };

    final transactionNames = <int, String>{
      for (final tx in transactions)
        tx.id:
            '${_capitalize(tx.type.name)} - ${DateFormat('d MMM y').format(tx.date)}',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents & Attachments'),
        actions: [
          if (filterState.query.isNotEmpty || filterState.ownerType != null)
            IconButton(
              icon: const Icon(Icons.settings_backup_restore),
              tooltip: 'Reset Filters',
              onPressed: () {
                _searchController.clear();
                filterNotifier.reset();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.p16,
              AppSizes.p12,
              AppSizes.p16,
              AppSizes.p8,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: filterNotifier.setQuery,
              decoration: InputDecoration(
                hintText: 'Search files by name, type, or extension',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: filterState.query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          filterNotifier.setQuery('');
                        },
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
            child: Wrap(
              spacing: AppSizes.p8,
              runSpacing: AppSizes.p8,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: filterState.ownerType == null,
                  onSelected: (_) => filterNotifier.setOwnerType(null),
                ),
                ChoiceChip(
                  label: const Text('Business Files'),
                  selected: filterState.ownerType == AttachmentOwnerType.business,
                  onSelected: (_) => filterNotifier.setOwnerType(
                    AttachmentOwnerType.business,
                  ),
                ),
                ChoiceChip(
                  label: const Text('Transaction Files'),
                  selected:
                      filterState.ownerType == AttachmentOwnerType.transaction,
                  onSelected: (_) => filterNotifier.setOwnerType(
                    AttachmentOwnerType.transaction,
                  ),
                ),
              ],
            ),
          ),
          AppSizes.gapH12,
          Expanded(
            child: asyncAttachments.when(
              loading: () => const AppLoader(message: 'Loading documents...'),
              error: (error, _) => Center(child: Text('Error: $error')),
              data: (attachments) {
                if (attachments.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.p32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_copy_outlined,
                            size: 64,
                            color:
                                isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                          AppSizes.gapH16,
                          Text(
                            'No attachments yet',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppSizes.gapH8,
                          Text(
                            'Attach invoices, receipts, contracts, or tax documents to businesses and transactions.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          AppSizes.gapH20,
                          FilledButton.icon(
                            onPressed: () => _showAttachFilesSheet(
                              context,
                              businesses: businesses,
                              transactions: transactions,
                            ),
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Attach Files'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final isWide = MediaQuery.of(context).size.width >= 800;
                if (isWide) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(AppSizes.p16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.1,
                      crossAxisSpacing: AppSizes.p12,
                      mainAxisSpacing: AppSizes.p12,
                    ),
                    itemCount: attachments.length,
                    itemBuilder: (context, index) {
                      final attachment = attachments[index];
                      return _DocumentCard(
                        attachment: attachment,
                        ownerLabel: _ownerLabelFor(
                          attachment,
                          businessNames,
                          transactionNames,
                        ),
                        onOpen: () => _openAttachment(attachment),
                        onRename: () => _renameAttachment(attachment),
                        onDelete: () => _deleteAttachment(attachment),
                      );
                    },
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  itemCount: attachments.length,
                  itemBuilder: (context, index) {
                    final attachment = attachments[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.p12),
                      child: _DocumentCard(
                        attachment: attachment,
                        ownerLabel: _ownerLabelFor(
                          attachment,
                          businessNames,
                          transactionNames,
                        ),
                        onOpen: () => _openAttachment(attachment),
                        onRename: () => _renameAttachment(attachment),
                        onDelete: () => _deleteAttachment(attachment),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAttachFilesSheet(
          context,
          businesses: businesses,
          transactions: transactions,
        ),
        icon: const Icon(Icons.upload_file),
        label: const Text('Attach'),
      ),
    );
  }

  String _ownerLabelFor(
    DocumentAttachment attachment,
    Map<int, String> businessNames,
    Map<int, String> transactionNames,
  ) {
    if (attachment.ownerType == AttachmentOwnerType.business) {
      return 'Business: ${businessNames[attachment.ownerId] ?? 'Unknown'}';
    }
    return 'Transaction: ${transactionNames[attachment.ownerId] ?? 'Unknown'}';
  }

  Future<void> _showAttachFilesSheet(
    BuildContext context, {
    required List<Business> businesses,
    required List<Transaction> transactions,
  }) async {
    AttachmentOwnerType ownerType = AttachmentOwnerType.business;
    int? ownerId;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.r24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final ownerItems = ownerType == AttachmentOwnerType.business
                ? businesses
                    .map<DropdownMenuItem<int>>((business) => DropdownMenuItem<int>(
                          value: business.id,
                          child: Text(
                            business.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList()
                : transactions
                    .map<DropdownMenuItem<int>>((tx) {
                      final label =
                          '${_capitalize(tx.type.name)} - ${DateFormat('d MMM y').format(tx.date)}';
                      return DropdownMenuItem<int>(
                        value: tx.id,
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    })
                    .toList();

            return Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.p24,
                AppSizes.p24,
                AppSizes.p24,
                MediaQuery.of(context).viewInsets.bottom + AppSizes.p24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attach Files',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  AppSizes.gapH16,
                  SegmentedButton<AttachmentOwnerType>(
                    segments: const [
                      ButtonSegment(
                        value: AttachmentOwnerType.business,
                        label: Text('Business'),
                        icon: Icon(Icons.business_outlined),
                      ),
                      ButtonSegment(
                        value: AttachmentOwnerType.transaction,
                        label: Text('Transaction'),
                        icon: Icon(Icons.receipt_long_outlined),
                      ),
                    ],
                    selected: {ownerType},
                    onSelectionChanged: (selection) {
                      setModalState(() {
                        ownerType = selection.first;
                        ownerId = null;
                      });
                    },
                  ),
                  AppSizes.gapH16,
                  DropdownButtonFormField<int>(
                    initialValue: ownerId,
                    isExpanded: true,
                    menuMaxHeight: 360,
                    decoration: InputDecoration(
                      labelText: ownerType == AttachmentOwnerType.business
                          ? 'Select Business'
                          : 'Select Transaction',
                    ),
                    items: ownerItems,
                    onChanged: (value) {
                      setModalState(() {
                        ownerId = value;
                      });
                    },
                  ),
                  AppSizes.gapH20,
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () async {
                        if (ownerId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select an owner first.'),
                            ),
                          );
                          return;
                        }
                        Navigator.of(context).pop();
                        await _pickAndAttachFiles(ownerType, ownerId!);
                      },
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Choose Files'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _pickAndAttachFiles(
    AttachmentOwnerType ownerType,
    int ownerId,
  ) async {
    final picked = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: const [
        'pdf',
        'png',
        'jpg',
        'jpeg',
        'webp',
        'heic',
        'txt',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'csv',
      ],
    );

    if (picked == null || picked.files.isEmpty) return;

    final repo = ref.read(documentRepositoryProvider);
    final eventEngine = ref.read(notificationEventEngineProvider);
    final now = DateTime.now();
    var attachedCount = 0;

    for (final file in picked.files) {
      final path = file.path;
      if (path == null || path.isEmpty) {
        continue;
      }

      final diskFile = File(path);
      if (!diskFile.existsSync()) {
        continue;
      }

      final size = await diskFile.length();
      final extension = _extractExtension(file.name);

      final attachment = DocumentAttachment()
        ..ownerType = ownerType
        ..ownerId = ownerId
        ..displayName = file.name
        ..originalFileName = file.name
        ..filePath = path
        ..fileSizeBytes = size
        ..extension = extension
        ..mimeType = _inferMimeType(extension)
        ..uploadedAt = now
        ..updatedAt = now;

      await repo.saveAttachment(attachment);
      attachedCount++;
    }

    if (attachedCount > 0) {
      await eventEngine.emitDocumentAdded(
        ownerType: ownerType,
        ownerId: ownerId,
        count: attachedCount,
      );
      await eventEngine.suggestDocumentExpiry(
        ownerType: ownerType,
        ownerId: ownerId,
      );
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Files attached successfully.')),
    );
  }

  Future<void> _openAttachment(DocumentAttachment attachment) async {
    final extension = (attachment.extension ?? '').toLowerCase();
    if (_isImageExtension(extension)) {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => Dialog(
          insetPadding: const EdgeInsets.all(AppSizes.p16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: Text(
                  attachment.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Flexible(
                child: InteractiveViewer(
                  child: Image.file(
                    File(attachment.filePath),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) {
                      return const Padding(
                        padding: EdgeInsets.all(AppSizes.p24),
                        child: Text('Unable to preview this image.'),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    await OpenFilex.open(attachment.filePath);
  }

  Future<void> _renameAttachment(DocumentAttachment attachment) async {
    final controller = TextEditingController(text: attachment.displayName);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename Attachment'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Display Name'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final candidate = controller.text.trim();
                if (candidate.isEmpty) return;
                Navigator.of(context).pop(candidate);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newName == null || newName.isEmpty) return;

    await ref.read(documentRepositoryProvider).renameAttachment(
          attachment.id,
          newName,
        );
    await ref.read(notificationEventEngineProvider).emitDocumentUpdated(newName);
  }

  Future<void> _deleteAttachment(DocumentAttachment attachment) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Attachment'),
        content: Text(
          'Delete ${attachment.displayName}? This removes the file reference from InvestTrack.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    await ref.read(documentRepositoryProvider).deleteAttachment(attachment.id);
    await ref
      .read(notificationEventEngineProvider)
      .emitDocumentDeleted(attachment.displayName);
  }

  String _extractExtension(String filename) {
    final dot = filename.lastIndexOf('.');
    if (dot == -1 || dot == filename.length - 1) {
      return 'file';
    }
    return filename.substring(dot + 1).toLowerCase();
  }

  bool _isImageExtension(String extension) {
    return extension == 'png' ||
        extension == 'jpg' ||
        extension == 'jpeg' ||
        extension == 'webp' ||
        extension == 'heic';
  }

  String _inferMimeType(String extension) {
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      case 'csv':
        return 'text/csv';
      case 'doc':
      case 'docx':
        return 'application/msword';
      case 'xls':
      case 'xlsx':
        return 'application/vnd.ms-excel';
      default:
        return 'application/octet-stream';
    }
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    final regex = RegExp(r'(?<=[a-z])(?=[A-Z])');
    final words = value.split(regex);
    return words.map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.attachment,
    required this.ownerLabel,
    required this.onOpen,
    required this.onRename,
    required this.onDelete,
  });

  final DocumentAttachment attachment;
  final String ownerLabel;
  final VoidCallback onOpen;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _fileColor(attachment.extension).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.r12),
              ),
              child: Icon(
                _fileIcon(attachment.extension),
                color: _fileColor(attachment.extension),
              ),
            ),
            AppSizes.gapW12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attachment.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSizes.gapH4,
                  Text(
                    ownerLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                  AppSizes.gapH4,
                  Text(
                    '${_formatSize(attachment.fileSizeBytes)} - ${DateFormat('d MMM y, h:mm a').format(attachment.uploadedAt)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            PopupMenuButton<_AttachmentAction>(
              onSelected: (action) {
                switch (action) {
                  case _AttachmentAction.open:
                    onOpen();
                  case _AttachmentAction.rename:
                    onRename();
                  case _AttachmentAction.delete:
                    onDelete();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: _AttachmentAction.open,
                  child: Text('Open'),
                ),
                PopupMenuItem(
                  value: _AttachmentAction.rename,
                  child: Text('Rename'),
                ),
                PopupMenuItem(
                  value: _AttachmentAction.delete,
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _fileIcon(String? extension) {
    switch ((extension ?? '').toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'webp':
      case 'heic':
        return Icons.image_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      case 'xls':
      case 'xlsx':
      case 'csv':
        return Icons.table_chart_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  Color _fileColor(String? extension) {
    switch ((extension ?? '').toLowerCase()) {
      case 'pdf':
        return AppColors.error;
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'webp':
      case 'heic':
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < 1024 * 1024) {
      final kb = bytes / 1024;
      return '${kb.toStringAsFixed(1)} KB';
    }
    final mb = bytes / (1024 * 1024);
    return '${mb.toStringAsFixed(1)} MB';
  }
}

enum _AttachmentAction {
  open,
  rename,
  delete,
}
