// // paywall_screen.dart
// import 'package:decibel/application/bloc/episode_bloc.dart';
// import 'package:flutter/material.dart';

// class PaywallScreen extends StatelessWidget {
//   final EpisodeBloc episodeBloc;

//   PaywallScreen({required this.episodeBloc});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Paywall Screen'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Access premium episodes!',
//               style: TextStyle(fontSize: 20),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Implement logic to navigate to the subscription screen
//                 // where users can choose and pay for subscription plans.
//               },
//               child: Text('Subscribe'),
//             ),
//             StreamBuilder<bool>(
//               stream: episodeBloc.userHasAccessToPremiumEpisodesStream,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData && snapshot.data == true) {
//                   return ElevatedButton(
//                     onPressed: () {
//                       // Implement logic to navigate to the episode list screen
//                       // where premium episodes can be accessed.
//                     },
//                     child: Text('View Premium Episodes'),
//                   );
//                 } else {
//                   return Text('You need a subscription to access premium episodes.');
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
