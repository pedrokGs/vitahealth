import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/shared_providers.dart';
import '../model/profile_model.dart';
import '../model/profile_service.dart';

class ProfileState {
  final bool isLoading;
  final String? errorMessage;
  final bool saved;

  const ProfileState({
    this.isLoading = false,
    this.errorMessage,
    this.saved = false,
  });

  ProfileState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? saved,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      saved: saved ?? this.saved,
    );
  }
}


class ProfileNotifier extends Notifier<ProfileState> {
  late final ProfileService service;

  @override
  ProfileState build() {
    service = ref.read(profileServiceProvider);
    return const ProfileState();
  }

  Future<void> saveProfile(Profile profile) async {
    state = state.copyWith(isLoading: true, errorMessage: null, saved: false);

    try {
      final result = await service.saveProfile(profile);

      if (!result) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Erro ao salvar perfil",
        );
        return;
      }

      state = state.copyWith(
        isLoading: false,
        saved: true,
      );

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}
