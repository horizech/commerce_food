import 'package:flutter/material.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/models/restaurant.dart';
import 'package:shop/widgets/restaurant/restaurant_grid_item.dart';

class RestaurantGrid extends StatelessWidget {
  final List<Restaurant> restaurants;

  const RestaurantGrid({
    Key? key,
    required this.restaurants,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if ((restaurants).isEmpty) {
      return const Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: Center(
            child: UpText("No restaurant Available"),
          ),
        ),
      );
    } else {
      return Container(
        child: _allRestaurantGrid(context, restaurants),
      );
    }
  }
}

Widget _allRestaurantGrid(
  BuildContext context,
  List<Restaurant> restaurants,
) {
  return Padding(
    padding: const EdgeInsets.all(30.0),
    child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: restaurants
            .map(
              (e) => RestaurantGridItem(
                restaurant: e,
              ),
            )
            .toList()),
  );
}
