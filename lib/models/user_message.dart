import 'package:flutter/material.dart';

class UserMessage {
  final String userName;
  final String avatarUrl;
  final String message;
  final MessageType messageType;
  final Color? messageColor;

  UserMessage({
    required this.userName,

    required this.message,
    required this.messageType,
    this.avatarUrl = '',
    this.messageColor = Colors.white,
  });
}

enum MessageType {
  userEnter,
  userMuted,
  userTiped,
  userSend,
  coursePurchased,
  chatMessage,
  anchorMessage,
}

/**
 * 获取用户消息列表
 * 这里可以根据实际需求从服务器获取数据
 */
List<UserMessage> getUserMessages() {
  return [
    UserMessage(
      userName: '晴天',
      avatarUrl: 'assets/images/avatar.jpg',
      message: '进来了',
      messageType: MessageType.userEnter,
    ),
    UserMessage(
      userName: '雪天',
      avatarUrl: 'assets/images/avatar.jpg',
      message: '已被禁言了',
      messageType: MessageType.userMuted,
    ),
    UserMessage(
      userName: '雨天',
      avatarUrl: 'assets/images/avatar.jpg',
      message: '赠送了',
      messageType: MessageType.userSend,
      messageColor: Color(0xFFFAB100),
    ),
    UserMessage(
      userName: '雨天',
      avatarUrl: 'assets/images/avatar.jpg',
      message: '购买课程',
      messageType: MessageType.coursePurchased,
      messageColor: Color(0xFF9F94FF),
    ),
    UserMessage(
      userName: '雨天',
      avatarUrl: 'assets/images/avatar.jpg',
      message: '打赏了',
      messageType: MessageType.userTiped,
      messageColor: Color(0xFFE7525A),
    ),
    UserMessage(
      userName: '雨天',
      avatarUrl: 'assets/images/avatar.jpg',
      message: '我来咯',
      messageType: MessageType.chatMessage,
    ),
    UserMessage(
      userName: '主播昵称',
      avatarUrl: 'assets/images/avatar.jpg',
      message: '大家伙们好',
      messageType: MessageType.anchorMessage,
    ),
  ];
  
}
