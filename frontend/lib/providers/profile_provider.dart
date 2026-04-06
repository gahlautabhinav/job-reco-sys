import 'package:flutter/foundation.dart';
import '../data/models/user_profile.dart';
import '../data/repositories/profile_repository.dart';
import '../data/services/api_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repo;

  ProfileProvider(this._repo);

  UserProfile _profile = const UserProfile();

  UserProfile get profile => _profile;

  SearchParams get defaultSearchParams => SearchParams.fromProfile(_profile);

  Future<void> load() async {
    _profile = await _repo.load();
    notifyListeners();
  }

  Future<void> save(UserProfile updated) async {
    await _repo.save(updated);
    _profile = updated;
    notifyListeners();
  }
}
