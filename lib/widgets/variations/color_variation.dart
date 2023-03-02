import 'package:flutter/material.dart';

import 'package:shop/models/product_option_value.dart';
import 'package:shop/widgets/variations/variation_controller.dart';
import 'package:shop/widgets/variations/variation_selection_mode.dart';
import 'package:shop/extensions/color_extension.dart';

class ColorVariationWidget extends StatefulWidget {
  final List<ProductOptionValue>? colorVariations;
  final Function? onChange;
  final List<int>? selectedValues;
  final List<int>? disabledValues;
  final VariationSelectionMode mode;
  final VariationController? controller;

  const ColorVariationWidget(
      {Key? key,
      this.colorVariations,
      this.onChange,
      this.selectedValues,
      this.disabledValues,
      this.mode = VariationSelectionMode.choose,
      this.controller})
      : super(key: key);

  @override
  State<ColorVariationWidget> createState() => _ColorVariationWidgetState();
}

class _ColorVariationWidgetState extends State<ColorVariationWidget> {
  List<int> selectableVariations = [];
  List<int> currentSelections = [];
  List<int> newSelections = [];

  reset() {
    currentSelections.clear();
    newSelections.clear();
    debugPrint("reset");
    setState(() {
      currentSelections = [];
    });
  }

  changeSelection(int id) {
    if (widget.mode == VariationSelectionMode.cart) {
      return;
    }

    newSelections = [...currentSelections];
    bool needsUpdate = false;

    if (widget.mode == VariationSelectionMode.choose) {
      if (!currentSelections.contains(id)) {
        newSelections = [id];
        needsUpdate = true;
      }
    } else if (widget.mode == VariationSelectionMode.filter) {
      if (currentSelections.contains(id)) {
        newSelections.remove(id);
      } else {
        newSelections.add(id);
      }
      needsUpdate = true;
    }

    if (needsUpdate) {
      // changeSelection(entry.key, entry.value);
      widget.onChange!(newSelections);
      setState(() {
        currentSelections = newSelections;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller != null) {
      widget.controller!.reset = reset;
    }
    if (selectableVariations.isEmpty) {
      selectableVariations = (widget.mode == VariationSelectionMode.cart)
          ? widget.selectedValues ?? []
          : (widget.colorVariations ?? []).map((s) => s.id!).toList();
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            spacing: 5.0,
            runSpacing: 5.0,
            children: [
              Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                children: selectableVariations
                    .asMap()
                    .entries
                    .map(
                      (entry) => GestureDetector(
                        onTap: () {
                          changeSelection(entry.value);
                          // if (widget.disabledValues == null ||
                          //     !widget.disabledValues!.contains(entry.value)) {
                          //   changeSelection(entry.value);
                          // }
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: (widget.selectedValues ??
                                              currentSelections)
                                          .contains(entry.value)
                                      ? Theme.of(context).primaryColor
                                      : (widget.disabledValues != null &&
                                              widget.disabledValues!
                                                  .contains(entry.value))
                                          ? Colors.grey
                                          : Colors.grey,
                                  width: 2,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: FractionallySizedBox(
                                  heightFactor:
                                      0.9, // Adjust those two for the white space
                                  widthFactor: 0.9,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: widget.colorVariations!
                                          .firstWhere((element) =>
                                              element.id == entry.value)
                                          .name
                                          .toColor(),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (widget.disabledValues != null &&
                                widget.disabledValues!.contains(entry.value))
                              const Positioned(
                                  child: Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 30,
                              ))
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
