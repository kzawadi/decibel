// Copyright 2023 Kelvin Zawadi.@kzawadi and the project contributors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/bloc/queue_event_state.dart';
import 'package:decibel/domain/podcast/queue_bloc.dart';
import 'package:decibel/presentation/core/action_text.dart';
import 'package:decibel/presentation/core/draggable_episode_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:provider/provider.dart';

/// This class is responsible for rendering the Up Next queue feature.
///
/// The user can see the currently playing item and the current queue. The user can
/// re-arrange items in the queue, remove individual items or completely clear the queue.
class UpNextView extends StatelessWidget {
  const UpNextView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final queueBloc = Provider.of<QueueBloc>(context, listen: false);

    return StreamBuilder<QueueState>(
      initialData: QueueEmptyState(),
      stream: queueBloc.queue,
      builder: (context, snapshot) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 24, 8),
                  child: Text(
                    'Now Playing',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: DraggableEpisodeTile(
                key: const Key('detileplaying'),
                episode: snapshot.data!.playing!,
                draggable: false,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 24, 8),
                  child: Text(
                    'Up Next',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 24, 8),
                  child: TextButton(
                    onPressed: () {
                      showPlatformDialog<void>(
                        context: context,
                        useRootNavigator: false,
                        builder: (_) => BasicDialogAlert(
                          title: const Text(
                            'Clear',
                          ),
                          content: const Text('Clear'),
                          actions: <Widget>[
                            BasicDialogAction(
                              title: const ActionText(
                                'Cancel',
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            BasicDialogAction(
                              title: ActionText(
                                Theme.of(context).platform == TargetPlatform.iOS
                                    ? 'Clear'.toUpperCase()
                                    : 'Clear',
                              ),
                              iosIsDefaultAction: true,
                              iosIsDestructiveAction: true,
                              onPressed: () {
                                queueBloc.queueEvent(QueueClearEvent());
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      'Clear',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            if (snapshot.hasData && snapshot.data!.queue.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'empty',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.hasData ? snapshot.data!.queue.length : 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      key: ValueKey(
                          'disqueue${snapshot.data!.queue[index].guid}'),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        queueBloc.queueEvent(QueueRemoveEvent(
                            episode: snapshot.data!.queue[index]));
                      },
                      child: DraggableEpisodeTile(
                        key: ValueKey(
                            'tilequeue${snapshot.data!.queue[index].guid}'),
                        index: index,
                        episode: snapshot.data!.queue[index],
                        playable: true,
                      ),
                    );
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    /// Seems odd to have to do this, but this -1 was taken from
                    /// the Flutter docs.
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }

                    queueBloc.queueEvent(QueueMoveEvent(
                      episode: snapshot.data!.queue[oldIndex],
                      oldIndex: oldIndex,
                      newIndex: newIndex,
                    ));
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
