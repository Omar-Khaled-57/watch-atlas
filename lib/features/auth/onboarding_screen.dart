import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/models/gender.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/supabase_service.dart';
import '../../l10n/l10n.dart';
import 'providers/auth_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _imagePicker = ImagePicker();

  String? _avatarPath;
  String? _selectedDefaultAvatar;
  Gender? _gender;
  DateTime? _dateOfBirth;
  bool _isSaving = false;

  static const _defaultAvatars = [
    'assets/images/pfp/1.jfif',
    'assets/images/pfp/2.jfif',
    'assets/images/pfp/3.jfif',
    'assets/images/pfp/4.jfif',
    'assets/images/pfp/5.jfif',
    'assets/images/pfp/6.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.setUpProfile),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.chooseAvatar,
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: Spacing.md),
            _buildAvatarPicker(colorScheme, textTheme),
            const SizedBox(height: Spacing.xxl),
            _buildDefaultAvatarGrid(colorScheme),
            const SizedBox(height: Spacing.xxl),
            Text(
              context.l10n.gender,
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: Spacing.md),
            DropdownButtonFormField<Gender?>(
              value: _gender,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.wc_rounded),
              ),
              items: [
                DropdownMenuItem(value: null, child: Text(context.l10n.notSpecified, style: textTheme.bodyMedium)),
                DropdownMenuItem(value: Gender.male, child: Text(context.l10n.male)),
                DropdownMenuItem(value: Gender.female, child: Text(context.l10n.female)),
                DropdownMenuItem(value: Gender.ratherNotSay, child: Text(context.l10n.ratherNotSay)),
              ],
              onChanged: (value) => setState(() => _gender = value),
            ),
            const SizedBox(height: Spacing.xxl),
            Text(
              'Date of Birth',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: Spacing.md),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.cake_rounded),
                  suffixIcon: const Icon(Icons.calendar_month_rounded),
                ),
                child: Text(
                  _dateOfBirth != null
                      ? '${_dateOfBirth!.month}/${_dateOfBirth!.day}/${_dateOfBirth!.year}'
                      : context.l10n.selectDateOfBirth,
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
                onPressed: _isSaving ? null : _complete,
                child: _isSaving
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(context.l10n.completeSetup),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPicker(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _pickImage(),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: colorScheme.surfaceContainerHighest,
            child: _avatarPath != null
                ? ClipOval(
                    child: Image.file(
                      File(_avatarPath!),
                      width: 80, height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(Icons.person_rounded, size: 40, color: colorScheme.onSurfaceVariant),
                    ),
                  )
                : Icon(Icons.camera_alt_rounded, size: 28, color: colorScheme.onSurfaceVariant),
          ),
        ),
        const SizedBox(width: Spacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.uploadPhoto, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(height: Spacing.xs),
              Text(context.l10n.orPickDefault, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatarGrid(ColorScheme colorScheme) {
    return Wrap(
      spacing: Spacing.md,
      runSpacing: Spacing.md,
      children: _defaultAvatars.map((path) {
        final isSelected = _selectedDefaultAvatar == path && _avatarPath == null;
        return GestureDetector(
          onTap: () => setState(() {
            _selectedDefaultAvatar = path;
            _avatarPath = null;
          }),
          child: Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: colorScheme.surfaceContainerHighest,
                child: ClipOval(
                  child: Image.asset(
                    path,
                    width: 56, height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(Icons.person_rounded, size: 28),
                  ),
                ),
              ),
              if (isSelected)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colorScheme.primary, width: 3),
                    ),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
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
                title: Text(context.l10n.camera),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: Text(context.l10n.gallery),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
    if (source == null) return;
    final picked = await _imagePicker.pickImage(source: source, maxWidth: 512, maxHeight: 512, imageQuality: 85);
    if (picked != null && mounted) {
      setState(() {
        _avatarPath = picked.path;
        _selectedDefaultAvatar = null;
      });
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 18),
      firstDate: DateTime(now.year - 120),
      lastDate: now,
      helpText: context.l10n.selectDateOfBirth,
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  Future<void> _complete() async {
    if (_isSaving) return;

    final age = _dateOfBirth != null
        ? DateTime.now().year - _dateOfBirth!.year - (DateTime.now().isBefore(DateTime(_dateOfBirth!.year, _dateOfBirth!.month, _dateOfBirth!.day)) ? 1 : 0)
        : 0;
    if (_dateOfBirth != null && age < 13) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.mustBe13)),
        );
      }
      return;
    }

    setState(() => _isSaving = true);

    try {
      final supabase = SupabaseService.instance;
      final userId = AuthService.instance.userId;
      final currentUser = AuthService.instance.currentUser;
      final updates = <String, dynamic>{
        'id': userId,
        'email': currentUser?.email ?? '',
        'username': currentUser?.email?.split('@').first ?? 'user_$userId',
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (_avatarPath != null) {
        updates['avatar_url'] = await supabase.uploadAvatar(userId, _avatarPath!);
        updates['default_avatar'] = null;
      } else if (_selectedDefaultAvatar != null) {
        updates['default_avatar'] = _selectedDefaultAvatar;
      }

      if (_gender != null) {
        updates['gender'] = _gender!.name;
      }
      if (_dateOfBirth != null) {
        updates['dob'] = _dateOfBirth!.toIso8601String().split('T').first;
      }

      await AuthService.instance.updateProfile(updates);
      ref.read(authNotifierProvider.notifier).completeOnboarding();

      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.errorWithDetails('${context.l10n.failedToSaveProfile}: $e')),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
