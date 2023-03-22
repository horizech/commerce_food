import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_checkbox.dart';
import 'package:flutter_up/widgets/up_expansion_tile.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/product_attribute.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class ProductAttributeExpansionTile extends StatefulWidget {
  final int attributeId;
  final List<AttributeValue> attributeValues;
  final Function onChange;
  final int productId;
  final ProductAttribute? productAttribute;
  const ProductAttributeExpansionTile(
      {Key? key,
      required this.productId,
      required this.attributeId,
      required this.attributeValues,
      this.productAttribute,
      required this.onChange})
      : super(key: key);

  @override
  State<ProductAttributeExpansionTile> createState() =>
      _ProductAttributeExpansionTileState();
}

class _ProductAttributeExpansionTileState
    extends State<ProductAttributeExpansionTile> {
  bool isAll = false;
  List<bool> checkboxes = [];
  bool useForVariation = false;
  bool mandatory = false;
  List<Attribute> attributes = [];
  List<AttributeValue> attributeBasedValues = [];
  bool isLoading = false;
  ProductAttribute? oldProductAttribute;

  @override
  void initState() {
    super.initState();
    if (widget.attributeValues.isNotEmpty) {
      attributeBasedValues = widget.attributeValues
          .where((element) => element.attribute == widget.attributeId)
          .toList();

      if (attributeBasedValues.isNotEmpty) {
        for (var v in attributeBasedValues) {
          if (widget.productAttribute != null &&
              widget.productAttribute!.attributeValues
                  .any((element) => element == v.id)) {
            checkboxes.add(true);
          } else {
            checkboxes.add(false);
          }
        }
      }
    }

    if (widget.productAttribute != null &&
        widget.productAttribute!.id != null) {
      useForVariation = widget.productAttribute!.useForVariation;
      mandatory = widget.productAttribute!.mandatory;
    }
  }

  addProductAttribute() {
    List<int> attributeValueList = [];
    checkboxes.asMap().entries.forEach((element) {
      if (element.value == true) {
        attributeValueList.add(attributeBasedValues
            .asMap()
            .entries
            .where((v) => v.key == element.key)
            .map((e) => e.value.id!)
            .first);
      }
    });
    ProductAttribute newProductAttribute = ProductAttribute(
        product: widget.productId,
        attribute: widget.attributeId,
        attributeValues: attributeValueList,
        mandatory: mandatory,
        useForVariation: useForVariation,
        id: widget.productAttribute != null
            ? widget.productAttribute!.id
            : null);

    widget.onChange(newProductAttribute);
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
        }
        return SizedBox(
          width: 300,
          child: UpExpansionTile(
            expandedAlignment: Alignment.topLeft,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            title: attributes
                .where((element) => element.id == widget.attributeId)
                .first
                .name,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const UpText(
                    "Values",
                    type: UpTextType.heading6,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  UpCheckbox(
                    initialValue: isAll,
                    label: "All",
                    onChange: (value) {
                      isAll = value;
                      if (isAll) {
                        for (var element in checkboxes.asMap().entries) {
                          checkboxes[element.key] = true;
                        }
                      } else {
                        for (var element in checkboxes.asMap().entries) {
                          checkboxes[element.key] = false;
                        }
                      }
                      setState(() {});
                    },
                  ),
                  attributeBasedValues.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...attributeBasedValues
                                .asMap()
                                .entries
                                .map((e) => UpCheckbox(
                                      onChange: (value) {
                                        checkboxes[e.key] = value;
                                        setState(() {});
                                      },
                                      initialValue: checkboxes[e.key],
                                      label: widget.attributeValues
                                          .where((element) =>
                                              element.id == e.value.id)
                                          .first
                                          .name,
                                    ))
                                .toList(),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 15,
                  ),
                  const UpText(
                    "Configuration",
                    type: UpTextType.heading6,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  UpCheckbox(
                      initialValue: useForVariation,
                      label: "Use for variation",
                      onChange: (value) {
                        useForVariation = value;
                        setState(() {});
                      }),
                  const SizedBox(
                    height: 5,
                  ),
                  UpCheckbox(
                      initialValue: mandatory,
                      label: "Mandatory",
                      onChange: (value) {
                        mandatory = value;
                        setState(() {});
                      }),
                  const SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 100,
                      child: UpButton(
                        onPressed: () {
                          addProductAttribute();
                        },
                        text: "Save",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
