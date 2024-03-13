import 'dart:async';

import 'package:randomweb/features/chat/data/models/message.dart';
import 'package:randomweb/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:randomweb/features/chat/data/datasources/socket_api.dart';

class Repository {
  Repository._private();

  static final Repository _instance = Repository._private();

  static Repository get instance => _instance;

  final Socket _socket = SocketAPI.instance.socket;

  static final StreamController<ChatEvent> _streamController =
      StreamController<ChatEvent>.broadcast();

  static Stream<ChatEvent> get stream => _streamController.stream;

  void makeConnection() {
    _socket.emit('make');
   
  }

  void sendMessage(String message) {
    
    _socket.emit('message', message);
  }

  void listen() {
   
    _socket.once('userDisconnected', (data) {
      _socket.clearListeners();
      // BlocProvider.of<ChatBloc>(context).add(
      //   UserDisconnectedEvent(),
      // );

      _streamController.add(UserDisconnectedEvent());
    });

    _socket.once('userConnected', (data) {
      // BlocProvider.of<ChatBloc>(context).add(
      //   UserConnectedEvent(),
      // );
      _streamController.add(UserConnectedEvent());
    });

    _socket.on('message', (message) {
      
      // BlocProvider.of<ChatBloc>(context)
      //     .add(MessageRecivedEvent(Message(message: message, mine: false)));

      _streamController
          .add(MessageRecivedEvent(Message(message: message, mine: false)));
    });
  }

  void disconnect() {
    _socket.clearListeners();
    _socket.close();
  }
}
