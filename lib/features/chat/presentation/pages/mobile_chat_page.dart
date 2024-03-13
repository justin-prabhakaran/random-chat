import 'dart:async';

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:randomweb/features/chat/data/datasources/socket_api.dart';
import 'package:randomweb/features/chat/data/models/message.dart';
import 'package:randomweb/features/chat/data/repositories/repository.dart';

import '../bloc/chat_bloc.dart';

class MobileChatPage extends StatefulWidget {
  const MobileChatPage({super.key});

  @override
  State<MobileChatPage> createState() => _MobileChatPageState();
}

class _MobileChatPageState extends State<MobileChatPage> {
  late ChatBloc _chatBloc;
  late ScrollController _scrollController;
  late FocusNode _focus;
  late TextEditingController _controller;
  late StreamSubscription<ChatEvent> _streamSubscription;

  @override
  void initState() {
    SocketAPI.instance.createConnection();

    window.onBeforeUnload.listen((event) {
      Repository.instance.disconnect();
    });

    window.onAbort.listen((event) {
      Repository.instance.disconnect();
    });

    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _scrollController = ScrollController();
    _focus = FocusNode();
    _controller = TextEditingController();

    Repository.instance.makeConnection();

    _chatBloc.add(AddLoadingEvent());

    Repository.instance.listen();

    _streamSubscription = Repository.stream.listen((event) {
      _chatBloc.add(event);
    });

    super.initState();
  }

  @override
  void dispose() {
    // print('disposed caledd.........');
    // _chatBloc.close();
    _focus.dispose();
    _controller.dispose();
    _scrollController.dispose();
    _streamSubscription.cancel();

    Repository.instance.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.exit_to_app),
      //       onPressed: () {
      //         Repository.instance.disconnect();
      //         Navigator.pop(context);
      //       },
      //     ),
      //   ],
      // ),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is UserConnectedState) {
            showSnackBar(context, "User Connected Successfully");
          }
          if (state is UserDisconnectedState) {
            showSnackBar(context, "User Disconnected !");
            Navigator.pop(context);
          }
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is ChatRecivedState) {
                      // print('Log : Rebuilding.......');
                      return Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: state.messages.length + 1,
                          itemBuilder: (context, index) {
                            if (index == state.messages.length) {
                              return const SizedBox(
                                height: 40,
                              );
                            }
                            return Align(
                              alignment: state.messages[index].mine
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 5),
                                decoration: BoxDecoration(
                                  color: state.messages[index].mine
                                      ? Colors.green
                                      : Colors.black,
                                  border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  state.messages[index].message,
                                  style: GoogleFonts.firaCode(
                                    color: state.messages[index].mine
                                        ? Colors.black
                                        : Colors.green,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is LoadingState) {
                      return const Expanded(
                        child: Center(
                            child: SpinKitThreeBounce(
                          color: Colors.green,
                          size: 20,
                        )),
                      );
                    } else {
                      return Expanded(child: Container());
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(3),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focus,
                    autofocus: true,
                    onSubmitted: (val) {
                      try {
                        if (val.isNotEmpty) {
                          _chatBloc.add(
                            SendMessageEvent(
                              Message(message: val, mine: true),
                            ),
                          );
                          _controller.clear();
                          _scrollController.jumpTo(
                            _scrollController.position.maxScrollExtent,
                          );
                          _focus.requestFocus();
                        }
                      } catch (e) {
                        // print('Error sending message: $e');
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.black,
                      filled: true,
                      hoverColor: Colors.black,
                      suffixIcon: IconButton(
                        onPressed: () {
                          try {
                            final val = _controller.text.trim();
                            if (val.isNotEmpty) {
                              _chatBloc.add(
                                SendMessageEvent(
                                  Message(message: val, mine: true),
                                ),
                              );
                              _controller.clear();
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                              _focus.requestFocus();
                            }
                          } catch (e) {
                            // print('Error sending message: $e');
                          }
                        },
                        icon: const Icon(Icons.send_outlined),
                        color: Colors.green,
                      ),
                    ),
                    style: GoogleFonts.firaCode(
                      color: Colors.green,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                TextButton(
                  onPressed: () {
                    Repository.instance.disconnect();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Exit !',
                    style: GoogleFonts.firaCode(
                      color: Colors.green,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.firaCode(
            color: Colors.green,
            fontSize: 15,
          ),
        ),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.green),
        ),
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
        ),
      ),
    );
  }
}
