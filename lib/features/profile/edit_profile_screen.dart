import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/providers/app_providers.dart';
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
  String? _bannerPath;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadProfile());
  }

  Future<void> _loadProfile() async {
    final profile = await ref.read(currentUserProfileProvider.future);
    if (profile != null && mounted) {
      _displayNameController.text = profile.displayName ?? '';
      _bioController.text = profile.bio ?? '';
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage({required bool banner}) async {
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
      maxWidth: banner ? 1920 : 512,
      maxHeight: banner ? 1080 : 512,
      imageQuality: 85,
    );

    if (picked != null && mounted) {
      setState(() {
        if (banner) {
          _bannerPath = picked.path;
        } else {
          _avatarPath = picked.path;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final updates = <String, dynamic>{
        'display_name': _displayNameController.text.trim(),
        'bio': _bioController.text.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await ref.read(updateProfileProvider(updates).future);

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
    final textTheme = context.textTheme;

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
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBannerPicker(colorScheme),
              const SizedBox(height: 16),
              Center(child: _buildAvatarPicker(colorScheme)),
              const SizedBox(height: 24),
              Text(
                'Display Name',
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 24),
              Text(
                'Bio',
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 32),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerPicker(ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () => _pickImage(banner: true),
      child: ClipRRect(
        borderRadius: BorderRadiusDirectional.all(Radius.circular(12)),
        child: SizedBox(
          width: double.infinity,
          height: 180,
          child: _bannerPath != null
              ? Image.file(
                  File(_bannerPath!),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildBannerPlaceholder(colorScheme),
                )
              : Consumer(builder: (context, ref, child) {
                  final profile =
                      ref.watch(currentUserProfileProvider).asData?.value;
                  if (profile?.bannerUrl != null) {
                    return CachedNetworkImage(
                      imageUrl: profile!.bannerUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          _buildBannerPlaceholder(colorScheme),
                      errorWidget: (context, url, error) =>
                          _buildBannerPlaceholder(colorScheme),
                    );
                  }
                  return _buildBannerPlaceholder(colorScheme);
                }),
        ),
      ),
    );
  }

  Widget _buildBannerPlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_photo_alternate_rounded,
              size: 40,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to change banner',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPicker(ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () => _pickImage(banner: false),
      child: Stack(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: colorScheme.surfaceContainerHighest,
            child: _avatarPath != null
                ? ClipOval(
                    child: Image.file(
                      File(_avatarPath!),
                      width: 96,
                      height: 96,
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
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              _buildAvatarPlaceholder(colorScheme),
                          errorWidget: (context, url, error) =>
                              _buildAvatarPlaceholder(colorScheme),
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
