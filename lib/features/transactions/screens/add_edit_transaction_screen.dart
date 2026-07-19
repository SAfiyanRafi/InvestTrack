import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../businesses/providers/business_provider.dart';
import '../../notifications/providers/notification_event_engine.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';

/// Screen for logging a new [Transaction] or updating an existing one.
class AddEditTransactionScreen extends ConsumerStatefulWidget {
  const AddEditTransactionScreen({
    this.transactionId,
    this.businessId,
    super.key,
  });

  final int? transactionId;
  final int? businessId;

  @override
  ConsumerState<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState
    extends ConsumerState<AddEditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _tagInputController = TextEditingController();

  int? _selectedBusinessId;
  TransactionType? _selectedType;
  DateTime _selectedDate = DateTime.now();
  List<String> _tags = [];
  String? _attachmentPath;

  bool _isLoading = false;
  bool _isEditMode = false;
  bool _transactionNotFound = false;
  Transaction? _existingTransaction;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.transactionId != null;
    _selectedBusinessId = widget.businessId;

    if (_isEditMode) {
      _loadExistingTransactionData();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _tagInputController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingTransactionData() async {
    setState(() => _isLoading = true);

    try {
      final repo = ref.read(transactionRepositoryProvider);
      final transaction = await repo.getTransactionById(widget.transactionId!);

      // Guard: widget may have been disposed while the DB call was in flight.
      if (!mounted) return;

      if (transaction == null) {
        // The transaction ID does not exist in the database (e.g. invalid deep link).
        setState(() {
          _transactionNotFound = true;
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _existingTransaction = transaction;
        _selectedBusinessId = transaction.businessId;
        _selectedType = transaction.type;
        _amountController.text = transaction.amount.toString();
        _selectedDate = transaction.date;
        _descriptionController.text = transaction.description ?? '';
        _categoryController.text = transaction.category ?? '';
        _attachmentPath = transaction.attachmentPath;
        _tags = List.from(transaction.tags);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load transaction: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addTag() {
    final text = _tagInputController.text.trim();
    if (text.isNotEmpty) {
      if (!_tags.contains(text)) {
        setState(() {
          _tags.add(text);
          _tagInputController.clear();
        });
      }
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBusinessId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a business')),
      );
      return;
    }
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a transaction type')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(transactionRepositoryProvider);

      final transaction = _existingTransaction ?? Transaction();
      transaction.businessId = _selectedBusinessId!;
      transaction.type = _selectedType!;
      transaction.amount = double.parse(_amountController.text);
      transaction.date = _selectedDate;
      transaction.description = _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim();
      transaction.category = _categoryController.text.trim().isEmpty
          ? null
          : _categoryController.text.trim();
      transaction.attachmentPath = _attachmentPath;
      transaction.tags = _tags;

      await repo.saveTransaction(transaction);

      final eventEngine = ref.read(notificationEventEngineProvider);
      await eventEngine.emitTransactionEvent(transaction: transaction);
      if (transaction.type == TransactionType.investment ||
          transaction.type == TransactionType.additionalInvestment) {
        await eventEngine.suggestRoiReview(businessId: transaction.businessId);
      }

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save transaction: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteTransaction() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text(
            'Are you sure you want to permanently delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        final repo = ref.read(transactionRepositoryProvider);
        await repo.deleteTransaction(widget.transactionId!);

        if (mounted) {
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete transaction: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Watch business list for dropdown
    final asyncBusinesses = ref.watch(watchBusinessesProvider);

    // Show full-screen loader while fetching existing transaction data.
    if (_isLoading && _isEditMode) {
      return const Scaffold(
        body: AppLoader(message: 'Loading transaction details...'),
      );
    }

    // Show a graceful error if the transaction ID was not found in the DB.
    if (_transactionNotFound) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Transaction')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.p32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                AppSizes.gapH16,
                Text(
                  'Transaction Not Found',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                AppSizes.gapH8,
                Text(
                  'This transaction may have been deleted.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                AppSizes.gapH24,
                AppButton.outlined(
                  onPressed: () => context.pop(),
                  text: 'Go Back',
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Transaction' : 'Add Transaction'),
        actions: [
          if (_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteTransaction,
              tooltip: 'Delete Transaction',
            ),
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.p16),
              children: [
                // 1. Select Business Dropdown
                Text(
                  'Related Business *',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSizes.gapH8,
                asyncBusinesses.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (err, stack) =>
                      Text('Error loading businesses: $err'),
                  data: (businesses) {
                    // In CREATE mode: only show Active businesses.
                    // In EDIT mode: show ALL businesses (including Archived) so
                    // that the existing transaction's business is always present
                    // in the list — preventing a DropdownButtonFormField
                    // assertion error when the business has been archived.
                    final dropdownBusinesses = _isEditMode
                        ? businesses
                        : businesses
                            .where((b) => b.status == 'Active')
                            .toList();

                    return DropdownButtonFormField<int>(
                      initialValue: _selectedBusinessId,
                      isExpanded: true,
                      menuMaxHeight: 360,
                      decoration: const InputDecoration(
                        hintText: 'Choose business profile',
                      ),
                      items: dropdownBusinesses.map((b) {
                        // Visually distinguish archived businesses.
                        final label = b.status == 'Active'
                            ? b.name
                            : '${b.name} (Archived)';
                        return DropdownMenuItem(
                          value: b.id,
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => _selectedBusinessId = val);
                      },
                      validator: (value) {
                        if (value == null) return 'Please select a business';
                        return null;
                      },
                    );
                  },
                ),
                AppSizes.gapH16,

                // 2. Select Type & Category side by side
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 620;

                    final typeField = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Type *',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AppSizes.gapH8,
                        DropdownButtonFormField<TransactionType>(
                          initialValue: _selectedType,
                          isExpanded: true,
                          menuMaxHeight: 360,
                          decoration: const InputDecoration(
                            hintText: 'Select',
                          ),
                          items: TransactionType.values.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(
                                _capitalize(type.name),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() => _selectedType = val);
                          },
                          validator: (value) {
                            if (value == null) return 'Required';
                            return null;
                          },
                        ),
                      ],
                    );

                    final categoryField = AppTextField(
                      controller: _categoryController,
                      labelText: 'Category',
                      hintText: 'e.g. Operating, Tax',
                    );

                    if (compact) {
                      return Column(
                        children: [
                          typeField,
                          AppSizes.gapH16,
                          categoryField,
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: typeField),
                        AppSizes.gapW16,
                        Expanded(child: categoryField),
                      ],
                    );
                  },
                ),
                AppSizes.gapH16,

                // 3. Amount & Date Picker
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 620;

                    final amountField = AppTextField(
                      controller: _amountController,
                      labelText:
                          'Amount (${CurrencyConfig.defaultConfig.symbol.trim()}) *',
                      hintText: 'e.g. 1500.00',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Amount is required';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount <= 0) {
                          return 'Must be positive';
                        }
                        return null;
                      },
                    );

                    final dateField = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date *',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AppSizes.gapH8,
                        InkWell(
                          onTap: () => _selectDate(context),
                          borderRadius: BorderRadius.circular(AppSizes.r12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.p16,
                              vertical: AppSizes.p16,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurfaceCard
                                  : AppColors.lightSurfaceCard,
                              borderRadius: BorderRadius.circular(AppSizes.r12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('MMM d, y').format(_selectedDate),
                                  style: theme.textTheme.bodyMedium,
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  size: 18,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );

                    if (compact) {
                      return Column(
                        children: [
                          amountField,
                          AppSizes.gapH16,
                          dateField,
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: amountField),
                        AppSizes.gapW16,
                        Expanded(child: dateField),
                      ],
                    );
                  },
                ),
                AppSizes.gapH16,

                // 4. Description
                AppTextField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  hintText: 'Enter notes or transaction details',
                  maxLines: 2,
                ),
                AppSizes.gapH16,

                // 5. Attachment stub
                Text(
                  'Receipt Attachment',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSizes.gapH8,
                InkWell(
                  onTap: () {
                    setState(() {
                      _attachmentPath = _attachmentPath == null
                          ? '/mock/storage/receipt_${DateTime.now().millisecondsSinceEpoch}.jpg'
                          : null;
                    });
                  },
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p16,
                      vertical: AppSizes.p16,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(AppSizes.r12),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _attachmentPath == null
                              ? Icons.add_a_photo_outlined
                              : Icons.check_circle_outline,
                          color: _attachmentPath == null
                              ? theme.colorScheme.primary
                              : AppColors.success,
                          size: 20,
                        ),
                        AppSizes.gapW8,
                        Text(
                          _attachmentPath == null
                              ? 'Tap to mock attach receipt photo'
                              : 'Receipt Attached successfully',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: _attachmentPath == null
                                ? theme.colorScheme.primary
                                : AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AppSizes.gapH16,

                // 6. Tags Entry
                Text(
                  'Tags',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSizes.gapH8,
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _tagInputController,
                        hintText: 'Add a tag (e.g. Dividend)',
                        onFieldSubmitted: (_) => _addTag(),
                      ),
                    ),
                    AppSizes.gapW8,
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.r12),
                        ),
                      ),
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: _addTag,
                    ),
                  ],
                ),
                if (_tags.isNotEmpty) ...[
                  AppSizes.gapH12,
                  Wrap(
                    spacing: AppSizes.p8,
                    runSpacing: AppSizes.p8,
                    children: _tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => _removeTag(tag),
                      );
                    }).toList(),
                  ),
                ],
                AppSizes.gapH32,

                // Save and Cancel buttons
                Row(
                  children: [
                    Expanded(
                      child: AppButton.outlined(
                        onPressed: () => context.pop(),
                        text: 'Cancel',
                      ),
                    ),
                    AppSizes.gapW16,
                    Expanded(
                      child: AppButton(
                        onPressed: _saveForm,
                        text: 'Save',
                      ),
                    ),
                  ],
                ),
                AppSizes.gapH48,
              ],
            ),
          ),
          if (_isLoading) const AppLoader(isFullscreen: true),
        ],
      ),
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    final regex = RegExp(r'(?<=[a-z])(?=[A-Z])');
    final words = value.split(regex);
    return words
        .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }
}
