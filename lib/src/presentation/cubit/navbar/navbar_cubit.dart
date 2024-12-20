import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'navbar_state.dart';

class NavbarCubit extends Cubit<NavbarState> {
  NavbarCubit() : super(NavbarHome());

  Future<void> openMainPage() async {
    emit(NavbarHome());
  }

  Future<void> moveIndex(int index) async {
    switch (index) {
      case 0:
        print('Home');
        emit(NavbarHome());
        break;
      case 1:
        print('History');
        emit(NavbarHistory());
        break;
      case 2:
        print('Profile');
        emit(NavbarProfile());
        break;
      case 3:
        print('Permission');
        emit(NavbarPermission());
        break;
    }
  }
}
