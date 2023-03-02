import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class StoreDependantPage extends StatelessWidget {
  final Widget page;
  const StoreDependantPage({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit, StoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (!state.isLoading && !state.isSuccessful && !state.isError) {
            context.read<StoreCubit>().getStore();
          }

          if (state.isSuccessful) {
            return page;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  height: 30,
                  width: 30,
                  margin: const EdgeInsets.all(5),
                  child: const CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation(Colors.black),
                  ),
                ),
              ),
            ],
          );
          // return Transform.scale(
          //   scale: 0.2,
          //   child: const CircularProgressIndicator(),
          // );
          //   return const SizedBox(
          //       width: 30, height: 30, child: CircularProgressIndicator());
        });
  }
}
