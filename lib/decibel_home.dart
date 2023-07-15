import 'package:decibel/application/bloc/audio_bloc.dart';
import 'package:decibel/application/theme/pager_bloc.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:decibel/presentation/core/layout_selector.dart';
import 'package:decibel/presentation/core/title_bar_widget.dart';
import 'package:decibel/presentation/library/discovery.dart';
import 'package:decibel/presentation/library/downloads.dart';
import 'package:decibel/presentation/library/library.dart';
import 'package:decibel/presentation/podcast/mini_player.dart';
import 'package:decibel/presentation/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class DecibelHome extends StatefulWidget {
  const DecibelHome({super.key});

  @override
  _DecibelHomeState createState() => _DecibelHomeState();
}

class _DecibelHomeState extends State<DecibelHome> with WidgetsBindingObserver {
  final log = Logger('_DecibelHomePageState');

  @override
  void initState() {
    super.initState();

    final audioBloc = Provider.of<AudioBloc>(context, listen: false);

    WidgetsBinding.instance.addObserver(this);

    audioBloc.transitionLifecycleState(LifecycleState.resume);
  }

  @override
  void dispose() {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    audioBloc.transitionLifecycleState(LifecycleState.pause);

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);

    switch (state) {
      case AppLifecycleState.resumed:
        audioBloc.transitionLifecycleState(LifecycleState.resume);
      case AppLifecycleState.paused:
        audioBloc.transitionLifecycleState(LifecycleState.pause);
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pager = Provider.of<PagerBloc>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverVisibility(
                  sliver: SliverAppBar(
                    title: const TitleWidget(),
                    centerTitle: true,
                    // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    pinned: true,
                    actions: <Widget>[
                      PopupMenuButton<String>(
                        onSelected: _menuSelect,
                        icon: const Icon(
                          Ionicons.ellipsis_vertical_circle_outline,
                        ),
                        itemBuilder: (BuildContext context) {
                          return <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              textStyle:
                                  Theme.of(context).textTheme.titleMedium,
                              value: 'layout',
                              child: const Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child:
                                        Icon(Ionicons.grid_outline, size: 18),
                                  ),
                                  Text(AppStrings.layoutLabel),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              textStyle:
                                  Theme.of(context).textTheme.titleMedium,
                              value: 'settings',
                              child: const Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Ionicons.settings_outline,
                                      size: 18,
                                    ),
                                  ),
                                  Text(AppStrings.settingsLabel),
                                ],
                              ),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                ),
                StreamBuilder<int>(
                  stream: pager.currentPage,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    return _fragment(snapshot.data);
                  },
                ),
                // const Discovery(),
              ],
            ),
          ),
          const MiniPlayer(),
        ],
      ),
      bottomNavigationBar: StreamBuilder<int>(
        stream: pager.currentPage,
        initialData: 0,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          final index = snapshot.data ?? 0;

          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).bottomAppBarTheme.color,
            selectedIconTheme: Theme.of(context).iconTheme,
            selectedItemColor: Theme.of(context).iconTheme.color,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            unselectedItemColor:
                HSLColor.fromColor(Theme.of(context).bottomAppBarTheme.color!)
                    .withLightness(0.8)
                    .toColor(),
            currentIndex: index,
            onTap: pager.changePage,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: index == 0
                    ? const Icon(Ionicons.radio_sharp)
                    : const Icon(Ionicons.radio_outline),
                label: AppStrings.libraryLabel,
              ),
              BottomNavigationBarItem(
                icon: index == 1
                    ? const Icon(Ionicons.compass_sharp)
                    : const Icon(Ionicons.compass_outline),
                label: AppStrings.discoverLabel,
              ),
              BottomNavigationBarItem(
                icon: index == 2
                    ? const Icon(Ionicons.download_sharp)
                    : const Icon(Ionicons.download_outline),
                label: AppStrings.downloadsLabel,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _fragment(int? index) {
    if (index == 0) {
      return const Library();
    } else if (index == 1) {
      return const Discovery();
    } else {
      return const Downloads();
    }
  }

  Future<void> _menuSelect(String choice) async {
    final theme = Theme.of(context);

    switch (choice) {
      case 'settings':
        await Navigator.push(
          context,
          MaterialPageRoute<void>(
            settings: const RouteSettings(name: 'settings'),
            builder: (context) => const Settings(),
          ),
        );
      case 'layout':
        await showModalBottomSheet<void>(
          context: context,
          backgroundColor: theme.secondaryHeaderColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          builder: (context) => const LayoutSelectorWidget(),
        );
    }
  }
}
