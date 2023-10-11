import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import '../../../core/theme/generateMaterialColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../core/widgets_helper/widgets.dart';
import '../../../core/models/message_model.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/util/flash_helper.dart';
import '../../navigation/navigation_app.dart';
import '../../../core/models/chat_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/mobx/mobx_app.dart';
import '../widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import '../widgets/user_badges.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'dart:developer';
import 'dart:async';
import 'dart:io';



class ChatScreenPage extends StatefulWidget {
  final UserModel receiverUser;
  final UserModel currentUser;
  const ChatScreenPage({
    Key? key,
    required this.receiverUser,
    required this.currentUser,
  }) : super(key: key);
  @override
  _ChatScreenPageState createState() => _ChatScreenPageState();
}

class _ChatScreenPageState extends State<ChatScreenPage> {
  final TextEditingController _messageController = TextEditingController();
  final SpeechToText speech = SpeechToText();
  late List<UserModel> _memberInfo;
  final MobxApp _mobx = MobxApp();
  final picker = ImagePicker();
  late List<String> _userIds;
  bool _isChatExist = false;
  bool _isLoading = false;
  Chat? _chat;

  //! SpeechToText
  List<LocaleName> _localeNames = [];
  String _currentLocaleId = 'en_US';
  double maxSoundLevel = -50000;
  double minSoundLevel = 50000;
  bool _hasSpeech = false;
  String lastStatus = '';
  String lastWords = '';
  String lastError = '';
  // double level = 0.0;

  @override
  void initState() {
    super.initState();
    _setupChat();
    _initSpeechState();
    // utilsController.seIgnoreNotify(
    //   val: widget.receiverUser.uid,
    // );
  }

  void onEnd() {
    if (widget.currentUser.role.contains('user')) {
      Get.offAll(() => const NavigationApp());
    }
  }

  _setupChat() async {
    // try {
      _isLoading = true;
      List<String> userIds = [];
      userIds.add(widget.currentUser.uid);
      userIds.add(widget.receiverUser.uid);

      List<UserModel> users = [];
      users.add(widget.currentUser);
      users.add(widget.receiverUser);

      Chat? chat = await chatLogic.getChatByUsers(userIds);

      bool isChatExist = chat != null;

      if (isChatExist) {
        chatLogic.setChatRead(
          chat: chat,
          read: true,
        );

        Chat chatWithMemberInfo = Chat(
          id: chat.id,
          memberInfo: users,
          memberIds: chat.memberIds,
          readStatus: chat.readStatus,
          recentSender: chat.recentSender,
          // acceptStatus: chat.acceptStatus,
          recentMessage: chat.recentMessage,
          recentTimestamp: chat.recentTimestamp,
        );

        setState(() {
          _chat = chatWithMemberInfo;
        });
      }

      setState(() {
        _isChatExist = isChatExist;
        _memberInfo = users;
        _userIds = userIds;
        _isLoading = false;
      });
    // } catch (e) {
    //   logger.e('$e');
    // }
  }

  Future<void> _initSpeechState() async {
    log('Initialize');
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: true,
      );
      if (hasSpeech) {
        // Get the list of languages installed on the supporting platform so they
        // can be displayed in the UI for selection by the user.
        _localeNames = await speech.locales();

        var systemLocale = await speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }

      if (!mounted) return;

      setState(() {
        _hasSpeech = hasSpeech;
      });
      log('hasSpeech: $_hasSpeech');
    } catch (e) {
      setState(() {
        lastError = 'Speech recognition failed: ${e.toString()}';
        _hasSpeech = false;
      });
    }
  }

  void startListening() {
    log('start listening');
    lastWords = '';
    lastError = '';
    // Note that `listenFor` is the maximum, not the minimun, on some
    // recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
    speech.listen(
        onResult: resultListener,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    log('Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    _messageController.text = result.recognizedWords;
    _mobx.setComposingMessage(_messageController.text.isNotEmpty);
  }

  void soundLevelListener(double level) {
    minSoundLevel = math.min(minSoundLevel, level);
    maxSoundLevel = math.max(maxSoundLevel, level);
    _mobx.setLevel(level);
  }

  void stopListening() {
    log('stop');
    speech.stop();
    _mobx.setLevel(0.0);
  }

  void cancelListening() {
    log('cancel');
    speech.cancel();
    _mobx.setLevel(0.0);
    startListening();
  }

  void errorListener(SpeechRecognitionError error) {
    log('Received error status: $error, listening: ${speech.isListening}');
    lastError = '${error.errorMsg} - ${error.permanent}';
    if (!speech.isListening) {
      _mobx.setLevel(0.0);
    }
  }

  void statusListener(String status) {
    log('Received listener status: $status, listening: ${speech.isListening}');
    lastStatus = status;
    if (!speech.isListening) {
      _mobx.setLevel(0.0);
    }
  }

  Future<void> _createChat(userIds) async {
    Chat chat = await chatLogic.createChat(_memberInfo, userIds);
    setState(() {
      _chat = chat;
      _isChatExist = true;
    });
  }

  @override
  void dispose() {
    // utilsController.seIgnoreNotify(val: null);
    if (_chat != null) {
      chatLogic.setChatRead(chat: _chat!, read: true);
    }
    super.dispose();
  }

  Container _buildMessageTF() {
    return Container(
        padding: const EdgeInsets.only(left: 3, right: 3),
        margin: const EdgeInsets.only(left: 5, right: 5, bottom: 8),
        decoration: BoxDecoration(
          // border: Border.all(color: Theme.of(context).colorScheme),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Observer(
          builder: (_) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 38,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.lightBlue[400],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () async {
                      if (networkState.isConnected) {
                        final pickedFile = await picker.pickImage(source: ImageSource.camera);
                        if (pickedFile != null) {
                          File imageFile = File(pickedFile.path);
                          String? imageUrl = await chatLogic.uploadMessageImage(imageFile);
                          _sendMessage(text: null, imageUrl: imageUrl, giphyUrl: null);
                        }
                      } else {
                        FlashHelper.errorBar(context: context, message: 'error_connection'.tr);
                      }
                    },
                  ),
                ),
                Expanded(
                  child: TextField(
                    minLines: 1,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    textAlign: TextAlign.start,
                    controller: _messageController,
                    onChanged: (messageText) {
                      _mobx.setComposingMessage(messageText.isNotEmpty);
                    },
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: 'message'.tr,
                    ),
                  ),
                ),
                /*
                Observer(
                  builder: (_) {
                    return Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: .26,
                            spreadRadius: _mobx.level * 0.8,
                            color: primaryColor.withOpacity(.3),
                          )
                        ],
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.mic),
                        onPressed: !_hasSpeech || speech.isListening ? cancelListening : startListening,
                      ),
                    );
                  },
                ),
                */
                if (!_mobx.isComposingMessage)
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 0),
                          width: 30.0,
                          child: IconButton(
                            icon: const Icon(Icons.photo),
                            onPressed: () async {
                              final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                              if (pickedFile != null) {
                                File imageFile = File(pickedFile.path);
                                String? imageUrl = await chatLogic.uploadMessageImage(imageFile);
                                _sendMessage(text: null, imageUrl: imageUrl, giphyUrl: null);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_mobx.isComposingMessage)
                  GestureDetector(
                    onTap: (_mobx.isComposingMessage && !_mobx.isSending)
                        ? () => _sendMessage(
                              text: _messageController.text.trim(),
                              imageUrl: null,
                              giphyUrl: null,
                            )
                        : null,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'send'.tr,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
              ],
            );
          },
        ),
    );
  }

  _sendMessage({String? text, String? imageUrl, String? giphyUrl}) async {
    if ((text != null && text.trim().isNotEmpty) || imageUrl != null || giphyUrl != null) {
      _mobx.setSending(true);

      if (!_isChatExist) {
        await _createChat(_userIds);
      }

      if (imageUrl == null && giphyUrl == null) {
        _messageController.clear();
        _mobx.setComposingMessage(false);
      }

      Message message = Message(
        id: const Uuid().v4(),
        receiverId: widget.receiverUser.uid,
        senderId: widget.currentUser.uid,
        timestamp: FieldValue.serverTimestamp(),
        imageUrl: imageUrl,
        isLiked: false,
        text: text,
      );

      chatLogic.sendChatMessage(
        chat: _chat!,
        message: message,
        receiverUser: widget.receiverUser,
      );
      _mobx.setSending(false);
    }
  }

  _buildMessagesStream() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          chatsRef.doc(_chat!.id).collection('messages').orderBy('timestamp', descending: true).limit(20).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        return Expanded(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              physics: const AlwaysScrollableScrollPhysics(),
              reverse: true,
              children: _buildMessageBubbles(snapshot),
            ),
          ),
        );
      },
    );
  }

  List<MessageBubble> _buildMessageBubbles(AsyncSnapshot<QuerySnapshot> messages) {
    List<MessageBubble> messageBubbles = [];

    for (var doc in messages.data?.docs ?? []) {
      Message message = Message.fromDoc(doc);
      MessageBubble messageBubble = MessageBubble(
        user: message.senderId == widget.currentUser.uid ? widget.currentUser : widget.receiverUser,
        chat: _chat!,
        message: message,
      );
      messageBubbles.removeWhere((msgBbl) => message.id == msgBbl.message.id);
      messageBubbles.add(messageBubble);
    }
    return messageBubbles;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_chat != null) {
          chatLogic.setChatRead(chat: _chat!, read: true);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                // onTap: () => Get.to(() => UserProfilePage(user: widget.receiverUser)),
                child: chatCircleAvatar(widget.receiverUser),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                // onTap: () => Get.to(() => UserProfilePage(user: widget.receiverUser)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.receiverUser.displayName,
                      maxLines: 1,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StreamBuilder<DocumentSnapshot>(
                          stream: iamonlineRef.doc(widget.receiverUser.uid).snapshots(),
                          builder: (context, snapOnline) {
                            switch (snapOnline.connectionState) {
                              case ConnectionState.waiting:
                                return const SizedBox.shrink();
                              default:
                                return checkOnline(
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontSize: 11,
                                    height: 1,
                                  ),
                                );
                            }
                          },
                        ),
                        UserBadges(
                          user: widget.receiverUser,
                          color: backgroundColor,
                          size: 15,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        // backgroundColor: buttonTextColor,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (_isChatExist && !_isLoading) _buildMessagesStream(),
              if (!_isChatExist && _isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              if (!_isChatExist && !_isLoading) const SizedBox.shrink(),
              _buildMessageTF(),
            ],
          ),
        ),
      ),
    );
  }
}
