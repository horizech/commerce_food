import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:shop/models/restaurant.dart';
import 'package:shop/widgets/appbar/food_appbar.dart';
import 'package:shop/widgets/restaurant/restaurant_grid.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Restaurant> restaurants = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UpConfig.of(context).theme.secondaryColor,
      ),
      child: Scaffold(
        appBar: FoodAppbar(),
        backgroundColor: Colors.transparent,
        key: scaffoldKey,
        drawerEnableOpenDragGesture: false,
        endDrawerEnableOpenDragGesture: false,
        body: BlocConsumer<StoreCubit, StoreState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.restaurants != null && state.restaurants!.isNotEmpty) {
              restaurants = state.restaurants!.toList();
            }

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Column(
                  children: [
                    RestaurantGrid(
                      restaurants: restaurants,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
