import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_presensi/constant/app_config.dart';
import 'package:sistem_presensi/src/presentation/cubit/presence/add_presence/add_presence_cubit.dart';
import 'package:sistem_presensi/src/presentation/cubit/presence/add_presence/add_presence_state.dart';
import 'package:sistem_presensi/src/presentation/cubit/presence/load_presence/load_presence_cubit.dart';
import 'package:sistem_presensi/src/presentation/cubit/user/user_cubit.dart';
import 'package:sistem_presensi/src/presentation/styles/color_style.dart';
import 'package:sistem_presensi/src/presentation/widget/main_card_widget.dart';
import 'package:sistem_presensi/src/presentation/widget/presence_widget.dart';
import 'package:sistem_presensi/src/presentation/widget/common/card_widget.dart';
import 'package:sistem_presensi/utils/scroll_behavior.dart';
import 'package:timelines/timelines.dart';

class HomeMainPage extends StatelessWidget {
  static const int presence = 24;
  static const int absence = 1;
  // static const List schTime = AppConfig.schTime;

  const HomeMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: ListView(
              children: [
                BlocBuilder<UserCubit, UserState>(builder: (context, userState) {
                  if (userState is UserSuccess) {
                    return MainCard(
                      grade: userState.userInfo?['division'],
                      name: userState.userInfo?['name'],
                      idNumber: userState.userInfo?['worker_number'],
                      presence: userState.userInfo?['total_presence'],
                      absence: userState.userInfo?['total_absence'],
                    );
                  }
                  if (userState is UserFailure) {
                    return SizedBox(
                      height: 174,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(child: Text('Gagal memuat'),),
                    );
                  }
                  return CardLoading(
                    height: 174,
                    borderRadius: BorderRadius.circular(20),
                  );
                }),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BlocListener<AddPresenceCubit, AddPresenceState>(
              listener: (context, state) {
                if(state is AddPresenceSuccess) {
                  BlocProvider.of<UserCubit>(context).getUserInfo();
                  //TODO: optimize
                  BlocProvider.of<LoadPresenceCubit>(context).getCurrentUserPresences();
                }
              },
              child: BlocBuilder<LoadPresenceCubit, LoadPresenceState>(
                builder: (context, presenceState) {
                  if (presenceState is LoadPresenceSuccess) {
                    if (presenceState.isAlreadyPresence) {
                      return const SizedBox();
                    } else {
                      return PresenceCard();
                    }
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTimeline(BuildContext context, List schedule, List schTime) {
    return FixedTimeline.tileBuilder(
      theme: TimelineThemeData(
          nodePosition: 0,
          indicatorPosition: 0,
          // color: Theme.of(context).primaryColor,
          indicatorTheme: const IndicatorThemeData(size: 20, color: ColorStyle.indigoPurple,),
          connectorTheme: const ConnectorThemeData(
            thickness: 5,
            space: 46,
            color: ColorStyle.indigoLight,
          )
      ),
      builder: TimelineTileBuilder.fromStyle(
        contentsAlign: ContentsAlign.basic,
        contentsBuilder: (context, index) => CScheduleCard(subject: schedule[index], time: schTime[index],),
        itemCount: schedule.length,
      ),
    );
  }
}