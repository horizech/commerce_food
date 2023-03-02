import 'dart:async';

import 'package:rxdart/subjects.dart';
// import 'package:rxdart/rxdart.dart';

class VariationService {
  final BehaviorSubject<Map<String, List<int>>?> _variationSubject =
      BehaviorSubject.seeded(null);

  Stream get variationStream$ => _variationSubject.stream;

  Map<String, List<int>>? get currentVariation =>
      _variationSubject.valueWrapper?.value;

  setVariation(Map<String, List<int>> newValue) {
    _variationSubject.add(newValue);
  }

  void removeVariation() {
    _variationSubject.add(null);
  }
}
