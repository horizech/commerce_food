import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/models/up_row.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_table.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/product_detail.dart';
import 'package:shop/services/product_detail_service.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class AdminProductvariationsPage extends StatelessWidget {
  final Map<String, String>? queryParams;

  const AdminProductvariationsPage({
    Key? key,
    this.queryParams,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user;
    int? productId;
    if (queryParams != null &&
        queryParams!.isNotEmpty &&
        queryParams!['productId'] != null &&
        queryParams!['productId']!.isNotEmpty) {
      productId = int.parse(queryParams!['productId']!);
    }
    user ??= Apiraiser.authentication.getCurrentUser();

    return Scaffold(
      body: user != null &&
              user.roleIds != null &&
              (user.roleIds!.contains(2) || user.roleIds!.contains(1))
          ? BlocConsumer<StoreCubit, StoreState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Visibility(
                  visible: productId != null && productId > 0,
                  child: FutureBuilder<ProductDetail?>(
                      future:
                          ProductDetailService.getProductDetail(productId ?? 0),
                      builder: (BuildContext context,
                          AsyncSnapshot<ProductDetail?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.hasData &&
                                  snapshot.data != null &&
                                  snapshot.data!.product != null &&
                                  snapshot.data!.product!.isVariedProduct ==
                                      true
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: UpText(
                                          "Product: ${snapshot.data!.product!.name}",
                                          type: UpTextType.heading5,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: UpButton(
                                          text: "Add Product Variation",
                                          onPressed: () {
                                            ServiceManager<
                                                    UpNavigationService>()
                                                .navigateToNamed(
                                              Routes.addEditProductVariaton,
                                              queryParams: {
                                                'productId':
                                                    '${snapshot.data!.product!.id}',
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      snapshot.data!.productVariations != null
                                          ? Visibility(
                                              visible: snapshot.data!
                                                      .productVariations !=
                                                  null,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: UpTable(
                                                    onSelectChanged: (index) =>
                                                        {
                                                      if (snapshot.data !=
                                                              null &&
                                                          snapshot.data!
                                                                  .productVariations !=
                                                              null)
                                                        {
                                                          ServiceManager<
                                                                  UpNavigationService>()
                                                              .navigateToNamed(
                                                            Routes
                                                                .addEditProductVariaton,
                                                            queryParams: {
                                                              'productId':
                                                                  '${snapshot.data!.product!.id}',
                                                              'productVariationId':
                                                                  '${snapshot.data!.productVariations![index].id}',
                                                            },
                                                          ),
                                                        }
                                                    },
                                                    columns: const [
                                                      "Id",
                                                      "Name",
                                                      "Price",
                                                      "Options",
                                                    ],
                                                    rows: [
                                                      ...snapshot.data!
                                                          .productVariations!
                                                          .map(
                                                        (e) => UpRow(
                                                          [
                                                            SizedBox(
                                                              child: UpText(
                                                                e.id.toString(),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              child: UpText(
                                                                e.name
                                                                    .toString(),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              child: UpText(
                                                                e.price
                                                                    .toString(),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              child: UpText(
                                                                e.options
                                                                    .toString(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ))
                              : const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: UpText(
                                      "isVarried product : False",
                                    ),
                                  ),
                                );
                        } else {
                          return const UpCircularProgress();
                        }
                      }),
                );
              },
            )
          : const UnAuthorizedWidget(),
    );
  }
}
