import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/states.dart';
import 'package:todo_app/screens/archivedTask.dart';
import 'package:todo_app/screens/doneTask.dart';
import 'package:todo_app/screens/newTask.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List screensTitle = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  List screens = [Newtask(), const Donetask(), const Archivedtask()];
  IconData floatingActionButtonIcon = Icons.edit;
  bool isBottomSheetShown = false;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  late Database database;
  void changeBottomNavigationBarIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavigationBarIndex());
  }

  void changeFloatingActionButtonIcon(IconData icon, bool bottomSheet) {
    floatingActionButtonIcon = icon;
    isBottomSheetShown = bottomSheet;
    emit(ChangeFloatingActionButtonIcon());
  }

  void createDataBase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        db
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY , name TEXT , time TEXT , date TEXT , status TEXT)')
            .then((onValue) {
          print('DataBase created');
        });
      },
      onOpen: (db) {
        database = db;
        getData(db);
        print('DataBase opened');
      },
    ).then((onValue) {
      database = onValue;
      emit(CreateDataState());
    });
  }

  Future insertData({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction(
      (txn) async {
        return await txn
            .rawInsert(
                'INSERT INTO tasks(name,time,date,status) VALUES("$title","$time","$date","new")')
            .then((onValue) {
          print('Data inserted');
          emit(InsertDataState());
          getData(database);
        }).catchError((onError) {
          print('the error is $onError');
        });
      },
    );
  }

  void updateData({required String status, required int id}) {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        [status, id]).then((onValue) {
      getData(database);
      emit(UpdateDataState());
    });
  }

  void deleteData({required int id}) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((onValue) {
      getData(database);
      emit(DeleteDataState());
    });
  }

  void getData(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    database.rawQuery('SELECT * FROM tasks').then((onValue) {
      onValue.forEach((Element) {
        if (Element['status'] == 'new') {
          newTasks.add(Element);
        } else if (Element['status'] == 'done') {
          doneTasks.add(Element);
        } else {
          archiveTasks.add(Element);
        }
      });
      emit(GetDataState());
    });
  }
}
