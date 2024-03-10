import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_mp3/core/services/theme/app_colors.dart';
import 'package:quran_mp3/src/quran_audio/domain/entities/reciter.dart';
import 'package:quran_mp3/src/quran_audio/presentation/bloc/reciter_bloc.dart';
import 'package:quran_mp3/src/quran_audio/presentation/screens/reciter_detail_screen.dart';

class RecitersScreen extends StatelessWidget {
  const RecitersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      // appBar: AppBar(
      //   backgroundColor: AppColors.darkPrimaryColor,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       Text(
      //         'قائمة القراء',
      //         style: TextStyle(color: AppColors.primaryColor),
      //       ),
      //     ],
      //   ),
      // ),
      body: BlocBuilder<ReciterBloc, ReciterState>(
        builder: (context, state) {
          if (state.status == ReciterStateStatus.loading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          } else if (state.status == ReciterStateStatus.loaded ||
              state.status == ReciterStateStatus.loadedReciter ||
              state.status == ReciterStateStatus.loadingReciter) {
            return Column(
              children: [
                Container(
                  height: size.height * 0.3,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: AppColors.darkPrimaryColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'إبحت عن',
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'قارئك المفضل',
                          style: TextStyle(
                              color: AppColors.primaryColor, fontSize: 30),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 50,
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: AppColors.primaryColor),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            onChanged: (value) => {
                              context
                                  .read<ReciterBloc>()
                                  .add(FilterRecitersInfo(query: value))
                            },
                            textAlign: TextAlign.end,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(color: AppColors.primaryColor),
                            cursorColor:
                                AppColors.primaryColor.withOpacity(0.5),
                            decoration: InputDecoration(
                                hintText: 'القارء',
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: AppColors.primaryColor
                                        .withOpacity(0.5)),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color:
                                      AppColors.primaryColor.withOpacity(0.5),
                                )),
                          ),
                        )
                      ]),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      // crossAxisSpacing: 10,
                      // mainAxisSpacing: 10,
                    ),
                    itemCount: state.filtredReciters.length,
                    itemBuilder: (context, index) {
                      final reciter = state.filtredReciters[index];
                      return buildReciterWidget(
                          context: context, reciter: reciter);
                    },
                  ),
                ),
              ],
            );
          }

          return const Center(
            child: Text('Reciters Screen'),
          );
        },
      ),
    );
  }
}

Widget buildReciterWidget(
    {required BuildContext context, required Reciter reciter}) {
  return GestureDetector(
    onTap: () {
      context.read<ReciterBloc>().add(GetReciterDetail(reciterId: reciter.id));

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ReciterDetailScreen()));
    },
    child: Container(
      padding: const EdgeInsets.all(12),
      // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      // margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: AppColors.darkShadowColor,
              offset: const Offset(5, 4),
              spreadRadius: 1,
              blurRadius: 10),
          BoxShadow(
              color: AppColors.lightShadowColor,
              offset: const Offset(-3, -4),
              spreadRadius: -2,
              blurRadius: 8)
        ],
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              reciter.name,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              reciter.rewaya,
              style: const TextStyle(fontSize: 10),
            )
          ]),
    ),
  );
}
