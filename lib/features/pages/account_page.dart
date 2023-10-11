import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/generateMaterialColor.dart';
import 'package:popcorn/core/util/img.dart';
import 'package:flutter/material.dart';



class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: greyColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(IMG.background),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: size.height/8),
                    Container(
                      // height: size.width / 3,
                      padding: const EdgeInsets.only(left: 23, right: 8),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: ClipOval(
                              child: Container(
                                color: Colors.grey,
                                width: size.width / 3,
                                height: size.width / 3,
                                child: Center(
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    height: size.width - 240,
                                    width: size.width - 240,
                                    imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvxDrCR5SfO2zzeBNLF9U9xbjlC8-ToAA68g&usqp=CAU",
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) {
                                      return const Center(
                                        child: Text('M',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 50,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // right: -5,
                            right: 120,
                            bottom: 2,
                            child: SizedBox(
                              height: 21,
                              width: 21,
                              child: Material(
                                  type: MaterialType.transparency,
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: primaryColor, width: 2),
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(1000.0),
                                      child: const Center(
                                        // child: Icon(
                                        //   Icons.add,
                                        //   size: 16.0,
                                        //   color: Colors.white,
                                        // ),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: const [
                        Text('Mazen Coder',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text('ID: 323537115',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {  },
                      child: const Text('Visitors\n0',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {  },
                      child: const Text('Followers\n0',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {  },
                      child: const Text('Following\n0',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
