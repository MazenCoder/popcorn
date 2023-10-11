// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:rawaj/features/chat/widgets/user_badges.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rawaj/core/models/account_model.dart';
// import 'package:rawaj/core/usecases/constants.dart';
// import 'package:rawaj/core/util/image_helper.dart';
// import 'package:rawaj/core/usecases/themes.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
//
//
//
// class SearchScreen extends StatefulWidget {
//   final SearchFrom searchFrom;
//   final File imageFile;
//   SearchScreen({@required this.searchFrom, this.imageFile});
//
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   TextEditingController _searchController = TextEditingController();
//   Future<QuerySnapshot> _users;
//   String _searchText = '';
//
//   ListTile _buildUserTile(AccountModel user) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: Colors.grey,
//         radius: 20.0,
//         backgroundImage: (user.photoURL != null && user.photoURL.isNotEmpty)
//             ? CachedNetworkImageProvider(user.photoURL)
//             : AssetImage(IMG.USER_PLACEHOLDER),
//       ),
//       title: Row(
//         children: [Text(user.username), UserBadges(user: user, size: 15)],
//       ),
//       trailing: widget.searchFrom == SearchFrom.createStoryScreen
//           ? FlatButton(
//               child: Text(
//                 'send'.tr(),
//                 style: kFontSize18TextStyle.copyWith(color: Colors.white),
//               ),
//               color: Colors.blue,
//               onPressed: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => ChatScreen(
//                       receiverUser: user,
//                       imageFile: widget.imageFile,
//                     ),
//                   ),
//                 ),
//               },
//             )
//           : SizedBox.shrink(),
//       onTap: widget.searchFrom == SearchFrom.homeScreen
//           ? () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => ProfileScreen(
//                     goToCameraScreen: () =>
//                         CustomNavigation.navigateToHomeScreen(
//                             context,
//                             Provider.of<UserData>(context, listen: false)
//                                 .currentUserId,
//                             initialPage: 0),
//                     isCameFromBottomNavigation: false,
//                     userId: user.id,
//                     currentUserId: Provider.of<UserData>(context, listen: false)
//                         .currentUserId,
//                   ),
//                 ),
//               )
//           : widget.searchFrom == SearchFrom.messagesScreen
//               ? () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => ChatScreen(
//                         receiverUser: user,
//                         imageFile: widget.imageFile,
//                       ),
//                     ),
//                   )
//               : null,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String _currentUserId = Provider.of<UserData>(context).currentUserId;
//     void _clearSearch() {
//       WidgetsBinding.instance
//           .addPostFrameCallback((_) => _searchController.clear());
//       setState(() {
//         _users = null;
//         _searchText = '';
//       });
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: TextField(
//           controller: _searchController,
//           decoration: InputDecoration(
//             focusedBorder: InputBorder.none,
//             enabledBorder: InputBorder.none,
//             contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
//             border: InputBorder.none,
//             hintText: 'Search for a user...',
//             prefixIcon: Icon(
//               Icons.search,
//               color: Theme.of(context).accentColor.withOpacity(0.6),
//               size: 30.0,
//             ),
//             suffixIcon: _searchText.trim().isEmpty
//                 ? null
//                 : IconButton(
//                     color: Theme.of(context).accentColor.withOpacity(0.6),
//                     icon: Icon(Icons.clear),
//                     onPressed: _clearSearch,
//                   ),
//             // filled: true,
//           ),
//           onChanged: (value) {
//             setState(() {
//               _searchText = value;
//             });
//           },
//           onSubmitted: (input) {
//             if (input.trim().isNotEmpty) {
//               setState(() {
//                 _users = DatabaseService.searchUsers(input);
//               });
//             }
//           },
//         ),
//       ),
//       body: _users == null
//           ? Center(
//               child: Text('Search for a user'),
//             )
//           : FutureBuilder(
//               future: _users,
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//                 if (snapshot.data.documents.length == 0) {
//                   return Center(
//                     child: Text('No Users found! Please try again.'),
//                   );
//                 }
//                 return ListView.builder(
//                     itemCount: snapshot.data.documents.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       User user = User.fromDoc(snapshot.data.documents[index]);
//                       // Prevent current user to send messages to himself
//                       return (widget.searchFrom != SearchFrom.homeScreen &&
//                               user.id == _currentUserId)
//                           ? SizedBox.shrink()
//                           : _buildUserTile(user);
//                     });
//               },
//             ),
//     );
//   }
// }
