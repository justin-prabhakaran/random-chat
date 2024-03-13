import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:randomweb/features/chat/data/models/message.dart';
import 'package:randomweb/features/chat/data/repositories/repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List<Message> messages = [];

  ChatBloc() : super(ChatInitial()) {
    on<MessageRecivedEvent>((event, emit) {
      messages.add(event.message);
      emit(ChatRecivedState(List<Message>.from(messages)));
    });

    on<SendMessageEvent>((event, emit) {
      messages.add(event.message);
      Repository.instance.sendMessage(event.message.message);
      emit(ChatRecivedState(List<Message>.from(messages)));
    });

    on<UserConnectedEvent>((event, emit) {
      messages = [];
      emit(UserConnectedState());
    });
    on<UserDisconnectedEvent>((event, emit) {
      messages = [];
      emit(UserDisconnectedState());
    });

    on<AddLoadingEvent>(
      (event, emit) {
        emit(LoadingState());
      },
    );
  }
}
