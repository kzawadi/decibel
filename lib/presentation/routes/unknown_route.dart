import 'package:flutter/material.dart';

class UnknownRoute extends StatelessWidget {
  const UnknownRoute({
    super.key,
  });

  // final UnAuthenticatingFailure? value;
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('an error has occured ,Please restart this App'),
            SizedBox(
              height: 20,
            ),
            Text('error: unknown'),
          ],
        ),
      ),
    );
  }
}
