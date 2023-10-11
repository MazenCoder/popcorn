import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/models/message_model.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/widgets_helper/widgets.dart';
import 'full_screen_image.dart';
import 'package:intl/intl.dart';
import 'heart_anime.dart';
import 'dart:async';



class MessageBubble extends StatefulWidget {
  final Chat chat;
  final Message message;
  final UserModel user;
  const MessageBubble({
    Key? key,
    required this.chat,
    required this.message,
    required this.user,
  }) : super(key: key);

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _isLiked = false;
  bool _heartAnim = false;

  @override
  void initState() {
    _isLiked = widget.message.isLiked;
    super.initState();
  }

  _likeUnLikeMessage(String currentUserId) {
    appUtils.likeUnlikeMessage(
        widget.message, widget.chat.id, !_isLiked, widget.user, currentUserId);
    setState(() => _isLiked = !_isLiked);

    if (_isLiked) {
      setState(() {
        _heartAnim = true;
      });

      Timer(const Duration(milliseconds: 350), () {
        setState(() {
          _heartAnim = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('E, h:mm a', 'en_US');
    final bool isMe = widget.message.senderId == userState.user?.uid;

    int receiverIndex = widget.chat.memberInfo.indexWhere((member) => member.uid == widget.message.receiverId);
    int senderIndex   = widget.chat.memberInfo.indexWhere((member) => member.uid != widget.message.receiverId);

    _buildText() {
      return GestureDetector(
        onDoubleTap: widget.message.senderId == userState.user?.uid
            ? null : () => _likeUnLikeMessage(userState.user!.uid),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Text(widget.message.text??'',
            style: TextStyle(
              color: isMe ?
              primaryColor :
              Colors.white,
              fontSize: 15.0,
            ),
          ),
        ),
      );
    }

    _imageFullScreen(url) {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => FullScreenImage(url),
        ),
      );
    }

    _buildImage(BuildContext context) {
      final size = MediaQuery.of(context).size;
      return GestureDetector(
        onDoubleTap: widget.message.senderId == userState.user!.uid
            ? null : () => _likeUnLikeMessage(userState.user!.uid),
        onTap: () => _imageFullScreen(widget.message.imageUrl),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: size.height * 0.4,
              width: size.width * 0.6,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Theme.of(context).colorScheme.secondary),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Hero(
                  tag: widget.message.imageUrl??const Uuid().v4(),
                  child: CachedNetworkImage(
                    progressIndicatorBuilder: (context, url, downloadProgress) {
                      return Center(
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                        ),
                      );
                    },
                    fadeInDuration: const Duration(milliseconds: 500),
                    imageUrl: widget.message.imageUrl??const Uuid().v4(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            _heartAnim ? const HeartAnime(size: 80.0) : const SizedBox.shrink(),
          ],
        ),
      );
    }

    _buildGiphy(BuildContext context) {
      final size = MediaQuery.of(context).size;
      return GestureDetector(
        onDoubleTap: widget.message.senderId == userState.user?.uid
            ? null : () => _likeUnLikeMessage(userState.user!.uid),
        // onTap: () => _imageFullScreen(widget.message.giphyUrl),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: size.height * 0.3,
              width: size.width * 0.6,
              decoration: BoxDecoration(
                border:
                    Border.all(width: 1, color: Theme.of(context).colorScheme.secondary),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Hero(
                  // tag: widget.message.giphyUrl,
                  tag: 'message_bubble',
                  child: CachedNetworkImage(
                    progressIndicatorBuilder: (context, url, downloadProgress) {
                      return Center(
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                        ),
                      );
                    },
                    fadeInDuration: const Duration(milliseconds: 500),
                    imageUrl: widget.message.imageUrl??const Uuid().v4(),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            _heartAnim ? const HeartAnime(size: 80.0,) : const SizedBox.shrink(),
          ],
        ),
      );
    }

    Padding _buildLikeIcon() {
      return Padding(
        padding: isMe
            ? const EdgeInsets.only(left: 10)
            : const EdgeInsets.only(right: 10),
        child: GestureDetector(
          onTap: widget.message.senderId == userState.user!.uid
              ? null
              : () => _likeUnLikeMessage(userState.user!.uid),
          child: Icon(
            widget.message.isLiked ? Icons.favorite : Icons.favorite_border,
            color: widget.message.isLiked ? Colors.red : Colors.grey[400],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: !isMe
                    ? const EdgeInsets.only(right: 40.0)
                    : const EdgeInsets.only(left: 40.0),
                child: Text(isMe ?
                (widget.message.timestamp != null) ?
                timeFormat.format(widget.message.timestamp.toDate()) : '' :
                '${getUsername(user: widget.chat.memberInfo[senderIndex])}'
                    '\n${timeFormat.format(widget.message.timestamp.toDate())}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
              const SizedBox(height: 6.0),
              Row(
                children: [
                  // if (!isMe) _buildLikeIcon(),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65,
                    ),
                    decoration: BoxDecoration(
                      color: widget.message.text != null
                          ? isMe
                          ? Theme.of(context).cardColor
                          : Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      border: Border.all(
                          color: widget.message.text != null ? isMe
                              ? primaryColor
                              : Theme.of(context).cardColor
                              : Colors.transparent,
                      ),
                    ),
                    child: widget.message.text != null
                        ? _buildText()
                        : widget.message.imageUrl != null
                            ? _buildImage(context)
                            : _buildGiphy(context),
                  ),
                  // if (isMe) _buildLikeIcon()
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
