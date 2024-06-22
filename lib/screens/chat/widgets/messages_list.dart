import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../models/message.dart';
import '../../../utils/common/enums/message_type.dart';
import '../../../utils/common/enums/swipe_direction.dart';
import '../../../utils/common/providers/reply_message_provider.dart';
import '../controllers/chat_controller.dart';
import '../../../utils/common/providers/current_user_provider.dart';
import '../../../utils/common/widgets/loader.dart';
import 'message_card.dart';

class MessagesList extends ConsumerStatefulWidget {
  const MessagesList({
    Key? key,
    required this.uId,
    required this.isGroupChat,
  }) : super(key: key);

  final String uId;
  final bool isGroupChat;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessagesListState();
}

class _MessagesListState extends ConsumerState<MessagesList> {
  late final ScrollController _messagesScrollController;

  @override
  void initState() {
    super.initState();
    _messagesScrollController = ScrollController();
  }

  @override
  void dispose() {
    _messagesScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: widget.isGroupChat
          ? ref
          .watch(chatControllerProvider)
          .getGroupMessagesList(groupId: widget.uId)
          : ref
          .watch(chatControllerProvider)
          .getMessagesList(receiverUserId: widget.uId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Loader();
        }

        // adding callback to new message to scroll to bottom.
        SchedulerBinding.instance?.addPostFrameCallback(
              (_) => _messagesScrollController.animateTo(
            _messagesScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear,
          ),
        );

        return ListView.builder(
          controller: _messagesScrollController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            Message message = snapshot.data![index];

            final bool isSenderUser =
                message.senderUserId == ref.read(currentUserProvider!).uid;

            // setting message seen for receiver
            if (!message.isSeen &&
                message.receiverUserId == ref.read(currentUserProvider!).uid) {
              ref.read(chatControllerProvider).setChatMessageSeen(
                context,
                receiverUserId: widget.uId,
                messageId: message.messageId,
              );
            }

            return MessageCard(
              key: Key(message.messageId),
              isSender: isSenderUser,
              message: message.lastMessage,
              messageType: message.messageType,
              isSeen: message.isSeen,
              time: DateFormat.Hm().format(message.time),
              swipeDirection:
              isSenderUser ? SwipeDirection.left : SwipeDirection.right,
              repliedText: message.repliedMessage,
              repliedMessageType: message.repliedMessageType,
              username: message.repliedTo,
              onSwipe: (details) => _onSwipeMessage(
                message: message.lastMessage,
                isMe: isSenderUser,
                messageType: message.messageType,
                isSender: isSenderUser,
              ),
            );
          },
        );
      },
    );
  }

  void _onSwipeMessage({
    required String message,
    required bool isMe,
    required MessageType messageType,
    required bool isSender,
  }) {
    ref.read(replyMessageProvider.state).state = ReplyMessage(
      message: message,
      isMe: isMe,
      messageType: messageType,
      isSender: isSender,
    );
  }
}
