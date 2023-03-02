import 'package:flutter/material.dart';
import 'package:flutter_up/enums/up_button_type.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/dialogs/add_edit_product_option_dialog.dart';
import 'package:shop/dialogs/add_edit_product_option_value_dialog.dart';
import 'package:shop/models/product_option_value.dart';
import 'package:shop/models/product_options.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';

class AddEditProductOptionsWidget extends StatefulWidget {
  final int? currentCollection;
  final Function? change;
  final Map<String, int>? options;
  const AddEditProductOptionsWidget(
      {Key? key, this.currentCollection, this.change, this.options})
      : super(key: key);

  @override
  State<AddEditProductOptionsWidget> createState() =>
      _AddEditProductOptionsWidgetState();
}

class _AddEditProductOptionsWidgetState
    extends State<AddEditProductOptionsWidget> {
  List<ProductOption>? productOptions;
  List<ProductOptionValue>? productOptionValues;
  Map<String, int> newOptions = {};

  //  product option value add dialog
  _productOptionValueAddDialog(ProductOption productOption) {
    if (widget.currentCollection != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AddEditProductOptionValueDialog(
            productOption: productOption,
            currentCollection: widget.currentCollection!,
          );
        },
      ).then((result) {
        if (result == "success") {
          getProductOptionValues();
        }
      });
    }
  }

  //  product option add dialog
  _productOptionAddDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AddEditProductOptionDialog(
          productOptions: productOptions,
          currentCollection: widget.currentCollection,
        );
      },
    ).then((result) {
      if (result == "success") {
        getProductOptions();
      }
    });
  }

//by api
  getProductOptions() async {
    List<ProductOption>? newProductOptions =
        await AddEditProductService.getProductOptions();

    if (newProductOptions != null && newProductOptions.isNotEmpty) {
      productOptions = newProductOptions;
      getProductOptionValues();
    } else {}
  }

  getProductOptionValues() async {
    List<ProductOptionValue>? newProductOptionsValues =
        await AddEditProductService.getProductOptionValues(
            widget.currentCollection, null);
    if (newProductOptionsValues != null && newProductOptionsValues.isNotEmpty) {
      productOptionValues = newProductOptionsValues;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.options != null && widget.options!.isNotEmpty) {
      widget.options!.forEach((key, value) {
        newOptions[key] = value;
      });
    }
    getProductOptions();
  }

  @override
  Widget build(BuildContext context) {
    return productOptions != null && productOptions!.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                //product option

                Row(
                  children: [
                    const UpText("Product Option"),
                    UpButton(
                      onPressed: () {
                        _productOptionAddDialog();
                      },
                      type: UpButtonType.icon,
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
                // product option values
                Visibility(
                  visible: productOptions != null &&
                      productOptions!.isNotEmpty &&
                      productOptionValues != null &&
                      productOptionValues!.isNotEmpty,
                  child: Wrap(
                    children: productOptions!.map(
                      (element) {
                        if (productOptionValues!
                            .any((v) => v.productOption == element.id)) {
                          return Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              ProductOptionDropdownWidget(
                                productOption: element,
                                productOptionValues: productOptionValues,
                                change: (value) {
                                  newOptions[element.name] = int.parse(value);
                                  if (widget.change != null) {
                                    widget.change!(newOptions);
                                  }
                                },
                                initialValue: widget.options != null &&
                                        widget.options![element.name] != null
                                    ? widget.options![element.name].toString()
                                    : null,
                              ),
                              UpButton(
                                onPressed: () {
                                  _productOptionValueAddDialog(element);
                                },
                                type: UpButtonType.icon,
                                child: const Icon(Icons.add),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    ).toList(),
                  ),
                ),
              ],
            ))
        : const UpCircularProgress();
  }
}

class ProductOptionDropdownWidget extends StatefulWidget {
  final List<ProductOptionValue>? productOptionValues;
  final ProductOption productOption;
  final Function? change;
  final String? initialValue;

  const ProductOptionDropdownWidget({
    Key? key,
    this.productOptionValues,
    required this.productOption,
    this.initialValue,
    this.change,
  }) : super(key: key);

  @override
  State<ProductOptionDropdownWidget> createState() =>
      _ProductOptionDropdownWidgetState();
}

class _ProductOptionDropdownWidgetState
    extends State<ProductOptionDropdownWidget> {
  String currentOption = "";
  List<ProductOptionValue>? oldProductOptionValues = [];
  List<UpLabelValuePair> productOptionDropdown = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() {
    widget.productOptionValues!
        .where((e) => e.productOption == widget.productOption.id)
        .forEach((element) {
      productOptionDropdown
          .add(UpLabelValuePair(label: element.name, value: "${element.id}"));
    });
    oldProductOptionValues = widget.productOptionValues;

    // in case of edit options not null
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      currentOption = widget.initialValue ?? productOptionDropdown.first.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.productOptionValues != oldProductOptionValues) {
      initialize();
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: productOptionDropdown.isNotEmpty,
        child: SizedBox(
          width: 200,
          child: UpDropDown(
            onChanged: ((value) => {
                  widget.change!(value),
                  // setState(() {}),
                }),
            value: currentOption,
            label: widget.productOption.name,
            itemList: productOptionDropdown,
          ),
        ),
      ),
    );
  }
}
