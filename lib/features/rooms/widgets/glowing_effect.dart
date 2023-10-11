import 'package:popcorn/packages/bottom_sheet/bottom_sheets/material_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/generateMaterialColor.dart';
import 'package:popcorn/core/usecases/constants.dart';
import 'package:popcorn/core/models/user_model.dart';
import 'package:popcorn/core/util/img.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mic_option_fit.dart';
import 'dart:developer';



class GlowingEffect extends StatefulWidget {
  final String roomId;
  final int index;
  const GlowingEffect({
    required this.roomId,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  State<GlowingEffect> createState() => _GlowingEffectState();
}

class _GlowingEffectState extends State<GlowingEffect>
    with SingleTickerProviderStateMixin<GlowingEffect>{

  late AnimationController glowingCircle;
  UserModel? _user;
  int? _hashCode;


  @override
  void initState() {
    super.initState();
    glowingCircle = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    glowingCircle.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final key = userState.user!.uniqueKey;
        if (roomState.speakers[key]?.isSpeaking??false) {
          return;
        } else if (_user != null && _user?.uid == userState.user?.uid) {
          // await roomState.engine.muteLocalAudioStream(true);
          // await roomState.engine.enableLocalAudio(false);
          roomLogic.setStateSpeaker(
            uid: userState.user!.uid,
            roomId: widget.roomId,
            state: false,
          );
          setState(() {
            _hashCode = null;
            _user = null;
          });
        } else {
          int? option = await showMaterialModalBottomSheet(
            expand: false, context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => const MicOptionFit(),
          );
          switch(option) {
            //Take mic
            case 1: {
              // await roomState.engine.muteLocalAudioStream(false);
              // await roomState.engine.enableLocalAudio(true);
              roomLogic.setStateSpeaker(
                uid: userState.user!.uid,
                roomId: widget.roomId,
                state: true,
              );
              setState(() {
                _hashCode = userState.user?.uniqueKey;
                _user = userState.user;
              });
              return;
            }
            //Lock mic
            case 2: {
              return;
            }
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_hashCode != null)
                    Obx(() {
                      double volume = roomState.speakers[_hashCode]?.volume ??0.0;
                      log('totalVolume: %$volume, $_hashCode');
                      return Stack (
                        children: [
                          ...List.generate(3, (index) {
                            return FadeTransition(
                              alwaysIncludeSemantics: false,
                              opacity: Tween<double>(begin: (_hashCode != null) ? volume : 0, end: 0.0)
                                  .animate(CurvedAnimation(parent: glowingCircle,
                                  curve: Interval(index * 0.2, (index * 0.2 + 0.6), curve: Curves.easeInOut))),
                              child: ScaleTransition(
                                scale: Tween<double>(begin: 1.0, end: 2.0)
                                    .animate(CurvedAnimation(parent: glowingCircle,
                                  curve: Interval(
                                    index * 0.2, (index * 0.2 + 0.6),
                                    curve: Curves.easeInOut,
                                  ),
                                ),
                                ),
                                child: Container(margin: const EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(75)
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    }),

                  if (_user?.displayName != null)
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: '${_user?.displayName}',
                        width: 48, height: 48,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          IMG.logo, width: 48, height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade400,
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.mic,
                          color: Colors.white,
                          size: 22
                        ),
                      ),
                    ),
                ],
              )
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 60,
            child: Text('${_user?.displayName??widget.index}',
              style: context.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
