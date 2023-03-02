import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState(null));

  void reset() {
    emit(CartState(null));
  }

  void addToCart(CartItem item) async {
    Cart cart = state.cart;

    List<int> alreadyMatchingItems = [];

    cart.items.asMap().entries.forEach((x) {
      if (x.value.product.id == item.product.id) {
        if (CartItem.areVariationsEqual(
            x.value.selectedVariationsValues, item.selectedVariationsValues)) {
          alreadyMatchingItems.add(x.key);
        }
      }
    });

    if (alreadyMatchingItems.isNotEmpty) {
      for (int i in alreadyMatchingItems) {
        cart.items[i].quantity += item.quantity;
      }
    } else {
      try {
        cart.items.add(CartItem.fromJson(item.toJson()));
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    emit(CartState(cart));
  }

  void updateQuantity(int index, int quantity) {
    Cart cart = state.cart;
    cart.items[index].quantity = quantity;
    emit(CartState(cart));
  }

  void removeItem(int index) {
    Cart cart = state.cart;
    cart.items.removeAt(index);
    emit(CartState(cart));
  }
}
