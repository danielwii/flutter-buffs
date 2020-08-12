import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:like_button/like_button.dart';

import 'images.dart';

class Avatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final Widget hint;
  final VoidCallback onTap;
  final String text;
  final bool isFollowed;
  final Future<bool> Function(bool isFollowed) onFollowClick;

  const Avatar(
      {Key key,
      @required this.imageUrl,
      this.size = 110,
      this.hint,
      this.onTap,
      this.text,
      this.isFollowed,
      this.onFollowClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onTap,
      child: Row(children: <Widget>[
        Container(
            width: size,
            height: size,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white30)),
            padding: const EdgeInsets.all(3.0),
            child: imageUrl == null || imageUrl.isEmpty
                ? hint ?? Icon(Icons.photo_camera, size: size * .618)
                : ClipOval(child: CachedImage(imageUrl))),
        if (text != null)
          Container(
              margin: EdgeInsets.only(left: 2),
              padding: EdgeInsets.only(left: 4, right: 0 /*onFollowClick == null ? 4 : 0*/),
              decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2)),
              child: Row(children: <Widget>[
                Text(text, style: TextStyle(color: Colors.white.withOpacity(.9))),
                if (onFollowClick != null)
                  LikeButton(
                      size: 24,
                      onTap: onFollowClick,
                      isLiked: isFollowed,
                      likeBuilder: (bool isLiked) => Icon(isLiked ? FontAwesome5.heart : FontAwesome5.plus_circle,
                          size: 16, color: isLiked ? Colors.red : Colors.white))
              ])),
      ]));
}
