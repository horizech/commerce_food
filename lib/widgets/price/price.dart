import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

class PriceWidget extends StatelessWidget {
  final double? price;
  final double? discountPrice;
  final DateTime? discountStartDate;
  final DateTime? discountEndDate;

  const PriceWidget(
      {Key? key,
      this.price,
      this.discountPrice,
      this.discountStartDate,
      this.discountEndDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return price != null
        ? checkDisocunt(discountStartDate, discountEndDate)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${getDiscountPercentage(price, discountPrice).toString()}% discount",
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price.toString(),
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.red,
                          decorationStyle: TextDecorationStyle.solid,
                          decorationThickness: 3,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        discountPrice.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Align(alignment: Alignment.topLeft, child: Text(price.toString()))
        : const Text("");
  }
}

// to check if there is discount or not
checkDisocunt(DateTime? discountStartDate, DateTime? disountEndDate) {
  bool isDiscount = false;
  // DateTime startDate = DateTime.parse(service_start_date);
  // DateTime endDate = DateTime.parse(service_end_date);

  DateTime currentDate = DateTime.now();
  if (discountStartDate != null && disountEndDate != null) {
    if (discountStartDate.isBefore(currentDate) &&
        disountEndDate.isAfter(currentDate)) {
      isDiscount = true;
    }
  }
  return isDiscount;
}

getDiscountPercentage(double? price, double? discountPrice) {
  double percentage = 0;
  if (price != null && discountPrice != null) {
    percentage = 100 - ((discountPrice / price) * 100);
  }
  return percentage.ceilToDouble();
}

getPrice(Product product) {
  double? price = 0;
  bool isDisocunt =
      checkDisocunt(product.discountStartDate, product.discountEndDate);
  if (isDisocunt) {
    price = product.discounPrice;
  } else {
    price = product.price;
  }
  return price;
}
