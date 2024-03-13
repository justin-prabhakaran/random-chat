import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randomweb/features/chat/presentation/pages/desktop_home_page.dart';
import 'package:randomweb/features/chat/presentation/pages/home_page.dart';
import 'package:randomweb/features/chat/presentation/pages/mobile_home_page.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'features/chat/presentation/bloc/chat_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => ChatBloc(),
      child: MaterialApp(
          showSemanticsDebugger: false,
          title: 'Random Chat',
          theme:
              ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
          home: const HomePage()),
    );
  }
}
