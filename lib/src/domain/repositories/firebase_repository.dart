import 'package:geolocator/geolocator.dart';
import 'package:sistem_presensi/src/domain/entities/presence_entity.dart';
import 'package:sistem_presensi/src/domain/entities/user_entity.dart';

abstract class FirebaseRepository {
  Future<bool> isSignIn();
  Future<void> signIn(UserEntity user);
  Future<String> signUp(UserEntity user);
  Future<void> getCreateCurrentUser(UserEntity user);
  Future<void> signOut();
  Future<String> getCurrentUserId();
  Future<void> addNewPresence(PresenceEntity presence);
  Future<UserEntity> getCurrentUser();
  Future<Position> getCurrentPosition();
  Stream<bool> isAlreadyPresenceStream();
  Stream<List<PresenceEntity>> getCurrentUserPresences();
  Future<void> storeFaceArray(String uid, List faceArray);
  Future<List> getFaceArray();
}