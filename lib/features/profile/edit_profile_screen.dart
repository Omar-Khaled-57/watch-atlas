import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/models/gender.dart';
import '../../core/providers/app_providers.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/supabase_service.dart';
import 'providers/profile_providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _imagePicker = ImagePicker();

  String? _avatarPath;
  Gender? _gender;
  DateTime? _dateOfBirth;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadProfile());
  }

  Future<void> _loadProfile() async {
    final profile = await ref.read(currentUserProfileProvider.future);
    if (profile != null && mounted) {
      setState(() {
        _displayNameController.text = profile.displayName ?? '';
        _bioController.text = profile.bio ?? '';
        _gender = profile.gender;
        _dateOfBirth = profile.dateOfBirth;
      });
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    final picked = await _imagePicker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (picked != null && mounted) {
      setState(() => _avatarPath = picked.path);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final supabase = SupabaseService.instance;
      final currentUser = AuthService.instance.currentUser;
      final userId = ref.read(authServiceProvider).userId;

      final updates = <String, dynamic>{
        'email': currentUser?.email ?? '',
        'username': currentUser?.email?.split('@').first ?? 'user_$userId',
        'display_name': _displayNameController.text.trim(),
        'bio': _bioController.text.trim(),
        'gender': _gender?.name,
        'dob': _dateOfBirth?.toIso8601String().split('T').first,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (_avatarPath != null) {
        updates['avatar_url'] = await supabase.uploadAvatar(userId, _avatarPath!);
      }

      await AuthService.instance.updateProfile(updates);
      ref.invalidate(currentUserProfileProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: isLandscape ? 40 : 24,
              vertical: isLandscape ? 24 : 32,
            ),
            child: Form(
              key: _formKey,
              child: isLandscape
                  ? _buildLandscapeForm(colorScheme)
                  : _buildPortraitForm(colorScheme),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitForm(ColorScheme colorScheme) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(bottom: Spacing.xl),
            child: _buildAvatarPicker(colorScheme, radius: 72),
          ),
        ),
        ..._buildFormFields(colorScheme),
      ],
    );
  }

  Widget _buildLandscapeForm(ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(top: Spacing.lg),
          child: _buildAvatarPicker(colorScheme, radius: 56),
        ),
        const SizedBox(width: Spacing.xl * 2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildFormFields(colorScheme),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildFormFields(ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;
    return [
      Text('Display Name', style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
      const SizedBox(height: Spacing.sm),
      TextFormField(
        controller: _displayNameController,
        decoration: const InputDecoration(
          hintText: 'Enter your display name',
          prefixIcon: Icon(Icons.person_rounded),
        ),
        textCapitalization: TextCapitalization.words,
        maxLength: 50,
        validator: (value) {
          if (value != null && value.trim().length > 50) {
            return 'Display name must be 50 characters or less';
          }
          return null;
        },
      ),
      const SizedBox(height: Spacing.xl),
      Text('Bio', style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
      const SizedBox(height: Spacing.sm),
      TextFormField(
        controller: _bioController,
        decoration: const InputDecoration(
          hintText: 'Tell others about yourself',
          alignLabelWithHint: true,
        ),
        maxLines: 5,
        maxLength: 500,
        textCapitalization: TextCapitalization.sentences,
        validator: (value) {
          if (value != null && value.trim().length > 500) {
            return 'Bio must be 500 characters or less';
          }
          return null;
        },
      ),
      const SizedBox(height: Spacing.xl),
      Text('Gender', style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
      const SizedBox(height: Spacing.sm),
      DropdownButtonFormField<Gender?>(
        value: _gender,
        decoration: const InputDecoration(prefixIcon: Icon(Icons.wc_rounded)),
        items: [
          DropdownMenuItem(value: null, child: Text('Not specified', style: textTheme.bodyMedium)),
          DropdownMenuItem(value: Gender.male, child: const Text('Male')),
          DropdownMenuItem(value: Gender.female, child: const Text('Female')),
          DropdownMenuItem(value: Gender.ratherNotSay, child: const Text('Rather not say')),
        ],
        onChanged: (value) => setState(() => _gender = value),
      ),
      const SizedBox(height: Spacing.xl),
      Text('Date of Birth', style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
      const SizedBox(height: Spacing.sm),
      InkWell(
        onTap: () async {
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: _dateOfBirth ?? DateTime(now.year - 18),
            firstDate: DateTime(now.year - 120),
            lastDate: now,
            helpText: 'Select date of birth',
          );
          if (picked != null) setState(() => _dateOfBirth = picked);
        },
        child: InputDecorator(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.cake_rounded),
            suffixIcon: Icon(Icons.calendar_month_rounded),
          ),
          child: Text(
            _dateOfBirth != null
                ? '${_dateOfBirth!.month}/${_dateOfBirth!.day}/${_dateOfBirth!.year}'
                : 'Select your date of birth',
            style: textTheme.bodyLarge?.copyWith(
              color: _dateOfBirth != null ? null : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
      const SizedBox(height: Spacing.xxl),
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Save Changes'),
        ),
      ),
    ];
  }

  Widget _buildAvatarPicker(ColorScheme colorScheme, {double radius = 48}) {
    final diameter = radius * 2;
    return GestureDetector(
      onTap: () => _pickImage(),
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: colorScheme.surfaceContainerHighest,
            child: _avatarPath != null
                ? ClipOval(
                    child: Image.file(
                      File(_avatarPath!),
                      width: diameter,
                      height: diameter,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildAvatarPlaceholder(colorScheme),
                    ),
                  )
                : Consumer(builder: (context, ref, child) {
                    final profile =
                        ref.watch(currentUserProfileProvider).asData?.value;
                    if (profile?.avatarUrl != null) {
                      return ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: profile!.avatarUrl!,
                          width: diameter,
                          height: diameter,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              _buildAvatarPlaceholder(colorScheme),
                          errorWidget: (context, url, error) =>
                              _buildAvatarPlaceholder(colorScheme),
                        ),
                      );
                    }
                    if (profile?.defaultAvatar != null) {
                      return ClipOval(
                        child: Image.asset(
                          profile!.defaultAvatar!,
                          width: diameter,
                          height: diameter,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(colorScheme),
                        ),
                      );
                    }
                    return _buildAvatarPlaceholder(colorScheme);
                  }),
          ),
          PositionedDirectional(
            bottom: 0,
            end: 0,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.surface, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder(ColorScheme colorScheme) {
    return Icon(
      Icons.person_rounded,
      size: 48,
      color: colorScheme.onSurfaceVariant,
    );
  }
}
