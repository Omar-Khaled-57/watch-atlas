import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/models/media_enums.dart';
import '../providers/lists_providers.dart';

class CreateListDialog extends ConsumerStatefulWidget {
  final String? initialTitle;
  final String? initialDescription;
  final MediaListType? initialType;
  final String? editId;

  const CreateListDialog({
    super.key,
    this.initialTitle,
    this.initialDescription,
    this.initialType,
    this.editId,
  });

  @override
  ConsumerState<CreateListDialog> createState() => _CreateListDialogState();
}

class _CreateListDialogState extends ConsumerState<CreateListDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late MediaListType _selectedType;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _descriptionController = TextEditingController(text: widget.initialDescription ?? '');
    _selectedType = widget.initialType ?? MediaListType.public;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isWide = MediaQuery.of(context).size.width > 600;

    return Dialog(
      constraints: BoxConstraints(
        maxWidth: isWide ? 480 : double.infinity,
        minWidth: isWide ? 0 : double.infinity,
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(Spacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.editId != null ? 'Edit List' : 'Create List',
                style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
              ),
              const SizedBox(height: Spacing.xl),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter list name',
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
              ),
              const SizedBox(height: Spacing.lg),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'Describe this list',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Text(
                'Visibility',
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: Spacing.sm),
              ...MediaListType.values.map((type) {
                final isSelected = _selectedType == type;
                return Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 8),
                  child: InkWell(
                    onTap: () => setState(() => _selectedType = type),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      padding: const EdgeInsetsDirectional.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? colorScheme.primary.withValues(alpha: 0.1) : null,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: isSelected ? colorScheme.primary : colorScheme.outline,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            type == MediaListType.public
                                ? Icons.public_rounded
                                : type == MediaListType.private
                                    ? Icons.lock_rounded
                                    : Icons.group_rounded,
                            size: 20,
                            color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  type.name[0].toUpperCase() + type.name.substring(1),
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  _typeDescription(type),
                                  style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_circle_rounded, size: 20, color: colorScheme.primary),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: FilledButton(
                      onPressed: _submit,
                      child: Text(widget.editId != null ? 'Save' : 'Create'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(userListsProvider.notifier);
    if (widget.editId != null) {
      final current = ref.read(userListsProvider).valueOrNull ?? [];
      final existing = current.where((l) => l.id == widget.editId).firstOrNull;
      if (existing != null) {
        notifier.updateList(existing.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          listType: _selectedType,
          updatedAt: DateTime.now(),
        ));
      }
    } else {
      notifier.createList(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        listType: _selectedType,
      );
    }
    Navigator.of(context).pop(true);
  }

  String _typeDescription(MediaListType type) {
    switch (type) {
      case MediaListType.public:
        return 'Anyone can see this list';
      case MediaListType.private:
        return 'Only you can see this list';
      case MediaListType.collaborative:
        return 'Others can add and remove items';
    }
  }
}
