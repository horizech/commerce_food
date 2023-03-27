import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/enums/up_text_direction.dart';
import 'package:flutter_up/models/up_radio_button_items.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_radio_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/product_attribute.dart';
import 'package:shop/models/product_variation.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class VariedVariationsWidget extends StatefulWidget {
  final List<ProductVariation> productVariations;
  final ProductAttribute currentProductAttribute;
  final List<Attribute> attributes;
  final List<AttributeValue> attributeValues;
  final List<String> keys;
  final Function onChange;
  final Map<String, int> selectedvariation;

  const VariedVariationsWidget({
    super.key,
    required this.attributes,
    required this.attributeValues,
    required this.currentProductAttribute,
    required this.productVariations,
    required this.keys,
    required this.onChange,
    required this.selectedvariation,
  });

  @override
  State<VariedVariationsWidget> createState() => _VariedVariationsWidgetState();
}

class _VariedVariationsWidgetState extends State<VariedVariationsWidget> {
  List<UpRadioButtonItem> radioValues = [];
  List<int> keyValues = [];
  @override
  void initState() {
    super.initState();
    if (widget.keys.isNotEmpty) {
      if (widget.keys.any((element) =>
          element ==
          widget.attributes
              .where((element) =>
                  element.id == widget.currentProductAttribute.attribute)
              .first
              .name)) {
        for (var variation in widget.productVariations) {
          if (variation.options.isNotEmpty) {
            variation.options.forEach((key, value) {
              if (variation.options[widget.attributes
                      .where((element) =>
                          element.id ==
                          widget.currentProductAttribute.attribute)
                      .first
                      .name] !=
                  null) {
                if (widget.currentProductAttribute.attributeValues
                    .any((element) => element == value)) {
                  keyValues.add(value);
                }
              }
            });
          }
        }
        keyValues = keyValues.toSet().toList();

        if (keyValues.isNotEmpty) {
          initializeRadioButton();
        }
      }
    }
  }

  initializeRadioButton() {
    for (var element in keyValues) {
      if (widget.attributeValues.any((e) => e.id == element)) {
        radioValues.add(UpRadioButtonItem(
            value: element,
            label: widget.attributeValues
                .where((e) => e.id == element)
                .first
                .name));
      }
    }
  }

  setAvailableVariations() {
    List<ProductVariation> enabledVariation = [];
    enabledVariation = widget.productVariations
        .where((element) =>
            element.options["Size"] == widget.selectedvariation["Size"])
        .toList();

    // disabledVariation = widget.productVariations.where((element) {
    //   return mapCompare(
    //     element.options,
    //   );
    // }).toList();
    enabledVariation;
  }

  bool mapCompare(Map<String, int> options) {
    List<bool> allow = [];

    widget.selectedvariation.forEach((key, value) {
      if (options[key] == widget.selectedvariation[key]) {
        allow.add(true);
      }
    });

    return allow.every((element) => element == true) ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedvariation.isNotEmpty &&
        widget.selectedvariation[widget.attributes
                .where((element) =>
                    element.id == widget.currentProductAttribute.attribute)
                .first
                .name] ==
            null) {
      setAvailableVariations();
    }
    return BlocConsumer<StoreCubit, StoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          return radioValues.isNotEmpty && radioValues.length > 1
              ? SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: UpText(
                                  "Select ${widget.attributes.where((element) => element.id == widget.currentProductAttribute.attribute).first.name}",
                                  type: UpTextType.heading5,
                                ),
                              ),
                              UpText(
                                "1 Required",
                                style: UpStyle(
                                  textColor: UpConfig.of(context)
                                      .theme
                                      .primaryColor[200],
                                ),
                              ),
                            ],
                          ),
                        ),
                        UpRadioButton(
                          onChange: (radioValue) {
                            Map<String, int> map = {
                              widget.attributes
                                  .where((element) =>
                                      element.id ==
                                      widget.currentProductAttribute.attribute)
                                  .first
                                  .name: radioValue
                            };
                            widget.onChange(map);
                          },
                          initialValue: false,
                          items: radioValues,
                          labelDirection: UpTextDirection.right,
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox();
        });
  }
}
