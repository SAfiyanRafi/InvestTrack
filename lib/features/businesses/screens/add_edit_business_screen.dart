import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../notifications/providers/notification_event_engine.dart';
import '../models/business.dart';
import '../providers/business_provider.dart';

/// Screen for creating or updating a [Business] profile.
class AddEditBusinessScreen extends ConsumerStatefulWidget {
  const AddEditBusinessScreen({
    this.businessId,
    super.key,
  });

  final int? businessId;

  @override
  ConsumerState<AddEditBusinessScreen> createState() => _AddEditBusinessScreenState();
}

class _AddEditBusinessScreenState extends ConsumerState<AddEditBusinessScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _nameController = TextEditingController();
  final _ownerController = TextEditingController();
  final _locationController = TextEditingController();
  final _ownershipController = TextEditingController(text: '100');
  final _descriptionController = TextEditingController();
  final _tagInputController = TextEditingController();

  String? _selectedCategory;
  List<String> _tags = [];
  bool _isLoading = false;
  bool _isEditMode = false;
  Business? _existingBusiness;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.businessId != null;
    if (_isEditMode) {
      _loadExistingBusinessData();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ownerController.dispose();
    _locationController.dispose();
    _ownershipController.dispose();
    _descriptionController.dispose();
    _tagInputController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingBusinessData() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(businessRepositoryProvider);
      final business = await repo.getBusinessById(widget.businessId!);
      if (!mounted) return;

      if (business != null) {
        _existingBusiness = business;
        _nameController.text = business.name;
        _ownerController.text = business.owner ?? '';
        _locationController.text = business.location ?? '';
        _ownershipController.text = business.ownershipPercentage.toInt().toString();
        _descriptionController.text = business.description ?? '';
        _selectedCategory = business.category;
        _tags = List.from(business.tags);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(businessRepositoryProvider);
      
      final business = _existingBusiness ?? Business();
      business.name = _nameController.text.trim();
      business.owner = _ownerController.text.trim().isEmpty ? null : _ownerController.text.trim();
      business.location = _locationController.text.trim().isEmpty ? null : _locationController.text.trim();
      business.description = _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim();
      business.ownershipPercentage = double.tryParse(_ownershipController.text) ?? 100.0;
      business.category = _selectedCategory;
      business.tags = _tags;
      
      if (!_isEditMode) {
        business.createdDate = DateTime.now();
        business.status = 'Active';
      }

      await repo.saveBusiness(business);

      if (!_isEditMode) {
        final eventEngine = ref.read(notificationEventEngineProvider);
        await eventEngine.emitBusinessCreated(
          businessId: business.id,
          businessName: business.name,
        );
        await eventEngine.suggestBusinessReview(
          businessId: business.id,
          businessName: business.name,
        );
      }
      
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save business: $e')),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final categories = ref.read(businessCategoriesProvider);

    if (_isLoading && _isEditMode) {
      return const Scaffold(
        body: AppLoader(message: 'Loading business details...'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Business' : 'Add Business'),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.p16),
              children: [
                // Business Name
                AppTextField(
                  controller: _nameController,
                  labelText: 'Business Name *',
                  hintText: 'Enter business name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Business name is required';
                    }
                    return null;
                  },
                ),
                AppSizes.gapH16,

                // Owner Name
                AppTextField(
                  controller: _ownerController,
                  labelText: 'Owner / Co-owner',
                  hintText: 'Enter owner name',
                ),
                AppSizes.gapH16,

                // Category Selection
                Text(
                  'Category',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSizes.gapH8,
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(
                    hintText: 'Select category',
                  ),
                  items: categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                AppSizes.gapH16,

                // Ownership percentage & Location side by side
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: AppTextField(
                        controller: _ownershipController,
                        labelText: 'Equity Share (%)',
                        hintText: 'e.g. 50',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          final percent = double.tryParse(value);
                          if (percent == null || percent < 0 || percent > 100) {
                            return 'Must be 0-100';
                          }
                          return null;
                        },
                      ),
                    ),
                    AppSizes.gapW16,
                    Expanded(
                      flex: 6,
                      child: AppTextField(
                        controller: _locationController,
                        labelText: 'Location',
                        hintText: 'e.g. London, UK',
                      ),
                    ),
                  ],
                ),
                AppSizes.gapH16,

                // Description
                AppTextField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  hintText: 'Enter description or investment notes',
                  maxLines: 3,
                ),
                AppSizes.gapH16,

                // Tags Entry
                Text(
                  'Tags',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSizes.gapH8,
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _tagInputController,
                        hintText: 'Add a tag (e.g. RealEstate)',
                        onFieldSubmitted: (_) => _addTag(),
                      ),
                    ),
                    AppSizes.gapW8,
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.r12),
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
}
