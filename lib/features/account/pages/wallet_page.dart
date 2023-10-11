import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:popcorn/core/widgets_helper/responsive_safe_area.dart';
import '../../../core/theme/generateMaterialColor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:popcorn/core/util/img.dart';
import 'package:flutter/material.dart';
import 'manage_subscription_page.dart';
import 'package:get/get.dart';



class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {

  // PaymentMethod _paymentMethod;

  @override
  void initState() {

    super.initState();
  }


  int calcRanks(ranks) {
    double multiplier = .5;
    return (multiplier * ranks).round();
  }

  Future<String?> startPay(BuildContext context, double costPrice) async {
    try {
      /*
      StripePayment.setStripeAccount(null);
      await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest()).then((paymentMethod) {
        _paymentMethod = paymentMethod;
        print('Received ${paymentMethod.id}');
      }).catchError((setError) {
        Get.snackbar(
          'oops'.tr,
          'payment_cancelled'.tr,
          backgroundColor: Colors.white,
          icon: Icon(MdiIcons.wifiRemove, color: Colors.red[300]),
          shouldIconPulse: true,
          barBlur: 20,
          isDismissible: true,
          duration: Duration(seconds: 4),
        );
        print('Error $setError');
        return null;
      });
      if (_paymentMethod?.id != null && costPrice > 0) {
        return await appUtils.startDirectCharge(context, _paymentMethod, costPrice);
      }
      */
      return null;
    } catch(e) {
      print('$e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: goldColor,
      child: ResponsiveSafeArea(
        builder: (_) => Container(
          // color: goldColor,
          child: Scaffold(
            // backgroundColor: greyColor,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ClipPath(
                    clipper: OvalBottomBorderClipper(),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Positioned(
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage(
                                  IMG.coins,
                                ),
                              ),
                            ),
                            height: 70,
                            width: 70,
                          ),
                        ),
                        Container(
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // gradient: LinearGradient(
                            //   begin: FractionalOffset.bottomCenter,
                            //   end: FractionalOffset.topCenter,
                              // colors: [
                              //   goldColor.withOpacity(0.0),
                              //   goldColor,
                              // ],
                              // stops: [
                              //   0.0,
                              //   1.0
                              // ],
                            // ),
                          ),
                        ),
                      ],
                    )
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                    child: InkWell(
                      onTap: () => Get.to(() => ManageSubscriptionPage()),
                      child: Row(
                        children: [
                          SvgPicture.asset(IMG.coinSvg,
                            width: 30, height: 30,
                          ),
                          SizedBox(width: 3,),
                          Text('100',
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 25
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          Container(
                            height: 35.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(40),
                              // shadowColor: goldColor,
                              // color: goldColor,
                              elevation: 2.0,
                              child: InkWell(
                                onTap: () async {
                                  await startPay(context, 1);
                                },
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: Text('USD 0.99'.tr,
                                      style: GoogleFonts.lato(
                                        fontWeight: FontWeight.bold,
                                        // color: goldColor.shade800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                    child: Row(
                      children: [
                        SvgPicture.asset(IMG.coinSvg,
                          width: 30, height: 30,
                        ),
                        SizedBox(width: 3,),
                        Text('1,000',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 25
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Container(
                          height: 35.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(40),
                            // shadowColor: goldColor,
                            // color: goldColor,
                            elevation: 2.0,
                            child: InkWell(
                              onTap: () async {

                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: Text('USD 8.99'.tr,
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      // color: goldColor.shade800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                    child: Row(
                      children: [
                        SvgPicture.asset(IMG.coinSvg,
                          width: 30, height: 30,
                        ),
                        SizedBox(width: 3,),
                        Text('5,000',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 25
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Container(
                          height: 35.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(40),
                            // shadowColor: goldColor,
                            // color: goldColor,
                            elevation: 2.0,
                            child: InkWell(
                              onTap: () async {

                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: Text('USD 43.99'.tr,
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      // color: goldColor.shade800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                    child: Row(
                      children: [
                        SvgPicture.asset(IMG.coinSvg,
                          width: 30, height: 30,
                        ),
                        SizedBox(width: 3,),
                        Text('12,000',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 25
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Container(
                          height: 35.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(40),
                            // shadowColor: goldColor,
                            // color: goldColor,
                            elevation: 2.0,
                            child: InkWell(
                              onTap: () async {

                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: Text('USD 99.99'.tr,
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      // color: goldColor.shade800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                    child: Row(
                      children: [
                        SvgPicture.asset(IMG.coinSvg,
                          width: 30, height: 30,
                        ),
                        SizedBox(width: 3,),
                        Text('50,000',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 25
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Container(
                          height: 35.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(40),
                            // shadowColor: goldColor,
                            // color: goldColor,
                            elevation: 2.0,
                            child: InkWell(
                              onTap: () async {
                                await startPay(context, 400);
                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: Text('USD 399.99'.tr,
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      // color: goldColor.shade800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Contact Us',
                        style: GoogleFonts.lato(
                          color: Colors.white54,
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(Icons.arrow_forward_ios,
                        size: 12, color: Colors.white54,
                      )
                    ],
                  ),
                  SizedBox(height: 16,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
