import '../../../core/usecases/constants.dart';
import 'package:flutter/material.dart';
import 'direct_messages_page.dart';
import 'package:get/get.dart';




class TabUsers extends StatefulWidget {
  final int initialIndex;
  const TabUsers({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _TabUsersState createState() => _TabUsersState();
}

class _TabUsersState extends State<TabUsers>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<TabUsers> {

  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _tabController = TabController(
      length: 2, vsync: this,
      initialIndex: widget.initialIndex,
    );
    super.initState();
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        title: Text('name_app'.tr,
          // style: GoogleFonts.roboto(
          //     color: Colors.white
          // ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text('messages'.tr,
                // style: GoogleFonts.notoSans(
                //   fontWeight: FontWeight.normal,
                // ),
              ),
            ),

            Tab(
              child: Text('activity'.tr,
                // style: GoogleFonts.notoSans(
                //   fontWeight: FontWeight.normal,
                // ),
              ),
            ),
          ]
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DirectMessagesPage(currentUser: userState.user!),
          SizedBox(),
          // const ActivityScreen(),
        ],
      ),
    );
  }
}
