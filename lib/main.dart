import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videoplayer/Bloc/Auth/auth_barrel.dart';
import 'package:videoplayer/Repositories/AuthRepo.dart';

import 'view/Screen/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MultiBlocProvider(providers: [
      BlocProvider<AuthBloc>(
        create: (BuildContext context) => AuthBloc(AuthRepo()),
      ),
    ], child: MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()));
  }
}
