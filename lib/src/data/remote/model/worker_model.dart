import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistem_presensi/src/domain/entities/worker_entity.dart';

class WorkerModel extends WorkerEntity{
  const WorkerModel({
    final String? name,
    final String? grade,
    final String? email,
    final String? password,
    final int? nis,
  }): super(
    name: name,
    email: email,
    password: password,
    nis: nis
  );

  factory WorkerModel.fromSnapshot(DocumentSnapshot snapshot){
    return WorkerModel(
        name: snapshot.get('name'),
        grade: snapshot.get('grade'),
        email: snapshot.get('email'),
        password: snapshot.get('password'),
        nis: snapshot.get('nis'),
    );
  }

  Map<String, dynamic> toDocument(){
    return {
      'name': name,
      'email': email,
      'password': password,
      'nis': nis
    };
  }
}