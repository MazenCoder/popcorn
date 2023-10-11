// import 'package:inoface_lescopains/features/settings/domain/usecases/feedback_mobx.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:inoface_lescopains/core/network/network_info.dart';
// import 'package:inoface_lescopains/core/util/flash_helper.dart';
// import 'package:inoface_lescopains/core/util/color_helper.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:mailer/smtp_server.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/material.dart';
// import 'package:mailer/mailer.dart';
// import 'dart:io';
//
//
//
// class SendFeedback extends StatelessWidget {
//
//   final TextEditingController _controller = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final FeedbackMobx _mobx = FeedbackMobx();
//   final String username = 'inoser.maroc@gmail.com';
//   final String password = 'Inoser123456';
//
//   File _image;
//
//   final attachArgs = 'attach';
//
//   List<String> listTopic = [
//     'title_feed1'.tr(),
//     'title_feed2'.tr(),
//     'title_feed3'.tr(),
//     'title_feed4'.tr(),
//     'title_feed5'.tr(),
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorHelper.COLOR_GREY,
//       appBar: AppBar(
//         title: Text('feedback'.tr()),
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           children: <Widget>[
//
//             Observer(
//               builder: (_) => Container(
//                 padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 16),
//                 child: DropdownButton<String>(
//                   hint: Text(_mobx.topic, style: TextStyle(
//                     fontSize: 20,
//                     color: ColorHelper.COLOR_BLACK,
//                   ),),
//                   isExpanded: true,
//                   iconSize: 30,
//                   underline: Container(
//                     height: 1.0,
//                     decoration: const BoxDecoration(
//                         border: Border(bottom: BorderSide(color: Colors.transparent, width: 0.0))
//                     ),
//                   ),
//                   items: listTopic.map((String value) {
//                     return new DropdownMenuItem<String>(
//                       value: value,
//                       child: new Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (val) => _mobx.selectTopic(val),
//                 ),
//               ),
//             ),
//
//             Container(
//               margin: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 16),
//               color: ColorHelper.COLOR_WITHE,
//               child: TextFormField(
//                 validator: (val) {
//                   if(val.isEmpty)
//                     return 'required_field'.tr();
//                   return null;
//                 },
//                 controller: _controller,
//                 minLines: 8,
//                 maxLines: 15,
//                 autocorrect: false,
//                 decoration: InputDecoration(
//                   hintText: 'msg_about_app'.tr(),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//                   focusedErrorBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//
//                   errorBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//                   fillColor: Colors.white,
//                 ),
//               ),
//             ),
//
//             new Container(
//               margin: const EdgeInsets.only(left: 20, right: 20),
//               padding: const EdgeInsets.only(top: 30),
//               child: new RaisedButton.icon(
//                 icon: Icon(MdiIcons.send),
//                 color: ColorHelper.COLOR_PINK[400],
//                 textColor: ColorHelper.COLOR_WITHE,
//                 label: Padding(
//                   padding: const EdgeInsets.only(top: 14, bottom: 14),
//                   child: Text('send'.tr()),
//                 ),
//                 onPressed: () async {
//                   if (await NetworkConn().isConnected) {
//                     if (_formKey.currentState.validate()) {
//                       final smtpServer = gmail(username, password);
//
//                       final message = Message()
//                         ..from = Address(username, 'Inoface Feedback')
//                         ..recipients.add('alareqimazen@gmail.com')
//                         //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
//                         //..bccRecipients.add(Address('bccAddress@example.com'))
//                         ..subject = '${_mobx.topic} :: 🛎️'
//                         ..text = 'Date time: ${DateTime.now()}.\nMessage: ${_controller.text}'
//                         ..html = "<p>Date time: ${DateTime.now()}</p>\n<p>Message: ${_controller.text}</p>";
//
//
//                       /*
//                       Iterable<Attachment> toAt(Iterable<String> attachments) =>
//                           (attachments ?? []).map((a) => FileAttachment(_image));
//
//                       final message = Message()
//                         ..from = Address(username, 'Inoface Feedback')
//                         ..recipients.add('alareqimazen@gmail.com')
//                         //..ccRecipients.addAll(['farid.elhouzia@gmail.com'])
//                         //..bccRecipients.add(Address('bccAddress@example.com'))
//                         ..subject = '${_mobx.topic} :: 🛎️'
//                         ..text = 'Date time: ${DateTime.now()}.\nMessage: ${_controller.text}'
//                         ..html = "<p>Date time: ${DateTime.now()}</p>\n<p>Message: ${_controller.text}</p>"
//                         ..attachments.addAll(toAt(attachArgs as Iterable<String>));
//                        */
//
//                       try {
//                         _controller.clear();
//                         final sendReport = await send(message, smtpServer);
//                         print('Message sent: ' + sendReport.toString());
//                         _controller.clear();
//                         FlashHelper.successBar(context, message: 'message_send'.tr());
//                       } on MailerException catch (e) {
//                         FlashHelper.errorBar(context, message: 'message_not_send'.tr());
//                         print("e --> $e");
//                         for (var p in e.problems) {
//                           print('Problem: ${p.code}: ${p.msg}');
//                         }
//                       }
//                     }
//                   } else {
//                     FlashHelper.errorBar(context, message: 'error_connection'.tr());
//                   }
//                 },
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(8.0),
//                   ),
//                 ),
//               ),
//             ),
//             new SizedBox(height: 16,),
//
//           ],
//         ),
//       ),
// //      floatingActionButton: FloatingActionButton(
// //        onPressed: () async {
// //          try {
// //
// //            RenderRepaintBoundary boundary = scr.currentContext.findRenderObject();
// //            var image = await boundary.toImage();
// //            var byteData = await image.toByteData(format: ImageByteFormat.png);
// //            var pngBytes = byteData.buffer.asUint8List();
// //            print(pngBytes);
// //
// //
// //            final pickedFile = await picker.getImage(source: ImageSource.gallery);
// //            print("path: ${pickedFile.path}");
// //            _image = File(pickedFile.path);
// //          } catch(e) {
// //            print(e);
// //          }
// //        },
// //      ),
//     );
//   }
// }