// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:decibel/application/bloc/audio_bloc.dart';
import 'package:decibel/domain/podcast/episode.dart';
import 'package:decibel/infrastructure/podcast/services/audio/audio_player_service.dart';
import 'package:decibel/presentation/core/delayed_progress_indicator.dart';
import 'package:decibel/presentation/core/dot_decoration.dart';
import 'package:decibel/presentation/core/person_avatar.dart';
import 'package:decibel/presentation/core/placeholder_builder.dart';
import 'package:decibel/presentation/core/podcast_html.dart';
import 'package:decibel/presentation/core/podcast_image.dart';
import 'package:decibel/presentation/podcast/chapter_selector.dart';
import 'package:decibel/presentation/podcast/now_playing_floating_player.dart';
import 'package:decibel/presentation/podcast/now_playing_options.dart';
import 'package:decibel/presentation/podcast/playback_error_listener.dart';
import 'package:decibel/presentation/podcast/player_position_controls.dart';
import 'package:decibel/presentation/podcast/player_transport_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// This is the full-screen player Widget which is invoked by touching the mini player.
/// This displays the podcast image, episode notes and standard playback controls.
///
/// TODO: The fade in/out transition applied when scrolling the queue is the first implementation.
/// Using [Opacity] is a very inefficient way of achieving this effect, but will do as a place
/// holder until a better animation can be achieved.
///

class NowPlaying extends StatefulWidget {
  const NowPlaying({
    super.key,
  });

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> with WidgetsBindingObserver {
  late StreamSubscription<AudioState> playingStateSubscription;
  AutoSizeGroup textGroup = AutoSizeGroup();
  double scrollPos = 0;
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    var popped = false;

    // If the episode finishes we can close.
    playingStateSubscription = audioBloc.playingState!
        .where((state) => state == AudioState.stopped)
        .listen((playingState) async {
      // Prevent responding to multiple stop events after we've popped and lost context.
      if (!popped) {
        Navigator.pop(context);
        popped = true;
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    playingStateSubscription.cancel();

    super.dispose();
  }

  bool isMobilePortrait(BuildContext context) {
    final query = MediaQuery.of(context);
    return query.orientation == Orientation.portrait ||
        query.size.width <= 1000;
  }

  @override
  Widget build(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    final playerBuilder = PlayerControlsBuilder.of(context);

    return Semantics(
      header: false,
      label: 'player',
      child: StreamBuilder<Episode?>(
        stream: audioBloc.nowPlaying,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final duration = snapshot.data == null ? 0 : snapshot.data!.duration;
          final transportBuilder = playerBuilder?.builder(duration);

          return isMobilePortrait(context)
              ? NotificationListener<DraggableScrollableNotification>(
                  onNotification: (notification) {
                    setState(() {
                      if (notification.extent > (notification.minExtent)) {
                        opacity =
                            1 - (notification.maxExtent - notification.extent);
                        scrollPos = 1.0;
                      } else {
                        opacity = 0.0;
                        scrollPos = 0.0;
                      }
                    });

                    return true;
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // We need to hide the main player when the floating player is visible to prevent
                      // screen readers from reading both parts of the stack.
                      Visibility(
                        visible: opacity < 1,
                        child: NowPlayingTabs(
                          episode: snapshot.data!,
                          transportBuilder: transportBuilder,
                        ),
                      ),
                      SizedBox.expand(
                        child: SafeArea(
                          child: Column(
                            children: [
                              /// Sized boxes without a child are 'invisible' so they do not prevent taps below
                              /// the stack but are still present in the layout. We have a sized box here to stop
                              /// the draggable panel from jumping as you start to pull it up. I am really looking
                              /// forward to the Dart team fixing the nested scroll issues with [DraggableScrollableSheet]
                              SizedBox(
                                height: 64,
                                child: scrollPos == 1
                                    ? Opacity(
                                        opacity: opacity,
                                        child: const FloatingPlayer(),
                                      )
                                    : null,
                              ),
                              if (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                                const Expanded(
                                  child: NowPlayingOptionsSelector(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: NowPlayingTabs(
                        episode: snapshot.data!,
                        transportBuilder: transportBuilder,
                      ),
                    ),
                    const Expanded(
                      child: NowPlayingOptionsSelectorWide(),
                    ),
                  ],
                );
        },
      ),
    );
  }
}

/// This widget displays the episode logo, episode title and current
/// chapter if available.
///
/// If running in portrait this will be in a vertical format; if in
/// landscape this will be in a horizontal format. The actual displaying
/// of the episode text is handed off to [NowPlayingEpisodeDetails].
class NowPlayingEpisode extends StatelessWidget {
  const NowPlayingEpisode({
    required this.imageUrl,
    required this.episode,
    required this.textGroup,
    super.key,
  });
  final String? imageUrl;
  final Episode episode;
  final AutoSizeGroup? textGroup;

  @override
  Widget build(BuildContext context) {
    final placeholderBuilder = PlaceholderBuilder.of(context);

    return OrientationBuilder(
      builder: (context, orientation) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: MediaQuery.of(context).orientation == Orientation.portrait ||
                  MediaQuery.of(context).size.width >= 1000
              ? Column(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Semantics(
                        label: 'artwork',
                        child: PodcastImage(
                          key: Key('nowplaying$imageUrl'),
                          url: imageUrl!,
                          width: MediaQuery.of(context).size.width * .75,
                          height: MediaQuery.of(context).size.height * .75,
                          fit: BoxFit.contain,
                          borderRadius: 6,
                          placeholder: placeholderBuilder != null
                              ? placeholderBuilder.builder()(context)
                              : const DelayedCircularProgressIndicator(),
                          errorPlaceholder: placeholderBuilder != null
                              ? placeholderBuilder.errorBuilder()(context)
                              : const Image(
                                  image: AssetImage(
                                    'assets/illustrations/music-note.png',
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: NowPlayingEpisodeDetails(
                        episode: episode,
                        textGroup: textGroup,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          bottom: 8,
                        ),
                        child: PodcastImage(
                          key: Key('nowplaying$imageUrl'),
                          url: imageUrl!,
                          height: 280,
                          width: 280,
                          fit: BoxFit.contain,
                          borderRadius: 8,
                          placeholder: placeholderBuilder != null
                              ? placeholderBuilder.builder()(context)
                              : const DelayedCircularProgressIndicator(),
                          errorPlaceholder: placeholderBuilder != null
                              ? placeholderBuilder.errorBuilder()(context)
                              : const Image(
                                  image: AssetImage(
                                    'assets/illustrations/music-note.png',
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: NowPlayingEpisodeDetails(
                        episode: episode,
                        textGroup: textGroup,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

/// This widget is responsible for displaying the main episode details.
///
/// This displays the current episode title and, if available, the
/// current chapter title and optional link.
class NowPlayingEpisodeDetails extends StatelessWidget {
  const NowPlayingEpisodeDetails({
    super.key,
    this.episode,
    this.textGroup,
  });
  final Episode? episode;
  final AutoSizeGroup? textGroup;
  static const minFontSize = 14.0;

  @override
  Widget build(BuildContext context) {
    final chapterTitle = episode?.currentChapter?.title ?? '';
    final chapterUrl = episode?.currentChapter?.url ?? '';

    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
            child: Semantics(
              container: true,
              child: AutoSizeText(
                episode?.title ?? '',
                group: textGroup,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                minFontSize: minFontSize,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                maxLines: episode!.hasChapters ? 3 : 4,
              ),
            ),
          ),
        ),
        if (episode!.hasChapters)
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Semantics(
                      label: 'current chapter',
                      container: true,
                      child: AutoSizeText(
                        chapterTitle,
                        group: textGroup,
                        minFontSize: minFontSize,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ),
                  if (chapterUrl.isEmpty)
                    const SizedBox(
                      height: 0,
                      width: 0,
                    )
                  else
                    Semantics(
                      label: 'chapter',
                      container: true,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.link,
                        ),
                        color: Theme.of(context).primaryIconTheme.color,
                        onPressed: () {
                          _chapterLink(chapterUrl);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _chapterLink(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch chapter link: $url';
    }
  }
}

/// This widget handles the displaying of the episode show notes.
///
/// This consists of title, show notes and person details
/// (where available).
class NowPlayingShowNotes extends StatelessWidget {
  const NowPlayingShowNotes({
    required this.episode,
    super.key,
  });
  final Episode? episode;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Text(
                  episode!.title!,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            if (episode!.persons.isNotEmpty)
              SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount: episode!.persons.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return PersonAvatar(person: episode!.persons[index]);
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                left: 8,
                right: 8,
              ),
              child: PodcastHtml(
                content: episode?.content ?? episode?.description ?? '',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for rendering main episode tabs.
///
/// This will be episode details and show notes. If the episode supports chapters
/// this will be included also. This is the parent widget. The tabs are
/// rendered via [EpisodeTabBar] and the tab contents via. [EpisodeTabBarView].
class NowPlayingTabs extends StatelessWidget {
  const NowPlayingTabs({
    required this.transportBuilder,
    required this.episode,
    super.key,
  });

  final WidgetBuilder? transportBuilder;
  final Episode episode;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: episode.hasChapters ? 3 : 2,
      initialIndex: episode.hasChapters ? 1 : 0,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).appBarTheme.systemOverlayStyle!.copyWith(
              systemNavigationBarColor: Theme.of(context).secondaryHeaderColor,
            ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            leading: IconButton(
              tooltip: 'minimize',
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              onPressed: () => {
                Navigator.pop(context),
              },
            ),
            flexibleSpace: PlaybackErrorListener(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  EpisodeTabBar(
                    chapters: episode.hasChapters,
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                flex: 5,
                child: EpisodeTabBarView(
                  episode: episode,
                  chapters: episode.hasChapters,
                ),
              ),
              if (transportBuilder != null)
                transportBuilder!(context)
              else
                const SizedBox(
                  height: 148,
                  child: NowPlayingTransport(),
                ),
              if (MediaQuery.of(context).orientation == Orientation.portrait)
                const Expanded(
                  child: NowPlayingOptionsScaffold(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// This class is responsible for rendering the tab selection at the top of the screen.
///
/// It displays two or three tabs depending upon whether the current episode supports
/// (and contains) chapters.
class EpisodeTabBar extends StatelessWidget {
  const EpisodeTabBar({
    super.key,
    this.chapters = false,
  });
  final bool chapters;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: DotDecoration(colour: Theme.of(context).primaryColor),
      tabs: [
        if (chapters)
          const Tab(
            child: Align(
              child: Text('Chapters'),
            ),
          ),
        const Tab(
          child: Align(
            child: Text('Episode'),
          ),
        ),
        const Tab(
          child: Align(
            child: Text('Episode Notes'),
          ),
        ),
      ],
    );
  }
}

/// This class is responsible for rendering the tab bodies.
///
/// This includes the chapter selection view (if the episode supports chapters),
/// the episode details (image and description) and the show notes view.
class EpisodeTabBarView extends StatelessWidget {
  const EpisodeTabBarView({
    super.key,
    this.episode,
    this.textGroup,
    this.chapters = false,
  });
  final Episode? episode;
  final AutoSizeGroup? textGroup;
  final bool chapters;

  @override
  Widget build(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context);

    return TabBarView(
      children: [
        if (chapters)
          ChapterSelector(
            episode: episode!,
          ),
        StreamBuilder<Episode?>(
          stream: audioBloc.nowPlaying,
          builder: (context, snapshot) {
            final e = snapshot.hasData ? snapshot.data! : episode!;

            return NowPlayingEpisode(
              episode: e,
              imageUrl: e.positionalImageUrl,
              textGroup: textGroup,
            );
          },
        ),
        NowPlayingShowNotes(episode: episode),
      ],
    );
  }
}

/// This is the parent widget for the episode position and transport
/// controls.
class NowPlayingTransport extends StatelessWidget {
  const NowPlayingTransport({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Divider(
          height: 0,
        ),
        PlayerPositionControls(),
        PlayerTransportControls(),
      ],
    );
  }
}

/// This widget allows users to inject their own transport controls
/// into the app.
///
/// When rendering the controls, Anytime will check if a PlayerControlsBuilder
/// is in the tree. If so, it will use the builder rather than its own
/// transport controls.
class PlayerControlsBuilder extends InheritedWidget {
  const PlayerControlsBuilder({
    required this.builder,
    required super.child,
    super.key,
  });
  final WidgetBuilder Function(int duration) builder;

  static PlayerControlsBuilder? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PlayerControlsBuilder>();
  }

  @override
  bool updateShouldNotify(PlayerControlsBuilder oldWidget) {
    return builder != oldWidget.builder;
  }
}
// class NowPlaying extends StatefulWidget {
//   const NowPlaying({super.key});

//   @override
//   State<NowPlaying> createState() => _NowPlayingState();
// }

// class _NowPlayingState extends State<NowPlaying> with WidgetsBindingObserver {
//   late StreamSubscription<AudioState> playingStateSubscription;
//   AutoSizeGroup textGroup = AutoSizeGroup();
//   double scrollPos = 0;
//   double opacity = 0;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);

//     final audioBloc = Provider.of<AudioBloc>(context, listen: false);
//     var popped = false;

//     // If the episode finishes we can close.
//     playingStateSubscription = audioBloc.playingState!
//         .where((state) => state == AudioState.stopped)
//         .listen((playingState) async {
//       // Prevent responding to multiple stop events after we've popped and lost context.
//       if (!popped) {
//         Navigator.pop(context);
//         popped = true;
//       }
//     });
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     playingStateSubscription.cancel();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final audioBloc = Provider.of<AudioBloc>(context, listen: false);
//     final playerBuilder = PlayerControlsBuilder.of(context);

//     return StreamBuilder<Episode?>(
//       stream: audioBloc.nowPlaying,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Container();
//         }

//         final duration = snapshot.data == null ? 0 : snapshot.data!.duration;
//         final transportBuilder = playerBuilder?.builder(duration);

//         return NotificationListener<DraggableScrollableNotification>(
//           onNotification: (notification) {
//             setState(() {
//               if (notification.extent > (notification.minExtent)) {
//                 opacity = 1 - (notification.maxExtent - notification.extent);
//                 scrollPos = 1.0;
//               } else {
//                 opacity = 0.0;
//                 scrollPos = 0.0;
//               }
//             });

//             return true;
//           },
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               DefaultTabController(
//                 length: snapshot.data!.hasChapters ? 3 : 2,
//                 initialIndex: snapshot.data!.hasChapters ? 1 : 0,
//                 child: Scaffold(
//                   appBar: AppBar(
//                     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                     elevation: 0,
//                     leading: IconButton(
//                       tooltip: AppStrings.minimisePlayerWindowButtonLabel,
//                       icon: Icon(
//                         Icons.keyboard_arrow_down,
//                         color: Theme.of(context).primaryIconTheme.color,
//                       ),
//                       onPressed: () => {
//                         Navigator.pop(context),
//                       },
//                     ),
//                     flexibleSpace: PlaybackErrorListener(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: <Widget>[
//                           EpisodeTabBar(
//                             chapters: snapshot.data!.hasChapters,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   body: Column(
//                     children: [
//                       Expanded(
//                         flex: 5,
//                         child: EpisodeTabBarView(
//                           episode: snapshot.data!,
//                           chapters: snapshot.data!.hasChapters,
//                         ),
//                       ),
//                       if (transportBuilder != null)
//                         transportBuilder(context)
//                       else
//                         const SizedBox(
//                           height: 148,
//                           child: NowPlayingTransport(),
//                         ),
//                       const Expanded(
//                         child: NowPlayingOptionsScaffold(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox.expand(
//                 child: SafeArea(
//                   child: Column(
//                     children: [
//                       /// Sized boxes without a child are 'invisible' so they do not prevent taps below
//                       /// the stack but are still present in the layout. We have a sized box here to stop
//                       /// the draggable panel from jumping as you start to pull it up. I am really looking
//                       /// forward to the Dart team fixing the nested scroll issues with [DraggableScrollableSheet]
//                       SizedBox(
//                         height: 64,
//                         child: scrollPos == 1
//                             ? Opacity(
//                                 opacity: opacity,
//                                 child: const FloatingPlayer(),
//                               )
//                             : null,
//                       ),
//                       const Expanded(
//                         child: NowPlayingOptionsSelector(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// /// This class is responsible for rendering the tab selection at the top of the screen. It displays
// /// two or three tabs depending upon whether the current episode supports (and contains) chapters.
// class EpisodeTabBar extends StatelessWidget {
//   const EpisodeTabBar({
//     super.key,
//     this.chapters = false,
//   });
//   final bool chapters;

//   @override
//   Widget build(BuildContext context) {
//     return TabBar(
//       isScrollable: true,
//       indicatorSize: TabBarIndicatorSize.tab,
//       indicator: DotDecoration(colour: Theme.of(context).primaryColor),
//       tabs: [
//         if (chapters)
//           const Tab(
//             child: Align(
//               child: Text(AppStrings.chaptersLabel),
//             ),
//           ),
//         const Tab(
//           child: Align(
//             child: Text(AppStrings.episodeLabel),
//           ),
//         ),
//         const Tab(
//           child: Align(
//             child: Text(AppStrings.notesLabel),
//           ),
//         ),
//       ],
//     );
//   }
// }

// /// This class is responsible for rendering the tab body containing the chapter selection view (if
// /// the episode supports chapters), the episode details (image and description) and the show
// /// notes view.
// class EpisodeTabBarView extends StatelessWidget {
//   const EpisodeTabBarView({
//     super.key,
//     this.episode,
//     this.textGroup,
//     this.chapters = false,
//   });
//   final Episode? episode;
//   final AutoSizeGroup? textGroup;
//   final bool chapters;

//   @override
//   Widget build(BuildContext context) {
//     final audioBloc = Provider.of<AudioBloc>(context);

//     return TabBarView(
//       children: [
//         if (chapters)
//           ChapterSelector(
//             episode: episode!,
//           ),
//         StreamBuilder<Episode?>(
//           stream: audioBloc.nowPlaying,
//           builder: (context, snapshot) {
//             final e = snapshot.hasData ? snapshot.data! : episode!;

//             return NowPlayingEpisode(
//               episode: e,
//               imageUrl: e.positionalImageUrl,
//               textGroup: textGroup,
//             );
//           },
//         ),
//         NowPlayingShowNotes(episode: episode!),
//       ],
//     );
//   }
// }

// class NowPlayingEpisode extends StatelessWidget {
//   const NowPlayingEpisode({
//     required this.imageUrl,
//     required this.episode,
//     required this.textGroup,
//     super.key,
//   });
//   final String? imageUrl;
//   final Episode episode;
//   final AutoSizeGroup? textGroup;

//   @override
//   Widget build(BuildContext context) {
//     final placeholderBuilder = PlaceholderBuilder.of(context);

//     return OrientationBuilder(
//       builder: (context, orientation) {
//         return Padding(
//           padding: const EdgeInsets.all(8),
//           child: MediaQuery.of(context).orientation == Orientation.portrait
//               ? Column(
//                   children: [
//                     Expanded(
//                       flex: 7,
//                       child: PodcastImage(
//                         key: Key('nowplaying$imageUrl'),
//                         url: imageUrl!,
//                         width: MediaQuery.of(context).size.width * .75,
//                         height: MediaQuery.of(context).size.height * .75,
//                         fit: BoxFit.contain,
//                         borderRadius: 6,
//                         placeholder: placeholderBuilder != null
//                             ? placeholderBuilder.builder()(context)
//                             : const DelayedCircularProgressIndicator(),
//                         errorPlaceholder: placeholderBuilder != null
//                             ? placeholderBuilder.errorBuilder()(context)
//                             : const Image(
//                                 image: AssetImage(AssetsConstants.logo),
//                               ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 3,
//                       child: NowPlayingEpisodeDetails(
//                         episode: episode,
//                         textGroup: textGroup,
//                       ),
//                     ),
//                   ],
//                 )
//               : Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: PodcastImage(
//                         key: Key('nowplaying$imageUrl'),
//                         url: imageUrl!,
//                         height: 280,
//                         width: 280,
//                         fit: BoxFit.contain,
//                         borderRadius: 8,
//                         placeholder: placeholderBuilder != null
//                             ? placeholderBuilder.builder()(context)
//                             : const DelayedCircularProgressIndicator(),
//                         errorPlaceholder: placeholderBuilder != null
//                             ? placeholderBuilder.errorBuilder()(context)
//                             : const Image(
//                                 image: AssetImage(AssetsConstants.logo),
//                               ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 3,
//                       child: NowPlayingEpisodeDetails(
//                         episode: episode,
//                         textGroup: textGroup,
//                       ),
//                     ),
//                   ],
//                 ),
//         );
//       },
//     );
//   }
// }

// class NowPlayingEpisodeDetails extends StatelessWidget {
//   const NowPlayingEpisodeDetails({
//     required this.episode,
//     required this.textGroup,
//     super.key,
//   });
//   final Episode? episode;
//   final AutoSizeGroup? textGroup;
//   static const minFontSize = 14.0;

//   @override
//   Widget build(BuildContext context) {
//     final chapterTitle = episode?.currentChapter?.title ?? '';
//     final chapterUrl = episode?.currentChapter?.url ?? '';

//     return Column(
//       children: [
//         Expanded(
//           flex: 5,
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
//             child: AutoSizeText(
//               episode?.title ?? '',
//               group: textGroup,
//               textAlign: TextAlign.center,
//               overflow: TextOverflow.ellipsis,
//               minFontSize: minFontSize,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24,
//               ),
//               maxLines: episode!.hasChapters ? 3 : 4,
//             ),
//           ),
//         ),
//         if (episode!.hasChapters)
//           Expanded(
//             flex: 4,
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Flexible(
//                     child: AutoSizeText(
//                       chapterTitle,
//                       group: textGroup,
//                       minFontSize: minFontSize,
//                       textAlign: TextAlign.center,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Colors.grey[300],
//                         fontWeight: FontWeight.normal,
//                         fontSize: 16,
//                       ),
//                       maxLines: 2,
//                     ),
//                   ),
//                   if (chapterUrl.isEmpty)
//                     const SizedBox(
//                       height: 0,
//                       width: 0,
//                     )
//                   else
//                     IconButton(
//                       padding: EdgeInsets.zero,
//                       icon: const Icon(Icons.link),
//                       color: Theme.of(context).primaryIconTheme.color,
//                       onPressed: () {
//                         _chapterLink(chapterUrl);
//                       },
//                     ),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Future<void> _chapterLink(String url) async {
//     final uri = Uri.parse(url);

//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       throw 'Could not launch chapter link: $url';
//     }
//   }
// }

// class NowPlayingShowNotes extends StatelessWidget {
//   const NowPlayingShowNotes({
//     required this.episode,
//     super.key,
//   });
//   final Episode? episode;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox.expand(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                   left: 16,
//                   right: 16,
//                   bottom: 16,
//                 ),
//                 child: Text(
//                   episode?.title ?? 'no title',
//                   style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//               ),
//             ),
//             if (episode!.persons.isNotEmpty)
//               SizedBox(
//                 height: 120,
//                 child: Container(
//                   child: ListView.builder(
//                     itemCount: episode!.persons.length,
//                     scrollDirection: Axis.horizontal,
//                     itemBuilder: (BuildContext context, int index) {
//                       return PersonAvatar(person: episode!.persons[index]);
//                     },
//                   ),
//                 ),
//               ),
//             Padding(
//               padding: const EdgeInsets.only(
//                 top: 8,
//                 left: 8,
//                 right: 8,
//               ),
//               child: PodcastHtml(content: episode!.description!),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class NowPlayingTransport extends StatelessWidget {
//   const NowPlayingTransport({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       children: <Widget>[
//         Divider(
//           height: 0,
//         ),
//         PlayerPositionControls(),
//         PlayerTransportControls(),
//       ],
//     );
//   }
// }

// class PlayerControlsBuilder extends InheritedWidget {
//   const PlayerControlsBuilder({
//     required this.builder,
//     required super.child,
//     super.key,
//   });
//   final WidgetBuilder Function(int duration) builder;

//   static PlayerControlsBuilder? of(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<PlayerControlsBuilder>();
//   }

//   @override
//   bool updateShouldNotify(PlayerControlsBuilder oldWidget) {
//     return builder != oldWidget.builder;
//   }
// }
