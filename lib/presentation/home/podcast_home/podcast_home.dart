import 'package:decibel/presentation/core/title_bar_widget.dart';
import 'package:flutter/material.dart';

class PodcastHome extends StatelessWidget {
  const PodcastHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverVisibility(
                  sliver: SliverAppBar(
                    title: const TitleWidget(),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    pinned: true,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Widget _fragment(int index) {
//   if (index == 0) {
//     return Library();
//   } else if (index == 1) {
//     return Discovery(
//       categories: true,
//       inlineSearch: widget.inlineSearch,
//     );
//   } else {
//     return Downloads();
//   }
// }
