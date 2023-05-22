import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/enums/up_button_type.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:shop/dialogs/add_edit_keyword_dialog.dart';
import 'package:shop/models/keyword.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class AddEditKeywordWidget extends StatefulWidget {
  final List<int>? keywordList;
  final Function? change;
  const AddEditKeywordWidget({
    Key? key,
    required this.keywordList,
    this.change,
  }) : super(key: key);

  @override
  State<AddEditKeywordWidget> createState() => _AddEditKeywordWidgetState();
}

class _AddEditKeywordWidgetState extends State<AddEditKeywordWidget> {
  List<Keyword> keywords = [];
  List<UpLabelValuePair> keywordsDropdown = [];
  String? currentKeyword;
  List<String> selectedKeywords = [];
  _keywordsAddDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AddEditKeywordDialog();
      },
    ).then((result) {
      if (result == "success") {
        getKeywords();
      }
    });
  }

//by api
  getKeywords() async {
    keywords = await AddEditProductService.getKeywords();

    if (keywords.isNotEmpty) {
      _initalizeDropdown();
    }
  }

  _initalizeDropdown() {
    keywordsDropdown.clear();
    if (keywords.isNotEmpty) {
      for (var k in keywords) {
        keywordsDropdown.add(UpLabelValuePair(label: k.name, value: "${k.id}"));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.keywordList != null && widget.keywordList!.isNotEmpty) {
      for (var element in widget.keywordList!) {
        selectedKeywords.add("$element");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit, StoreState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (keywords.isEmpty) {
          if (state.keywords != null && state.keywords!.isNotEmpty) {
            keywords = state.keywords!.toList();
          }
          _initalizeDropdown();
        }

        return keywords.isNotEmpty && keywordsDropdown.isNotEmpty
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: keywordsDropdown.isNotEmpty,
                    child: SizedBox(
                      width: 200,
                      child: UpDropDown(
                        isMultipleSelect: true,
                        onMultipleChanged: ((value) => {
                              if (widget.change != null)
                                {
                                  widget.change!(value),
                                }
                            }),
                        values: selectedKeywords,
                        label: "Keyword",
                        itemList: keywordsDropdown,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: UpButton(
                      onPressed: () {
                        _keywordsAddDialog();
                      },
                      type: UpButtonType.icon,
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              )
            : const SizedBox();
      },
    );
  }
}
