import 'package:equatable/equatable.dart';
import 'package:shop/models/cart_item.dart';

class Cart extends Equatable {
  List<CartItem> items = [];

  @override
  List<Object?> get props => throw UnimplementedError();
}
