import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/direction.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/enums/up_text_direction.dart';
import 'package:flutter_up/models/up_radio_button_items.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_radio_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/product_attribute.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class CarProductAttributesWidget extends StatefulWidget {
  final Function onChange;
  final ProductAttribute currentProductAttribute;

  const CarProductAttributesWidget({
    super.key,
    required this.onChange,
    required this.currentProductAttribute,
  });

  @override
  State<CarProductAttributesWidget> createState() =>
      _CarProductAttributesWidgetState();
}

class _CarProductAttributesWidgetState
    extends State<CarProductAttributesWidget> {
  List<AttributeValue> attributeValues = [];
  List<Attribute> attributes = [];
  List<UpRadioButtonItem> radioValues = [];
  @override
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit, StoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          widget.currentProductAttribute;
          if (attributeValues.isEmpty) {
            if (state.attributeValues != null &&
                state.attributeValues!.isNotEmpty) {
              attributeValues = state.attributeValues!.toList();
            }
          }
          if (attributes.isEmpty) {
            if (state.attributes != null && state.attributes!.isNotEmpty) {
              attributes = state.attributes!.toList();
            }
          }
          if (radioValues.isEmpty) {
            for (var element
                in widget.currentProductAttribute.attributeValues) {
              if (attributeValues.any((e) => e.id == element)) {
                radioValues.add(UpRadioButtonItem(
                    value: element,
                    label: attributeValues
                        .where((e) => e.id == element)
                        .first
                        .name));
              }

              if (radioValues.isNotEmpty && radioValues.length == 1) {
                Map<String, dynamic> map = {
                  "${attributes.where((element) => element.id == widget.currentProductAttribute.attribute).first.id}":
                      radioValues.first.value
                };
                widget.onChange(map);
              }
            }
          }
          return radioValues.isNotEmpty
              ? SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: UpText(
                                "Select ${attributes.where((element) => element.id == widget.currentProductAttribute.attribute).first.name}",
                                type: UpTextType.heading5,
                              ),
                            ),
                            UpText(
                              widget.currentProductAttribute.mandatory
                                  ? "1 Required"
                                  : "Optional",
                              style: UpStyle(
                                textColor: UpConfig.of(context)
                                    .theme
                                    .primaryColor[200],
                              ),
                            ),
                          ],
                        ),
                        UpRadioButton(
                          direction: UpDirection.vertical,
                          onChange: (radioValue) {
                            Map<String, dynamic> map = {
                              "${attributes.where((element) => element.id == widget.currentProductAttribute.attribute).first.id}":
                                  radioValue
                            };
                            widget.onChange(map);
                          },
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
