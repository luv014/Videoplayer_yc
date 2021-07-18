import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:videoplayer/models/user.dart';

abstract class AuthStates extends Equatable {
  List<Object> get props => [];
}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthSuccessFulState extends AuthStates {
  final UserModel user;
  AuthSuccessFulState({@required this.user});
}

class AuthFailedState extends AuthStates {
  final msg;
  AuthFailedState({ @required this.msg});
}
