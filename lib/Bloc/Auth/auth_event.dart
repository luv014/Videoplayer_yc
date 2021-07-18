import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {}

class RequestGoogleAuth extends AuthEvent {
  List<Object> get props => [];
}
