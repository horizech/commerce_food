import 'package:flutter/material.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/restaurant.dart';
import 'package:shop/widgets/media/media_widget.dart';

class RestaurantGridItem extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantGridItem({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  State<RestaurantGridItem> createState() => _RestaurantGridItemState();
}

class _RestaurantGridItemState extends State<RestaurantGridItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation _animation;
  late Animation padding;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 275),
      vsync: this,
    );
    _animation = Tween(begin: 1.0, end: 1.2).animate(CurvedAnimation(
        parent: _controller, curve: Curves.ease, reverseCurve: Curves.easeIn));
    padding = Tween(begin: 0.0, end: -25.0).animate(CurvedAnimation(
        parent: _controller, curve: Curves.ease, reverseCurve: Curves.easeIn));
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10, bottom: 10.0, left: 8.0, right: 8.0),
      child: GestureDetector(
        onTap: () {
          ServiceManager<UpNavigationService>().navigateToNamed(
            Routes.products,
            queryParams: {
              'RestaurantId': '${widget.restaurant.id}',
            },
          );
        },
        child: SizedBox(
          width: 280,
          // height: 192,
          // decoration: BoxDecoration(
          //     color: Colors.white,
          //     border: Border.all(
          //       width: 4,
          //       color: const Color.fromRGBO(200, 16, 46, 1.0),
          //     ),
          //     borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MouseRegion(
                onEnter: (value) {
                  setState(() {
                    _controller.forward();
                  });
                },
                onExit: (value) {
                  setState(() {
                    _controller.reverse();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.zero,
                    ),
                    clipBehavior: Clip.hardEdge,
                    transform: Matrix4(
                        _animation.value,
                        0,
                        0,
                        0,
                        0,
                        _animation.value,
                        0,
                        0,
                        0,
                        0,
                        1,
                        0,
                        padding.value,
                        padding.value,
                        0,
                        1),
                    width: 280,
                    height: 192,
                    child: MediaWidget(
                      mediaId: 2,
                      onChange: () => {
                        ServiceManager<UpNavigationService>().navigateToNamed(
                          Routes.home,
                          queryParams: {
                            'RestaurantId': '${widget.restaurant.id}',
                          },
                        )
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 280,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.basic,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: UpText(
                            widget.restaurant.name,
                            style: UpStyle(textSize: 20),
                          ),
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            UpIcon(
                              icon: Icons.star,
                              style: UpStyle(
                                  iconColor: Colors.orange, iconSize: 16),
                            ),
                            UpText(
                              "${widget.restaurant.rating}/5",
                              style: UpStyle(textSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
