import '../models/user_profile.dart';
import '../services/database_service.dart';

class ProfileRepository {
  final DatabaseService _db;

  ProfileRepository(this._db);

  Future<UserProfile> load() async {
    return await _db.getProfile() ?? const UserProfile();
  }

  Future<void> save(UserProfile profile) async {
    await _db.saveProfile(profile);
  }
}
