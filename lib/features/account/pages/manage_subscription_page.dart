import 'package:popcorn/core/controllers/user/user_logic.dart';
import '../../../../../core/usecases/constants.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/widgets_helper/responsive_safe_area.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../../core/mobx/mobx_app.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';





class ManageSubscriptionPage extends StatefulWidget {
  const ManageSubscriptionPage({Key? key}) : super(key: key);

  @override
  State<ManageSubscriptionPage> createState() => _ManageSubscriptionPageState();
}

class _ManageSubscriptionPageState extends State<ManageSubscriptionPage> {



  final DateFormat timeFormat = DateFormat('dd MMM yyyy');
  final MobxApp _mobxApp = MobxApp();

  @override
  void initState() {
    _mobxApp.setIndexAction(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      color: Colors.white,
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text('manage_subscription'.tr,
              style: GoogleFonts.notoSans(
                fontWeight: FontWeight.bold,
                color: headlineColor,
                fontSize: 16,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GetBuilder<UserLogic>(
                  builder: (controller) {
                    return Column(
                      children: [

                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              // color: greyColor
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5)
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('current_plan'.tr,
                                    style: GoogleFonts.notoSans(
                                      fontWeight: FontWeight.bold,
                                      color: headlineColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text('free_trial'.tr,
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.notoSans(
                                        fontWeight: FontWeight.normal,
                                        color: headlineColor,
                                        fontSize: 15,
                                      ),
                                    )
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('time_period'.tr,
                                    style: GoogleFonts.notoSans(
                                      fontWeight: FontWeight.bold,
                                      color: headlineColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text('2week_free'.tr,
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.notoSans(
                                        fontWeight: FontWeight.normal,
                                        color: headlineColor,
                                        fontSize: 15,
                                      ),
                                    )
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      child: Material(
                                        borderRadius: BorderRadius.circular(12),
                                        // shadowColor: greyColor,
                                        // color: greyColor,
                                        elevation: 2.0,
                                        child: InkWell(
                                          onTap: () async {

                                          },
                                          child: Center(
                                            child: Text('unsubscribe'.tr.toUpperCase(),
                                              style: GoogleFonts.notoSans(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      child: Material(
                                        borderRadius: BorderRadius.circular(12),
                                        // shadowColor: blueAccentColor,
                                        // color: blueAccentColor,
                                        elevation: 2.0,
                                        child: InkWell(
                                          onTap: () async {
                                            // await stripeController.subscriptions(
                                            //     context, _mobxApp.indexAction??1);
                                          },
                                          child: Center(
                                            child: Text('subscribe'.tr.toUpperCase(),
                                              style: GoogleFonts.notoSans(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 0.5,
                                // color: greyColor,
                              ),
                              left: BorderSide(width: 0.5,
                                // color: greyColor,
                              ),
                              right: BorderSide(width: 0.5,
                                // color: greyColor,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 16),

                              Text('10_posts_day'.tr,
                                style: GoogleFonts.notoSans(
                                  fontWeight: FontWeight.bold,
                                  color: headlineColor,
                                  fontSize: 16,
                                ),
                              ),

                              Text('find_candidates_customers'.tr,
                                style: GoogleFonts.notoSans(
                                  fontWeight: FontWeight.normal,
                                  color: headlineColor,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 16),
                              Observer(
                                builder: (_) {
                                  return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _mobxApp.setIndexAction(0);
                                            },
                                            child: Container(
                                              height: 180,
                                              decoration: BoxDecoration(
                                                // color: _mobxApp.indexAction == 0 ?
                                                // Colors.orange.withOpacity(0.2) :
                                                // greyColor.withOpacity(0.2),
                                                // color: greyColor.withOpacity(0.2),
                                                // border: Border(
                                                //   top: BorderSide(width: 0.5, color: greyColor),
                                                //   bottom: BorderSide(width: 0.5, color: greyColor),
                                                // ),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text('${monthsText[0]}',
                                                      style: GoogleFonts.notoSans(
                                                        fontWeight: FontWeight.bold,
                                                        color: headlineColor,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    Text('${plansText[2]}',
                                                      style: GoogleFonts.notoSans(
                                                        fontWeight: FontWeight.bold,
                                                        color: headlineColor,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _mobxApp.setIndexAction(1);
                                            },
                                            child: Container(
                                              height: 180,
                                              decoration: BoxDecoration(
                                                // color: _mobxApp.indexAction == 1 ?
                                                // Colors.orange.withOpacity(0.2) :
                                                // greyColor.withOpacity(0.2),
                                                // color: Colors.orange.withOpacity(0.2),
                                                // border: Border.all(
                                                //     width: 0.5,
                                                //     color: greyColor
                                                // ),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text('${monthsText[1]}',
                                                      style: GoogleFonts.notoSans(
                                                        fontWeight: FontWeight.bold,
                                                        color: headlineColor,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    Text('${plansText[1]}',
                                                      style: GoogleFonts.notoSans(
                                                        fontWeight: FontWeight.bold,
                                                        color: headlineColor,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Text('save36'.tr,
                                                      style: GoogleFonts.notoSans(
                                                        fontWeight: FontWeight.normal,
                                                        color: headlineColor,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _mobxApp.setIndexAction(2);
                                            },
                                            child: Container(
                                              height: 180,
                                              decoration: BoxDecoration(
                                                // color: _mobxApp.indexAction == 2 ?
                                                // Colors.orange.withOpacity(0.2) :
                                                // greyColor.withOpacity(0.2),
                                                // border: Border(
                                                //   top: BorderSide(width: 0.5, color: greyColor),
                                                //   bottom: BorderSide(width: 0.5, color: greyColor),
                                                // ),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text('${monthsText[2]}',
                                                      style: GoogleFonts.notoSans(
                                                        fontWeight: FontWeight.bold,
                                                        color: headlineColor,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    Text('${plansText[0]}',
                                                      style: GoogleFonts.notoSans(
                                                        fontWeight: FontWeight.bold,
                                                        color: headlineColor,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]
                                  );
                                },
                              )
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
