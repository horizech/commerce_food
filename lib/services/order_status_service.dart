import 'dart:async';

import 'package:rxdart/subjects.dart';
// import 'package:rxdart/rxdart.dart';

class OrderStatusService {
  final BehaviorSubject<int?> _orderStatusSubject =
      BehaviorSubject.seeded(null);

  Stream get statusStream$ => _orderStatusSubject.stream;

  int? get currentStatus => _orderStatusSubject.valueWrapper?.value;

  setStatus(int newValue) {
    _orderStatusSubject.add(newValue);
  }

  void removeStream() {
    _orderStatusSubject.add(null);
  }
}
