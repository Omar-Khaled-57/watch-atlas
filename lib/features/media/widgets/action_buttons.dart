import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/models/media_enums.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/shared/app_modal.dart';
import '../../../l10n/l10n.dart';
import '../../../models/media_model.dart';
import '../../lists/providers/lists_providers.dart';
import '../../lists/widgets/create_list_dialog.dart';
import '../../tracking/providers/tracking_providers.dart';
import 'status_dropdown.dart';

/// Status dropdown + add-to-list action buttons.
class ActionButtons extends ConsumerWidget {
  final MediaModel media;

  const ActionButtons({super.key, required this.media});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMediaList = ref.watch(userMediaProvider).value ?? [];
    final currentUserMedia = userMediaList
        .where((m) => m.mediaId == media.id)
        .firstOrNull;
    final currentStatus = currentUserMedia?.status ?? WatchStatus.planToWatch;

    return Row(
      children: [
        Expanded(
          child: StatusDropdown(
            currentStatus: currentStatus,
            onChanged: (status) {
              final notifier = ref.read(userMediaProvider.notifier);
              if (currentUserMedia != null) {
                notifier.updateStatus(currentUserMedia, status);
              } else {
                notifier.addMedia(
                  mediaId: media.id,
                  mediaType: media.mediaType,
                  status: status,
                );
                ref.read(behaviorServiceProvider).trackMediaSave(media.id);
              }
              if (status == WatchStatus.completed) {
                ref.read(behaviorServiceProvider).trackMediaComplete(media.id);
              }
            },
          ),
        ),
        SizedBox(width: Spacing.md),
        Semantics(
          button: true,
          label: context.l10n.addToList,
          child: OutlinedButton.icon(
            onPressed: () => _showAddToListSheet(context, ref, media),
            icon: const Icon(Icons.playlist_add_rounded, size: 20),
            label: Text(context.l10n.navLists),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: Spacing.lg,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.all(
                  Radius.circular(Spacing.cardRadiusMd),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddToListSheet(
    BuildContext context,
    WidgetRef ref,
    MediaModel media,
  ) {
    final l10n = context.l10n;
    final content = Consumer(
      builder: (context, ref, _) {
        final listsAsync = ref.watch(userListsProvider);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            listsAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(Spacing.xl),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (_, _) => Center(
                child: Padding(
                  padding: EdgeInsets.all(Spacing.xl),
                  child: Text(l10n.failedToLoadList),
                ),
              ),
              data: (lists) {
                if (lists.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.all(Spacing.xl),
                    child: Center(child: Text(l10n.noListsYet)),
                  );
                }
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: [
                      ...lists.map(
                        (list) => ListTile(
                          leading: Icon(
                            list.isPinned
                                ? Icons.push_pin_rounded
                                : Icons.folder_rounded,
                          ),
                          title: Text(
                            list.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(l10n.itemCount(list.itemCount)),
                          onTap: () {
                            ref
                                .read(userListsProvider.notifier)
                                .addItemToList(list.id, media);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.addedToTitle(list.title)),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.add_rounded),
              title: Text(l10n.createNewList),
              onTap: () async {
                final created = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => const CreateListDialog(),
                );
                if (created == true && context.mounted) {
                  final updatedLists = ref.read(userListsProvider).value ?? [];
                  final newList = updatedLists.isNotEmpty
                      ? updatedLists.first
                      : null;
                  if (newList != null) {
                    ref
                        .read(userListsProvider.notifier)
                        .addItemToList(newList.id, media);
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        newList != null
                            ? l10n.addedToTitle(newList.title)
                            : l10n.listCreated,
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );

    AppDialog.show(context: context, title: l10n.addToList, content: content);
  }
}
