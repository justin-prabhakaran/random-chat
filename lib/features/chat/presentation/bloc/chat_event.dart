part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class UserDisconnectedEvent extends ChatEvent {}

class UserConnectedEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final Message message;

  const SendMessageEvent(this.message);
}

class MessageRecivedEvent extends ChatEvent {
  final Message message;
  const MessageRecivedEvent(this.message);

  @override
  List<Object> get props => [message];
}

class AddLoadingEvent extends ChatEvent {}
