import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videoplayer/Bloc/Auth/auth_barrel.dart';
import 'package:videoplayer/view/Widgets/CustomSnackbar.dart';
import 'package:videoplayer/view/Widgets/videoplayer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red,
          centerTitle: true,
          title: BlocBuilder<AuthBloc, AuthStates>(
            builder: (context, state) {
              if (state is AuthSuccessFulState) {
                return Text('Welcome ${state.user.name}');
              }
              return Text("Login");
            },
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: BlocConsumer<AuthBloc, AuthStates>(
              listener: (context, state) {
                if (state is AuthSuccessFulState) {
                  CustomSnackbar.showSnackBar(
                      'Welcome ${state.user.name}', context);
                } else if (state is AuthFailedState) {
                  CustomSnackbar.showSnackBar('${state.msg}', context);
                }
              },
              builder: (context, state) {
                if (state is AuthLoadingState) {
                  return RefreshProgressIndicator();
                }
                if (state is AuthSuccessFulState) {
                  return TextButton(
                    child: Text("Tap to see the video"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen()),
                      );
                    },
                  );
                }
                return TextButton.icon(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    label: Text(
                      "Login With Google",
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(Icons.login, color: Colors.white),
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context)
                          .add(RequestGoogleAuth());
                    });
              },
            ),
          ),
          Center(
            child: TextButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
                label: Text(
                  "Continue..",
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(Icons.queue_play_next_outlined, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen()),
                  );
                }),
          )
        ],
      ),
    );
  }
}
