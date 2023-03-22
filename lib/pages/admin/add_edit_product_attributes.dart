import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:apiraiser/apiraiser.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_attribute.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/widgets/product_attributes/product_attributes_expansion_tile.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class AddEditProductAttributes extends StatefulWidget {
  final Product currentProduct;
  const AddEditProductAttributes({
    Key? key,
    required this.currentProduct,
  }) : super(key: key);

  @override
  State<AddEditProductAttributes> createState() =>
      _AddEditProductAttributesState();
}

class _AddEditProductAttributesState extends State<AddEditProductAttributes> {
  List<Attribute> attributes = [];
  List<ProductAttribute> productAttributes = [];
  List<AttributeValue> attributeValues = [];
  List<UpLabelValuePair> attributesDropdown = [];
  String currentAttribute = "";
  List<int> selectedAttributes = [];

  @override
  void initState() {
    super.initState();
    getProductAttribute();
  }

  getProductAttribute() async {
    productAttributes =
        await AddEditProductService.getProductAttributes() ?? [];
    if (productAttributes.isNotEmpty) {
      productAttributes = productAttributes
          .where((element) => element.product == widget.currentProduct.id)
          .toList();

      if (selectedAttributes.isEmpty) {
        getSelectedAttributes();
      }
      setState(() {});
    }
  }

  addEditProductAttribute(ProductAttribute newProductAttribute) async {
    APIResult? result = await AddEditProductService.addEditProductAttribute(
        data: newProductAttribute.toJson(newProductAttribute),
        proAttributeId:
            newProductAttribute.id != null ? newProductAttribute.id! : null);
    if (result != null && result.success) {
      showUpToast(context: context, text: result.message ?? "");
      getProductAttribute();
    } else if (result == null) {
      showUpToast(context: context, text: result!.message ?? "");
    }
  }

  getSelectedAttributes() {
    selectedAttributes = [];
    if (productAttributes.isNotEmpty) {
      for (var element in productAttributes) {
        selectedAttributes.add(element.attribute);
      }
    }
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit, StoreState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (attributes.isEmpty) {
          if (state.attributes != null && state.attributes!.isNotEmpty) {
            attributes = state.attributes!.toList();
          }
          if (attributes.isNotEmpty) {
            for (var attribute in attributes) {
              attributesDropdown.add(UpLabelValuePair(
                  label: attribute.name, value: "${attribute.id}"));
            }
          }
        }

        if (attributeValues.isEmpty) {
          if (state.attributeValues != null &&
              state.attributeValues!.isNotEmpty) {
            attributeValues = state.attributeValues!.toList();
          }
        }

        return Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: SizedBox(
                    width: 300,
                    child: Visibility(
                      visible: attributesDropdown.isNotEmpty,
                      child: UpDropDown(
                        label: "Attribute",
                        value: currentAttribute,
                        itemList: attributesDropdown,
                        onChanged: (value) {
                          currentAttribute = value ?? "";
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 100,
                  child: UpButton(
                    onPressed: () {
                      if (currentAttribute.isNotEmpty) {
                        if (selectedAttributes.isEmpty) {
                          selectedAttributes.add(int.parse(currentAttribute));
                        } else if ((selectedAttributes.isNotEmpty &&
                            selectedAttributes.every(
                              (element) =>
                                  element != int.parse(currentAttribute),
                            ))) {
                          selectedAttributes.add(int.parse(currentAttribute));
                        } else {
                          showUpToast(
                              context: context,
                              text: "Product Attribute already exists");
                        }
                        setState(() {});
                      }
                    },
                    text: "Add",
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            selectedAttributes.isNotEmpty
                ? Column(
                    children: selectedAttributes
                        .map(
                          (e) => ProductAttributeExpansionTile(
                            attributeId: e,
                            productId: widget.currentProduct.id!,
                            onChange: (newProductAttribute) {
                              addEditProductAttribute(newProductAttribute);
                            },
                            attributeValues: attributeValues,
                            productAttribute: productAttributes.isNotEmpty &&
                                    productAttributes.any((proAttribute) =>
                                        proAttribute.attribute == e)
                                ? productAttributes
                                    .where((element) => element.attribute == e)
                                    .first
                                : null,
                          ),
                        )
                        .toList(),
                  )
                : const SizedBox()
          ],
        );
      },
    );
  }
}
