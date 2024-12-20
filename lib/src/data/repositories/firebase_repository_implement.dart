import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:sistem_presensi/src/data/remote/data_sources/firebase_datasource.dart';
import 'package:sistem_presensi/src/data/service/geolocator.dart';
import 'package:sistem_presensi/src/domain/entities/presence_entity.dart';
import 'package:sistem_presensi/src/domain/entities/user_entity.dart';
import 'package:sistem_presensi/src/domain/repositories/firebase_repository.dart';

class FireBaseRepositoryImplement extends FirebaseRepository {
  final FirebaseDataSource dataSource;
  final GeoLoc geoLoc;

  FireBaseRepositoryImplement({required this.dataSource, required this.geoLoc});

  @override
  Future<void> addNewPresence(PresenceEntity presence) async {
    await dataSource.addNewPresence(presence).then((uid) async {
      if (uid!=null) {
        await dataSource.incrementTotalPresence(uid);
      }
    });
  }

  @override
  Future<String> getCurrentUserId() async =>
      dataSource.getCurrentUserId();

  @override
  Stream<List<PresenceEntity>> getCurrentUserPresences() async* {
    final uid = await getCurrentUserId();
    yield* dataSource.getUserPresences(uid);
  }

  @override
  Future<bool> isSignIn() async =>
      dataSource.isSignIn();

  @override
  Future<void> signIn(UserEntity user) async =>
      dataSource.signIn(user);

  @override
  Future<void> signOut() async =>
      dataSource.signOut();

  @override
  Future<String> signUp(UserEntity user) async =>
      dataSource.signUp(user);

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async =>
      dataSource.getCreateCurrentUser(user);

  @override
  Future<UserEntity> getCurrentUser() async =>
      dataSource.getCurrentUser();

  @override
  Future<Position> getCurrentPosition() {
    return geoLoc.determinePosition();
  }

  @override
  Stream<bool> isAlreadyPresenceStream() {
    return dataSource.isAlreadyPresenceStream();
  }

  @override
  Future<void> storeFaceArray(String uid, List faceArray) {
    return dataSource.storeFaceArray(uid, faceArray);
  }

  @override
  Future<List> getFaceArray() {
    return dataSource.getFaceArray();
  }
}