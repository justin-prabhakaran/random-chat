import 'package:flutter/material.dart';
import 'package:randomweb/features/chat/presentation/pages/desktop_chat_page.dart';
import 'package:randomweb/features/chat/presentation/pages/mobile_chat_page.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return const MobileChatPage();
        }
        if (sizingInformation.isDesktop) {
          return const DesktopChatPage();
        }
        return const DesktopChatPage();
      },
    );
  }
}
