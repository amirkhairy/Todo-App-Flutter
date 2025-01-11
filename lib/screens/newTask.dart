import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/components.dart';
import 'package:todo_app/layout/cubit.dart';
import 'package:todo_app/layout/states.dart';

class Newtask extends StatelessWidget {
  const Newtask({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
            itemBuilder: (context, index) =>
                taskItem(AppCubit.get(context).newTasks[index], context),
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsetsDirectional.only(start: 20),
              child: Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
            ),
            itemCount: AppCubit.get(context).newTasks.length);
      },
    );
  }
}
