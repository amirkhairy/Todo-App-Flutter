import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/layout/cubit.dart';
import 'package:todo_app/layout/states.dart';

class Homescreen extends StatelessWidget {
  Homescreen({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: Center(
                child: Text(
                  AppCubit.get(context)
                      .screensTitle[AppCubit.get(context).currentIndex],
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 30,
              iconSize: 25,
              selectedFontSize: 15,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey[600],
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.task_alt_outlined),
                  label: 'New',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done_all),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
              onTap: (value) {
                AppCubit.get(context).changeBottomNavigationBarIndex(value);
              },
              currentIndex: AppCubit.get(context).currentIndex,
            ),
            body: AppCubit.get(context)
                .screens[AppCubit.get(context).currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (true == AppCubit.get(context).isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    AppCubit.get(context)
                        .insertData(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    )
                        .then((onvalue) {
                      AppCubit.get(context)
                          .changeFloatingActionButtonIcon(Icons.edit, false);
                      Navigator.pop(context);
                      titleController.clear();
                      timeController.clear();
                      dateController.clear();
                    });
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) {
                          return Padding(
                            padding: const EdgeInsetsDirectional.only(
                              start: 10,
                              end: 10,
                              bottom: 10,
                            ),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: titleController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'The Title is Empty';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Title',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: timeController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'The Time is Empty';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Time',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((onValue) {
                                        if (onValue != null) {
                                          timeController.text = onValue
                                              .format(context)
                                              .toString();
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: dateController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'The Date is Empty';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Date',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2030),
                                      ).then((onValue) {
                                        if (onValue != null) {
                                          dateController.text =
                                              DateFormat.yMMMd()
                                                  .format(onValue);
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                      .closed
                      .then((onValue) {
                        AppCubit.get(context)
                            .changeFloatingActionButtonIcon(Icons.edit, false);
                      });
                  AppCubit.get(context)
                      .changeFloatingActionButtonIcon(Icons.add, true);
                }
              },
              backgroundColor: Colors.blue,
              child: Icon(
                AppCubit.get(context).floatingActionButtonIcon,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
