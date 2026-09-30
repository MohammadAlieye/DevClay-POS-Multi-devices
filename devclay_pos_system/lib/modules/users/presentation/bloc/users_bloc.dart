import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/user_facing_error.dart';
import '../../domain/entities/user_entities.dart';
import '../../domain/repositories/users_repository.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc(
    this._repository, {
    required int currentUserId,
    required String currentUserRole,
  }) : _currentUserId = currentUserId,
       _currentUserRole = currentUserRole,
       super(const UsersInitial()) {
    on<UsersStarted>(_onStarted);
    on<UsersSearchChanged>(_onSearch);
    on<UsersTabChanged>(_onTab);
    on<UserSaved>(_onSaved);
    on<UserPasswordReset>(_onPasswordReset);
    on<UserActiveToggled>(_onActiveToggled);
    on<UserDeleted>(_onDeleted);
    on<UserSelected>(_onSelected);
    on<UsersMessageDismissed>(_onDismiss);
  }

  final UsersRepository _repository;
  final int _currentUserId;
  final String _currentUserRole;

  Future<void> _onStarted(UsersStarted event, Emitter<UsersState> emit) async {
    emit(const UsersLoading());
    await _load(emit);
  }

  Future<void> _onSearch(
    UsersSearchChanged event,
    Emitter<UsersState> emit,
  ) async {
    final current = state;
    if (current is UsersLoaded) {
      emit(current.copyWith(query: event.query));
    }
  }

  Future<void> _onTab(UsersTabChanged event, Emitter<UsersState> emit) async {
    final current = state;
    if (current is UsersLoaded) {
      emit(current.copyWith(tab: event.tab));
    }
  }

  Future<void> _onSaved(UserSaved event, Emitter<UsersState> emit) async {
    try {
      if (event.id == _currentUserId && !event.draft.isActive) {
        throw ArgumentError('You cannot deactivate your own account.');
      }
      await _repository.saveUser(
        event.draft,
        id: event.id,
        context: StaffUserSaveContext(
          editorUserId: _currentUserId,
          editorRole: _currentUserRole,
        ),
      );
      await _load(
        emit,
        message: event.id == null ? 'Staff account created' : 'Staff updated',
      );
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onPasswordReset(
    UserPasswordReset event,
    Emitter<UsersState> emit,
  ) async {
    try {
      await _repository.resetPassword(
        userId: event.userId,
        password: event.password,
      );
      await _load(emit, message: 'Password updated');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  void _emitActionError(Emitter<UsersState> emit, Object error) {
    final message = userFacingError(error);
    final current = state;
    if (current is UsersLoaded) {
      emit(current.copyWith(message: message));
    } else {
      emit(UsersError(message));
    }
  }

  Future<void> _onActiveToggled(
    UserActiveToggled event,
    Emitter<UsersState> emit,
  ) async {
    if (event.userId == _currentUserId && !event.isActive) {
      final current = state;
      if (current is UsersLoaded) {
        emit(
          current.copyWith(message: 'You cannot deactivate your own account'),
        );
      }
      return;
    }

    try {
      await _repository.setActive(
        userId: event.userId,
        isActive: event.isActive,
      );
      await _load(
        emit,
        message: event.isActive ? 'Account activated' : 'Account deactivated',
      );
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onDeleted(UserDeleted event, Emitter<UsersState> emit) async {
    if (event.userId == _currentUserId) {
      final current = state;
      if (current is UsersLoaded) {
        emit(current.copyWith(message: 'You cannot delete your own account'));
      }
      return;
    }

    try {
      await _repository.deleteUser(event.userId);
      await _load(emit, message: 'Staff moved to Recycle Bin');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onSelected(UserSelected event, Emitter<UsersState> emit) async {
    final current = state;
    if (current is UsersLoaded) {
      emit(current.copyWith(selectedUserId: event.userId));
    }
  }

  Future<void> _onDismiss(
    UsersMessageDismissed event,
    Emitter<UsersState> emit,
  ) async {
    final current = state;
    if (current is UsersLoaded) {
      emit(current.copyWith(clearMessage: true));
    }
  }

  Future<void> _load(Emitter<UsersState> emit, {String? message}) async {
    try {
      final current = state;
      final query = current is UsersLoaded ? current.query : '';
      final tab = current is UsersLoaded ? current.tab : UsersTab.all;
      final selectedUserId = current is UsersLoaded
          ? current.selectedUserId
          : null;
      final users = await _repository.getUsers();
      emit(
        UsersLoaded(
          users: users,
          query: query,
          tab: tab,
          selectedUserId: selectedUserId ?? users.firstOrNull?.id,
          currentUserId: _currentUserId,
          message: message,
        ),
      );
    } catch (error) {
      _emitActionError(emit, error);
    }
  }
}
