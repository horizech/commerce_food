// import 'package:flutter/material.dart';

// import 'package:flutter_up/config/up_config.dart';

// import 'package:flutter_up/models/up_app_bar_item.dart';
// import 'package:flutter_up/widgets/up_app_bar.dart';

// class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
//   final String title;

//   const HomeAppBar({Key? key, required this.title})
//       : preferredSize = const Size.fromHeight(kToolbarHeight),
//         super(key: key);

//   @override
//   final Size preferredSize; // default is 56.0

//   @override
//   // ignore: library_private_types_in_public_api
//   _HomeAppBarState createState() => _HomeAppBarState();
// }

// class _HomeAppBarState extends State<HomeAppBar> {
//   UpAppBarItem _selectedItem = UpAppBarItem(); // The app's "state".

//   List<UpAppBarItem> _getUpAppBarItems() {
//     return <UpAppBarItem>[
//       UpAppBarItem(title: Constants.authLogout, icon: Icons.power_settings_new),
//     ];
//   }

//   @override
//   void initState() {
//     super.initState();
//     _selectedItem = _getUpAppBarItems()[0];
//   }

//   @override
//   void dispose() {
//     // Clean up the focus node when the Form is disposed.
//     _selectedItem = UpAppBarItem();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return UpAppBar(
//       title: widget.title,
//       actions: [
//         PopupMenuButton<UpAppBarItem>(
//           onSelected: _select,
//           itemBuilder: (BuildContext context) {
//             return _getUpAppBarItems().map((UpAppBarItem item) {
//               return PopupMenuItem<UpAppBarItem>(
//                   value: item,
//                   child: Row(children: [
//                     Icon(
//                       item.icon,
//                       color: UpConfig.of(context).theme.primaryColor.shade50,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
//                       child: Text(item.title ?? ""),
//                     )
//                   ]));
//             }).toList();
//           },
//         )
//       ],
//     );
//   }
// }
