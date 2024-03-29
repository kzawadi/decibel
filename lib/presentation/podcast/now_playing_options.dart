// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/bloc/queue_event_state.dart';
import 'package:decibel/domain/podcast/queue_bloc.dart';
import 'package:decibel/presentation/core/action_text.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/core/draggable_episode_tile.dart';
import 'package:decibel/presentation/core/slider_handle.dart';
import 'package:decibel/presentation/podcast/up_next_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:provider/provider.dart';

/// This class gives us options that can be dragged up from the bottom of the main player
/// window. Currently the option is Up Next. This class is an initial version
/// and should by much simpler than it is; however, a [NestedScrollView] is the widget we
/// need to implement this UI, there is a current issue whereby the scroll view and
/// [DraggableScrollableSheet] clash and therefore cannot be used together.
///
/// See issues (64157)[https://github.com/flutter/flutter/issues/64157]
///            (67219)[https://github.com/flutter/flutter/issues/67219]
///
/// If anyone can come up with a more elegant solution (and one that does not throw
/// an overflow error in debug) please raise and issue/submit a PR.
///
/// TODO(kzawadi): Extract contents of Up Next UI into separate widgets.

class NowPlayingOptionsSelector extends StatefulWidget {
  final double? scrollPos;
  static const baseSize = 68.0;

  const NowPlayingOptionsSelector({super.key, this.scrollPos});

  @override
  State<NowPlayingOptionsSelector> createState() =>
      _NowPlayingOptionsSelectorState();
}

class _NowPlayingOptionsSelectorState extends State<NowPlayingOptionsSelector> {
  DraggableScrollableController? draggableController;

  @override
  Widget build(BuildContext context) {
    final queueBloc = Provider.of<QueueBloc>(context, listen: false);
    final theme = Theme.of(context);
    final windowHeight = MediaQuery.of(context).size.height;
    final minSize = NowPlayingOptionsSelector.baseSize /
        (windowHeight - NowPlayingOptionsSelector.baseSize);
    final mediaQueryData = MediaQuery.of(context);

    return DraggableScrollableSheet(
      initialChildSize: minSize,
      minChildSize: minSize,
      maxChildSize: 1,
      controller: draggableController,
      // Snap doesn't work as the sheet and scroll controller just don't get along
      // snap: true,
      // snapSizes: [minSize, maxSize],
      builder: (BuildContext context, ScrollController scrollController) {
        return DefaultTabController(
          animationDuration: !draggableController!.isAttached ||
                  draggableController!.size <= minSize
              ? const Duration()
              : kTabScrollDuration,
          length: 2,
          child: LayoutBuilder(
            builder: (BuildContext ctx, BoxConstraints constraints) {
              return SingleChildScrollView(
                controller: scrollController,
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(
                    height: constraints.maxHeight,
                  ),
                  child: Material(
                    color: theme.secondaryHeaderColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).highlightColor,
                        width: 0,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (mediaQueryData.accessibleNavigation)
                          Semantics(
                            liveRegion: true,
                            label: optionsSliderOpen()
                                ? 'L.of(context)!.semantic_playing_options_collapse_label'
                                : 'L.of(context)!.semantic_playing_options_expand_label',
                            child: GestureDetector(
                              onTap: () {
                                if (draggableController != null) {
                                  if (draggableController!.size < 1.0) {
                                    draggableController!.animateTo(
                                      1,
                                      duration:
                                          const Duration(milliseconds: 150),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    draggableController!.animateTo(
                                      0,
                                      duration:
                                          const Duration(milliseconds: 150),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                }
                              },
                              child: const SliderHandle(),
                            ),
                          ),
                        if (!mediaQueryData.accessibleNavigation)
                          const SliderHandle(),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0),
                            border: Border(
                              bottom: draggableController != null &&
                                      (!draggableController!.isAttached ||
                                          draggableController!.size <= minSize)
                                  ? BorderSide.none
                                  : BorderSide(color: Colors.grey[800]!),
                            ),
                          ),
                          child: StreamBuilder<QueueState>(
                            initialData: QueueEmptyState(),
                            stream: queueBloc.queue,
                            builder: (context, snapshot) {
                              return TabBar(
                                onTap: (index) {
                                  DefaultTabController.of(ctx).animateTo(index);

                                  if (draggableController != null &&
                                      draggableController!.size < 1.0) {
                                    draggableController!.animateTo(
                                      1,
                                      duration:
                                          const Duration(milliseconds: 150),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                automaticIndicatorColorAdjustment: false,

                                /// Little hack to hide the indicator when closed
                                indicatorColor: draggableController != null &&
                                        (!draggableController!.isAttached ||
                                            draggableController!.size <=
                                                minSize)
                                    ? Theme.of(context).secondaryHeaderColor
                                    : null,
                                tabs: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    child: Text(
                                      'UP Next'.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                  //   // If the episode does not support transcripts, grey out
                                  //   // the option.
                                  //   child: snapshot.hasData &&
                                  //           snapshot.data?.playing != null &&
                                  //           snapshot.data!.playing!.hasTranscripts
                                  //       ? Text(
                                  //           L.of(context)!.transcript_label.toUpperCase(),
                                  //           style: Theme.of(context).textTheme.labelLarge,
                                  //         )
                                  //       : Text(
                                  //           L.of(context)!.transcript_label.toUpperCase(),
                                  //           style: Theme.of(context)
                                  //               .textTheme
                                  //               .labelLarge!
                                  //               .copyWith(color: theme.disabledColor),
                                  //         ),
                                  // ),
                                ],
                              );
                            },
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 12)),
                        const Expanded(
                          child: TabBarView(
                            children: [
                              UpNextView(),
                              // TranscriptView(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  bool optionsSliderOpen() {
    return draggableController != null &&
        draggableController!.isAttached &&
        draggableController!.size == 1.0;
  }

  @override
  void initState() {
    draggableController = DraggableScrollableController();
    super.initState();
  }
}

class NowPlayingOptionsScaffold extends StatelessWidget {
  const NowPlayingOptionsScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: NowPlayingOptionsSelector.baseSize - 8.0,
    );
  }
}

/// This implementation displays the additional options in a tab set outside of a
/// draggable sheet.
///
/// Currently these options are Up Next & Transcript.
class NowPlayingOptionsSelectorWide extends StatefulWidget {
  final double? scrollPos;
  static const baseSize = 68.0;

  const NowPlayingOptionsSelectorWide({super.key, this.scrollPos});

  @override
  State<NowPlayingOptionsSelectorWide> createState() =>
      _NowPlayingOptionsSelectorWideState();
}

class _NowPlayingOptionsSelectorWideState
    extends State<NowPlayingOptionsSelectorWide> {
  DraggableScrollableController? draggableController;

  @override
  Widget build(BuildContext context) {
    final queueBloc = Provider.of<QueueBloc>(context, listen: false);
    final theme = Theme.of(context);
    final scrollController = ScrollController();

    return DefaultTabController(
      length: 2,
      child: LayoutBuilder(
        builder: (BuildContext ctx, BoxConstraints constraints) {
          return SingleChildScrollView(
            controller: scrollController,
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(
                height: constraints.maxHeight,
              ),
              child: Material(
                color: theme.secondaryHeaderColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0),
                        border: Border(
                          bottom:
                              BorderSide(color: Colors.grey[800]!, width: 1),
                        ),
                      ),
                      child: StreamBuilder<QueueState>(
                        initialData: QueueEmptyState(),
                        stream: queueBloc.queue,
                        builder: (context, snapshot) {
                          return TabBar(
                            automaticIndicatorColorAdjustment: false,
                            tabs: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 16, bottom: 16),
                                child: Text(
                                  'Up Next'.toUpperCase(),
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                              //   child: snapshot.hasData &&
                              //           snapshot.data?.playing != null &&
                              //           snapshot.data!.playing!.hasTranscripts
                              //       ? Text(
                              //           L.of(context)!.transcript_label.toUpperCase(),
                              //           style: Theme.of(context).textTheme.labelLarge,
                              //         )
                              //       : Text(
                              //           L.of(context)!.transcript_label.toUpperCase(),
                              //           style: Theme.of(context)
                              //               .textTheme
                              //               .labelLarge!
                              //               .copyWith(color: theme.disabledColor),
                              //         ),
                              // ),
                            ],
                          );
                        },
                      ),
                    ),
                    const Expanded(
                      child: TabBarView(
                        children: [
                          UpNextView(),
                          // TranscriptView(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}




// class NowPlayingOptionsSelector extends StatefulWidget {
//   const NowPlayingOptionsSelector({super.key, this.scrollPos});
//   final double? scrollPos;
//   static const baseSize = 68.0;

//   @override
//   State<NowPlayingOptionsSelector> createState() =>
//       _NowPlayingOptionsSelectorState();
// }

// class _NowPlayingOptionsSelectorState extends State<NowPlayingOptionsSelector> {
//   DraggableScrollableController? draggableController;

//   @override
//   Widget build(BuildContext context) {
//     final queueBloc = Provider.of<QueueBloc>(context, listen: false);
//     final theme = Theme.of(context);
//     final windowHeight = MediaQuery.of(context).size.height;
//     final minSize = NowPlayingOptionsSelector.baseSize /
//         (windowHeight - NowPlayingOptionsSelector.baseSize);
//     final orientation = MediaQuery.of(context).orientation;

//     return orientation == Orientation.portrait
//         ? DraggableScrollableSheet(
//             initialChildSize: minSize,
//             minChildSize: minSize,
//             controller: draggableController,
//             // Snap doesn't work as the sheet and scroll controller just don't get along
//             // snap: true,
//             // snapSizes: [minSize, maxSize],
//             builder: (BuildContext context, ScrollController scrollController) {
//               return DefaultTabController(
//                 animationDuration: !draggableController!.isAttached ||
//                         draggableController!.size <= minSize
//                     ?  Duration.zero
//                     : kTabScrollDuration,
//                 length: 2,
//                 child: LayoutBuilder(
//                   builder: (BuildContext ctx, BoxConstraints constraints) {
//                     return SingleChildScrollView(
//                       controller: scrollController,
//                       child: ConstrainedBox(
//                         constraints: BoxConstraints.expand(
//                           height: constraints.maxHeight,
//                         ),
//                         child: Material(
//                           color: theme.secondaryHeaderColor,
//                           shape: RoundedRectangleBorder(
//                             side: BorderSide(
//                               color: Theme.of(context).highlightColor,
//                               width: 0,
//                             ),
//                             borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(18),
//                               topRight: Radius.circular(18),
//                             ),
//                           ),
//                           child: StreamBuilder<QueueState>(
//                             initialData: QueueEmptyState(),
//                             stream: queueBloc.queue,
//                             builder: (context, snapshot) {
//                               return Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: <Widget>[
//                                   const SliderHandle(),
//                                   const Padding(
//                                     padding: EdgeInsets.only(bottom: 12),
//                                   ),
//                                   Expanded(
//                                     child: TabBarView(
//                                       children: [
//                                         Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.fromLTRB(
//                                                     16,
//                                                     8,
//                                                     24,
//                                                     8,
//                                                   ),
//                                                   child: Text(
//                                                     AppStrings
//                                                         .nowPlayingQueueLabel,
//                                                     style: Theme.of(context)
//                                                         .textTheme
//                                                         .titleLarge,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.fromLTRB(
//                                                 8,
//                                                 8,
//                                                 8,
//                                                 0,
//                                               ),
//                                               child: DraggableEpisodeTile(
//                                                 key: const Key('detileplaying'),
//                                                 episode: snapshot.data!.playing,
//                                                 draggable: false,
//                                               ),
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.fromLTRB(
//                                                     16,
//                                                     0,
//                                                     24,
//                                                     8,
//                                                   ),
//                                                   child: Text(
//                                                     AppStrings.upNextQueueLabel,
//                                                     style: Theme.of(context)
//                                                         .textTheme
//                                                         .titleLarge,
//                                                   ),
//                                                 ),
//                                                 const Spacer(),
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.fromLTRB(
//                                                     16,
//                                                     0,
//                                                     24,
//                                                     8,
//                                                   ),
//                                                   child: TextButton(
//                                                     onPressed: () {
//                                                       showPlatformDialog<void>(
//                                                         context: context,
//                                                         useRootNavigator: false,
//                                                         builder: (_) =>
//                                                             BasicDialogAlert(
//                                                           title: const Text(
//                                                             AppStrings
//                                                                 .queueClearLabelTitle,
//                                                           ),
//                                                           content: const Text(
//                                                             AppStrings
//                                                                 .queueClearLabel,
//                                                           ),
//                                                           actions: <Widget>[
//                                                             BasicDialogAction(
//                                                               title:
//                                                                   const ActionText(
//                                                                 AppStrings
//                                                                     .cancelButtonLabel,
//                                                               ),
//                                                               onPressed: () {
//                                                                 Navigator.pop(
//                                                                   context,
//                                                                 );
//                                                               },
//                                                             ),
//                                                             BasicDialogAction(
//                                                               title: ActionText(
//                                                                 Theme.of(context)
//                                                                             .platform ==
//                                                                         TargetPlatform
//                                                                             .iOS
//                                                                     ? AppStrings
//                                                                         .queueClearButtonLabel
//                                                                         .toUpperCase()
//                                                                     : AppStrings
//                                                                         .queueClearButtonLabel,
//                                                               ),
//                                                               iosIsDefaultAction:
//                                                                   true,
//                                                               iosIsDestructiveAction:
//                                                                   true,
//                                                               onPressed: () {
//                                                                 queueBloc
//                                                                     .queueEvent(
//                                                                   QueueClearEvent(),
//                                                                 );
//                                                                 Navigator.pop(
//                                                                   context,
//                                                                 );
//                                                               },
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       );
//                                                     },
//                                                     child: Text(
//                                                       AppStrings
//                                                           .clearQueueButtonLabel,
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .titleSmall!
//                                                           .copyWith(
//                                                             fontSize: 12,
//                                                             color: Theme.of(
//                                                               context,
//                                                             ).primaryColor,
//                                                           ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             if (snapshot.hasData &&
//                                                 snapshot.data!.queue.isEmpty)
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(24),
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     color: Theme.of(context)
//                                                         .dividerColor,
//                                                     border: Border.all(
//                                                       color: Theme.of(context)
//                                                           .dividerColor,
//                                                     ),
//                                                     borderRadius:
//                                                         const BorderRadius.all(
//                                                       Radius.circular(
//                                                         10,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                       24,
//                                                     ),
//                                                     child: Text(
//                                                       AppStrings
//                                                           .emptyQueueMessage,
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .titleMedium,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               )
//                                             else
//                                               Expanded(
//                                                 child:
//                                                     ReorderableListView.builder(
//                                                   buildDefaultDragHandles:
//                                                       false,
//                                                   shrinkWrap: true,
//                                                   padding:
//                                                       const EdgeInsets.all(8),
//                                                   itemCount: snapshot.hasData
//                                                       ? snapshot
//                                                           .data!.queue.length
//                                                       : 0,
//                                                   itemBuilder: (
//                                                     BuildContext context,
//                                                     int index,
//                                                   ) {
//                                                     return Dismissible(
//                                                       key: ValueKey(
//                                                         'disqueue${snapshot.data!.queue[index].guid}',
//                                                       ),
//                                                       direction:
//                                                           DismissDirection
//                                                               .endToStart,
//                                                       onDismissed: (direction) {
//                                                         queueBloc.queueEvent(
//                                                           QueueRemoveEvent(
//                                                             episode: snapshot
//                                                                 .data!
//                                                                 .queue[index],
//                                                           ),
//                                                         );
//                                                       },
//                                                       child:
//                                                           DraggableEpisodeTile(
//                                                         key: ValueKey(
//                                                           'tilequeue${snapshot.data!.queue[index].guid}',
//                                                         ),
//                                                         index: index,
//                                                         episode: snapshot
//                                                             .data!.queue[index],
//                                                         playable: true,
//                                                       ),
//                                                     );
//                                                   },
//                                                   onReorder: (
//                                                     int oldIndex,
//                                                     int newIndex,
//                                                   ) {
//                                                     /// Seems odd to have to do this, but this -1 was taken from
//                                                     /// the Flutter docs.
//                                                     if (oldIndex < newIndex) {
//                                                       newIndex -= 1;
//                                                     }

//                                                     queueBloc.queueEvent(
//                                                       QueueMoveEvent(
//                                                         episode: snapshot.data!
//                                                             .queue[oldIndex],
//                                                         oldIndex: oldIndex,
//                                                         newIndex: newIndex,
//                                                       ),
//                                                     );
//                                                   },
//                                                 ),
//                                               ),
//                                           ],
//                                         ),
//                                         Container(
//                                           child: Text(
//                                             snapshot.data!.playing
//                                                     .description ??
//                                                 'no descriptions',
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           )
//         : const SizedBox(
//             height: 0,
//             width: 0,
//           );
//   }

//   @override
//   void initState() {
//     draggableController = DraggableScrollableController();
//     super.initState();
//   }
// }

// class NowPlayingOptionsScaffold extends StatelessWidget {
//   const NowPlayingOptionsScaffold({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const SizedBox(
//       height: NowPlayingOptionsSelector.baseSize - 8.0,
//     );
//   }
// }
