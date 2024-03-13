import 'package:equatable/equatable.dart';

class Message extends Equatable {
  String message;
  bool mine;

  Message({
    required this.message,
    required this.mine,
  });

  @override
  List<Object?> get props => [message, mine];
}
