part of 'cart_cubit.dart';

class CartState {
  Cart cart = Cart();
  CartState(Cart? cart) {
    if (cart != null) {
      this.cart = cart;
    } else {
      this.cart = Cart();
      this.cart.items = [];
    }
  }
}
