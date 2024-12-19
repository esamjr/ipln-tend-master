import 'package:equatable/equatable.dart';

class WorkerEntity extends Equatable {
  final String? name;
  final String? email;
  final String? password;
  final int? nis;

  const WorkerEntity({
    this.name,
    this.email,
    this.password,
    this.nis,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    nis,
  ];
}