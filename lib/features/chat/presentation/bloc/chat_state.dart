part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatRecivedState extends ChatInitial {
  final List<Message> messages;

  ChatRecivedState(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatSendState extends ChatInitial {

}

class UserDisconnectedState extends ChatInitial {}

class UserConnectedState extends ChatInitial {}

class LoadingState extends ChatInitial {}
