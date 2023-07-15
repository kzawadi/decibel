// Copyright 2023 Kelvin Zawadi @kzawadi. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:decibel/application/bloc/bloc_state.dart';
import 'package:decibel/application/bloc/podcast_bloc.dart';
import 'package:decibel/domain/podcast/episode.dart';
import 'package:decibel/domain/podcast/feed.dart';
import 'package:decibel/domain/podcast/podcast.dart';
import 'package:decibel/presentation/core/action_text.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/core/assets_constants.dart';
import 'package:decibel/presentation/core/delayed_progress_indicator.dart';
import 'package:decibel/presentation/core/placeholder_builder.dart';
import 'package:decibel/presentation/core/platform_back_button.dart';
import 'package:decibel/presentation/core/platform_progress_indicator.dart';
import 'package:decibel/presentation/core/podcast_html.dart';
import 'package:decibel/presentation/core/podcast_image.dart';
import 'package:decibel/presentation/core/sync_spinner.dart';
import 'package:decibel/presentation/podcast/playback_error_listener.dart';
import 'package:decibel/presentation/podcast/podcast_context_menu.dart';
import 'package:decibel/presentation/podcast/podcast_episode_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

/// This Widget takes a search result and builds a list of currently available
/// podcasts. From here a user can option to subscribe/unsubscribe or play a
/// podcast directly from a search result.
class PodcastDetails extends StatefulWidget {
  const PodcastDetails(this.podcast, this._podcastBloc, {super.key});
  final Podcast podcast;
  final PodcastBloc _podcastBloc;

  @override
  State<PodcastDetails> createState() => _PodcastDetailsState();
}

class _PodcastDetailsState extends State<PodcastDetails> {
  final log = Logger('PodcastDetails');
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final ScrollController _sliverScrollController = ScrollController();
  Brightness brightness = Brightness.dark;
  bool toolbarCollapsed = false;
  late SystemUiOverlayStyle _systemOverlayStyle;

  @override
  void initState() {
    super.initState();

    // Load the details of the Podcast specified in the URL
    log.fine('initState() - load feed');

    widget._podcastBloc.load(
      Feed(
        podcast: widget.podcast,
        backgroundFresh: true,
        silently: true,
      ),
    );

    // We only want to display the podcast title when the toolbar is in a
    // collapsed state. Add a listener and set toollbarCollapsed variable
    // as required. The text display property is then based on this boolean.
    _sliverScrollController.addListener(() {
      if (!toolbarCollapsed &&
          _sliverScrollController.hasClients &&
          _sliverScrollController.offset > (300 - kToolbarHeight)) {
        setState(() {
          toolbarCollapsed = true;
          _updateSystemOverlayStyle();
        });
      } else if (toolbarCollapsed &&
          _sliverScrollController.hasClients &&
          _sliverScrollController.offset < (300 - kToolbarHeight)) {
        setState(() {
          toolbarCollapsed = false;
          _updateSystemOverlayStyle();
        });
      }
    });

    widget._podcastBloc.backgroundLoading
        .where((event) => event is BlocPopulatedState<void>)
        .listen((event) {
      if (mounted) {
        /// If we have not scrolled (save a few pixels) just refresh the episode list;
        /// otherwise prompt the user to prevent unexpected list jumping
        if (_sliverScrollController.offset < 20) {
          widget._podcastBloc.podcastEvent(PodcastEvent.refresh);
        } else {
          scaffoldMessengerKey.currentState!.showSnackBar(
            SnackBar(
              content: const Text(AppStrings.newEpisodeLabel),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: AppStrings.newEpisodesViewNowLabel,
                onPressed: () {
                  _sliverScrollController.animateTo(
                    100,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                  widget._podcastBloc.podcastEvent(PodcastEvent.refresh);
                },
              ),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    _systemOverlayStyle = SystemUiOverlayStyle(
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
      statusBarColor: Theme.of(context)
          .appBarTheme
          .backgroundColor!
          .withOpacity(toolbarCollapsed ? 1.0 : 0.5),
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    log.fine('_handleRefresh');

    widget._podcastBloc.load(
      Feed(
        podcast: widget.podcast,
        refresh: true,
      ),
    );
  }

  void _resetSystemOverlayStyle() {
    setState(() {
      _systemOverlayStyle = SystemUiOverlayStyle(
        statusBarIconBrightness:
            Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
        statusBarColor: Colors.transparent,
      );
    });
  }

  void _updateSystemOverlayStyle() {
    setState(() {
      _systemOverlayStyle = SystemUiOverlayStyle(
        statusBarIconBrightness:
            Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
        statusBarColor: Theme.of(context)
            .appBarTheme
            .backgroundColor!
            .withOpacity(toolbarCollapsed ? 1.0 : 0.5),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final podcastBloc = Provider.of<PodcastBloc>(context, listen: false);
    final placeholderBuilder = PlaceholderBuilder.of(context);

    return WillPopScope(
      onWillPop: () {
        _resetSystemOverlayStyle();
        return Future.value(true);
      },
      child: ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: RefreshIndicator(
            displacement: 60,
            onRefresh: _handleRefresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _sliverScrollController,
              slivers: <Widget>[
                SliverAppBar(
                  systemOverlayStyle: _systemOverlayStyle,
                  title: AnimatedOpacity(
                    opacity: toolbarCollapsed ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Text(widget.podcast.title!),
                  ),
                  leading: PlatformBackButton(
                    iconColour: toolbarCollapsed &&
                            Theme.of(context).brightness == Brightness.light
                        ? Theme.of(context).appBarTheme.foregroundColor!
                        : Colors.white,
                    decorationColour: toolbarCollapsed
                        ? const Color(0x00000000)
                        : const Color(0x88888888),
                    onPressed: () {
                      _resetSystemOverlayStyle();
                      Navigator.pop(context);
                    },
                  ),
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      key: Key(
                        'detailhero${widget.podcast.imageUrl}:${widget.podcast.link}',
                      ),
                      tag: '${widget.podcast.imageUrl}:${widget.podcast.link}',
                      child: ExcludeSemantics(
                        child: StreamBuilder<BlocState<Podcast>>(
                          initialData: BlocEmptyState<Podcast>(),
                          stream: podcastBloc.details,
                          builder: (context, snapshot) {
                            final state = snapshot.data;
                            var podcast = widget.podcast;

                            if (state is BlocLoadingState<Podcast>) {
                              podcast = state.data!;
                            }

                            if (state is BlocPopulatedState<Podcast>) {
                              podcast = state.results!;
                            }

                            return PodcastHeaderImage(
                              podcast: podcast,
                              placeholderBuilder: placeholderBuilder,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                StreamBuilder<BlocState<Podcast>>(
                  initialData: BlocEmptyState<Podcast>(),
                  stream: podcastBloc.details,
                  builder: (context, snapshot) {
                    final state = snapshot.data;

                    if (state is BlocLoadingState) {
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            children: <Widget>[
                              PlatformProgressIndicator(),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is BlocErrorState) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(
                                Icons.error_outline,
                                size: 50,
                              ),
                              Text(
                                AppStrings.noPodcastDetailsMessage,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is BlocPopulatedState<Podcast>) {
                      return SliverToBoxAdapter(
                        child: PlaybackErrorListener(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              PodcastTitle(state.results!),
                              const Divider(),
                            ],
                          ),
                        ),
                      );
                    }

                    return const SliverToBoxAdapter(
                      child: SizedBox(
                        width: 0,
                        height: 0,
                      ),
                    );
                  },
                ),
                StreamBuilder<List<Episode?>?>(
                  stream: podcastBloc.episodes,
                  builder: (context, snapshot) {
                    return snapshot.hasData && snapshot.data!.isNotEmpty
                        ? PodcastEpisodeList(
                            episodes: snapshot.data!,
                            play: true,
                            download: true,
                          )
                        : SliverToBoxAdapter(child: Container());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PodcastHeaderImage extends StatelessWidget {
  const PodcastHeaderImage({
    required this.podcast,
    required this.placeholderBuilder,
    super.key,
  });

  final Podcast podcast;
  final PlaceholderBuilder? placeholderBuilder;

  @override
  Widget build(BuildContext context) {
    if (podcast.imageUrl == null || podcast.imageUrl!.isEmpty) {
      return const SizedBox(
        height: 560,
        width: 560,
      );
    }

    return PodcastBannerImage(
      key: Key('details${podcast.imageUrl}'),
      url: podcast.imageUrl!,
      placeholder: placeholderBuilder != null
          ? placeholderBuilder!.builder()(context)
          : const DelayedCircularProgressIndicator(),
      errorPlaceholder: placeholderBuilder != null
          ? placeholderBuilder!.errorBuilder()(context)
          : SvgPicture.asset(
              AssetsConstants.logo,
            ),
    );
  }
}

class PodcastTitle extends StatefulWidget {
  const PodcastTitle(this.podcast, {super.key});
  final Podcast podcast;

  @override
  State<PodcastTitle> createState() => _PodcastTitleState();
}

class _PodcastTitleState extends State<PodcastTitle> {
  final GlobalKey descriptionKey = GlobalKey();
  final maxHeight = 100.0;
  PodcastHtml? description;
  bool showOverflow = false;
  final StreamController<bool> isDescriptionExpandedStream =
      StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final settings = Provider.of<SettingsBloc>(context).currentSettings;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
                      child: Text(
                        widget.podcast.title ?? '',
                        style: textTheme.titleLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Text(
                        widget.podcast.copyright ?? '',
                        style: textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<bool>(
                stream: isDescriptionExpandedStream.stream,
                initialData: false,
                builder: (context, snapshot) {
                  final expanded = snapshot.data!;
                  return Visibility(
                    visible: showOverflow,
                    child: expanded
                        ? TextButton(
                            style: const ButtonStyle(
                              visualDensity: VisualDensity.compact,
                            ),
                            child: const Icon(Icons.expand_less),
                            onPressed: () {
                              isDescriptionExpandedStream.add(false);
                            },
                          )
                        : TextButton(
                            style: const ButtonStyle(
                              visualDensity: VisualDensity.compact,
                            ),
                            child: const Icon(Icons.expand_more),
                            onPressed: () {
                              isDescriptionExpandedStream.add(true);
                            },
                          ),
                  );
                },
              )
            ],
          ),
          PodcastDescription(
            key: descriptionKey,
            content: description,
            isDescriptionExpandedStream: isDescriptionExpandedStream,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              children: <Widget>[
                SubscriptionButton(widget.podcast),
                PodcastContextMenu(widget.podcast),
                const Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SyncSpinner(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    description = PodcastHtml(
      content: widget.podcast.description!,
      fontSize: FontSize.medium,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (descriptionKey.currentContext!.size!.height == maxHeight) {
        setState(() {
          showOverflow = true;
        });
      }
    });
  }
}

/// This class wraps the description in an expandable box. This handles the
/// common case whereby the description is very long and, without this constraint,
/// would require the use to always scroll before reaching the podcast episodes.
///
/// TODO: Animate between the two states.
class PodcastDescription extends StatelessWidget {
  const PodcastDescription({
    required this.isDescriptionExpandedStream,
    super.key,
    this.content,
  });
  final PodcastHtml? content;
  final StreamController<bool> isDescriptionExpandedStream;
  static const maxHeight = 100.0;
  static const padding = 4.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: PodcastDescription.padding),
      child: StreamBuilder<bool>(
        stream: isDescriptionExpandedStream.stream,
        initialData: false,
        builder: (context, snapshot) {
          final expanded = snapshot.data!;
          return AnimatedSize(
            duration: const Duration(milliseconds: 150),
            curve: Curves.fastOutSlowIn,
            alignment: Alignment.topCenter,
            child: Container(
              constraints: expanded
                  ? const BoxConstraints()
                  : BoxConstraints.loose(
                      const Size(double.infinity, maxHeight - padding),
                    ),
              child: expanded
                  ? content
                  : ShaderMask(
                      shaderCallback: LinearGradient(
                        colors: [Colors.white, Colors.white.withAlpha(0)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.9, 1],
                      ).createShader,
                      child: content,
                    ),
            ),
          );
        },
      ),
    );
  }
}

class SubscriptionButton extends StatelessWidget {
  const SubscriptionButton(this.podcast, {super.key});
  final Podcast podcast;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PodcastBloc>(context);

    return StreamBuilder<BlocState<Podcast>>(
      stream: bloc.details,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final state = snapshot.data;

          if (state is BlocPopulatedState<Podcast>) {
            final p = state.results!;

            return p.subscribed
                ? OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(
                      Icons.delete_outline,
                    ),
                    label: const Text(AppStrings.unsubscribeLabel),
                    onPressed: () {
                      showPlatformDialog<void>(
                        context: context,
                        useRootNavigator: false,
                        builder: (_) => BasicDialogAlert(
                          title: const Text(AppStrings.unsubscribeLabel),
                          content: Text(AppStrings.unsubscribeMessage),
                          actions: <Widget>[
                            BasicDialogAction(
                              title: const ActionText(
                                AppStrings.cancelButtonLabel,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            BasicDialogAction(
                              title: const ActionText(
                                AppStrings.unsubscribeButtonLabel,
                              ),
                              iosIsDefaultAction: true,
                              iosIsDestructiveAction: true,
                              onPressed: () {
                                bloc.podcastEvent(PodcastEvent.unsubscribe);

                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(
                      Icons.add,
                    ),
                    label: const Text(AppStrings.subscribeLabel),
                    onPressed: () {
                      bloc.podcastEvent(PodcastEvent.subscribe);
                    },
                  );
          }
        }
        return Container();
      },
    );
  }
}
