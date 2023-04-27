import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/is_user_admin.dart';
import 'package:shop/models/role.dart';
import 'package:shop/models/user.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/widgets/app_bars/admin_appbar.dart';
import 'package:shop/widgets/drawers/nav_drawer.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class AdminUserRoles extends StatefulWidget {
  const AdminUserRoles({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminUserRoles> createState() => _AdminUserRolesState();
}

class _AdminUserRolesState extends State<AdminUserRoles> {
  List<UpLabelValuePair> rolesDropdown = [];
  List<UpLabelValuePair> usersDropdown = [];
  String currentUser = "", currentRole = "";

  @override
  void initState() {
    super.initState();
    getRoles();
  }

  getRoles() async {
    List<Role> roles = await AddEditProductService.getRoles();
    if (roles.isNotEmpty) {
      for (var element in roles) {
        rolesDropdown
            .add(UpLabelValuePair(label: element.name, value: "${element.id}"));
      }
      getUser();
    }
  }

  getUser() async {
    List<User1> users = await AddEditProductService.getUser();
    if (users.isNotEmpty) {
      for (var element in users) {
        usersDropdown.add(
            UpLabelValuePair(label: element.username, value: "${element.id}"));
      }
      setState(() {});
    }
  }

  _updateRole() async {
    if (currentRole.isNotEmpty && currentUser.isNotEmpty) {
      Map<String, dynamic> map = {
        "User": int.parse(currentUser),
        "Role": int.parse(currentRole),
      };
      APIResult? result = await AddEditProductService.addRole(map);
      if (result != null && result.success) {
        showUpToast(
          context: context,
          text: result.message ?? "",
        );
      } else {
        showUpToast(
          context: context,
          text: "An Error Occurred",
        );
      }
    } else {
      showUpToast(
        context: context,
        text: "Select all values",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppbar(),
      drawer: const NavDrawer(),
      body: isUserAdmin()
          ? rolesDropdown.isNotEmpty && usersDropdown.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: UpText(
                            "Update User role",
                            type: UpTextType.heading6,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: UpDropDown(
                            value: currentUser,
                            itemList: usersDropdown,
                            label: "User",
                            onChanged: (value) => {
                              currentUser = value ?? "",
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: UpDropDown(
                            value: currentRole,
                            itemList: rolesDropdown,
                            label: "Roles",
                            onChanged: (value) => {
                              currentRole = value ?? "",
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: UpButton(
                            onPressed: () {
                              _updateRole();
                            },
                            text: "Update",
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : const UpCircularProgress()
          : const UnAuthorizedWidget(),
    );
  }
}
