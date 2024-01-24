// Copyright 2023 Kelvin Zawadi.@kzawadi All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:decibel/application/bloc/discovery/discovery_bloc.dart';
import 'package:decibel/application/bloc/discovery/discovery_state_event.dart';
import 'package:decibel/presentation/core/discovery_results.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sliver_tools/sliver_tools.dart';

/// This class is the root class for rendering the Discover tab.

class Discovery extends StatefulWidget {
  const Discovery({
    super.key,
    this.categories = true,
    this.inlineSearch = false,
  });
  final bool categories;
  final bool inlineSearch;

  @override
  State<StatefulWidget> createState() => _DiscoveryState();
}

class _DiscoveryState extends State<Discovery> {
  @override
  void initState() {
    super.initState();

    final bloc = Provider.of<DiscoveryBloc>(context, listen: false);

    bloc.discover(
      DiscoveryChartEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<DiscoveryBloc>(context);

    return widget.categories
        ? MultiSliver(
            children: [
              SliverPersistentHeader(
                delegate: MyHeaderDelegate(bloc),
                pinned: true,
              ),
              DiscoveryResults(
                data: bloc.results,
                inlineSearch: widget.inlineSearch,
              ),
            ],
          )
        : DiscoveryResults(
            data: bloc.results,
            inlineSearch: widget.inlineSearch,
          );
  }
}

/// This delegate is responsible for rendering the horizontal scrolling list of categories
/// that can optionally be displayed at the top of the Discovery results page.
class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  MyHeaderDelegate(this.discoveryBloc);
  final DiscoveryBloc discoveryBloc;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return CategorySelectorWidget(discoveryBloc: discoveryBloc);
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class CategorySelectorWidget extends StatefulWidget {
  CategorySelectorWidget({
    required this.discoveryBloc,
    super.key,
  });
  final ItemScrollController itemScrollController = ItemScrollController();

  final DiscoveryBloc discoveryBloc;

  @override
  State<CategorySelectorWidget> createState() => _CategorySelectorWidgetState();
}

class _CategorySelectorWidgetState extends State<CategorySelectorWidget> {
  @override
  Widget build(BuildContext context) {
    var selectedCategory = widget.discoveryBloc.selectedGenre.genre;

    return Container(
      width: double.infinity,
      color: Theme.of(context).canvasColor,
      child: StreamBuilder<List<String>>(
        stream: widget.discoveryBloc.genres,
        initialData: const [],
        builder: (context, snapshot) {
          final i = widget.discoveryBloc.selectedGenre.index;

          return snapshot.hasData && snapshot.data != null
              ? ScrollablePositionedList.builder(
                  initialScrollIndex: (i > 0) ? i : 0,
                  itemScrollController: widget.itemScrollController,
                  itemCount: snapshot.data!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    final item = snapshot.data![i];
                    final padding = i == 0 ? 14.0 : 0.0;

                    return Container(
                      margin: EdgeInsets.only(left: padding),
                      child: Card(
                        color: item == selectedCategory ||
                                (selectedCategory.isEmpty && i == 0)
                            ? Theme.of(context).cardTheme.shadowColor
                            : Theme.of(context).cardTheme.color,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xffffffff),
                            visualDensity: VisualDensity.compact,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedCategory = item;
                            });

                            widget.discoveryBloc.discover(
                              DiscoveryChartEvent(
                                genre: item,
                              ),
                            );
                          },
                          child: Text(item),
                        ),
                      ),
                    );
                  },
                )
              : Container();
        },
      ),
    );
  }
}
