import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myyoukounkoun/models/user_model.dart';

final userNotifierProvider =
    StateNotifierProvider<UserProvider, UserModel>((ref) => UserProvider());
final profilePictureAlreadyLoadedNotifierProvider =
    StateNotifierProvider<ProfilePictureAlreadyLoaded, bool>(
        (ref) => ProfilePictureAlreadyLoaded());

class UserProvider extends StateNotifier<UserModel> {
  UserProvider()
      : super(UserModel(
            id: 0,
            token: "",
            email: "",
            pseudo: "",
            gender: "",
            birthday: "",
            nationality: "",
            profilePictureUrl: "",
            validCGU: false,
            validPrivacyPolicy: false,
            validEmail: false));

  void initUser(UserModel user) {
    state = user;
  }

  Future<void> updateUser(UserModel user) async {
    state = user;
  }

  void clearUser() {
    state = UserModel(
        id: 0,
        token: "",
        email: "",
        pseudo: "",
        gender: "",
        birthday: "",
        nationality: "",
        profilePictureUrl: "",
        validCGU: false,
        validPrivacyPolicy: false,
        validEmail: false);
  }
}

class ProfilePictureAlreadyLoaded extends StateNotifier<bool> {
  ProfilePictureAlreadyLoaded() : super(false);

  void profilePictureLoaded(bool newState) {
    state = newState;
  }

  void clearProfilePicture() {
    state = false;
  }
}
