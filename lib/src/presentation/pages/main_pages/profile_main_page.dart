import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_presensi/src/presentation/cubit/auth/auth_cubit.dart';
import 'package:sistem_presensi/src/presentation/styles/color_style.dart';
import 'package:sistem_presensi/src/presentation/widget/common/dialog_widget.dart';

import '../../cubit/user/user_cubit.dart';

class ProfileMainPage extends StatelessWidget {
  const ProfileMainPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const SizedBox(height: 24,),
          const SizedBox(
            height: 100,
            width: 100,
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://www.cornwallbusinessawards.co.uk/wp-content/uploads/2017/11/dummy450x450.jpg'),
              radius: 100,
            ),
          ),
          const SizedBox(height: 16,),
          BlocBuilder<UserCubit, UserState>(builder: (context, userState) {
            if (userState is UserSuccess) {
              return Column(
                children: [
                  Text(
                    userState.userInfo?['name'],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4,),
                  Text(
                    userState.userInfo?['division'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorStyle.darkGrey),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
          const SizedBox(height: 48,),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Divider(height: 5.0,),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => CAlertDialog(
                        title: 'Keluar Akun',
                        content: 'Yakin akan keluar akun?',
                        onPressed: () => BlocProvider.of<AuthCubit>(context).loggedOut(),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
                    child: Row(
                      children: [
                        const Icon(Icons.logout_outlined,),
                        const SizedBox(width: 16,),
                        Text(
                          'Logout',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}