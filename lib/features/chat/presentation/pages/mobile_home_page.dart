import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:randomweb/features/chat/presentation/pages/chat_page.dart';
import 'package:url_launcher/url_launcher.dart';

class MobileHomePage extends StatelessWidget {
  const MobileHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Random Chat',
          style: GoogleFonts.firaCode(color: Colors.green, fontSize: 18),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text(
                    //   'Enter your name : ',
                    //   style:
                    //       GoogleFonts.firaCode(color: Colors.green, fontSize: 18),
                    // ),\
                    AnimatedTextKit(
                        isRepeatingAnimation: false,
                        totalRepeatCount: 1,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Enter your name : ',
                            textStyle: GoogleFonts.firaCode(
                                color: Colors.green, fontSize: 18),
                          ),
                        ]),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        onSubmitted: (String val) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatPage(),
                              ));
                        },
                        // showCursor: true,
                        autofocus: true,
                        style: GoogleFonts.firaCode(
                            color: Colors.green, fontSize: 18),
                        cursorColor: Colors.green,
                        decoration: const InputDecoration(
                          hoverColor: Colors.black,
                          fillColor: Colors.black,
                          filled: true,
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),
                // Text(
                //   'Press Enter to make new connection',
                //   style: GoogleFonts.firaCode(color: Colors.green, fontSize: 18),
                // )
                AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Press Enter to make new connection',
                      textStyle: GoogleFonts.firaCode(
                          color: Colors.green, fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
          ),
          // const Spacer(),
          const Divider(
            color: Colors.green,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '  created by @jp',
                style: GoogleFonts.firaCode(color: Colors.green, fontSize: 15),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () async {
                      await launchUrl(
                          mode: LaunchMode.externalApplication,
                          Uri.parse('https://www.instagram.com/ima.justyn/'));
                    },
                    icon: const FaIcon(
                      size: 18,
                      FontAwesomeIcons.instagram,
                      color: Colors.green,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await launchUrl(
                          mode: LaunchMode.externalApplication,
                          Uri.parse(
                              'https://www.linkedin.com/in/justinprabhakaran-m/'));
                    },
                    icon: const FaIcon(
                      size: 18,
                      FontAwesomeIcons.linkedin,
                      color: Colors.green,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
