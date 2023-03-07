import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/models/up_row.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/widgets/up_table.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/collection.dart';
import 'package:shop/models/product.dart';
import 'package:shop/services/products_service.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class AdminProducts extends StatefulWidget {
  const AdminProducts({Key? key}) : super(key: key);

  @override
  State<AdminProducts> createState() => _AdminProductsState();
}

class _AdminProductsState extends State<AdminProducts> {
  User? user;
  List<int>? selectedCollection;
  String currentCollection = "";
  List<UpLabelValuePair> collectionDropdown = [];
  List<Collection> collections = [];
  bool isAuthorized = false;
  @override
  void initState() {
    super.initState();
    user ??= Apiraiser.authentication.getCurrentUser();
    if (user != null && user!.roleIds != null) {
      if (user!.roleIds!.contains(2) || user!.roleIds!.contains(1)) {
        isAuthorized = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isAuthorized
          ? BlocConsumer<StoreCubit, StoreState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state.collections != null) {
                  collections = state.collections!.toList();
                }
                if (collectionDropdown.isEmpty) {
                  collectionDropdown.add(
                    UpLabelValuePair(label: "All", value: "-1"),
                  );
                  if (collections.isNotEmpty) {
                    for (var c in collections) {
                      collectionDropdown.add(
                          UpLabelValuePair(label: c.name, value: "${c.id}"));
                    }
                  }
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            width: 200,
                            child: UpDropDown(
                              label: "Collection",
                              value: currentCollection,
                              itemList: collectionDropdown,
                              onChanged: (value) {
                                currentCollection = value.toString();

                                if (value != null && value != "-1") {
                                  selectedCollection = [int.parse(value)];
                                } else {
                                  selectedCollection = null;
                                }
                                setState(() {});
                              },
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UpButton(
                            text: "Add Product",
                            onPressed: () {
                              ServiceManager<UpNavigationService>()
                                  .navigateToNamed(
                                Routes.addEditProduct,
                                queryParams: {},
                              );
                            }),
                      ),
                      FutureBuilder<List<Product>>(
                        future: ProductService.getProducts(
                            selectedCollection, {}, null, "", {}),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Product>> snapshot) {
                          return snapshot.hasData && snapshot.data != null
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: UpTable(
                                    onSelectChanged: (index) => {
                                      if (snapshot.data != null &&
                                          snapshot.data!.isNotEmpty)
                                        {
                                          ServiceManager<UpNavigationService>()
                                              .navigateToNamed(
                                            Routes.addEditProduct,
                                            queryParams: {
                                              'productId':
                                                  '${snapshot.data![index].id}',
                                            },
                                          ),
                                        }
                                    },
                                    columns: const [
                                      "Id",
                                      "Name",
                                      "Price",
                                      'IsVariedProduct',
                                    ],
                                    rows: [
                                      ...snapshot.data!.map(
                                        (e) => UpRow(
                                          [
                                            SizedBox(
                                              child: UpText(
                                                e.id.toString(),
                                              ),
                                            ),
                                            SizedBox(
                                              child: UpText(
                                                e.name.toString(),
                                              ),
                                            ),
                                            SizedBox(
                                              child: UpText(
                                                e.price.toString(),
                                              ),
                                            ),
                                            SizedBox(
                                              child: UpText(
                                                e.isVariedProduct.toString(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const Center(
                                  child: UpCircularProgress(),
                                );
                        },
                      ),
                    ],
                  ),
                );
              })
          : const UnAuthorizedWidget(),
    );
  }
}
