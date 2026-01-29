import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;
  SignUpBloc(
    this._userRepository
  ) : super(SignUpInitial()) {
    on<SignUpRequired>((event, emit) async {
      emit(SignUpLoading());
      try {
        debugPrint("🔵 SignUpBloc: Starting sign up for ${event.user.email}");
        // signUp() already calls setUserData internally, so we don't need to call it again
        MyUser myUser = await _userRepository.signUp(event.user, event.password);
        debugPrint("✅ SignUpBloc: Sign up completed successfully for UID: ${myUser.userId}");
        emit(SignUpSuccess());
      } catch (e, stackTrace) {
        debugPrint("❌ SignUpBloc Error: $e");
        debugPrint("❌ SignUpBloc StackTrace: $stackTrace");
        emit(SignUpFailure());
      }
    });
  }
}
