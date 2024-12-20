import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sistem_presensi/src/data/remote/data_sources/firebase_datasource.dart';
import 'package:sistem_presensi/src/data/remote/model/presence_model.dart';
import 'package:sistem_presensi/src/data/remote/model/user_model.dart';
import 'package:sistem_presensi/src/domain/entities/presence_entity.dart';
import 'package:sistem_presensi/src/domain/entities/user_entity.dart';
import 'package:sistem_presensi/utils/date_util.dart';

class FirebaseDataSourceImplement extends FirebaseDataSource {

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  FirebaseDataSourceImplement({required this.auth, required this.firestore, required this.storage});

  @override
  Future<String?> addNewPresence(PresenceEntity presenceEntity) async {
    final UserEntity user = await getCurrentUser();
    final uid = await getCurrentUserId();

    final CollectionReference presenceCollectionRef = firestore.collection('users').doc(uid).collection('presences');
    final presenceId = presenceCollectionRef.doc().id;

    await presenceCollectionRef.doc(presenceId).get().then((presence){
      final folderRef = storage.ref().child('images').child('presence').child(user.userId!);
      final imageRef = folderRef.child('$presenceId.jpg');

      final newPresence = PresenceModel(
        presenceId: presenceId,
        name: user.userInfo!['name'],
        grade: user.userInfo!['division'],
        isPresence: presenceEntity.isPresence,
        location: presenceEntity.location,
        time: presenceEntity.time,
        imageURL: imageRef.fullPath,
      ).toDocument();

      if(!presence.exists) {
        presenceCollectionRef.doc(presenceId).set(newPresence);
        imageRef.putFile(presenceEntity.imageFile!);
      }
    });
    return uid;
  }

  @override
  Stream<List<PresenceEntity>> getUserPresences(String uid) {
    final CollectionReference presenceCollectionRef = firestore.collection('users').doc(uid).collection('presences');
    final presencesStream = presenceCollectionRef.snapshots();

    return presencesStream.map((querySnap){
      return querySnap.docs.map((docSnap) => PresenceModel.fromSnapshot(docSnap)).toList();
    });
  }

  @override
  Future<bool> isSignIn() async => auth.currentUser?.uid != null;

  @override
  Future<void> signIn(UserEntity userEntity) async {
    final user = await auth.signInWithEmailAndPassword(email: userEntity.email!, password: userEntity.password!);
    final claims = await user.user!.getIdTokenResult().then((token) => token.claims);
    if (claims?['teacher'] != null) {
      auth.signOut();
      throw FirebaseAuthException(code: 'user-not-found', message: 'User not found');
    }
  }

  @override
  Future<void> signOut() async => auth.signOut();

  @override
  Future<String> signUp(UserEntity userEntity) async {
    return await auth.createUserWithEmailAndPassword(email: userEntity.email!, password: userEntity.password!)
        .then((value) {
          value.user?.updateDisplayName('TestUser');
          return value.user!.uid;
        });
  }

  @override
  Future<void> getCreateCurrentUser(UserEntity userEntity) async {
    final CollectionReference userCollectionRef = firestore.collection('users');
    final uid = await getCurrentUserId();

    await userCollectionRef.doc(uid).get().then((user){
      Timestamp createdDateTime = Timestamp.now();

      final newUser = UserModel(
        userId: uid,
        grade: userEntity.grade,
        email: userEntity.email,
        role: userEntity.role,
        createdAt: createdDateTime,
        userInfo: userEntity.userInfo,
        password: userEntity.password
      ).toDocument();

      if(!user.exists) {
        userCollectionRef.doc(uid).set(newUser);
      }
      return;
    });
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final CollectionReference userCollectionRef = firestore.collection('users');
    final uid = await getCurrentUserId();
    late UserModel currentUser;

    await userCollectionRef.doc(uid).get().then((user){
      currentUser = UserModel.fromSnapshot(user);
    });

    return currentUser;
  }

  @override
  Future<String> getCurrentUserId() async => auth.currentUser!.uid;

  @override
  Future<void> incrementTotalPresence(String uid) async {
    final UserEntity user  = await getCurrentUser();
    final DocumentReference userRef = firestore.collection('users').doc(uid);

    final userInfo = user.userInfo!;
    userInfo['total_presence'] = userInfo['total_presence'] + 1;

    await userRef.update({
      'user_info': userInfo
    }).then(
            (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  @override
  Stream<bool> isAlreadyPresenceStream() async* {
    final uid = await getCurrentUserId();

    final presenceCollectionRef = firestore.collection('users').doc(uid).collection('presences');
    final query = presenceCollectionRef.where('timestamp', isGreaterThan: CDateUtil.getStartOfToday()).snapshots();

    yield* query.map((event) => event.size == 0 ? false : true);
  }

  Future<void> storeFaceArray(String uid, List faceArray) async {
    final userRef = firestore.collection('users').doc(uid);
    userRef.update({"face_array": faceArray}).then((value) {print('Update Face Array Success');}, onError: (e) => print("Error updating document $e"));
  }

  Future<List> getFaceArray() async {
    final uid = await getCurrentUserId();
    final userRef = firestore.collection('users').doc(uid);

    return userRef.get().then((snapshot) =>
        snapshot.get('face_array')
    );
  }
}