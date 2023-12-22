//Profile_Controller
import '../models/profile_model.dart';

class ProfileController {
  final ProfileModel model;

  ProfileController({required this.model});

  Future<Map<String, dynamic>?> loadUserData(String userId) async {
    return await model.loadUserData(userId);
  }
}
