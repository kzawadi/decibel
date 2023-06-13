import 'dart:async';

import 'package:injectable/injectable.dart';

@injectable
class SelectInterestsUseCase {
  //extends IUseCase<List<String>, String>
  List<String> selectedInterest = <String>[];
  // @override
  FutureOr<List<String>> call({required String params}) {
    if (selectedInterest.contains(params)) {
      selectedInterest.remove(params);
    } else {
      selectedInterest.add(params);
    }
    print(selectedInterest.length);
    print(selectedInterest);
    return selectedInterest;
  }
  // List<String> selectedInterest = <String>[];

  // final StreamController<List<String>> _interestsStreamController =
  //     StreamController<List<String>>.broadcast();

  // Stream<List<String>> get interestsStream => _interestsStreamController.stream;

  // void updateSelectedInterest(String params) {
  // if (selectedInterest.contains(params)) {
  //   selectedInterest.remove(params);
  // } else {
  //   selectedInterest.add(params);
  // }
  // print(selectedInterest.length);
  // print(selectedInterest);

  //   _interestsStreamController.add(selectedInterest);
  // }

  // void dispose() {
  //   _interestsStreamController.close();
  // }
}
