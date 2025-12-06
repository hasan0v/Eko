import 'package:equatable/equatable.dart';

/// Authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Check authentication status
class AuthCheckStatus extends AuthEvent {
  const AuthCheckStatus();
}

/// Login event
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Register event
class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String? photoUrl;

  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [name, email, password, phone, photoUrl];
}

/// Logout event
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Update profile event
class AuthUpdateProfileRequested extends AuthEvent {
  final String? name;
  final String? phone;
  final String? photoUrl;

  const AuthUpdateProfileRequested({
    this.name,
    this.phone,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [name, phone, photoUrl];
}

/// Password reset request event
class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested(this.email);

  @override
  List<Object?> get props => [email];
}
