import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/dialogs/delete_dialog.dart';
import 'package:shop/is_user_admin.dart';
import 'package:shop/models/keyword.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/widgets/app_bars/admin_appbar.dart';
import 'package:shop/widgets/drawers/nav_drawer.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class AdminKeywords extends StatefulWidget {
  const AdminKeywords({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminKeywords> createState() => _AdminKeywordsState();
}

class _AdminKeywordsState extends State<AdminKeywords> {
  List<Keyword> keywords = [];
  TextEditingController nameController = TextEditingController();
  Keyword selectedKeyword = const Keyword(name: "", id: -1);
  @override
  void initState() {
    super.initState();
  }

  getKeywords() async {
    keywords = await AddEditProductService.getKeywords();
    setState(() {});
  }

  _updateKeyword(Keyword? k) async {
    Keyword keyword = Keyword(
      name: nameController.text,
    );
    APIResult? result = await AddEditProductService.addEditkeyword(
        data: Keyword.toJson(keyword), keywordId: k != null ? k.id! : null);
    if (result != null && result.success) {
      showUpToast(
        context: context,
        text: result.message ?? "",
      );
      getKeywords();
    } else {
      showUpToast(
        context: context,
        text: "An Error Occurred",
      );
    }
  }

  _deleteKeyword(int keywordId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DeleteDialog();
      },
    ).then((result) async {
      if (result == "success") {
        APIResult? result =
            await AddEditProductService.deleteKeyword(keywordId);
        if (result != null && result.success) {
          showUpToast(context: context, text: result.message ?? "");
          selectedKeyword = const Keyword(name: "", id: -1);
          nameController.text = "";
          getKeywords();
        } else {
          showUpToast(
            context: context,
            text: "An Error Occurred",
          );
        }
      }
    });
  }

  Widget leftSide() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        color: Colors.grey[200],
        width: 300,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            GestureDetector(
                onTap: (() {
                  selectedKeyword = const Keyword(name: "", id: -1);
                  nameController.text = selectedKeyword.name;

                  setState(() {});
                }),
                child: Container(
                  color: selectedKeyword.id == -1
                      ? UpConfig.of(context).theme.primaryColor[100]
                      : Colors.transparent,
                  child: const ListTile(
                    title: UpText("Create a new keyword"),
                  ),
                )),
            ...keywords
                .map(
                  (e) => GestureDetector(
                    onTap: (() {
                      selectedKeyword = e;
                      nameController.text = selectedKeyword.name;
                      setState(() {});
                    }),
                    child: Container(
                      color: selectedKeyword.id == e.id
                          ? UpConfig.of(context).theme.primaryColor[100]
                          : Colors.transparent,
                      child: ListTile(
                        title: UpText(e.name),
                      ),
                    ),
                  ),
                )
                .toList()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppbar(),
      drawer: const NavDrawer(),
      body: isUserAdmin()
          ? BlocConsumer<StoreCubit, StoreState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (keywords.isEmpty) {
                  if (state.keywords != null && state.keywords!.isNotEmpty) {
                    keywords = state.keywords!.toList();
                  }
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        leftSide(),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20,
                            top: 10,
                          ),
                          child: SizedBox(
                            width: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: UpText(
                                      "Keyword",
                                      type: UpTextType.heading5,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 300,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: 300,
                                          child: UpTextField(
                                            controller: nameController,
                                            label: 'Name',
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Visibility(
                                            visible: selectedKeyword.id != -1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: 70,
                                                height: 30,
                                                child: UpButton(
                                                  onPressed: () {
                                                    _deleteKeyword(
                                                        selectedKeyword.id!);
                                                  },
                                                  text: "Delete",
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: 70,
                                              height: 30,
                                              child: UpButton(
                                                onPressed: () {
                                                  _updateKeyword(
                                                      selectedKeyword.id != -1
                                                          ? selectedKeyword
                                                          : null);
                                                },
                                                text: "Save",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const UnAuthorizedWidget(),
    );
  }
}
