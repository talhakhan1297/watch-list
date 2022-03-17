import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:watch_list/navigation/navigation.dart';
import 'package:watch_list/repository/watch_list_repository.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final routerDelegate = KRouterDelegate();

  runApp(MyApp(routerDelegate: routerDelegate));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key, required this.routerDelegate}) : super(key: key) {
    routerDelegate.pushPage(name: '/');
  }

  final KRouterDelegate routerDelegate;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WatchListRepository(),
      child: MaterialApp.router(
        title: 'Flutter Web Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        routeInformationParser: const KRouteInformationParser(),
        routerDelegate: widget.routerDelegate,
      ),
    );
  }
}
