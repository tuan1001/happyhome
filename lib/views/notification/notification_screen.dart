// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:rcore/utils/r-layout/sub_layout.dart';

// import '../../utils/r-text/title.dart';
// import '../../utils/r-text/type.dart';

// class NotificationScreen extends StatefulWidget {
//   final ReceivedNotification? receivedNotification;
//   const NotificationScreen({
//     super.key,
//     this.receivedNotification,
//   });

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

//   bool showDemo = true;

//   @override
//   Widget build(BuildContext context) {
//     return RSubLayout(
//       globalKey: globalKey,
//       showBottomNavBar: false,
//       title: 'Thông báo',
//       backgroundColor: const Color.fromRGBO(235, 235, 237, 1),
//       contenPadding: EdgeInsets.zero,
//       body: [
//         showDemo != true
//             ? const Align(
//                 child: RText(title: 'HIện chưa có thông báo nào', type: RTextType.title),
//               )
//             : Container(
//                 // margin: EdgeInsets.zero,
//                 margin: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: const Color.fromRGBO(235, 235, 237, 1),
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 child: Column(
//                   children: [
//                     ...List.generate(
//                         10,
//                         (index) => Container(
//                               padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
//                               margin: EdgeInsets.zero,
//                               decoration: BoxDecoration(
//                                 color: const Color.fromRGBO(254, 254, 254, 1),
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: index == 0 ? const Radius.circular(10) : Radius.zero,
//                                   topRight: index == 0 ? const Radius.circular(10) : Radius.zero,
//                                   bottomLeft: index == 9 ? const Radius.circular(10) : Radius.zero,
//                                   bottomRight: index == 9 ? const Radius.circular(10) : Radius.zero,
//                                 ),
//                               ),
//                               child: Row(
//                                 // mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     margin: const EdgeInsets.only(top: 6, right: 5),
//                                     alignment: Alignment.topLeft,
//                                     width: 30,
//                                     child: Column(
//                                       children: [Image.asset('lib/assets/images/main-logo.png')],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: MediaQuery.of(context).size.width - 80,
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             const RText(
//                                               title: 'Thông báo',
//                                               type: RTextType.subtitle,
//                                             ),
//                                             const Spacer(),
//                                             PopupMenuButton(
//                                               elevation: 0,
//                                               padding: EdgeInsets.zero,
//                                               itemBuilder: (context) => [
//                                                 const PopupMenuItem(
//                                                   child: Text('Xóa'),
//                                                 ),
//                                               ],
//                                               child: const Icon(FontAwesomeIcons.ellipsis),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 2),
//                                         const RText(
//                                           title:
//                                               'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
//                                         ),
//                                         Row(
//                                           children: [
//                                             const Text('Loại thông báo - ', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
//                                             RText(
//                                               title: '10/10/2021',
//                                               type: RTextType.label,
//                                               color: Colors.grey.shade600,
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 5),
//                                         const Divider(height: 0),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ))
//                   ],
//                 ),
//               ),
//       ],
//     );
//   }
// }
