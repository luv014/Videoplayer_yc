import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videoplayer/Repositories/AuthRepo.dart';
import 'package:videoplayer/models/user.dart';

import 'auth_barrel.dart';

class AuthBloc extends Bloc<AuthEvent, AuthStates> {
  AuthRepo _authRepo;
  AuthBloc(this._authRepo) : super(AuthInitialState());

  @override
  Stream<AuthStates> mapEventToState(AuthEvent event) async* {
    if (event is RequestGoogleAuth) {
      yield AuthLoadingState();
      try {
        User user = await _authRepo.handleGoogleSignIn();
        if (user != null) {
          UserModel currentUser =
              UserModel(id: user.uid, name: user.displayName);
          yield AuthSuccessFulState(user: currentUser);
        } else {
          yield AuthFailedState(msg: 'User not found!');
        }
      } catch (e) {
        yield AuthFailedState(msg: e.toString());
      }
    }
  }
}
