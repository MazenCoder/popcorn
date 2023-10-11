import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../core/usecases/constants.dart';
import 'package:popcorn/core/util/img.dart';
import '../../../core/usecases/enums.dart';
import 'package:flutter/material.dart';
import '../widgets/forums_room.dart';
import 'package:get/get.dart';



class AllRoomPage extends StatefulWidget {
  const AllRoomPage({Key? key}) : super(key: key);

  @override
  _AllRoomPageState createState() => _AllRoomPageState();
}

class _AllRoomPageState extends State<AllRoomPage>
    with AutomaticKeepAliveClientMixin<AllRoomPage> {


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      roomLogic.initNewRooms();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _user = userState.user!;
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 100,
              aspectRatio: 16/20,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1,
            ),
            items: [
              "https://image.freepik.com/free-vector/christmas-website-banner-with-decorations-snowflakes_1035-17010.jpg",
              "https://previews.123rf.com/images/foodandmore/foodandmore1510/foodandmore151000140/46001699-golden-christmas-gift-border-with-decorative-luxury-gifts-over-a-textured-gold-background-with-copys.jpg",
              "https://images.click.in/classifieds/images/124/05_05_2019_19_51_34_2f15b3eee227a3f32dfc8cd7f79af15f_98l257jhcf.jpeg",
            ].map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      width: size.width,
                      imageUrl: item,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Image.asset(IMG.defaultImg,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: SafeArea(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: TabBar(
                            tabs: [
                              Text("popular".tr),
                              Text("new".tr),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    ForumsRoom(
                      searchFrom: SearchFrom.messagesScreen,
                      descending: false,
                      isNew: false,
                      user: _user,
                    ),
                    ForumsRoom(
                      searchFrom: SearchFrom.messagesScreen,
                      descending: true,
                      isNew: false,
                      user: _user,
                    ),
                  ],
                ),
            ),
          ),
        )
      ],
    );
  }
}
