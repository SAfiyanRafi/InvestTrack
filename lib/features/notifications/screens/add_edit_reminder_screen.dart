import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_sizes.dart';
import '../../businesses/providers/business_provider.dart';
import '../../transactions/models/transaction.dart';
import '../../transactions/providers/transaction_provider.dart';
import '../models/reminder.dart';
import '../providers/reminder_provider.dart';

class AddEditReminderScreen extends ConsumerStatefulWidget {
  const AddEditReminderScreen({
    this.reminderId,
    this.prefillBusinessId,
    this.prefillTransactionId,
    this.prefillCategory,
    super.key,
  });

  final int? reminderId;
  final int? prefillBusinessId;
  final int? prefillTransactionId;
  final ReminderCategory? prefillCategory;

  @override
  ConsumerState<AddEditReminderScreen> createState() =>
      _AddEditReminderScreenState();
}

class _AddEditReminderScreenState extends ConsumerState<AddEditReminderScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _customIntervalController =
      TextEditingController();

  DateTime _dueDate = DateTime.now().add(const Duration(hours: 1));
  ReminderRepeat _repeat = ReminderRepeat.none;
  ReminderPriority _priority = ReminderPriority.medium;
  ReminderCategory _category = ReminderCategory.custom;
  int? _businessId;
  int? _transactionId;

  bool _isLoading = false;
  Reminder? _existingReminder;

  bool get _isEditMode => widget.reminderId != null;

  @override
  void initState() {
    super.initState();
    _businessId = widget.prefillBusinessId;
    _transactionId = widget.prefillTransactionId;
    _category = widget.prefillCategory ?? ReminderCategory.custom;

    if (_isEditMode) {
      _loadExistingReminder();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _customIntervalController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingReminder() async {
    setState(() => _isLoading = true);

    final repo = ref.read(reminderRepositoryProvider);
    final reminder = await repo.getReminderById(widget.reminderId!);

    if (!mounted) {
      return;
    }

    if (reminder == null) {
      setState(() => _isLoading = false);
      return;
    }

    _existingReminder = reminder;
    _titleController.text = reminder.title;
    _descriptionController.text = reminder.description ?? '';
    _notesController.text = reminder.notes ?? '';
    _dueDate = reminder.dueDate;
    _repeat = reminder.repeat;
    _priority = reminder.priority;
    _category = reminder.category;
    _businessId = reminder.businessId;
    _transactionId = reminder.transactionId;
    if (reminder.customIntervalDays != null) {
      _customIntervalController.text = '${reminder.customIntervalDays}';
    }

    setState(() => _isLoading = false);
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueDate),
    );

    if (pickedTime == null || !mounted) {
      return;
    }

    setState(() {
      _dueDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _saveReminder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_dueDate.isBefore(DateTime.now()) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a future date and time.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final reminder = _existingReminder ?? Reminder();
      reminder.title = _titleController.text.trim();
      reminder.description = _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim();
      reminder.notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim();
      reminder.dueDate = _dueDate;
      reminder.repeat = _repeat;
      reminder.priority = _priority;
      reminder.category = _category;
      reminder.businessId = _businessId;
      reminder.transactionId = _transactionId;
      reminder.customIntervalDays = _repeat == ReminderRepeat.custom
          ? int.tryParse(_customIntervalController.text.trim())
          : null;

      await ref.read(reminderManagerProvider).saveReminder(reminder);

      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        context.pop();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode
                  ? 'Reminder updated successfully.'
                  : 'Reminder created successfully.',
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save reminder: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final businesses =
        ref.watch(watchBusinessesProvider).valueOrNull ?? const [];
    final transactions =
        ref.watch(watchTransactionsProvider).valueOrNull ??
        const <Transaction>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Reminder' : 'New Reminder'),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.p16),
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title *'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),
                AppSizes.gapH16,
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 2,
                ),
                AppSizes.gapH16,
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Due Date & Time'),
                  subtitle: Text(
                    DateFormat('d MMM y, h:mm a').format(_dueDate),
                  ),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: _pickDateTime,
                ),
                AppSizes.gapH16,
                DropdownButtonFormField<ReminderRepeat>(
                  initialValue: _repeat,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Repeat'),
                  items: ReminderRepeat.values
                      .map(
                        (repeat) => DropdownMenuItem(
                          value: repeat,
                          child: Text(_labelFromEnum(repeat.name)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _repeat = value;
                    });
                  },
                ),
                if (_repeat == ReminderRepeat.custom) ...[
                  AppSizes.gapH16,
                  TextFormField(
                    controller: _customIntervalController,
                    decoration: const InputDecoration(
                      labelText: 'Custom Repeat Interval (days)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (_repeat != ReminderRepeat.custom) return null;
                      final parsed = int.tryParse(value ?? '');
                      if (parsed == null || parsed <= 0) {
                        return 'Enter a positive number';
                      }
                      return null;
                    },
                  ),
                ],
                AppSizes.gapH16,
                DropdownButtonFormField<ReminderPriority>(
                  initialValue: _priority,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: ReminderPriority.values
                      .map(
                        (priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(_labelFromEnum(priority.name)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _priority = value;
                    });
                  },
                ),
                AppSizes.gapH16,
                DropdownButtonFormField<ReminderCategory>(
                  initialValue: _category,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: ReminderCategory.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(_labelFromEnum(category.name)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _category = value;
                    });
                  },
                ),
                AppSizes.gapH16,
                DropdownButtonFormField<int?>(
                  initialValue: _businessId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Business (Optional)',
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('None'),
                    ),
                    ...businesses.map(
                      (business) => DropdownMenuItem<int?>(
                        value: business.id,
                        child: Text(
                          business.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _businessId = value;
                    });
                  },
                ),
                AppSizes.gapH16,
                DropdownButtonFormField<int?>(
                  initialValue: _transactionId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Transaction (Optional)',
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('None'),
                    ),
                    ...transactions.map(
                      (tx) => DropdownMenuItem<int?>(
                        value: tx.id,
                        child: Text(
                          '${_labelFromEnum(tx.type.name)} - ${DateFormat('d MMM y').format(tx.date)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _transactionId = value;
                    });
                  },
                ),
                AppSizes.gapH16,
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 3,
                ),
                AppSizes.gapH24,
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : () => context.pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    AppSizes.gapW12,
                    Expanded(
                      child: FilledButton(
                        onPressed: _isLoading ? null : _saveReminder,
                        child: const Text('Save Reminder'),
                      ),
                    ),
                  ],
                ),
                AppSizes.gapH24,
              ],
            ),
          ),
          if (_isLoading)
            const ColoredBox(
              color: Color(0x55000000),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  String _labelFromEnum(String value) {
    final regex = RegExp(r'(?<=[a-z])(?=[A-Z])');
    final parts = value.split(regex);
    return parts
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}
