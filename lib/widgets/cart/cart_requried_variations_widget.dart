import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/enums/up_text_direction.dart';
import 'package:flutter_up/models/up_radio_button_items.dart';
import 'package:flutter_up/widgets/up_radio_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/product_attribute.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class RequriedVariationsWidget extends StatefulWidget {
  final ProductAttribute currentProductAttribute;

  const RequriedVariationsWidget(
      {super.key, required this.currentProductAttribute});

  @override
  State<RequriedVariationsWidget> createState() =>
      _RequriedVariationsWidgetState();
}

class _RequriedVariationsWidgetState extends State<RequriedVariationsWidget> {
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
              radioValues.add(UpRadioButtonItem(
                  value: attributeValues
                      .where((e) => e.id == attributeValues.first.id),
                  label: attributeValues
                      .where((e) => e.id == element)
                      .first
                      .name));
            }
          }
          return Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: UpText(
                      "Select ${attributes.where((element) => element.id == widget.currentProductAttribute.attribute).first.name}",
                      type: UpTextType.heading5,
                    ),
                  ),
                  UpRadioButton(
                    items: radioValues,
                    labelDirection: UpTextDirection.right,
                  )
                ],
              ),
            ),
          );
        });
  }
}
